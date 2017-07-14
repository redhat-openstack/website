---
title: 'What did you do in Mitaka:  Ihar Hrachyshka talks about Neutron'
author: rbowen
date: 2016-04-15 16:08:04 UTC
tags: Mitaka, podcast
comments: true
published: true
---

In this installment of our "What did you do in Mitaka?" series, Ihar Hrachyshka talks about his work on Neutron both in Mitaka, and what's planned for Newton.

You can listen below. If the player doesn't work for you, you can listen [HERE](http://rdocommunity.podbean.com/mf/web/sipki2/ihar_hrachyshka_mitaka.mp3/).

<iframe id="audio_iframe" src="https://www.podbean.com/media/player/7ximn-5e7230" width="100%" height="100" frameborder="0" scrolling="no"></iframe>

**Rich**: Hello, I'm speaking with [Ihar Hrachyshka](http://tm3.org/64) about the work that he did
in the RDO community on the [Mitaka release of OpenStack](http://releases.openstack.org/mitaka/index.html). Thank you for
taking time to speak with me.

**Ihar**: Thank you for having me

**R**: Could you mention the things that you've worked on in Mitaka, both
upstream, and also specifically for [RDO](http://rdoproject.org).

**I**: One thing that I was focusing on during Mitaka in upstream is - we
are looking at how we can enhance the upgrade story for the project I
work on, which is [Neutron](https://wiki.openstack.org/wiki/Neutron).

(See [Neutron Mitaka release notes](http://docs.openstack.org/releasenotes/neutron/mitaka.html)  )

There was a lot of good work done in this regard on other projects, in
previous cycles, like in Nova. And Neutron was kind of lagging on
that. During Mitaka, we formed a sub-team that looks specifically into
the upgrade story, and we've identified several pain points that we
were addressing during this cycle, and plan to continue the work in
Neutron, and forward.

One thing that we've identified is even though so-called rolling
upgrades were kind of supported in the sense that there was some code
to handle that scenario, for upgrades. But it was never actually
validated in our CI gate, so no-one could be sure that it actually
worked. So that was one thing that we tackled. We added proper jobs to
validate these scenarios, and make sure that they work.

Another thing for upgrades is that we are looking at reducing and
maybe even eliminating any downtime for API endpoints for Neutron,
especially in the case when you have highly-available controllers. That
involves a lot of work in the code base, a lot of change there to
refactor the code. We've already started the work during Mitaka, and
we're going to proceed with that in Newton. We hope that we complete
this work in Newton, and then for all upgrades starting from Newton to
the next release, operators will be able to retain their Neutron API
available while controllers are upgraded one by one. That's one thing
that I was working on.

There are other things. There was a lot of work done in Neutron in the
scope of Quality of Service (QOS). The initial support for QOS in
Neutron was merged in Liberty, but it's still quite limited, so we
expand on what we had done in that release. Specifically, the initial
support was just for OpenVSwitch, but in Mitaka we added support for
Linuxbridge ml2 driver. We also added role-based access control for QOS
policies. We added support for so-called DSCP tags, which is a feature
to prioritize traffic based on which port it came from.

Another interesting thing that we finally tackled in Mitaka is MTU
support. This is one of the huge pain points that were identified
by operators in the past, that Neutron, while being the networking
solution for OpenStack, cannot actually properly handle MTUs - which
stands for Maximum Transfer Unit. Neutron could not actually handle,
neither standard MTUs for ethernet, nor so-called jumbo frames, which
is really bad. It means that instances did not have access to the full
capabilities of the underlying physical infrastructure. That should
hopefully go away in Mitaka, because there were several changes there,
both on the Neutron side, and on Nova, which now should make Neutron
work out of the box, both for non-standard and standard MTU sizes.

Finally, one thing to note, apart from pure upstream work in the
Master branch, is that in Neutron, in this Mitaka release, we adopted
a new approach to handle backports for stable branches. Now instead of
waiting for something to break in a user installation, and then
reacting to their bug reports, we are proactively backporting all of
the bug fixes from the latest master branch into stable branches, and
release new stable releases, often. We hope that it will reduce the
number of painful problems, in actual installations that rely on stable
branches, very significantly.

**R**: This sounds like an enormous amount of work. How many people are
you working with across how many organizations, would you estimate?

**I**: In OpenStack it's always that you work with other people. I would
say ... I don't know ... there are I think 5, 6, major contributors to
Neutron. Surely, nothing comes in OpenStack if you're just single. So
that's collaboration.

**R**: Thank you very much for your time, and we look forward to seeing
what comes in Newton.

I: Thank you.
