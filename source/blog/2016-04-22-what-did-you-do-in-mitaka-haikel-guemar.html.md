---
title: What did you do in MItaka? Haïkel Guémar
author: rbowen
date: 2016-04-22 12:51:28 UTC
tags: mitaka, podcast, haikel-guemar, software-factory, packaging
comments: true
published: true
---

In this installment of the "What Did You Do in Mitaka" series, I'm
speaking with Haïkel Guémar


<iframe id='audio_iframe' src='https://www.podbean.com/media/player/z8zks-5ea7c6?from=yiiadmin' data-link='http://www.podbean.com/media/player/z8zks-5ea7c6?from=yiiadmin' height='100' width='100%' frameborder='0' scrolling='no' data-name='pb-iframe-player' ></iframe>

(If the above player doesn't work for you, you can download the audio [HERE](https://rdocommunity.podbean.com/mf/play/pfcayj/haikel-guemar-mitaka.mp/).)


**Rich**: Thanks for making time to speak with me.

**Haïkel**: Thank you.

**R**: So, tell me, what did you do in Mitaka?

**H**: I work on the [RDO](http://rdoproject.org) engineering team - the team that is responsible
for the stewardship of RDO. For this cycle, I've been focusing on our
new packaging work flow.

We were using, for a long time, a piece of infrastructure taken from
Fedora, CentOS, and GitHub. This didn't work very well, and was not
providing a consistent experience for the contributors. So we've been
working with another team at Red Hat to provide a more integrated
platform, and one that mirrors the one that we have upstream, based on
the same tools - meaning Git, Gerrit, Jenkins, Nodepool, Zuul - that is
called [Software Factory](https://github.com/redhat-cip/software-factory). So we've been working with the Software
Factory team to provide a specialization of that platform called
[RPMFactory](https://github.com/redhat-cip/rpmfactory).

RPMFactory is a platform specialized for producing RPMs in a
continuous delivery fashion. It has all the advantages of the old
tooling we have been using, but with more consistency. You don't have
to look in different places to find the source code, the packaging,
and stuff like that. Everything is under a single portal.

That's what I've been focusing on during this cycle, on top of my
usual duties, which is producing packages and fixing it.

**R**: And looking forward to the Newton release, what do you think you're
going to be working on in that cycle?

**H**: While we've been working in the new workflow, we've been setting a
new goal, that is to decrease the gap between upstream releases and
RDO releases down to 2 weeks. Well, we did it [on the very same day](https://www.rdoproject.org/blog/2016/04/rdo-mitaka-released/) for
Mitaka! So my goal would be for Newton to do as good as this time, or
even better. Why not under 2 hours? Not putting on ourselves more
pressure, but to try to release almost at the same time as upstream
GA, RDO. And also with the same quality standards.

One of the few things that I was not happy with during the Mitaka
cycle was mostly the fact that we didn't manage to release some
packages in time, so I'd like to do better. Soon enough I will be
asking for people to fill in a wish list on packaging, so that we are
able to work on that earlier. And so we could release them on time
with GA.

**R**: Thanks again for taking the time to do this.

**H**: Thank you Rich, for the series.
