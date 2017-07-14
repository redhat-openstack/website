---
title: 'What did you do in Mitaka? : Ivan Chavero'
author: rbowen
date: 2016-04-14 14:53:07 UTC
tags: mitaka
comments: true
published: true
---

*This is the first in what will hopefully be a long series of interviews with OpenStack engineers about what they worked on in the Mitaka cycle.*


The [OpenStack](http://openstack.org/)  cloud software project recently released the [Mitaka
release](http://releases.openstack.org/mitaka/index.html). 
[RDO](http://rdoproject.org/) is a community distribution of OpenStack. I've invited
several of the engineers that work on RDO to talk about what they did
in the Mitaka cycle.

<iframe id="audio_iframe" src="https://www.podbean.com/media/player/spvip-5e6b58" width="100%" height="100" frameborder="0" scrolling="no"></iframe>
  
If the above player doesn't appear, or doesn't work for you, you can listen <a href="http://rdocommunity.podbean.com/mf/play/urpzjr/ivan_chavero_packstack.mp3">here</a>.
 
**Rich**: Mitaka is ready now, and before we move on to Newton, we should
celebrate what we've done in Mitaka. I'm speaking with [Ivan
Chavero](http://tm3.org/63). I
understand that you worked primarily on [packstack](https://wiki.openstack.org/wiki/Packstack). I've had to
correct a number of people over the last few months who think that
packstack is abandoned, and we're not doing it any more. While, at the
same time, the people at [CERN](www.cern.ch) use packstack for a lot of things. and I
know that they're an unusual case, but there are other people that are
using it.

Tell us what you did in the Mitaka cycle.

**Ivan**: Well, we fixed a lot of bugs. We had a lot of problems because
there was some [migration from Keystone version 2 to Keystone version 3](http://docs.openstack.org/developer/keystone/http-api.html#should-i-use-v2-0-or-v3).
We added some other components like, [Ceilometer was split into aodh
and Gnocci](http://superuser.openstack.org/articles/ceilometer-gnocchi-and-aodh-liberty-progress), and we added that stuff.

I think it's pretty stable right now. 

We added more features to
Neutron. Everything we have to ... the new stuff, we have to test. We
add it to Packstack.

I wanted to add [Magnum](https://wiki.openstack.org/wiki/Magnum), but it wasn't a priority. And there's other
stuff like [Ceph](http://ceph.com/) that we wanted to add, but it was just like, let's fix
bugs, let's fix the stuff we need, and keep Packstack stable.

We did a lot of bug fixes for Packstack being able to work properly
with the CI infrastructure. Pretty much fixing a lot of bugs that we
found on the road.

**R**: Some of those other things that you mentioned - Magnum and Ceph and
so on, are those going to be goals for the Newton cycle, then?

**I**: Well, I want them to be goals, but I have to discuss it with the
community.

**R**: Who else in the community is working on Packstack?

**I**: There's a lot of people. In this cycle we had a lot of
contributions from outside the RDO community, which was very positive.
[Javier Peña](http://stackalytics.com/report/users/jpena-c) is working
on that. [David Simard](http://stackalytics.com/report/users/dmsimard)
is working on that from the CI part, a lot of stuff. [Alan
Pevec](http://stackalytics.com/report/users/apevec) is our
guiding light. And [Martin
Mágr](http://stackalytics.com/report/users/mmagr),
who is the current PTL - he's stepping down but right now he's the
PTL. A lot of people that are always asking stuff about Packstack and
doing reviews, and actually submitting patches.

You know, I think that people think that Packstack is dead because
it's not recommended for production use. Only if you really know what
you're doing, you should use it in production, but it's not
recommended. [TripleO](https://www.rdoproject.org/tripleo/) is the recommended stuff for production, and
Packstack is for doing the experiments, and proof-of-concept stuff.

But I use it on my home OpenStack deployment, and I do a lot of
experiments. It's pretty good for experimenting, because it's pretty
lightweight, and it's very easy to modify.

**R**: Thank you very much for your time, and I look forward to what's
coming in Newton!

**I**: Thank you!