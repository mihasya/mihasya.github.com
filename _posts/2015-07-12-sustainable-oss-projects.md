---
layout: post
title: A Story and Some Tips For Sustainable OSS Projects
---

This past week Kyle Kingsbury
[tweeted](https://twitter.com/aphyr/status/618880016991059968) about being
flooded with pull requests caused by changes to the InfluxDB API. Concidentally,
I had just spent several hours over the July 4th weekend dealing with the same
problem in [`go-metrics`](https://github.com/rcrowley/go-metrics), albeit on a
smaller scale. I think these are symptoms of a very very common problem with OSS
projects.

### A bit of history

The Metrics library has a very simple core API made up of various
metrics-related interfaces - you can create metrics, push in new values, and
read the metrics' current values and aggregates. Simple and beautiful.

The library was originally put together by the epic Richard Crowley while he was working
at Betable. He was starting to experiment with using Go for services, and needed
a way to keep track of them. Finding no satisfactory equivalent to [Coda Hale's
metrics library for Java](https://github.com/dropwizard/metrics), Richard made his
own. Folks quickly wrote adapters to push metrics into their time series system
of choice - I wrote one for Librato. Richard happily merged the PRs.

The core features were built, everything worked reasonably well, and Richard
moved on to a job that doesn't use Go nearly as heavily. Several months later, I
noticed `go-metrics` had 20+ open pull requests. I pinged Richard and offered to
help maintain the project. We were using it heavily, and were happy to pay our
dues. Richard immediately made myself and [Wade](https://github.com/wadey), a
Betable employee, collaborators on the repository. I started looking over the
PRs.

### The Paralysis

<p class="center">
    <img src="/imgs/posts/gometrics/papers.jpg" alt="too many papers"
    class="constrained"/><br />
    <small>Cropped from photo by <a
    href="https://www.flickr.com/photos/wheatfields/4774087006">wheatfields</a></small>
</p>

I quickly realized that I was not qualified to review a good chunk of the PRs:

* Update for InfluxDB 0.9
* Fallback to old influxdb client snapshot
* Update influxdb client

"I don't know _jack_ about InfluxDB," I thought. "How am I supposed to decide
what gets merged and what doesn't?" There was a Riemann client in there too. Who
am I to judge a Riemann client lib?

I had also observed that the InfluxDB API was still changing quite a bit. I
remembered that there had previously been a wave of PRs about InfluxDB. _Wait,
was this the same wave?_

Another issue that gave me pause was that I had no idea how many people were
already using this library with Influx, expecting the current client to continue
working. How many builds would break? Go's notoriously loosey-goosey dependency
management made it likely that as soon as I merged any API changing PR, I would
get another PR changing it back the next day.

There was also a PR about adding a Riemann client. _Welp, I don't use that
regularly either.._

### Clarity

In the summer of 2012, I did a brief contacting stint with Librato. Among other things, I
helped build a Java client library. They also asked me to tie that client to
Coda's library, so I obliged and [submited a PR](https://github.com/dropwizard/metrics/pull/258).
Coda replied fairly tersely:

> Really cool functionality, but I've been declining further modules for the
> main Metrics distribution. I suggest you run this as your own project. I'll be
> adding a section in the Metrics documentation with links to related libraries,
> and this should definitely be in it.

At the time, I thought "Well that kinda sucks. I want my code up there, with the
cool kids' code in the really popular library." Now, literally 3 years later, I
understood exactly why Coda made that move. He didn't use Librato. He had no
idea what would make a good or bad Librato client. It was just more surface area
to support. He had enough to worry about with core Metrics and DropWizard
features, keeping up with JVM changes and compatibility issues, etc, Never mind
other projects.

### The Path Forward

<p class="center">
    <img src="/imgs/posts/gometrics/wood_joints.jpg" alt="well fitted pieces"
    class="constrained"/><br />
    <small>Cropped from photo by <a
    href="https://www.flickr.com/photos/matthewbyrne/3802556684">matthewbyrne</a></small>
</p>

Though Kyle points out that [this may not be the best approach for every
project](https://twitter.com/aphyr/status/618905828846866432),
it seemed very clear to me that the only way the `go-metrics` lib could continue
to be maintained, at least by myself and Wade, was to modularize and move
any external dependencies out to their own libraries - with their own
maintainers, and hopefully their own communities. It's not going to make the
"moving target API" problem any easier, but it'll put the
solution into the hands of the people who are actually interacting with the
problem and have a vested interest in achieving and maintaining a palatable
solution. It removes myself, Richard, and Wade, completely disinterested and
uninitiated bystanders, from the critical path to a solution.

At the end of the day, it's just Separation of Concerns. It's just good
organization. The task is broken up into small semi-independent pieces with
responsibility for each piece given to the person with the most interest in that
piece. There's a corresponding and very palpable feeling of psychological
relief.  "Review the PRs for `go-metrics`" is no longer this huge nebulous task
that will require a huge amount of context and deep understanding of some
additional system. I know the core APIs. I can evaluate changes to that fairly
quickly.

### Practical Tips For Maintainers

If you find yourself maintaining a small OSS project with a fairly well defined
scope and API, here are some tips to keep yourself sane (some of these are more
general, not specific to the above story):

* **Always have a buddy.** If your project gets any traction and you start
seeing community adoption, find one or more particularly enthusiastic users and
convince them to help carry the load. We all want to take care of our baby
projects, but real life is what it is. People change jobs, have health issues,
go on lengthy vacations, start families, become vampires. Some combination of
those things will likely make your interest in any given project oscillate, and
you should have a framework in place for making sure you don't create another
zombie on GitHub.
* **Resist dependencies.** If someone creates a PR which brings in a new library,
especially code that talks to something over the network - a server or SaaS
of some kind - strongly consider pushing the author towards starting their own
library. If this is not possible due to a lack of APIs, invest the time in
adding hooks instead. It'll be worth it.
* **Have a concise contribution policy.** This will greatly reduce the burden of
having to reply to PRs that suffer from obvious code quality issues. It is an
absolute MUST to have a pre-written set of rules to appeal to instead of having
to post seemingly arbitrary responses to individual PR authors.
* **Enforce guidelines automatically whenever possible.** We are living in a
remarkable age. The tools available to maintaners are simply amazing. With the
help of services like GitHub, TravisCI, CodeClimate, etc., there's no need to
maintain a mailing list, apply patches by hand, set up some jury-rigged systems
for running tests. It's all free, and it's all great. Use it. `go-metrics` and
`go-tigertonic` do not take advantage of the OSS ecosystem, and I am about to
fix that. One other small note here: you should make it very easy to replicate
the exact process that the build is going to perform locally.  There should be a
`Makefile` or something similar containing the one command that the build tool
is going to run so that folks can validate their branches easily without having
to wait on the CI tool to run against their PR.

Hopefully you find our experience with maintaining and reviving `go-metrics`
helpful, and this story helps you avoid similar pitfalls. Happy hacking.
