---
title: The 3 Little Mistakes
layout: post
---

There are many mistakes people make when programming for the web. Here are three that I've seen everywhere I've worked. I think they deserve extra attention because they are relatively easy to avoid, but very difficult to recover from.

### Encodings

Even if you only ever have US based users, enough folks have accents in their names and all sorts of other reasons to introduce non-ascii characters into your systems. Enforce UTF-8 at all levels, and especially at storage time. Fixing an encoding issue is difficult, and usually involves re-writing all the data. It is unpleasant, no matter the underlying datastore.

### Limits and Pagination on API Requests

This is pretty straight-forward, but I've seen it neglected in practice quite a few times. Whether it's a `POST` where the bath size isn't bounded or a `GET` that returns "all the _____," it inevitably becomes a nightmare that is difficult to fix due to clients not expecting to have to paginate. This is particularly exacerbated in APIs used by mobile apps - a total fix requires getting all the client apps to upgrade to a new version of the library AND for all their users to upgrade.

### Timezones

This issue is similar to the encoding one - a matter of consistency. Storing everythign at UTC forces consistency on the data. Not doing so leaves an opening for rows in the same table to be written with different time zones, making querying and comparisons more complicated and possibly expensive. Almost without exception, you only want to think about timezones at display or query time; it's much easier to deal with DST when your data is normalized to the same, consistent, season-immune representation.

Cal's [book](http://www.amazon.com/dp/0596102356) has a lot of really good info on other details that merit attention when working on the Internets.
