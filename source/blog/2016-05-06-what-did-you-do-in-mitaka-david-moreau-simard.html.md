---
title: What did you do in Mitaka? David Moreau Simard
author: rbowen
date: 2016-05-06 13:47:48 UTC
tags: mitaka, openstack, release, dmsimard
comments: true
published: true
---

Continuing our series "What Did You Do In Mitaka?", I spoke with David Moreau Simard.

<iframe src='https://www.podbean.com/media/player/zqt2x-5f14b4?from=yiiadmin' data-link='https://www.podbean.com/media/player/zqt2x-5f14b4?from=yiiadmin' height='100' width='100%' frameborder='0' scrolling='no' data-name='pb-iframe-player' ></iframe>

*(If the above player doesn't work for you, please download the recording [HERE](https://rdocommunity.podbean.com/mf/play/qp7cm4/david-simard.mp3).)*


**Rich**: I'm speaking with [David Moreau Simard](https://github.com/dmsimard), who is one of the engineers
who works on [RDO](//rdoproject.org) at Red Hat. Thanks for taking time to speak with me.

**DMSimard**: It's a pleasure

**R**: What did you work on in Mitaka?

**D**: I'm part of the RDO engineering team at Red Hat.
My role is mostly around continuous integration and making sure that
RDO works.
This means that some days I could be implementing new ways of testing
RDO or some other days fixing bugs identified by our CI.

As far as Mitaka is concerned, we got Packstack to a point where it's
able to install and run Tempest against itself.
This is awesome because it's a great way to make sure everything works
properly, sort of a sanity check.

This improvement allowed us to make Packstack gate against itself
upstream to prevent regressions from merging by testing each commit.
This was part of a plan to make Packstack part of our testing
pipeline.

In Mitaka, we started using a new project called [WeIRDO](https://dmsimard.com/2015/12/07/thinking-outside-the-box-and-outside-the-gate-to-improve-openstack-and-rdo/).
It's meant to use upstream gate integration tests inside our own RDO
testing pipeline.
We really improved our testing coverage in Mitaka with TripleO
quickstart and WeIRDO.
With WeIRDO, we're able to easily test RDO trunk packages against
Packstack and Puppet-OpenStack and the jobs that they provide.

We built a great relationship with projects that consume RDO packages
throughout development cycles.
We mutually benefit from essentially testing each other. So it makes a
lot of sense to stay in touch with these guys.

Overall, I can really tell how the testing coverage for RDO has
improved tremendously, even since liberty.
Mitaka is really the best and most tested release of RDO yet. I want
to extend my thanks to everyone that was involved in making it happen.

**R**: So how about in Newton? What do you think is coming in Newton for
you?

**D**: So, Mitaka was already an awesome cycle from the perspective of
testing coverage that we had for RDO.
We want to keep working on that foundation to increase the coverage
further.
I also want to spend some time on improving monitoring and automation
to make troubleshooting problems easier.

Trunk breaks all the time, and so it takes a lot of time to
troublshoot that, and we want to make that easier. But also have
visibility into the problems that could be coming.

Earlier I talked about WeIRDO and how we use upstream gate jobs in our
testing pipeline.
In Newton, we want to add Kolla back into our testing pipeline through
WeIRDO.
I had some issues getting Kolla to work reliably in Mitaka but they've
fixed some problems upstream since then so we'll take another look at
it.

Just recently, there's also the Chef OpenStack community -- they've been working on
integration testing their cookbooks in the gate.
I'm definitely interested in seeing what they have, and possibly leveraging their work once they're ready.

The other large chunk of work will probably come from our effort in
streamlining and centralizing the different components of RDO.
Right now, we're a bit all over the place... But we've already started
working towards moving to a software factory instance.
Software factory is a project to provide upstream's testing ecosystem
with Git, Zuul, Nodepool, Gerrit and Jenkins.. but in a box, an
appliance.

This will definitely make things easier for everyone since everything
from RDO will be expected to be in this one place.

**R**: Thank you very much for your time.

**D**: I appreciate yours, and it was great working on this great release.

*David is dmsimard on [Twitter](http://twitter.com/dmsimard), 
[github](https://github.com/dmsimard), and on IRC.*