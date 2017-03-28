---
title: Stephen Finucane - OpenStack Nova - What's new in Ocata
author: rbowen
date: 2017-03-28 15:19:42 UTC
tags: openstack,openstackptg,atlanta,nova,networking,nfv
comments: true
published: true
---

At the OpenStack PTG in February, Stephen Finucane speaks about what's new in Nova in the Ocata release of OpenStack.

<iframe width="560" height="315" src="https://www.youtube.com/embed/NzWw_uosDnM?list=PLOuHvpVx7kYksG0NFaCaQsSkrUlj3Oq4S" frameborder="0" allowfullscreen></iframe>

Stephen: I'm Stephen Finucane, and I work on Nova for Red Hat.

I've previously worked at Intel. During most of my time working on [Nova](https://wiki.openstack.org/wiki/Nova) I've been focused on the same kind of feature set, which is what Intel liked to call EPA - Enhanced Platform Awareness - or NFV applications. Making Nova smarter from the perspective of Telco applications. You have all this amazing hardware, how do you expose that up and take full advantage of that when you're running virtualized applications?

The Ocata cycle was a bit of an odd one for me, and probably for the project itself, because it was really short. The normal cycle runs for about six months. This one ran for about four.

During the Ocata cycle I actually got [core status](https://docs.openstack.org/infra/manual/core.html). That was probably as a result of doing a lot of reviews. Lot of reviews, pretty much every waking hour, I had to do reviews. And that was made possible by the fact that I didn't actually get any specs in for that cycle.

So my work on Nova during that cycle was mostly around reviewing Python 3 fixes. It's still very much a community goal to get support in Python 3. 3.5 in this case. Also a lot of work around improving how we do configuration - making it so that administrators can actually understand what different knobs and dials Nova exposes, what they actually mean, and what the implications of changing or enabling them actually are.

Both of these have been going in since before the Ocata cycle, and we made really good progress during the Ocata cycle to continue to get ourselves 70 or 80% of the way there, and in the case of config options, the work is essentially done there at this point.

Outside of that, the community as a whole, most of what went on this cycle was again a continuation of work that has been going on the last couple cycles. A lot of focus on the maturity of Nova. Not so much new features, but improving how we did existing features. A lot of work on resource providers, which are a way that we can keep track of the various resources that Nova's aware of, be they storage, or cpu, or things like that.

Coming forward, as far as Pike goes, it's still very much up in the air. That's what we're here for this week discussing. There would be, from my perspective, a lot of the features that I want to see, doubling down on the NFV functionality that Nova supports. Making things 
like [SR-IOV](https://wiki.openstack.org/wiki/SR-IOV-Passthrough-For-Networking) easier to use, and more performant, where possible. There's also going to be some work around resource providers again for SR-IOV and NFV features and resources that we have.

The other stuff that the community is looking at, pretty much up in the air. The idea of exposing capabilities, something that we've had a lot of discussion about already this week, and I epxect we'll have a lot more. And then, again, evolution of the  Nova code base - what more features the community wants, and various customers want - going and providing those. 

This promises to be a very exciting cycle, on account of the fact that we're back into the full six month mode. There's a couple of new cores on board, and Nova itself is full steam ahead.