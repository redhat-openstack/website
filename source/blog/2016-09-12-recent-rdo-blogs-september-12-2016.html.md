---
title: Recent RDO blogs, September 12, 2016
author: rbowen
date: 2016-09-12 19:17:34 UTC
tags: openstack,blogs
comments: true
published: true
---

Here's what RDO enthusiasts have been blogging about in the last few weeks.

**LinuxCon talk slides: “A Practical Look at QEMU’s Block Layer Primitives”** by Kashyap Chamarthy

> Last week I spent time at LinuxCon (and the co-located KVM Forum) Toronto. I presented a talk on QEMU’s block layer primitives. Specifically, the QMP primitives block-commit, drive-mirror, drive-backup, and QEMU’s built-in NBD (Network Block Device) server.

... read more at [http://tm3.org/9x](http://tm3.org/9x)

**Complex data transformations with nested Heat intrinsic functions** by Steve Hardy

> Disclaimer, what follows is either pretty neat, or pure-evil depending your your viewpoint ;)  But it's based on a real use-case and it works, so I'm posting this to document the approach, why it's needed, and hopefully stimulate some discussion around optimizations leading to a improved/simplified implementation in the future.

... read more at [http://tm3.org/9y](http://tm3.org/9y)

**Red Hat OpenStack Platform 9 is here! So what’s new?** by Marcos Garcia

> This week we released the latest version of our OpenStack product, Red Hat OpenStack Platform 9. This release contains more than 500 downstream enhancements, bug fixes, documentation changes, and security updates. It’s based on the upstream OpenStack Mitaka release. We have worked hard to reduce the time to release new versions and have successfully done so with this release! Red Hat OpenStack Platform 9 contains new Mitaka features and functionality, as well as the additional hardening, stability, and certifications Red Hat is known for. Of course, there continues to be tight integration with other key portfolio products, as well as comprehensive documentation.

... read more at [http://tm3.org/9z](http://tm3.org/9z)

**Deploying Server on Ironic Node Baseline** by Adam Young

> My team is working on the ability to automatically enroll servers launched from Nova in FreeIPA. Debugging the process has proven challenging;  when things fail, the node does not come up, and there is little error reporting.  This article posts a baseline of what things look like prior to any changes, so we can better see what we are breaking.

... read more at [http://tm3.org/9-](http://tm3.org/9-)

**A retrospective of the OpenStack Telemetry project Newton cycle** by Julien Danjou

> A few weeks ago, I recorded an interview with Krishnan Raghuram about what was discussed for this development cycle for OpenStack Telemetry at the Austin summit.

... read more at [http://tm3.org/a0](http://tm3.org/a0)

**Deploying Fernet on the Overcloud** by Adam Young

> Here is a proof of concept of deploying an OpenStack Tripleo Overcloud using the Fernet token Provider.

... read more at [http://tm3.org/a1](http://tm3.org/a1)

**OpenStack Infra: Understanding Zuul** by Arie Bregman

> Recently I had the time to explore Zuul. I decided to gather everything I learned here in this post. Perhaps you’ll find it useful for your understanding of Zuul.

... read more at [http://tm3.org/a2](http://tm3.org/a2)

**OpenStack Infra: How to deploy Zuul** by Arie Bregman

> This is the second post on Zuul, which focuses on deploying it and its services. To learn what is Zuul and how it works, I recommend to read the previous post.

... read more at [http://tm3.org/a3](http://tm3.org/a3)

**Scaling-up TripleO CI coverage with scenarios** by Emilien Macchi
 
> When the project OpenStack started, it was “just” a set of services with the goal to spawn a VM. I remember you run everything on your laptop and test things really quickly.
The project has now grown, and thousands of features have been implemented, more backends / drivers are supported and new projects joined the party.
It makes testing very challenging because everything can’t be tested in CI environment.

... read more at [http://tm3.org/a4](http://tm3.org/a4)

**Introducing patches to RDO CloudSIG packages** by Jakub Ruzicka

> RDO infrastructure and tooling has been changing/improving with each OpenStack release and we now have our own packaging workflow powered by RPM factory at review.rdoproject.org, designed to keep up with supersonic speed of upstream development.

... read more at [http://tm3.org/a5](http://tm3.org/a5)

**From decimal to timestamp with MySQL** by Julien Danjou

> When working with timestamps, one question that often arises is the precision of those timestamps. Most software is good enough with a precision up to the second, and that's easy. But in some cases, like working on metering, a finer precision is required.

... read more at [http://tm3.org/a6](http://tm3.org/a6)

**Generating Token Request JSON from Environment Variables** by Adam Young

> When working with New APIS we need to test them with curl prior to writing the python client. I’ve often had to hand create the JSON used for the token request, as I wrote about way back here.  Here is a simple bash script to convert the V3 environment variables into the JSON for a token request.

... read more at [http://tm3.org/a7](http://tm3.org/a7)

**Actionable CI** by Assaf Muller

> I’ve observed a persistent theme across valuable and successful CI systems, and that is actionable results.
> A CI system for a project as complicated as OpenStack requires a staggering amount of energy to maintain and improve. Often times the responsible parties are focused on keeping it green and are buried under a mountain of continuous failures, legit or otherwise. So much so that they don’t have time to focus on the following questions:

... read more at [http://tm3.org/a8](http://tm3.org/a8)

**Thoughts on Red Hat OpenStack Platform and certification of Tesora Database as a Service Platform** by 	Ken Rugg, Chief Executive Officer, Tesora

> When I think about open source software, Red Hat is first name that comes to mind. At Tesora, we’ve been working to make our Database as a Service Platform available to Red Hat OpenStack Platform users, and now it is a Red Hat certified solution. Officially collaborating with Red Hat in the context of OpenStack, one of the fastest growing open source projects ever, is a tremendous opportunity.

... read more at [http://tm3.org/a9](http://tm3.org/a9)

