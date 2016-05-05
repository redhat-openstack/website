---
title: 'What did you do in Mitaka: Emilien Macchi'
author: rbowen
date: 2016-05-04 19:03:33 UTC
tags: podcast, mitaka, emilien-machi, software-factory, packaging, summit
comments: true
published: true
---

Continuing my series of interviews with RDO engineers, here's my chat with Emilien Macchi, who I talked with at OpenStack Summit last week in Austin.

If you'd like to talk about what you did in Mitaka, please contact me at [rbowen@redhat.com](mailto:rbowen@redhat.com).

<iframe src='https://www.podbean.com/media/player/fzkg3-5f06ba?from=yiiadmin' data-link='https://www.podbean.com/media/player/fzkg3-5f06ba?from=yiiadmin' height='100' width='100%' frameborder='0' scrolling='no' data-name='pb-iframe-player' ></iframe>

(If the above player doesn't work for you, please download the audio [HERE](https://rdocommunity.podbean.com/mf/play/uinm26/emilien_macchi.mp3).

**Rich**: I'm speaking with Emilien Macchi, who is one of the people that
worked on the Mitaka release of OpenStack. Thank you for taking time
to speak with me.

**Emilien**: Thank you for welcoming me.

**R**: What did you do in Mitaka?

**E**: In Mitaka, most of my tasks were related to packaging testing. I'm
currently leading the Puppet OpenStack group, which is a team where we
develop some Puppet modules that deploy OpenStack in production. Red
Hat is using the Puppet modules in TripleO, so we can automate the
deployment of OpenStack services. Recently we switched the gates of
OpenStack Infra to use RDO packaging. We had a lot of issued before
because we didn't have much CI. But since Mitaka, the RDO and the
Puppet teams worked a lot together to make sure that we can provide
some testing together. We can fix things very early when it's broken
upstream. Like when we have a new dependency or when we have a change
in the requirements. That was this kind of test where you provide very
early feedback to the RDO people that are doing the packaging. It was
very interesting to work with RDO.

We provided early feedback on the builds, on the failures. We also
contributed to ... I say "we", I don't like to say "I" ... we, my
group, my Puppet group, we contributed to the new packages that we
have in Mitaka. We updated the spec in the package so we could have
more features, and more services in the RDO projects.

Testing! Testing every day. Testing, testing, testing. Participating
in the events that the RDO community is having, like the weekly
meetings, the testing days. It was very interesting for us to have
this relationship with the RDO team.

So I'm looking forward to Newton.

**R**: What do you anticipate you'll be working on in Newton? 

**E**: Well, that's an interesting question. We are talking about this
week. [At OpenStack Summit, Austin.] 

The challenge for us ... the biggest challenge, I guess, is to follow
the release velocity of upstream projects. We have a bunch of projects
in OpenStack, and it's very hard to catch up with all of the projects
at the same time. In the meantime we have to because those projects,
they are in the RDO project and also in the products, so that's
something we need to ... we need to scale the way that we producing
all this work. 

Something we are very focused on right now is to use the Software
Factory project, which is how OpenStack Infra is operating to build
OpenStack software. This is a project - an open source project - which
is now used by RDO. We can have this same way as upstream, but for
downstream - we can have the same way to produce the RDO artifacts,
like the packages and the Puppet modules, and so on. That's the next
big challenge, is to be fully integrated with Software Factory, to
implement the missing features we will need to make the testing
better. 

Yeah, that's the biggest challenge: Improve the testing, and stopping
doing manual things, automate all the things, that is the next
challenge. 

**R**: Thank you very much. Thanks for your time.

**E**: Thank you for your time.
