# November 2016 RDO Community Newsletter

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

## RDO Newton Released

The RDO community is pleased to announce the general availability of the RDO build for OpenStack Newton for RPM-based distributions, CentOS Linux 7 and Red Hat Enterprise Linux. RDO is suitable for building private, public, and hybrid clouds. Newton is the 14th release from the [OpenStack project](http://openstack.org), which is the work of more than 2700 contributors from around the world ([source](http://stackalytics.com/)).

The [RDO community project](https://www.rdoproject.org/) curates, packages, builds, tests, and maintains a complete OpenStack component set for RHEL and CentOS Linux and is a member of the [CentOS Cloud Infrastructure SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud). The Cloud Infrastructure SIG focuses on delivering a great user experience for CentOS Linux users looking to build and maintain their own on-premise, public or hybrid clouds. At latest count, RDO contains [1157 packages](https://www.rdoproject.org/documentation/package-list/).

All work on RDO, and on the downstream release, Red Hat OpenStack Platform, is 100% open source, with all code changes going upstream first. 

**Getting Started**

There are three ways to get started with RDO.

To spin up a proof of concept cloud, quickly, and on limited hardware, try the [All-In-One Quickstart](http://rdoproject.org/Quickstart). You can run RDO on a single node to get a feel for how it works.

For a production deployment of RDO, use the [TripleO Quickstart](https://www.rdoproject.org/tripleo/) and you'll be running a production cloud in short order.

Finally, if you want to try out OpenStack, but don't have the time or hardware to run it yourself, visit [TryStack](http://trystack.org/), where you can use a free public OpenStack instance, running RDO packages, to experiment with the OpenStack management interface and API, launch instances, configure networks, and generally familiarize yourself with OpenStack


## OpenStack Summit Recap

It's just been a few days since the [OpenStack
Summit](http://openstack.org/summit) in Barcelona,
Spain, and some of us are still recovering. There's always far too much
happening at Summit for any one person to experience, so catching up on
all of the various blog posts afterwards is part of the
experience. Here's some of the event recaps from our community:

* [Attending OpenStack Summit Ocata](https://julien.danjou.info/blog/2016/openstack-summit-ocata-barcelona-review)
* [OpenStack Summit, Barcelona: 2 of N](http://drbacchus.com/openstack-summit-barcelona-2-of-n/)
* [What you missed at OpenStack Summit](https://www.mirantis.com/blog/what-you-missed-at-openstack-barcelona/)

Two highlights of OpenStack Summit for the RDO community were 
the RDO Infrastructure meeting, and the Evening with RDO and Ceph.

On Monday afternoon, before the Summit officially started, about 20 RDO
community members gathered to discuss some of the infrastructure issues
around the RDO project. As RDO has grown, our infrastructure needs have
grown, and various community members have brought up services to address
these needs. Over time, our infrastructure footprint has become
complicated enough that a beginner is likely to have trouble figuring
out what goes where. Over the coming year, we're going to try to
consolidate some of these services to fewer locations, preferably
running on RDO-based clouds, and document these services so that it's
easier for newbies to jump in. This, and other infrastructure related
issues, were discussed. You can see the agenda, and notes, from that
meeting, in the [meeting
etherpad](https://review.rdoproject.org/etherpad/p/barcelona-rdo-infra-meetup).

On Tuesday evening, RDO and Ceph together hosted a gathering at the
Princess Hotel. It was an evening of food, drinks, and technical
sessions about Ceph and RDO. We ended up having 215 people in
attendance, and 12 speakers, covering a variety of topics around our two
projects. Watch rdo-list and @rdocommunity for the slides from these
presentations over the coming days.

## Ocata Test Day Schedule

Based on the [Ocata development
schedule](https://releases.openstack.org/ocata/schedule.html), we've
posted a tentative [Ocata RDO test day
schedule](https://www.rdoproject.org/testday/) on the RDO website. Mark
your calendar. Plan to spend a few hours on those days testing the
latest RDO packages, and help make RDO Ocata the best RDO yet.

Over the last few test days, we've improved the test day instructions to
make it easier for you to participate without having to know everything
about RDO ahead of time. So don't worry if you're not an OpenStack
expert. Bring a fresh CentOS VM to the party, and we'll provide the rest
of the pieces.

Here's the tentative schedule:

* Ocata 1 – December 1st and 2nd, 2016
* Ocata 3 – February 2nd and 3rd, 2017
* Ocata Final – March 2nd and 3rd, 2017

You'll notice there's only three test days listed - Ocata is a shorter
than usual cycle, and falls during a time of the year where it's already
difficult to find test day dates. So we're dropping the Ocata 2 test
day, and moving tghe others around a little. This makes it all the more
important that the community show up to test.


## Upcoming Events 

There's several events on the horizon that you should be aware of. There
are some of the upcoming OpenStack Day events where we expect members of
the RDO community to be present.

* [OpenStack DACH Tag](https://www.openstack-dach.org/), Berlin,
  November 5th
* [OpenStack Day France](https://openstackdayfrance.fr/), Paris,
  November 22nd
* [OpenStack Day Canada](http://openstackca.org/), Montreal, November
  22nd


Other RDO events, including the many OpenStack meetups around the
world, are always listed on the [RDO events page](http://rdoproject.org/events).
If you have an RDO-related event, please feel free to add it by submitting a pull
request [on Github](https://github.com/OSAS/rh-events/blob/master/2016/RDO-Meetups.yml).

## Community meetings 

Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting
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

