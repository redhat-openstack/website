---
title: CentOS Dojo @ CERN
author: hguemar
date: 2017-10-23 11:11:24 UTC
tags: CentOS,CERN,dojo,SIG,Cloud SIG
published: true
comments: true
---


Hi,

Alan, Matthias, Rich and I were at CERN last week on thursday and friday to attend the CentOS dojo.
Rich also a wrote a series of [blog posts](http://drbacchus.com/cern-centos-dojo-2017/) about the dojo.

**First day: CentOS SIGs meetup**

Thursday was dedicated to a SIGs meeting, I'll give few highlights but you can read notes on his [etherpad]( https://public.etherpad-mozilla.org/p/cern-centos-thursday).

* We managed to agree on a proposal to allow bot accounts for SIGs which is one of RDO current pain points.
* There was also progress into improving CI for SIGs contents, like defining a matrix for SIGs depending on each other to trigger tests
* Testing against CentOS extras is also an issue. SIGs were advised to provide automated tests that CentOS QA can run and send feedback to SIGs (not blocking updates but still an improvement). Thanks to the [t_functional framework](https://wiki.centos.org/QaWiki/AutomatedTests/WritingTests/t_functional)
* Many discussions around the package build workflow (signing, embargoed builds, deprecate content).
* SIG process: what happens when a chair is MIA? (happened for storage SIG)
That was a very productive and focused session, we even managed not to get over schedule, defining a proper agenda ahead of time have helped.

At the end of the day, we had a tour of the datacenter (to see and touch the nodes that run RDO <3). Then, we visited the ATLAS experiment facility.

----------

**Second day: CentOS dojo**

Friday was the dojo (See [schedule](https://indico.cern.ch/event/649159/timetable/?view=standard) with slides attached!) itself, we had about 100 persons registered, with more or less20 not showing up. It started by Belmiro Moreira talk about the OpenStack infrastructure at CERN. It is amazing to see that their RDO cloud runs over 279k cores and has been updated to Pike. It was followed up by a talk from Hervé Rousseau about CERN storage facilities, and the challenge they are facing (Data Deluge in 2026!). They are big users of Ceph and CephFS.

Afterwards, we had a SIGs status from Storage, Opstools (mrunge) and Cloud (myself). It seems that attendance was happy to discover Opstools in a new light, Matthias had many questions after his talk.
For my Cloud SIG talk ([slides](https://hguemar.fedorapeople.org/slides/cloud-sig-cern-dojo17/), I collected many stats to show the vitality of our community. I would like to thank boucher and the Software Factory Team for the RepoXplorer project for the stats, it was really helpful.
Then, I spoke our contributions to cross-SIG collaboration, including amoralej proposal for a ceph build pipeline inspired by ours.
And I ended up with our own infrastructure, showing off DLRN, WeIRDO etc.
The day ended up by a talk from kwizart (RPMFusion maintainers) about CentOS and 3rd party repository.

The hallway track was also interesting as I got to meet with Magnum PTL and the other folks maintaining it at CERN. I finally got feedback about magnum packaging working fine, and we spoke about adding RDO 3rd-party CI to magnum. We don't ship magnum in OSP, but this is a visible project and used by RDO biggest use-case, so helping them to set it up is an excellent news for RDO.

-------

**Conclusion**

This was an excellent event, where SIGs were able to focus on solving our current pain points. As a community, RDO does value our collaboration with CentOS to provide a native and rock-solid experience of OpenStack, from the kernel to the API endpoints!
