# January 2017 RDO Community Newsletter

## Quick links:

* [Quick Start](http://rdoproject.org/quickstart)
* [Mailing Lists](https://www.rdoproject.org/community/mailing-lists/)
* [RDO release packages](https://trunk.rdoproject.org/)
* [Review.RDOProject.org](http://review.rdoproject.org/)
* [RDO blog](http://rdoproject.org/blog)
* [Q&A](http://ask.openstack.org/)
* [Open Tickets](http://tm3.org/rdobugs)
* [Twitter](http://twitter.com/rdocommunity)
* [Ocata release schedule](http://releases.openstack.org/ocata/schedule.html)

Thanks for being part of the RDO community!

## Upcoming Events

December is always a slow month around here, so there's not much to
report on this month, but we do have a number of events coming up that
you'll want to know about.

### FOSDEM and DevConf

[DevConf.cz](https://devconf.cz/) is coming up at the end of January, in
Brno, Czech Republic, and RDO will have a booth there, where you can get
your RDO tshirts and stickers. DevConf is a small event where you can
really spend quality time with other attendees, and which is often
attended by a significant number of the RDO engineers who are based in
Brno. We'd love to see you there.

DevConf will be held January 27 - 29, 2017, in Brno. You can register
for free at
[http://bit.ly/devconf-cz-2017-registration](http://bit.ly/devconf-cz-2017-registration).

The next weekend, [FOSDEM](https://fosdem.org/2017/) will be held in Brussels. FOSDEM is one of the
largest events for Free and Open Source software in the world, with
thousands of developers attending. RDO will be present at the CentOS
booth, and at the OpenStack booth. Stop by to ask your OpenStack
questions.

FOSDEM will be held February 4th and 5th at the ULB Campus Solbosch.
FOSDEM is also free, and no registration is required.

### Project Teams Gathering - Atlanta - February 20-24

As you are by now no doubt aware, the OpenStack Summit has been
reorganized somewhat, with the developers' summit portion of it being
pulled into a separate event - the [Project Teams Gathering](https://www.openstack.org/ptg/), or PTG.

If you're thinking of going to the PTG, you need to register as soon as
possible, since space is very limited.

The PTG is where the next release of OpenStack - Pike - will be
discussed, and teams will figure out what features they'll try to work
on.

### Meetups

Other RDO events, including the many OpenStack meetups around the
world, are always listed on the [RDO events page](http://rdoproject.org/events).
If you have an RDO-related event, please feel free to add it by submitting a pull
request [on Github](https://github.com/OSAS/rh-events/blob/master/2017/RDO-Meetups.yml).

## Blog Posts

There's been some great blog posts in the last month. Here's a sampling:

**Containers on the CERN cloud** by Tim Bell

> We have recently made the Container-Engine-as-a-Service (Magnum) available in production at CERN as part of the CERN IT department services for the LHC experiments and other CERN communities. This gives the OpenStack cloud users Kubernetes, Mesos and Docker Swarm on demand within the accounting, quota and project permissions structures already implemented for virtual machines.We shared the latest news on the service with the CERN technical staff (link). This is the follow up on the tests presented at the OpenStack Barcelona (link) and covered in the blog from IBM. The work has been helped by collaborations with Rackspace in the framework of the CERN openlab and the European Union Horizon 2020 Indigo Datacloud project.

Read more at [http://tm3.org/d6](http://tm3.org/d6)


**Red Hat OpenStack Platform 10 is here! So what’s new?** by Marcos Garcia - Principal Technical Marketing Manager

> It’s that time of the year. We all look back at 2016, think about the good and bad things, and wish that Santa brings us the gifts we deserve. We, at Red Hat, are really proud to bring you a present for this holiday season: a new version of Red Hat OpenStack Platform, version 10 (press release and release notes). This is our best release ever, so we’ve named it our first Long Life release (up to 5 years support), and this blog post will show you why this will be the perfect gift for your private cloud project.

Read more at [http://tm3.org/d8](http://tm3.org/d8)


**Comparing OpenStack Neutron ML2+OVS and OVN – Control Plane** by russellbryant

> We have done a lot of performance testing of OVN over time, but one major thing missing has been an apples-to-apples comparison with the current OVS-based OpenStack Neutron backend (ML2+OVS).  I’ve been working with a group of people to compare the two OpenStack Neutron backends.  This is the first piece of those results: the control plane.  Later posts will discuss data plane performance.

Read more at [http://tm3.org/d9](http://tm3.org/d9)


**TripleO to deploy Ceph standlone** by Giulio Fidente

> Here is a nice Christmas present: you can use TripleO for a standalone Ceph deployment, with just a few lines of YAML. Assuming you have an undercloud ready for a new overcloud, create an environment file like the following:

Read more at [http://tm3.org/d1](http://tm3.org/d1)


**Printed TripleO cheatsheets for FOSDEM/DevConf (feedback needed)** by Carlos Camacho

> We are working preparing some cheatsheets for people jumping into TripleO.

Read more at [http://tm3.org/d2](http://tm3.org/d2)


**ANNOUNCE: New libvirt project Go language bindings** by Daniel Berrange

> I’m happy to announce that the libvirt project is now supporting Go language bindings as a primary deliverable, joining Python and Perl, as language bindings with 100% API coverage of libvirt C library. The master repository is available on the libvirt GIT server, but it is expected that Go projects will consume it via an import of the github mirror, since the Go ecosystem is heavilty github focused (e.g. godoc.org can’t produce docs for stuff hosted on libvirt.org git)

Read more at [http://tm3.org/d3](http://tm3.org/d3)


**A Quick Introduction to Mistral Usage in TripleO (Newton) For developers** by jpichon

> Since Newton, Mistral has become a central component to the TripleO project, handling many of the operations in the back-end. I recently gave a short crash course on Mistral, what it is and how we use it to a few people and thought it might be useful to share some of my bag of tricks here as well.What is Mistral?It's a workflow service. You describe what you want as a series of steps (tasks) in YAML, and it will coordinate things for you, usually asynchronously.

Read more at [http://tm3.org/d4](http://tm3.org/d4)


**Lifecycle support changes for Red Hat OpenStack Platform 10 and beyond** by Peter Pawelski, Product Marketing Manager, Red Hat OpenStack Platform

> OpenStack continues to evolve

Read more at [http://tm3.org/d5](http://tm3.org/d5)


## Community meetings

Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting
on the #RDO channel on Freenode IRC. The agenda for this meeting is
posted each week in a [public
etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes
from the meeting are posted [on the RDO
website](https://www.rdoproject.org/community/community-meeting/). If
there's something you'd like to see happen in RDO - a package that is
missing, a tool that you'd like to see included, or a change in how
things are governed - this is the best time and place to help make that
happen.

## Keep in touch

There's lots of ways to stay in in touch with what's going on in the
RDO community. The best ways are ...


### WWW
* [RDO](http://rdoproject.org/)
* [OpenStack Q&A](http://ask.openstack.org/ )

### Mailing Lists:
* [rdo-list mailing list](http://www.redhat.com/mailman/listinfo/rdo-list )
* [This newsletter](http://www.redhat.com/mailman/listinfo/rdo-newsletter )

### IRC
* IRC - #rdo on Freenode.irc.net
* Puppet module development - #rdo-puppet

### Social Media
* [Follow us on Twitter](http://twitter.com/rdocommunity )
* [Google+](http://tm3.org/rdogplus )
* [Facebook](http://facebook.com/rdocommunity)

Thanks again for being part of the RDO community!
