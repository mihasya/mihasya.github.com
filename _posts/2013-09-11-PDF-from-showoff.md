---
layout: post
title: A Reliable, simple way to get a PDF out of Showoff
---

Perpetually agonized by actually using Keynote or Powerpoint to make slides, I
continue to use [Showoff](http://github.com/schacon/showoff) to make my slide
decks. Unfortunately, the codebase appears a bit neglected, and certain features
have stopped working very well over the course of re-installs. I have neither
the Ruby-fu nor the time nor the patience to figure out why PDF generation has
stopped working (I actually don't think that particular feature ever worked for
me at all), so I've had to resort to trickery.

I am posting this here because I keep forgetting how to do this and having to
blindly figure it out each time. Hopefully my own blog will be an obvious enough
place to look. **This has only been tested on a Mac using Chrome**, but it looks
like Safari will work to with a bit of tweaking

1. Add the following to a css file that is included in your preso

    ```css
    .slide {
        width: 11in;
        height: 8in; // this may need to be lowered slightly for Safari
    }
    ```

1. run `showoff serve` from your repo
1. Go to `http://localhost:9090/singlepage` (obviously port may vary if you used `-p`)
1. Use your browsers's `Print` function to generate a PDF

DONE. Happy PDFin.
<p class="center">
    <img src="/imgs/posts/showoff/print_showoff.png" alt="print dialog"
    class="constrained" />
</p>
