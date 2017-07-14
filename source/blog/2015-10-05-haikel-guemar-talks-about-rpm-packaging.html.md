---
title: Haikel Guemar talks about RPM packaging
author: rbowen
date: 2015-10-05 13:38:27 UTC
tags: packaging, ptl, podcast, openstack
comments: true
published: true
---

*This continues my [series talking with OpenStack project PTLs](/blog/ptl-interviews) (Project Technical Leads) about their projects, what's new in Liberty, and what's coming in future releases.*

If the audio player below doesn't work for you, you can listen to the interview [HERE](http://drbacchus.com/podcasts/openstack/haikel_packaging.mp3) or
see the transcript below.

<audio controls>
  <source src="http://drbacchus.com/podcasts/openstack/haikel_packaging.mp3" type="audio/mpeg">
</audio>


**R**: I'm Rich Bowen, I'm the community liaison for the OpenStack project
at Red Hat. I'm speaking with Haikel Guemar, who is the Project
Technical Lead (PTL) on the [RPM packaging project](https://wiki.openstack.org/wiki/Rpm-packaging) at OpenStack. Thanks
for taking this time to speak with me.

**H**: Thank you, Rich. I appreciate it.

**R**: This is a fairly new project, in terms of actually being part of
OpenStack - is that right?

**H**: Yeah, exactly. We've been an official project for a few months, and
we're still in bootstrapping. There has been some discussion at the
last Summit to converge packaging project to work together, upstream.
After some discussion we discussion, we decided to split between two
separate projects, one around Debian packaging, and one around RPM
packaging. So we've been working with people from RDO, SUSE, and also
some people from Mirantis, to work together on RPM packaging upstream.

By the way, I'm co-PTL of the project. I'm co-leading the project with
Dirk Mueller from SUSE. Hats off to Dirk, if you're listening to us.
We're trying to bring packaging into the heart of the project, because
OpenStack is fairly good at trying to develop its own software
pipeline, and the only bit that was missing was packaging - the last
missing bit between the project and the end-user.

So, we've been trying to do that, and also help the upstream project
to understand what are our needs upstream, because we have very
specific requirements that we want them to hear. 

**R**: How do you picture this project changing the downstream projects like
RDO and Fuel? Do you think there will be a big impact on those, or
will they go on as though nothing's changed?

**H**: I think there will be some impact, because if all the downstream
packages are working on this, at some point we will be able to produce
multiple packagings. There will still be some differences, but what we
are working on - trying to mitigate them and trying to share most of
our workers.

Speaking now with my RDO hat - I do hope that at some point, RDO will
derive from our upstream RPM packaging. That's what we want to do - be
closer to upstream. That's the point of RDO, not of the upstream
project.

**R**: Looking forward to that time, what would then be the role of
projects like RDO, and Fuel. Would they still be relevant, or do you
see them going away long term. 

**H**: Tough question. I think they will still be there, because at some
point we will be targeting very different segments. For instance, RDO
itself is the upstream for other downstream distributions of
OpenStack. Like, obviously, the Red Hat one, or Cisco's, or many
others. I think that maybe RDO might disappear, maybe, but we still
want to have some degree of integration. I hope that most of it will
go upstream, because that's where people are working, and we want to
deal with before it reaches the users, not after we release.

**R**: In Liberty, and even more in future releases, with the integrated
release kind of going away, and more reliance on tags, is the RPM
packaging project going to package everything, or just a particular
tag, or will that be up to the community.

**H**: That will be up to the community. The core upstream RPM packaging
team will be working on core projects. We will be looking at Big Tent
projects according to our own drive. But if people want to contribute
any other Big Tent projects, they are welcome to do it. We are really
looking forward to extending the comunity. We're still a small team so
we will be focusing on core OpenStack. Currently we're working on
clients because that's what everyone needs to work with OpenStack, and
when we're done, then we'll start working on services.

**R**: One of the things that RDO does is the CI effort within the CentOS
infrastructure. And there's obviously also a lot of that happening in
the upstream OpenStack. Will the RPM packaging rely on the upstream
for this?

**H**: We had some talks about it, and that was a funny discussion,
because we discovered that our respective CI are more or less the same
steps, and encounter the same issues. So we are willing to push more
of the CI upstream.

I personally hope - but it's not something that we agreed on - I hope
that we will become part of the continuous delivery pipeline of
OpenStack. That means that every commit from upstream would be
packaged and then introduced into the CI, and then these patches would
be usable for other CI, since we don't have any concrete example, I
will take one from RDO. We've been working with Puppet upstream CI
recently, as they wanted to have come CI on CentOS, so we've been
working on fixing staging issues that were affecting their CI so they
could test properly Puppet upstream modules on CentOS. That was
amazing because they helped us find many many issues that we were able to
solve very early. And that's what I hope for the upstream RPM project.

**R**: I noticed that they are no candidates for the PTL for the project
in the coming election. Is that just because the project is so new,
you're not going to have turnover in that?

**H**: Yeah, that was the discussion just this afternoon about it. We're
still new, and we don't want to confuse people with elections just
now. We're still building the community, and we've been working on
that with Dirk. The project won't be leaderless. It's still difficult
too, because we still have so much to do.

The main difference between the RPM packaging team and other teams is
that we're not solely dedicated to work on upstream tasks, like
Cinder, Glance, or Nova. We have much more downstream-focused teams,
so we wanted to stay focused. So we thought we would just keep the
same PTLs for the next cycle. And then when we are more mature we will
have candidacy. 

**R**: As PTL ... it's been interesting talking with various projects,
because the role of PTL can vary a great deal depending on the size
and maturity of the project. I was wondering if you could tell us what
your responsibilities are as PTL.

**H**: Our responsibility is ensuring that all the community team is
aligned around the same goals. It means also trying to gather new
members. For instance, being the PTL brings the attention on you, so
people contact you so they can join the project. As we are still
small, that was a critical path, and I have been trying to have them
join the team, and make them active participants. I've been pretty
happy that, for instance, Mirantis people reached out to me, and
they've been able to join, and I appreciate that. One of the other
things is to ensure that we are working together. I'm pretty happy
that I am co-PTL with Dirk, because we can share the load. It is very
tiring. We have to schedule meetings and gather people. Recently we
had a hack day, to solve some of our impediments. We have to ensure
that we have enough people, and we have the right people, to help. For
instance, we have tooling issues, so I tried to get some people who
would be likely to work on that aspect available for that day. I do
not view the PTL as someone who decides everything. It's more about
being the coordinator.

**R**: Finally: if somebody does want to get involved in the project,
where should they come? Is it to the mailing list, or IRC, or what?

**H**: We're still using the openstack-devel mailing list with 'RPM
Packaging' topics. We have an IRC channel on Freenode, which is
\#openstack-rpm-packaging. We have regular meetings every two weeks on
Thursday. We sometimes have an additional meeting, at the same time.
We keep logs of our agenda. And if you need anything else, just ping
`number80` or `dirk` on the channel, and we'd be happy to help you.

**R**: Thank you again for taking time to speak with me.

**H**: Thank you.