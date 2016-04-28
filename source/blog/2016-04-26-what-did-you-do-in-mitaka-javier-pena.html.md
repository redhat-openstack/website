---
title: What did you do in Mitaka? Javier Peña
author: rbowen
date: 2016-04-26 15:18:06 UTC
tags: podcast, mitaka
comments: true
published: true
---

We're continuing our series of "What did you do in Mitaka?"
interviews. This one is with Javier Peña.

<iframe src='https://www.podbean.com/media/player/82a4c-5ec74f?from=yiiadmin' data-link='https://www.podbean.com/media/player/82a4c-5ec74f?from=yiiadmin' height='100' width='100%' frameborder='0' scrolling='no' data-name='pb-iframe-player' ></iframe>


(If the above player doesn't work for you, you can download the file [HERE](https://rdocommunity.podbean.com/mf/play/fgk3cc/javier-pena-mitaka.mp3).



**Rich**: Today I'm speaking with Javier Peña, who is another member
of the Red Hat OpenStack engineering team. Thanks for making time to
speak with me.

**Javier**: Thank you very much for inviting me, Rich.

**R**: What did you work on in the Mitaka cycle?

**J**: I've been focusing on three main topics. First one was keeping the
DLRN infrastructure up and running. As you know, this is the service
we use to create RPM packages for our RDO distribution, straight from
the upstream master commits.

It's been evolving quite a lot during this cycle. We ended up with so
much success that we're having infrastructure issues. One of the
topics for the next cycle will be to improve the infrastructure, but
that's something we'll talk about later.

These packages have now been consumed by the TripleO, Kolla, and
Puppet OpenStack CI, so we're quite well tested. Not only are we
testing them directly from the RDO trunk repositories, but we have
external trials as well.

On top of that I have also been working on packaging, just like some
other colleagues on the team who've you've already had a chance to
talk to - Haikel, Chandan - I have been contributing packages both to
upstream Fedora, and also RDO directly.

And finally, I'm also one of the core maintainers of Packstack. In
this cycle we've been adding support for some services such as AODH
and Gnocchi. Also we switched Mysql support from the Python side. We
switched libraries, and we had to do some work with the upstream
Puppet community to make sure that PyMysql, which is now the default
Python library used upstream, is also used inside the Puppet core and
we can use it in Packstack.

**R**: You mentioned briefly infrastructure changes that you'll be making
in the upcoming cycle. Can you tell us more about what you have
planned for Newton?

**J**: Right now the DLRN infrastructure is building 6 different lines of
repositories. We have CentOS master, which is now Newton. Mitaka,
Liberty, and Kilo. And we have two branches for Fedora as well. So
this is quite a heavy load for VMs that we're running right now. We
were having some issues in the cloud we were running that instance. So
what we're doing now is we are migrating to the CentOS CI
infrastructure. We are having a much bigger machine in there. And also
what we are going to do is we will be publishing the resulting
repositories using the CentOS CDN, which is way more reliable than
what we could build with individual VMs.

**R**: Thank you again for your time. And we look forward to seeing what
comes in Newton. 

**J**: Thank you very much, Rich.