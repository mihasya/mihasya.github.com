---
title: On "Infrastructure for Startups"
layout: post
published: true
---

<a href="http://www.paulhammond.org/2012/startup-infrastructure/"><img alt="One of Paul's Slides" src="{{ site.url }}/imgs/posts/infrastructure-for-startups/dog.png" class="small" /></a>

Conference talks on the subject of infrastructure are often lacking in actionable advice - especially for fledgling startups. I am shamefully guilty of this myself.

A notable exception is a recent talk by Paul Hammond, my old manager and good friend. His Velocity 2012 talk titled <a href="http://www.paulhammond.org/2012/startup-infrastructure/">"Infrastructure for Startups"</a> was a refreshing dose of pragmatism, drawn from the experience of building and growing TypeKit. Paul ran Flickr Engineering before that - he has street cred for weeks. Unfortunately, video of the talk does not appear to be available, though that may change soon according to Paul.

Though I am prone to lengthy rants about building things the "right" way and am often heard advocating more rigorous planning at the start, I can't agree more with most of what Paul says - a 2-3 person startup just doesn't have the time to be mucking around with anything but the product they're building. This being 2012, there is an army of service providers ready to share the burden - for much less than the opportunity cost of building everything yourself.

### Don't forget to measure

I'd add one more thing to Paul's lists (<a href="http://www.paulhammond.org/2012/startup-infrastructure/slides/slide.187.png">here</a> and <a href="http://www.paulhammond.org/2012/startup-infrastructure/slides/slide.188.png">here</a>) - you need good graphs right away. I'm surprised Paul didn't mention this after "all performance problems have been on things we don't yet measure." Good metrics collection and display are critical to both business success and technical efficiency. The easier it is to put together dashboards that zero in on meaningful metrics and correlations, the more you'll do it, and the more quickly you'll identify inefficiencies and opportunities.

I've yet to hear a favorable review of the baked in ec2 monitoring tools (CloudWatch), so I, as usual, recommend the slick, easy to use, gorgeous <a href="http://metrics.librato.com">Librato Metrics</a> for these purposes. As a bonus, the product comes with some basic alerting features (haven't tried yet, in the interest of honesty), so it may help stall or obviate the need to set up nagios or one of the related monsters. All the tools for getting data in <a href="http://support.metrics.librato.com/knowledgebase/articles/24205-custom-and-contributed-data-collectors">have already been written</a>.

Speaking of alerts, <a href="http://pagerduty.com">PagerDuty</a> is another no-brainer for small teams starting to set up more fine-grained monitoring. Big surprise: Librato has PagerDuty integration.

I had some experience with the competing Cloudkick product and sadly don't have many kind words, although much has probably changed since our last interaction.
