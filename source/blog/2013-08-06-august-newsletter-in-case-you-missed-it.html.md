---
title: August newsletter, in case you missed it
date: 2013-08-06 11:54:13
author: rbowen
tags: newsletter
---



**Thanks for being part of the RDO community!**

July was a busy month, and we have a lot to tell you about. If you
want to keep up with what’s going on with RDO in the coming month,
the best way is to follow the RDO forum, at
http://bit.ly/13YEwCe, or to follow us on Twitter at
@rdocommunity

If you’d like to manage your mailing list subscription, or invite
other people to join the list, you can do that at http://red.ht/11amemL

**OSCon and Flock**

In July, we were at the O'Reilly Open Source Convention in Portland,
Oregon, as part of the OpenStack pavilion. Thanks to those of you who
stopped by to talk with us.

There was a lot of great OpenStack content at OSCon, and our own Dave
Neary led the 'OpenStack Distro Smackdown' session (http://bit.ly/15FwwfK ).

We also attended the OpenStack third birthday party, where we got to
celebrate this great journey we're on. One of the (many) things that
makes Open Source so cool is the ability to collaborate with our
competitors to make the world a better place, and OpenStack is a
great example of that. A big thank you and congratulations to the
entire OpenStack family.

If you missed OSCon, come to Flock (http://flocktofedora.org/ ),
August 9-12 (this weekend!) in Charleston, South Carolina. Flock is a
gathering of Fedora developers, and we'll be there talking with some
of the people who make RDO happen. On Saturday, Kashyap Chamarthy
will be leading the OpenStack Test event, in which participants will
set up and test the latest OpenStack packages on Fedora. (Details at
http://bit.ly/15KJGFV )

If you're attending, or hosting, any OpenStack meetups, we'd love to
hear about them and help you get the word out. Drop us a note on the
RDO forum, or send us a tweet.

**Videos**

In the last few weeks, we've put a vew videos on YouTube, showing
some simple tasks with OpenStack and RDO. We started with a demo of
TryStack.org, the site where you can take OpenStack for a test run
without having to set it up yourself.
(http://bit.ly/15FIhD0 ). And, more recently, we
published the video we put together for OSCon, showing an
installation of OpenStack using RDO, all the way through spinning up
a virtual machine and ssh'ing into it. (http://bit.ly/13YQ20f  )

In the coming weeks and months, we'll be publishing more of these,
showing you how to do various other tasks with OpenStack. You'll find
those in our YouTube channel at
http://www.youtube.com/channel/UCWYIPZ4lm4P3_pzZ9Hx9awg

**Networking with RDO**

We've had a lot of discussion in the RDO forum about networking over
the last month. With Neutron support coming to RDO, but not quite
mature yet, some people are having trouble getting networking
running.

To address this difficulty, we've added a networking resource in the
wiki (http://openstack.redhat.com/Networking ) where we can share
what works, and what doesn't, to help you get things running
smoothly.

Also, we've updated the QuickStart instructions
(http://openstack.redhat.com/Quickstart ) to disable Neutron
(formerly known as Quantum) networking, so that you can have a better
first-time experience when installing RDO.

Remember that you can also generate an answer file, using the
'--gen-answer-file=ANSWER_FILE' argument, edit that file to set your
preferences, and then run packstack using this file as input, using
the '--answer-file=ANSWER_FILE' argument.

**Using Ceph for Block Storage**

There's been a lot of interest lately around Ceph (http://ceph.com/
), the distributed object store and filesystem, and using it with
OpenStack. Our friends at Inktank were kind enough to add some
documentation to the RDO wiki about using Ceph for block storage with
RDO - http://bit.ly/13K3m9G
This is a detailed, step-by-step how-to, showing the entire process
of installing RDO, configuring Ceph, and getting the two to talk to
each other.

**Troubleshooting**

Because RDO tracks the latest releases of OpenStack, and because of
the inevitable variation in deployment platforms, you may encounter
some problems during deployment. (The Red Hat Entperprise Linux
OpenStack Platform, which trails upstream by a few months, is more
thoroughly hardened and tested.)

As you're working through these problems, you may wish to have a look
at the troubleshooting page on our wiki -
http://openstack.redhat.com/Troubleshooting - where we're trying to
document common scenarios that people are encountering, and tips for
solving these problems.

We welcome your participation in this process. If you find the
solution to some problem, please write it up so that everyone can
benefit.

**Other sources**

We recently came across this writeup of using RDO to deploy a
multi-node OpenStack cloud: http://www.cloudbase.it/rdo-multi-node/ .
It's a very deep dive into how everything fits together, as well as
hands-on configuration tips and examples. This is part one of a
promised series, so we encourage you to check back there.

If you come across helpful articles that you think will benefit the
entire community, please post them to the RDO forum, or send them
directly to me at rbowen@redhat.com

**In closing ...**

Thanks again for being part of the RDO community. We'd love to hear
how we can do better. Let us know on the forum
(http://openstack.redhat.com/forum/ ), or on Twitter (@rdocommunity),
or just drop us email at rbowen@redhat.com or on the RDO mailing list
(http://red.ht/12XFRiy )

Until next month ...

Rich and Dave, for the RDO community