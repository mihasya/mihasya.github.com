---
layout: post
title: Some Love For Ishmael
---

Back in the days of fire fighting and database optimizing at Flickr, when I
could debate the merits of different MVCC options comfortably, I built a little
tool called [Ishmael](https://github.com/mihasya/ishmael) to help us make sense
of `mk-query-digest` data more easily (apparently, the project has been moved to
the "Percona Toolit" and renamed
[`pt-query-digest`](http://www.percona.com/doc/percona-toolkit/2.2/pt-query-digest.html)).
Tim Denike made some improvements during his remaining time at Flickr after I
had left, and then Asher Feldman took the project with him to The Wikimedia
Foundation. Eventually, he sent in a large enough pull request that I simply did
not have the capacity to test it - I, after all, have not used MySQL in anger in
ages. So I did the natural thing and made Asher a collaborator on the repo.

This past week, during a moment of vanity, I noticed that there were quite a few
more stars on the repo than there had been. I wondered what might have caused
it, and shrugged. Then on Sunday the [DevOps Weekly](http://devopsweekly.com/)
email provided the answer: Asher had written [a post about MariaDB on Wikimedia's
blog](https://blog.wikimedia.org/2013/04/22/wikipedia-adopts-mariadb/), in which he mentions their use of Ishmael in comparing performance between
old and new database versions. It is a good read for anyone interested in
database migrations and upgrades, especially "doing it live!"

Everyone, look, this is my "proud open source moment" face.
