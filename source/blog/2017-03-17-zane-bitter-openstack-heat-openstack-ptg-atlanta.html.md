---
title: 'Zane Bitter - OpenStack Heat, OpenStack PTG, Atlanta '
author: rbowen
date: 2017-03-17 19:07:50 UTC
tags: openstack,heat,openstackptg
comments: true
published: true
---

At the OpenStack PTG last month, Zane Bitter speaks about his work on OpenStack Heat in the Ocata cycle, and what comes next.

<iframe width="560" height="315" src="https://www.youtube.com/embed/9JyEYnz3Oxw?list=PLOuHvpVx7kYksG0NFaCaQsSkrUlj3Oq4S" frameborder="0" allowfullscreen></iframe>

Rich: Tell us who you are and what you work on.

Zane: My name is Zane Bitter, and I work at Red Hat on Heat ... mostly on Heat. I'm one of the original Heat developers. I've been working on the project since 2012 when it started.

Heat is the orchestration service for OpenStack. It's about managing how you create and maintain your resources that you're using in your OpenStack cloud over time. It manages dependencies between various things you have to spin up, like servers, volumes, networks, ports, all those kinds of things. It allows you to define in a declarative way what resources you want and it does the job of figuring out how to create them in the right order and do it reasonably efficiently. Not waiting too long between creating stuff, but also making sure you have all the dependencies, in the right order.

And then it can manage those deployments over time as well. If you want to change your thing, it can figure out what you need do to change, if you need to replace a resource, what it needs to do to replace a resource, and get everything pointed to the right things again.

Rich: What is new in Ocata? What have you been working on in this cycle?

Zane: What I've been working on in Ocata is having a way of auto-healing services. If your service dies for some reason, you'd like that to recover by itself, rather than having to page someone and say, hey, my service is down, and then go in there and manually fix things up. So I've been working on integration between a bunch of different services, some of which started during the previous cycle.

I was working with Fei Long Wang from Catalyst IT who is PTL of Zaqar, getting some integration work between Zaqar and Mistral, so you can now trigger a Mistral workflow from a message on the Zaqar queue. So if you set that up as a subscription in Zaqar, it can fire off a thing when it gets a message on that queue, saying, hey, Mistral, run this workflow.

That in turn is integrated with Aodh - ("A.O.D.H". as, some people call it. I'm told the correct pronunciation is Aodh.) - which is the alarming service for OpenStack. It can ...

Rich: For some reason, I thought it was an acronym.

Zane: No, it's an Irish name.

Rich: That's good to know.

Zane: Eoghan Glynn was responsible for that one.

You can set up the alarm action for an alarm in Aodh to be to post a message to this queue. When you combine these together, that means that when an alarm goes off, it posts a message to a queue, and that can trigger a workflow.

What I've been working on in Ocata is getting that all packaged up into Heat templates so we have all the resources to create the alarm in Aodh, hook it up with the subscription ... hook up the Zaqar queue to a Mistral subscription, and have that all configured in a template along with the workflow action, which is going to call Heat, and say, this server is unhealthy now. We know from external to Heat, we know that this server is bad, and then kick off  the action which is to mark the server unhealthy. We then create a replacement, and then when that service is back up, we remove the old one.

Rich: Is that done, or do you still have stuff to do in Pike.

Zane: It's done. It's all working. It's in the Heat templates repository,  there's an example in there, so you can try that out. There's a couple caveats. There's a missfeature in Aodh - there's a delay between when you create the alarm and when ... there's a short period where, when an event comes in, it may not trigger an alarm. That's one caveat. But other than that, once it's up and working it works pretty reliably.

The other thing I should mention is that you have to turn on event alarms in Aodh, which is basically triggering alarms off of events in the ... on the Oslo messaging notification bus, which is not on by default, but it's a one line configuration change.

Rich: What can we look forward to in Pike, or is it too early in the week to say yet?

Zane: We have a few ideas for Pike. I'm planning to work on a template where ... so, Zaqar has pre-signed URLs, so you can drop a pre-signed URL into an instance, and allow that instance ... node server, in other words ... to post to that Zaqar queue without having any Keystone credentials, and basically all it can do with that URL is post to that one queue.  Similar to signed URLs in ________. What that should enable us to do is create a template where we're putting signed URLs, with an expiry, into a server, and then we can, before that expires, we can re-create it, so we can have updating credentials, and hook that up to a Mistral subscription, and that allows the service to kick off a Mistral work flow to do something the application needs to do, without having credentials for anything else in OpenStack. So you can let both Mistral and Heat use Keystone trusts, to say, I will offer it on behalf of the user who created this workflow. So if we can allow them to trigger that through Zaqar, there's a pretty secure way of giving applications access to modify stuff in the OpenStack cloud, but locking it down to only the stuff you want modified, and not risking that if someone breaks into your VM, they've got your Keystone credentials and can do whatever they want withour account.

That's one of the things I'm hoping to work on.

As well, we're continuing with Heat development. We've switched over to the new convergence architecture. In Newton, I think, was the first release to have that on by default. We're looking at improving performance with that now. We've got the right architecture for scaling out to a lot of Heat engines. Right now, it's a little heavy on database, a little heavy on memory, which is the tradeoff you make when you go from a monolithic architecture, which can be quite efficient, but doesn't scale out well, to, you scale out but there's potentially performance problems. I think there's some low-hanging fruit there, we should be able to crank up performance.  Memory use, and database accesses. Look for better performance out of the convergence architecture in Heat,  coming up in Pike.
