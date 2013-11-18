---
layout: post
title: The Myth of the Uninterrupted Programmer
---

<img src="/imgs/posts/uninterrupted/warcraft.jpg" class="right small"  />
This [post about office noise level](http://blog.42floors.com/our-office-is-too-loud/#.UkSLhhb3BZK)
and distractions came through my inbox, and a particular voice in the comments
section caught my eye.

> "Show me an office with caves and I'll show you my resume"

Plenty of comments followed echoing this sentiment.

While I agree that stretches of concentration are important for figuring out a
specific task, I think that this chorus is at the heart of a serious
misunderstanding many engineers have about their value as members of an
organization that is resulting in a tremendous amount of waste.

Sure, constant interruptions and context switches are exhausting and difficult.
I'm not suggesting that we should spend all day turning from one conversation to
another. It's easy to overdo meetings and office shennanigans. However, a
healthy amount of interaction and socialization has some very important
benefits.

## Interruptions cause you to retrace your steps - this is often good

There is a much less edifying real-life counterpoint to the widely romanticized
deeply concentrated programmer. It's that of a programmer spending 4 hours
trying to track down a confusing, elusive bug, only to figure it all out 5
minutes after walking away from it.  I've done it, I've seen it, and I continue doing
it and seeing it.

There's a very simple explanation for this phenomenon: in order to be able to
reason about an algorithm, especially a complex one, we have to assume and take
a whole load of things for granted. The stack, the configuration, the interfaces
on top of which we're working.

An incorrect assumption is a common source of confusion and infuriating
debugging. If you're lucky, the false assumption will be illuminated by a
debugger or a log line. However, the longer you'd been staring at the same
problem, the more likely you are to miss something much more simple. That helper
function you stubbed out earlier while testing something else? Yeah, that's
still there. You'll feel real dumb when you remember.

Interruptions - planned or unplanned - cause you to "resurface" and to have to
re-engage the problem almost from scratch. Part of that process is rebuilding
that chain of assumptions. Stepping back from a problem and seeing the bigger
picture is often much more productive than spinning down in the bowels of your
code.

(Here's a great [talk](http://vimeo.com/44984049) Joe Damato with a pretty good
discussion of discovering violations in your basic assumptions)

### Re-reading your own code is the best way to write readable code

If you're writing a bunch of code in a hurry, and especially if you're doing so
while fighting through bugs, you're likely leaving a disaster zone in your wake.
Even if you think you're writing "clean code" and writing tests to go along with
it, there are probably sections in your code that barely make any sense by the
time you've gotten them to do what you want.

Pair programming is one way of solving this - your passenger will point at the
screen and call you out for getting too fancy or too casual with your
single-letter variables. I'm still torn on pair programming, but I do think
it's a great idea to re-read your own code regularly for reasons related to the
first secion.

While an interruption causing you to lose context can be annoying, the forced
re-construction of context can point out flaws in your reasoning and force you
to recognize sections of code that are hard to read - because you'll have
trouble reading them too.

## Your peer has likely seen the same problem before

We spend a lot of time talking about sharing code and know-how in the OSS
community. We've also been putting lots of emphasis on DRY - "Don't Repeat
Yourself." Well, it's more like DRO - "Don't repeat others." This broader
message applies to your peers as well. When you're dealing with OSS code and you
find a bug you can't sort out, you ask the internet and see if anyone else has
had the same problem. For whatever reason, we find this easy, but we find
turning to our neighbor and asking the same thing difficult - PROBABLY because
we're afraid of the stigma of interrupting them. So we spin our wheels. Awesome.

Don't forget that someone in the room  is very likely to have used the same
software and tools you're using, seen similar problems in the same or similar
systems, or, if you're really lucky, wrote the damn thing in the first place.

Interruptions often come with an opportunity to ask your colleagues - they
may well be interrupted too.

## Are you even solving the correct problem?

Many conversations between engineers about productivity make it sound like the
goal of programming is to write as many lines of code as possible. This has been
reinforced by stories of companies like Google which were "run by the
engineers." I believe this has caused people to imagine the original Google
employees all furisouly writing code for 16 hours a day without uttering a word
to each other or anyone else, inevitably producing the world's best search
engine.

<div class="left">
<img src="http://farm3.staticflickr.com/2600/3998279762_ae2c6ede06_n.jpg"
class="small"/><br />
<small>Photo by <a href="http://www.flickr.com/photos/10422465@N00/3998279762">
Paul Simpson</a></small>
</div>
This is pure professional hubris. Hubris is all I hear when engineers bitch
about product and project managers interrupting them with all their "process."
Sure, it's easy to overdo, but it brings us back to that whole
["know your business"](http://blog.mihasya.com/2013/06/11/how-do-i-devops.html)
thing.

Sure, if you sit in your little cave for 16 hours, you're going to write a whole
bunch of code. But... what did you just produce? Sure, it's "correct" in the
strict engineering sense of the way - the right inputs produce the right
outputs, etc.. But is it correct in the context of a product? Did you actually
build something people will want? Does it work, as in, does it behave the way a
customer would expect?  Chances are it does not, because it's hard to build
things for humans without talking to them. 

The reality of the matter is that Google's early engineers were successful
because they were good at all those other things as well, not because they
ignored everything around them and ground code.

## How hard are you concentrating, anyway?

You can tell engineers don't REALLY mind being interrupted by just looking at
the constant shitpile of activity on HackerNews, Twitter, Google Plus, IRC, etc.
It's not about interruptions. It's just flat out whining. We don't like getting
out of our comfort zone and thinking about things about which we're not that
good at thinking. Stop coming up with excuses and get better at it.

## Interruptions force you to ship.

There's no disputing that interruptions and context switches are painful and
difficult, but knowing that they're coming can have a positive impact - if you
anticipate only having a couple of hours before you're interrupted, you will
work in more incremental chunks, which lend itself better to testing,
documentation, abstraction etc. These are all good things.

For example - there are guests coming over for dinner shortly, so I'm just
going to wrap this up and post it. It's too long as is.

## tl;dr

Sitting in a dark basement in silence great for leveling-up your World of
Warcraft character. It's no way to build good, usable software. There's no
substitute for good communication. 
