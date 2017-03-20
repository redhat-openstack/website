---
title: 'Zane Bitter - OpenStack Heat, OpenStack PTG, Atlanta '
author: rbowen
date: 2017-03-17 19:07:50 UTC
tags: openstack,heat,openstackptg
published: false
comments: true
---

At the OpenStack PTG last month, Zane Bitter speaks about his work on OpenStack Heat in the Ocata cycle, and what comes next.

<iframe width="560" height="315" src="https://www.youtube.com/embed/9JyEYnz3Oxw?list=PLOuHvpVx7kYksG0NFaCaQsSkrUlj3Oq4S" frameborder="0" allowfullscreen></iframe>

Rich: Tell us who you are and what you work on.

Zane: My name is Zane Bitter, and I work at Red Hat on Heat ... mostly on Heat. I'm one of the original Heat developers. I've been working on the project since 2012 when it started.

Heat is the orchestration service for OpenStack. It's about managing how you create and maintain your resources that you're using in your OpenStack cloud over time. It manages dependencies between various things you have to spin up, like servers, volumes, networks, ports, all those kinds of things. It allows you to define in a declarative way what resources you want and it does the job of figuring out how to create them in the right order and do it reasonably efficiently. Not waiting too long between creating stuff, but also making sure you have all the dependencies, in the right order.

And then it can manage those deployments over time as well. If you want to change your thing, it can figure out what you need do to change, if you need to replace a resource, what it needs to do to replace a resource, and get everything pointed to the right things again.

Rich: What is new in Ocata? What have you been working on in this cycle?

Zane: What I've been working on in Ocata is having a way of auto-healing services. If your service dies for some reason, you'd like that to recover by itself, rather than having to page someone and say, hey, my service is down, and then go in there and manually fix things up. So I've been working on integration between a bunch of different services, some of which started during the previous cycle.