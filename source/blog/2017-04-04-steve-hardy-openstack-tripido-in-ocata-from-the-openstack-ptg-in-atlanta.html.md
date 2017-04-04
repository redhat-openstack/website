---
title: 'Steve Hardy: OpenStack TripleO in Ocata, from the OpenStack PTG in Atlanta'
author: rbowen
date: 2017-04-04 19:26:24 UTC
tags: tripleo,openstack,openstackptg
comments: true
published: true
---

Steve Hardy talks about TripleO in the Ocata release, at the Openstack PTG in Atlanta.

<iframe width="560" height="315" src="https://www.youtube.com/embed/ban0Z7Cojfg?list=PLOuHvpVx7kYksG0NFaCaQsSkrUlj3Oq4S" frameborder="0" allowfullscreen></iframe>

Steve: My name is Steve Hardy. I work primarily on the TripleO project, which is an OpenStack deployment project. What makes TripleO interesting is that it uses OpenStack components primarily in order to deploy a production OpenStack cloud. It uses OpenStack Ironic to do bare metal provisioning. It uses Heat orchestration in order to drive the configuration workflow. And we also recently started using Mistral, which is an OpenStack workflow component.

So it's kind of different from some of the other deployment initiatives. And it's a nice feedback loop where we're making use of the OpenStack services in the  deployment story, as well as in the deployed cloud.

This last couple of cycles we've been working towards more composability. That basically means allowing operators more flexibility with service placement, and also  allowing them to define groups of node in a more flexible way so that you could either specify different configurations - perhaps you have multiple types of hardware for different compute configurations for Nova, or perhaps you want to scale services into particular groups of clusters for particular services.

It's basically about giving more choice and flexibility into how they deploy their architecture. 

Rich: Upgrades have long been a pain point. I understand there's some improvement in this cycle there as well?

Steve: Yes. Having delivered composable services and composable roles for the Newton OpenStack release, the next big challenge was giving operators the flexibility to deploy services on arbitrary nodes in your OpenStack environment, you need some way to upgrade, and you can't necessarily make assumptions about which service is running on which group of nodes.  So we've implented the new feature which is called composable upgrades. That uses some Heat functionality combined with Ansible tasks, in order to allow very flexible dynamic definition of what upgrade actions need to take place when you're upgrading some specific group of nodes within your environment. That's part of the new Ocata release. It's hopefully going to provide a better upgrade experience, for end-to-end upgrades of all the OpenStack services that TripleO supports.

Rich: It was a very short cycle. Did you get done what you wanted to get done, or are things pushed off to Pike now.

Steve: I think there's a few remaining improvements around operator-driven upgrades, which we'll be looking at during the Pike cycle. It certainly has been a bit of a challenge with the short development timeframe during Ocata. But the architecture has landed, and we've got composable upgrade support for all the services in Heat upstream, so I feel like we've done what we set out to do in this cycle,  and there will be further improvements around operator-drive upgrade workflow and also containerization during the Pike timeframe.

Rich: This week we're at the PTG. Have you already had your team meetings, or are they still to come.

Steve: The TripleO team meetings start tomorrow, which is Wednesday. The previous two days have mostly been cross-project discussion. Some of which related to collaborations which may impact TripleO features, some of which was very interesting. But the TripleO schedule starts tomorrow - Wednesday and Thursday. We've got a fairly packed agenda, which is going to focus around - primarily the next steps for upgrades, containerization, and ways that we can potentially collaborate more closely with some of the other deployment projects within the OpenStack community.

Rich: Is Kolla something that TripleO uses to deploy, or is that completely unrelated?

Steve: The two projects are collaborating. Kolla provides a number of components, one of which is container definitions for the OpenStack services themselves, and the containerized TripleO architecture actually consumes those.  There are some other pieces which are different between the two projects. We use Heat to orchestrate container deployment, and there's an emphasis on Ansible and Kubernetes on the Kolla side, where we're having discussions around future collaboration.

There's a session planned on our agenda for a meeting between the Kolla Kubernetes folks and TripleO folks to figure out of there's long-term collaboration there. But at the moment there's good collaboration around the container definitions and we just orchestrate deploying those containers.

We'll see what happens in the next  couple of days of sessions, and getting on with the work we have planned for Pike.

Rich: Thank you very much.

