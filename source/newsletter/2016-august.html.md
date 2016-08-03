# August 2016 RDO Community Newsletter

## Quick links:

* [Quick Start](http://rdoproject.org/quickstart)
* [Mailing Lists](https://www.rdoproject.org/community/mailing-lists/)
* [RDO release packages](https://trunk.rdoproject.org/)
* [Review.RDOProject.org](http://review.rdoproject.org/)
* [RDO blog](http://rdoproject.org/blog)
* [Q&A](http://ask.openstack.org/)
* [Open Tickets](http://tm3.org/rdobugs)
* [Twitter](http://twitter.com/rdocommunity)
* [Newton release schedule](http://releases.openstack.org/newton/schedule.html)

Thanks for being part of the RDO community!

Not subscribed to the newsletter? [Subscribe here](http://www.redhat.com/mailman/listinfo/rdo-newsletter).

## Newton 2

After a lot of work by the TripleO team, we have Newton milestone 2
packages available for RDO. To give it a try, you can use either
Packstack or TripleO.

To get started, on a fresh CentOS or RHEL VM:

    yum -y install yum-plugin-priorities
    cd /etc/yum.repos.d/
    sudo wget http://trunk.rdoproject.org/centos7/delorean-deps.repo
    sudo wget http://trunk.rdoproject.org/centos7/current-passed-ci/delorean.repo

Then for a packstack-based install, start with step 2 of the
[quickstart](https://www.rdoproject.org/install/quickstart/), or, for
TripleO-based installs, see the [TripleO
quickstart](https://www.rdoproject.org/tripleo/) or the [TripleO
quickstart USB key](https://www.rdoproject.org/tripleo/oooq-usbkey/).

And now, were forging ahead towards milestone 3, which is 
[scheduled](http://releases.openstack.org/newton/schedule.html) for the
week of August 29th. We're planning a test day for [September 8th and
9th](https://www.rdoproject.org/testday/newton/milestone3) to ensure
that it's the best version of RDO yet.

## Community Bloggers

We've had some great blog posts from the RDO community over the last
month. You will want to particularly check out these:

* [Introduction to Red Hat OpenStack Platform Director](http://tm3.org/83), by Marcos Garcia.

* [Improving RDO packaging testing coverage](http://tm3.org/7y), by David Simard.

* [How to build new OpenStack packages](http://tm3.org/7-) by Chandan Kumar.

* [Who is Testing Your Cloud?](http://tm3.org/7k) by Maria Bracho.

* [Improving the RDO Trunk infrastructure](http://tm3.org/7n) by Javier Pena.

If you're blogging about RDO or OpenStack, and want to be included in
our weekly blog highlights post on
[rdo-list](https://www.redhat.com/mailman/listinfo/rdo-list), please
drop me a note with your blog address. Thanks!

## Happy Birthday OpenStack!

Six years ago in July, OpenStack was announced at the O'Reilly Open
Source Convention. In that time, it's grown from 2 companies to [over
300](https://www.openstack.org/foundation/companies/),
and from a handful of projects to [more than
50](http://git.openstack.org/cgit/openstack/governance/tree/reference/projects.yaml).

We hope you had an opportunity to attend one of the many [6th birthday
meetups](https://goo.gl/mmRtXi) around the world. [I
attended](https://photos.google.com/share/AF1QipPfBEdr9uDhnKCjUGvk43v_JvEUeth7PWmBqREhfL6H3i3VmfFotMsoQ1wUhNbXGA?key=bDVzejloamVmMVFtRXZTZ3hudTJQbGdXUnZQMlZR)
ours right here in [Lexington,
Kentucky](http://www.meetup.com/OpenStack-Kentucky/events/232204499/)
where we had about 35 OpenStack enthusiasts from the University of
Kentucky College of Engineering, where OpenStack, and a 6PB Ceph
cluster, support the various research projects around the University, as
well as student projects in the school of Computer Science.

We also had a good turnout in [Manchester,
England](http://www.meetup.com/Manchester-OpenStack-Meetup/events/232048418/),
[Washington, DC](http://www.meetup.com/OpenStackDC/events/231785648/),
and many other places.

If you attended one of these meetups, do share your photos and event
reports with us in the [RDO G+ community](http://tm3.org/rdogplus).

## Upcoming Events 

Even if you can't make it to the major events where RDO has a presence,
we're often at smaller events around the world.

We'll be at [OpenStack SV](https://www.openstacksv.com/) next week in
Mountain View. Drop by the Red Hat booth and ask about RDO. And we'll be
at [OpenStack East](http://www.openstackeast.com/) in New York, August
23rd and 24th. There, too, we'll be in the Red Hat booth.

Looking a little further out, we'll also be at the upcoming [PyCon in
India](https://in.pycon.org/2016/) in September, and at [LinuxCon in
Berlin](http://events.linuxfoundation.org/events/linuxcon-europe) in
October, as well as, of course, at [OpenStack
Summit](https://www.openstack.org/summit) in Barcelona in October.

Other RDO events, including the many OpenStack meetups around the
world, are always listed at http://rdoproject.org/events  If you have
an RDO-related event, please feel free to add it by submitting a pull
request to
https://github.com/rbowen/rh-events/blob/master/2016/RDO-Meetups.yml

## TripleO

TripleO - which stands for 'OpenStack On OpenStack' - is a an OpenStack
deployment and management tool, intended to simplify the process of
deploying production OpenStack clouds.

TripleO is a big focus in this cycle, and if you haven't gotten up to
speed yet, there's a great way to do so. Someone has collected [an
entire YouTube
channel](https://www.youtube.com/channel/UCNGDxZGwUELpgaBoLvABsTA/) of
TripleO videos.

Next month, in Buffalo, NY, Rain Leander will be giving a talk at Code
Daze about TripleO, and being a TripleO contributor. If you're in the
area, consider attending. Details are at
[codedaze.io](http://www.codedaze.io/).

## Packaging meetings 

Every Wednesday at 15:00 UTC, we have the [weekly RDO community
meeting](https://etherpad.openstack.org/p/RDO-Meeting)
on the #RDO channel on Freenode IRC. And at 15:00 UTC Thursdays, we
have the CentOS Cloud SIG Meeting on #centos-devel.

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

