---
title: "Windshield: Display Incoming Geo Data Using PolyMaps"
layout: post
---
<img src="/imgs/posts/windshield/windshield-tv.png" class="small right"/>
While discussing what to do for a Free Friday project, [Neil](https://github.com/nilswalk) and I decided we want to build some sort of visualization related to the <a href="http://urbanairship.com/blog/2012/04/03/think-global-message-local-introducing-urban-airship-segments/">location data UA had been processing</a>. I quickly thought of the dashboard that [Jon Rohan](https://github.com/jonrohan) wrote for SimpleGeo, which would plot the coordinates that API requests were targetted at as those requests came in. After finding Jon's code, I realized that the front end portion was going to be very easy to adopt, as well as make generic. Having obtained Jon's blessing, I tidied the code up a bit and open-sourced it. Of course, the backend code that supplies _our_ geo data will remain closed source and proprietary, but there is [an example data source](https://github.com/mihasya/windshield/blob/master/example/windshield.js#L7) included to help others get started.

I called the project Windshield because the look like bugs that show up on the glass over the course of a long drive if you keep looking at it. The source is [here](https://github.com/mihasya/windshield/). I have an example up [here](/windshield/example/).

I could make this a wordy post about programming practices, javascript, and technology, but this was a really simple project. Besides, other people did most of the hard work:

 * [PolyMaps](http://polymaps.org/) did all the map parts of it.
 * [CloudMade](http://cloudmade.com) made the gorgeous tiles.
 * [Jon Rohan](github.com/jonrohan) wrote the code I aped heavy-handedly to get a grip on the thing.
 * I made the function that supplies the points pluggable so that it was easy to test and extend, so HURRAY for [higher order functions](http://en.wikipedia.org/wiki/Higher-order_function).

Probably the most surprising thing was [Aaron](https://github.com/straup) submitting a pull request hours after I had open sourced the damn thing to make the demo work correclty in FireFox. Thanks, Aaron!

Things I know I still need to do:

 * Make it easier to manipulate the map once it's created (perhaps return something from the windshield function)
 * Explore the concept of a PolyMaps "layer"
     * Can I create a custom layer for my points and use the DOM element for that layer to more efficeintly prune points over time? The present implementation of selecting all `circle` tags, then removing the parent of their parent of their parent brings the browser to its knees
 * Remove points over time in a FIFO arrangement? Would require quite a bit more javascript than I presently have appetite for, but who knows...

### Highly relevant:

<p class="center">
    <img src="/imgs/posts/windshield/nils-todo-twitter.png" class="center"/>
</p>


