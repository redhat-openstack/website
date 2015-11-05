---
title: Community Meetup at OpenStack Tokyo
author: rbowen
date: 2015-11-04 18:45:23 UTC
tags: summit, tokyo, meetup
comments: true
published: true
---

A week ago in Tokyo, we held the third RDO Community Meetup at the
OpenStack Summit. We had about 70 people in attendance, and some good
discussion. The full agenda for the meeting is at [https://etherpad.openstack.org/p/rdo-tokyo](https://etherpad.openstack.org/p/rdo-tokyo) and below are some of the things that were discussed. (The complete recording is at the bottom of this post.)

People who were in attendance, please feel free to [update and annote](https://github.com/redhat-openstack/website/blob/master/source/blog/2015-11-04-community-meetup-at-openstack-tokyo.html.md) your section of this report if you wish to add detail, or if I get anything wrong.

We started with a discussion of how the project is governed. It was observed that although we have a [weekly meeting](https://www.redhat.com/archives/rdo-list/2015-November/msg00028.html), it's not always possible for everyone to attend, but that these meetings are summarized back to the mailing list each week.

We announced that the new RDO website is live (you're looking at it now!) and that it is possible to [send pull requests](https://github.com/rbowen/rdo-website) for it now.

Haikel asked whether there was any interest in his project of an RDO aarch64 port, and identified a few people who expressed interest.

Trown talked a bit about the status of [RDO-Manager](https://www.rdoproject.org/rdo-manager/) in Liberty. Liberty is the first release where RDO-Manager has released at the same time, which is a big step. He briefly discussed the RDO Manager quickstart that is being worked on. Check back here later for a link to Trown's more detailed writeup.

Regarding the question of the relationship between RDO Manager and TripleO, it was established that RDO Manager is a downstream of TripleO, rather than being an upstream effort. It's more than just TripleO, but, rather, is a distribution of several tools, built on top of TripleO.

We spoke briefly about documenting what all of the moving pieces of the RDO project are, and how they fit together. Haikel said that he's made a start at documenting this, and drawing diagrams. He also encourage people to step up to participate in both documenting, and in improving the infrastructure.

A discussion arose about what the process is to get an upstream patch into RDO. From this, an [action item](https://github.com/redhat-openstack/website/issues/213) was raised to more clearly document what the process is to request patches, and where to [file tickets](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO).

We discussed the timing and frequency of test days in the Mitaka cycle, and this was later discussed more on IRC. The consensus was that there should be a test day about a week after each milestone, with a sanity check done during that week so that we don't have a catastrophic test day. Now that the [Mitaka release schedule is published](https://wiki.openstack.org/wiki/Mitaka_Release_Schedule) we should be able to put together a tentative [test day schedule](https://www.rdoproject.org/testday/) very soon.

An overview was given of the [RPM packaging](https://wiki.openstack.org/wiki/Rpm-packaging) effort in upstream OpenStack.

The relationship with CentOS was discussed, in particular the manual process required to push packages up to the repos. This process still requires that we ping the CentOS admins, but this will soon be an automated process. Haikel also enumerated the various reasons that the relationship with CentOS is still of great benefit to RDO, including exposure to a wider audience due to CentOS's recognized name. There was also a view expressed that we should run an RDO-based cloud, perhaps in addition to the CentOS infrastructure, so that we are testing on our own platform.

Finally, Rich Megginson spoke about the data aggregation effort that he is working on with Tushar Katarki. Rich will be doing a more detailed writeup of that section in the coming days.

Finally, a quick announcement was made of the upcoming [RDO Community Day at FOSDEM](https://www.redhat.com/archives/rdo-list/2015-November/msg00027.html). 

If you'd like to hear more detail from the meetup, I've put the [complete recording](http://drbacchus.com/podcasts/openstack/rdo_meetup_tokyo.mp3) up, and you can listen below. (59 minutes, 109 MB)

<audio controls>
  <source src="http://drbacchus.com/podcasts/openstack/rdo_meetup_tokyo.mp3" type="audio/mpeg">
</audio>


