---
layout: post
title: Low-hassle HTTP metrics with Tigertonic and Go-metrics
---

### First things first: What the shit is tigertonic?

<a href="http://gunshowcomic.com/338"><img
src="/imgs/posts/tt-metrics/tigertonic.png" class="right small"  /></a>
Tigertonic is a framework for making webservices in Go written by Richard
Crowley (I have contributed a bug fix or a feature here and there). Its defining
characteristic is that it allows you to translate functions which take and
return specific Go types into `http.Handler` implementations that understand and
return JSON payloads. Define your signature, pass it into the correct Tigertonic
wrapper, and out comes a web service that take in JSON, unmarshals it to the
input type, passes it to your handler, then takes the return value from your
handler and marshals it into JSON for the response.

It's similar to JAX-RS/Jersey annotations, but with much less code, and with
most of the ugly bits hidden from the framework's user.

Check out [the README](https://github.com/rcrowley/go-tigertonic#usage) for
more info. Richard has also [written](http://rcrowley.org/articles/tiger-tonic.html)
and [spoken](http://rcrowley.org/talks/gosf-2014-01-15.html#1) about
Tigertonic on various occasions. It's all well worth reading.

Here's an example of a very simple tigertonic service:

<pre>
type Book struct {
        Author, Title string
}

// this takes a Book object and returns an empty body
func PutBook(u *url.URL, h http.Header, book *Book) (status int, responseHeaders http.Header, _ interface{}, err error){ ... } 
// this takes an empty body and returns a Book object
func GetBook(u *url.URL, h http.Header, _ interface{}) (status int, responseHeaders http.Header, book *Book, err error) {}

func main() {
        mux := tigertonic.NewTrieServeMux()
        mux.Handle("GET", "/books/{book_id}", tigertonic.Marshaled(GetBook))
        mux.Handle("PUT", "/books/{book_id}", tigertonic.Marshaled(PutBook))

        server := tigertonic.NewServer("localhost:34334", mux)
        log.Fatal(server.ListenAndServe())
}
</pre>

(full code is [here](https://github.com/mihasya/ttmetricsexample/blob/master/basic/main.go))

### So You Want Some Metrics

At [Opsmatic](http://opsmatic.com) we strive to be a "learning organization" -
we want to learn something from every release, every change, every customer
interaction. An important component of that philosophy is an obsession with
measuring things. Jim, our CEO, wants "If you can't measure it, don't ship it"
written on his headstone when the time is right. No joke.

One of the things we wanted to measure was the number of requests served by our
API. While we were at it, we thought we'd grab the timing data too for
operational purposes.

### go-metrics and Tigertonic

Richard is adamant about everything in Tigertonic reducing to an implementation
of `http.Handler`, and with good reason: doing so enables the `Handler` that
actually performs the business logic to be wrapped in any number of completely
orthogonal `Handlers` that handle all sorts of other concerns - logging, CORS rules,
authentication.. **and metrics!** (the
[README](https://github.com/rcrowley/go-tigertonic/blob/master/README.md) lists
the available handlers.) The separation of concerns afforded by this approach is
truly refreshing.

[Go-metrics](https://github.com/rcrowley/go-metrics) is a library, also
maintained by Richard, that provides similar capabilities to Coda Hale's great
[Java metrics library](http://metrics.codahale.com/). It makes it very easy to
time and count things, as well as to extract the data from the timers and
counters.

Tigertonic comes with a few wrappers that hook up our `Handlers` directly
to these metrics. We're going to look at a couple in particular: `Timed` and
`CountedByStatusXX`. The former is a very thin wrapper around the functionality
of a go-metrics `Timer` - it just times the request and records the reading:

<pre>
func (t *Timer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
        defer t.UpdateSince(time.Now())
        t.handler.ServeHTTP(w, r)
}
</pre>

The latter is a bit more involved, but is also ultimately a thin wrapper around
some go-metrics primivites which counts the number of requests that result in a
given class of response codes `2XX`, `5XX`, etc. You can look at the code
[here](https://github.com/rcrowley/go-tigertonic/blob/abfd9c347631ef79c0b0d04e702c376efd5985fb/metrics.go#L155)

Adding a counter is done by calling `tigertonic.Counted(yourHandlerHere, ...)`.
Since the return value is also an `http.Handler`, you can pass that to
tigertonic's multiplexer or really anything that operatoes on `http.Handler` -
including the stdlib http server.

### Putting it all together

The goal at the outset was to easily capture metrics on all our endpoints. How are we doing on that? 

Quite well, it turns out. All we have to do to achieve the goals is some wrapping:

<pre>
func wrapHandler(name string, h http.Handler) http.Handler {
        return tigertonic.CountedByStatusXX(
                tigertonic.Timed(
                        tigertonic.ApacheLogged(h),
                        name,
                        metrics.DefaultRegistry,
                ),
                name,
                metrics.DefaultRegistry,
        )
}
</pre>

Then we invoke this wrapper before registering our handlers:

<pre>
mux.Handle("GET", "/books/{book_id}", wrapHandler("get-book", tigertonic.Marshaled(GetBook)))
mux.Handle("PUT", "/books/{book_id}", wrapHandler("put-book", tigertonic.Marshaled(PutBook)))
</pre>

ET VOILA. We need to give our handlers some names for the purposes of metrics
collection, so we create a little wrapper function that takes that name and a
`Handler` and wraps it in all the properly named metrics collectors. When we
need to add more handlers, we wrap those too and the data shows up for
free. In the [instrumented version of the code](https://github.com/mihasya/ttmetricsexample/blob/master/instrumented/main.go)
you can see that I've also made a call to `metrics.Log` which spawns a 
reporter goroutine off into the background, printing out the stats every 10
seconds. There are a number of more useful reporters available - for example,
I've contribued a [Librato reporter](https://github.com/rcrowley/go-metrics/blob/master/librato/librato.go)
which posts the metrics to the [Librato API](http://support.metrics.librato.com/knowledgebase/articles/66171-correlate-create-an-instrument-).

<img src="/imgs/posts/tt-metrics/graphs.png" class="constrained" />

### Slightly More Advanced

The full Opsmatic version of the above code is included below for additional
illustration. It is expanded to include the name of the service, some CORS
defaults, and two versions of the `wrap` method - one that includes a call to
`tigertonic.Marshal` and one that does not; we need the latter to accommodate a
couple of endpoints we have that do not return JSON.

<pre>
type OpsmaticService struct {
        serviceName    string
        allowedOrigins []string
        allowedHeaders []string
}

func NewOpsmaticService(name string, origins []string, headers []string) *OpsmaticService {
        return &OpsmaticService{name, origins, headers}
}

func NewDefaultOpsmaticService(name string) *OpsmaticService {
        return NewOpsmaticService(name, []string{"[redacted]"}, []string{"Authorization"})
}

func (self *OpsmaticService) WrapHandler(name string, h http.Handler) http.Handler {
        cors := tigertonic.NewCORSBuilder().AddAllowedOrigins(self.allowedOrigins...).AddAllowedHeaders(self.allowedHeaders...)

        return cors.Build(
                tigertonic.CountedByStatusXX(
                        tigertonic.Timed(
                                tigertonic.ApacheLogged(h),
                                fmt.Sprintf("%s-%s", self.serviceName, name),
                                metrics.DefaultRegistry,
                        ),
                        fmt.Sprintf("%s-%s", self.serviceName, name),
                        metrics.DefaultRegistry,
                ),
        )
}

func (self *OpsmaticService) MarshalAndWrapHandler(name string, f interface{}) http.Handler {
        return self.WrapHandler(name, tigertonic.Marshaled(f))
}
</pre>

### Conclusion

Using this little bit of boilerplate code, we can readily instrument new
endpoints as they come online without cluttering the code with counters and
timers. Using the aforementioned Librato reporter, we get graphs for new
endpoints that we deploy instantly and with zero additional wrangling. It's
quite a nice setup that required a fairly modest amount of code and requires
very minimal marginal effort on new endpoints. We hope that you enjoy it as
well.
