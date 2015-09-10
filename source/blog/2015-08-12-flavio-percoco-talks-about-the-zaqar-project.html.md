---
title: Flavio Percoco talks about the Zaqar project
date: 2015-08-12 09:23:52
author: rbowen
---

[Zaqar](https://wiki.openstack.org/wiki/Zaqar) (formerly called Marconi) is the messaging service in [OpenStack](http://openstack.org). I recently had an opportunity to interview Flavio Percoco, who is the PTL (Project Technical Lead) of that project, about what's new in Kilo, and what's coming in [Liberty](https://wiki.openstack.org/wiki/Liberty_Release_Schedule).

The recording is --> [here](http://drbacchus.com/podcasts/openstack/flavio_zaqar.mp3) <--, and the transcript follows below.

<hr />

<a href="http://drbacchus.com/wp-content/uploads/2015/08/FlavioPercoco.jpeg"><img class="alignleft size-medium wp-image-2320" src="http://drbacchus.com/wp-content/uploads/2015/08/FlavioPercoco-300x300.jpeg" alt="FlavioPercoco" width="300" height="300" /></a>

R: This is Rich Bowen. I am the RDO community liaison at Red Hat, and
I'm speaking with Flavio Percoco, who is the PTL of the Zaqar project.
We spoke two years ago about the project, and at that time it had a
different name. I was hoping you could tell us what has been happening
in the Kilo cycle, and what we can expect to see in Liberty.

F: Thanks, Rich, for having me here. Yes, we spoke two years ago, back
in Hong Kong, while the project was called Marconi. Many things have
happened in these last few years. We developed new APIs, we've added
new features to the project.

At that time, we had version 1 of the API, and we were still figuring
out what the project was supposed to be like, and what features we
wanted to support, and after that we released a version 1.1 of the
API, which was pretty much the same thing, but with a few changes, and
a few things that would make consuming Zaqar easier for the final
user.

Some other things changed. The community provided a lot of feedback to
the project team. We've attempted to graduate two times, and then the
Big Tent discussion happened, and we just fell into the category of
projects that would be a good part of the community - of the Big Tent
discussion. So we are now officially part of OpenStack. We're part of
this Big Tent group.

We changed the API a little bit. The impression that the old API gave
was that it was a queueing service, whereas what we really wanted to
do was a messaging service. There is a fundamental difference between
the two. Our focus is to provide a messaging API for OpenStack that
would not just allow users to send messages from one point to another,
but it would also allow users to have notifications right away from
that API. So we'll take advantage of the common storage that we'll use
for both features, for different services living within the same
service. That's a big thing, and something we probably didn't talk
about back then.

The other thing is that in Kilo we dedicated a lot of time to work on
these versions of the API and making sure that all of the feedback
that we got from the community was taken care of and that we were
improving the API based on that feedback, and those long discussions
that we had on the mailing list.

In Liberty, we've dedicated time to integrating with other project, as
in, having other projects consume the API. So we're very excited to
say that in Liberty a few patches have landed in Heat that rely on
Zaqar for having notifications, or to send messages, and communicate
with other parts of the Heat service. This is very exciting for us,
because we have some stories of production environments, but we didn't
have stories of other projects consuming Zaqar, and this definitely
puts us in a better position to improve the service, and get more
feedback from the community.

In terms of features for the Liberty cycle, we've dedicated time to
improve the websocket transport which we started in Kilo, but didn't
have enough time to complete there. This websocket transport will
allow for persistent connections to be made against the Zaqar service,
so you'll just connect to the service once, and you'll keep that
connection alive. This is ideal for several scenarios, and one of
those is connecting to Zaqar from a browser and having Javascript
communication directory to Zaqar, which is something we really want to
have.

Another interesting feature that we implemented in Liberty is called
pre-signed URLs, and what it does is something very similar - if folks
are familiar with Swift temp URLs -
http://docs.openstack.org/kilo/config-reference/content/object-storage-tempurl.html
- this is something very similar to that. It generates a URL that
can expire. You will share that URL with people or services that don't
have an username in Zaqar, so that they can connect to the service and
still send messages. This URL is limited to a single tenant and a
single queue, and it has privileges and policies attached to it so
that we can protect all the data that is going through the service.

I believe those are the two features that excite me the most from the
Liberty cycle. But what excites me the most about this cycle is that
we have other services using Zaqar, and that will allow us to improve
our service a lot.

R: Looking forward to the future, is there anything that you would
like to see in the M cycle? What is the next big thing for Zaqar?

F: In the M cycle, I still see us working on having more projects
consuming Zaqar. There's several use cases that we've talked about
that are not being taken care of in the community. For instance,
talking to guest agents. We have several services that need to have an
agent running in the instances. We can talk about Trove, we can talk
about Sahara, and Murano. We are looking forward to address that use
case, which is what we built presigned URLs for. I'm not sure we're
going to make it in Liberty, because we're already on the last
milestone of the cycle, but we'll still try to make it in Liberty. If
we can't make it in Liberty, that's definitely one of the topics we'll
need to dedicate time to in the M cycle.

But as a higher level view, I
would really like to see a better story for Zaqar in terms of operations
support and deployment - make it very simple for people to go there
and say they want Zaqar, this is all I need, I have my Puppet
manifest, or Anisible playbooks, or whatever people are using now - we
want to address that area that we haven't paid much attention to.
There is already some effort in the Puppet community to create
manifests for Zaqar, which is amazing. We want to complete that work,
we want to tell operations, hey, you don't have to struggle to make that
happen, you don't have to struggle to run Zaqar, this is all you need.

And the second thing that I would like to see Zaqar doing in the
future is to have a better opinion of what the storage it wants to
rely on is. So far we have support for two storages that are unicode
based and there's a proposal to support a third storage, but in
reality what we would really like to do is have a more opinionated
Zaqar instance of storage, so that we can build a better API, make it
consistent, and make sure it is dependable, and provide specific
features that are supported and that it doesn't matter what storage
you are using, it doesn't matter how you deploy Zaqar, you'll always
get the same API, which is something that right now it's not true. If
you deploy Redis, for instance, you will not have support for FIFO
queues, which are optional right now in the service. You won't be able
to have them because that's something that's related to the storage
itself. You don't get the same guarantees that you'd get with other
storage. We want to have a single story that we can tell to users,
regardless of what storage they are using. This doesn't mean that ops
cannot use their own storage. If you deploy Zaqar and you really want
to use a different storage, that's fine, we're not going to remove
plugability from the service. But in terms of support, I would like
Zaqar to be more opinionated.
