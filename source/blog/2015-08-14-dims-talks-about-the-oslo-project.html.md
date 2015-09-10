---
title: Dims talks about the Oslo project
date: 2015-08-14 11:12:31
author: rbowen
---

_This is the second in what I hope is a long-running series of interviews with the various OpenStack PTLs (Project Technical Leads), in an effort to better understand what the various projects do, what's new in the Kilo release, and what we can expect in Liberty, and beyond._

You can listen to the recording --> [here](http://drbacchus.com/podcasts/openstack/dims_oslo.mp3) <--, and the transcript is below.

**Rich**: Hi, this is Rich Bowen. I am the OpenStack Community Liaison at Red
Hat, and continuing my series on Project Technical Leads (PTLs) at
OpenStack, I'm talking with Davanum Srinivas, who I've known for a few
years outside of the OpenStack context, and he is the PTL for the [Oslo
project](https://wiki.openstack.org/wiki/Oslo).

Oslo is the OpenStack Commons Library.

Thanks for speaking with me Davanum.

**Dims**: Thanks, Rich. You can call me Dims. You know me by Dims.

**R**: Yeah, I know. _laughs_

**R**: Give us a little bit of background. How long has the Oslo project been around?

**D**: We were doing things differently - we have a really old history,
though. Some of the initial effort was started back in release B.

**R**: Oh, that long ago.

**D**: Yeah. So, what we were doing ... why did Oslo come about? Oslo came
about because way back when Nova started, we started splitting code
from Nova into separate projects. But these projects were sharing
code, so we were trying to figure out the best way to synchronize code
between these sibling or child projects. So we ended up with a single
repository of source code, called Oslo Incubator, where you would have
the master copy, and everybody would sync from there, but what was
happening was, everybody had their own sync schedule. Some people were
contributing patches back, and it was becoming hard to maintain those
patches. We decided we had to change the method the team worked. And
we started releasing libraries, for specific purposes. What you saw in
Kilo was a big bang explosion of a huge number of libraries from the
Oslo team. Most of it was code in Oslo Incubator. We just had to cut
the modules in a proper shape, sequence, with an API, with a correct
set of dependencies, and that's what we ended up releasing, one by
one. Other projects started using things like oslo.config,
oslo.messaging, oslo.db, oslo.log, and all these different libraries.

So that's where we are today.

**R**: What is it that you'll be doing in coming releases? Is it just the
effort of identifying duplication, or are you actively developing new
libraries.

**D**: Yes, we are. In Liberty, we have 5 new libraries coming up. Three
of them start with 'oslo.' - like oslo.cache, oslo.reports,
oslo.service. The other two do not have 'oslo' in their names. One is
called [Automaton](https://wiki.openstack.org/wiki/Oslo#automaton), the other is called [Futurist](https://wiki.openstack.org/wiki/Oslo#futurist).

Automaton is a library for building state machines and things like
that. Futurist is picking up some of the work that is done in upstream
futures and things like that and making it available to all of the
projects in the OpenStack ecosystem. 

So these two projects can be used outside of Oslo, and outside of
OpenStack by other people. That's why they don't have the Oslo name in
them.

**R**: Do you see a lot of projects outside of OpenStack using these?

**D**: We hope so. For example, there is a project called Debt Collector,
which we think fits well with how do you deprecate code and what are
the primitives that we can provide that make it easy to mark their
code being deprecated. A lot of people who work on Oslo also work in
the overall Python ecosystem, so the hope is that if we design the
libraries in such a way that it's reusable, other people will pick
some of our stuff up. But that's a stretch goal. The real goal is to
make sure that these libraries work well with the OpenStack projects.

And the other thing about these libraries is that they don't drag in
the Oslo baggage. For example, if you take oslo.db or oslo.messaging,
they pull in a lot of other Oslo libraries, and these little libraries
are designed so that they don't drag in other Oslo libraries. So
that's the other good thing about these. 

The way the Oslo project has been for the last few cycles has been
that we are doing a lot of experiments in Oslo, which have been rolled
out to other projects in the OpenStack ecosystem. Oslo is slightly
different from other projects in the sense that people don't work on
it full time. So we have people work part time on it, but they focus
mainly on other bigger projects. They come here when they need a
feature or a fix, or things like that, and then they stay. We have a
few cores who monitor reviews and bugs across all of the Oslo projects,
but we also have people who specifically focus on individual little
libraries, and they get core rights there. 

People in the OpenStack ecosystem are experimenting with different structures, like for
Neutron, they put everything into subrepos, and they experiement that
way. And I think that what we are doing might be more useful to Nova,
for example, and other projects, where they would like to keep a set
of cores together, and also have subsystem maintainers and things like
that.

Oslo is a good place to do this experimentation because the code base
is not that huge, and the community is not that big as well. And the
rate of churn, in terms of bugs and reviews, is not that high, as
well. We are also experimenting with release versioning and things
like that, and some of the things that you've seen recently driven by
Doug, across the OpenStack ecosystem, we tested it here first, in
terms of the versioning numbers, not having the Big Bang release, how
do we do it, and things like that.

We lead the way.

The other big thing is, for example, Python 3.4 support. All the Oslo
libraries have to be Python 3.4 complient first before they can be
used and the other projects can adopt. So we end up being in the
forefront trying to use libraries like websockify, or other libraries from
the OpenStack ecosystem, which are not Python 3.4 complient, and we
work with them to get them complient, and then use it in Oslo
libraries, and then we roll it in. So we play an important role, I
think, in the OpenStack ecosystem.

**R**: As PTL, is this a full time thing for you, or not? What are your
responsibilities as PTL?

**D**: One of the very time consuming work is getting the releases out on
a weekly basis. We try to make it predictable. At least, this cycle,
we have started to make it predictable. Earlier, we heard complaints,
we don't know when you guys are releasing, so we were not ready, and
things like that. So we have a good process this time around, where,
over the weekend, we run a bunch of tests, outside of the CI, as well
as inside our CI system, to make sure that the master of all Oslo
libraries works well with Nova, Neutron, Glance, and things like that,
and come Monday morning, we decide which projects need releases, based
on what has changed in them for the last week or so. We follow the
release management guildelines, working with Doug and Thierry, to
generate the releases during the day on Monday.

After Tuesday you don't have to worry about Oslo releases breaking the
CI or your code. That has helped a lot of projects, especially Nova,
for example. If they know there is a break late on Monday evening,
they know who to ping, and we can start triaging the issue, and by
Tuesday they are back on their feet.

That's the worst-case scenario. Best-case scenario, no problem
happens, and we are good to go. But there's always one test case, or
one scenario here or there. We always try to test beforehand, but like
somebody said, it's a living thing - the ecosystem, the CI system, is
like an emergent behavior, it's a living thing. It's hard.