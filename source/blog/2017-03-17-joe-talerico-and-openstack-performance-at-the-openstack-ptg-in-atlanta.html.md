---
title: 'Joe Talerico and OpenStack Performance at the OpenStack PTG in Atlanta '
author: rbowen
date: 2017-03-17 16:30:02 UTC
tags: openstack,ocata,performance,rdocommunity
comments: true
published: true
---

Last month at the [OpenStack PTG](http://openstack.org/ptg) in Atlanta, Joe Talerico spoke about his work on OpenStack Performance in the Ocata cycle.

Subscribe to our [YouTube channel](https://www.youtube.com/channel/UCWYIPZ4lm4P3_pzZ9Hx9awg)  for more videos like this.


<iframe width="560" height="315" src="https://www.youtube.com/embed/8xIsPqAKeHs?list=PLOuHvpVx7kYksG0NFaCaQsSkrUlj3Oq4S" frameborder="0" allowfullscreen></iframe>

Joe: Hi, I'm Joe Talerico. I work on OpenStack at Red Hat, doing OpenStack performance. In Ocata, we're going to be looking at doing API and dataplane performance and performance CI. In Pike we're looking at doing mix/match workloads of [Rally](https://wiki.openstack.org/wiki/Rally), [Shaker](https://github.com/openstack/shaker),
and [perfkit benchmarker](http://googlecloudplatform.github.io/PerfKitBenchmarker/), and different styles, different workloads running concurrently. That's what we're looking forward to in Pike.

Rich: How long have you been working on this stuff?

Joe: OpenStack performance, probably right around four years now. I started with doing Spec Cloud development,  and Spec Cloud development turned into doing performance work at Red Hat for OpenStack ... actually, it was Spec Virt, then Spec Cloud, then performance at OpenStack.

Rich: What kind of things were  in Ocata that you find interesting?

Joe: In Ocata ... for us ... well, in Newton, composable roles, but building upon that,  in TripleO, being able to do ... breaking out the control plane even further, being able to scale out our deployments to much larger clouds. In Ocata, we're looking to work with  CNCF, and do a 500 node deployment, and then put  OpenShift on top of that, and find some more potential performance issues, or performance gains, going from Newton to Ocata. We've done this previously with Newton, we're going to redo it with Ocata. 
