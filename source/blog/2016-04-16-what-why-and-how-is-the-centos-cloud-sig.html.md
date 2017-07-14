---
title: What, Why, and How is the CentOS Cloud SIG?
author: rbowen
date: 2016-04-16 18:48:08 UTC
tags: centos, sig, packaging
comments: true
published: true
---

2 years ago we started the [CentOS Cloud SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud). Progress has been slow but steady. Slow, I think, because we've not done a wonderful job of explaining what it's for, and why it matters. But it has been a very important aspect of moving the [RDO project](http://rdoproject.org/) forward, so it deserves better explanation.

The Cloud SIG produces packages which allow you, the CentOS user, to deploy Cloud infrastructure on top of CentOS with complete confidence that it's going to work. 

So, it's more than just packages - the RDO project was already producing packages. It's the entire ecosystem, testing OpenStack (and other cloud platforms) on CentOS, ensuring that OpenStack will work on CentOS, and that CentOS will work on OpenStack. To this end, there's [CI on the CentOS infrastructure](https://ci.centos.org/), which is also used by numerous other projects, so we know that what we're doing doesn't break what they're doing.

It's also a community of cloud operators, running on CentOS, providing support to other users, and feedback and bug reports to the developers working upstream. This feedback loop further ensures the reliability of the platform, not only for CentOS users, but for the entire OpenStack community.

We meet every Thursday at 15:00 UTC on the #centos-devel channel on Freenode IRC, if you want to drop by and have your say. If you're using CentOS, and you're deploying any cloud infrastructure, we want to hear from you.