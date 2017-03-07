# March 2017 RDO Community Newsletter

## Quick links:

* [TripleO Quick Start](https://www.rdoproject.org/tripleo/)
* [All-In-One Quick Start](http://rdoproject.org/quickstart)
* [Mailing Lists](https://www.rdoproject.org/community/mailing-lists/)
* [RDO release packages](https://trunk.rdoproject.org/)
* [Review.RDOProject.org](http://review.rdoproject.org/)
* [RDO blog](http://rdoproject.org/blog)
* [Q&A](http://ask.openstack.org/)
* [Open Tickets](http://tm3.org/rdobugs)
* [Twitter](http://twitter.com/rdocommunity)
* [Newton release schedule](http://releases.openstack.org/newton/schedule.html)

Thanks for being part of the RDO community!

## Ocata Released!!!

* The RDO community is proud to announce the release of RDO packages for OpenStack Ocata. Following just a few hours after the upstream release of Ocata, RDO's packages passed CI, and were delivered to our RPM repositories around the Internet.

Javier Pena did a great writeup of the release on the RDO blog, including details of what is new in Ocata, and where to try out the new RDO packages. You can read that [here](https://www.rdoproject.org/blog/2017/02/rdo-ocata-released/). We recommend using the [TripleO Quickstart](https://www.rdoproject.org/tripleo/) to get started trying out Ocata.

For those who want to dig deeper into what goes on behind the scenes during an RDO release, Haïkel Guémar did a writeup of exactly that in the [RDO blog](https://www.rdoproject.org/blog/2017/02/rdo-ocata-release-behind-the-scenes/). He covered the release process, as well as reflections on how it went this time, and what we hope to improve on the next time. If you'd like to be more involved in RDO, this is the perfect place to start.


## Recent Events

### OpenStack Project Teams Gathering

Two weeks ago in Atlanta, OpenStack held the first PTG - the Project Teams Gathering. This is an outgrowth of the developers summit that, until now, was held at OpenStack Summit. It's been split off into its own event, so that the project teams can focus entirely on this one task, without the distration of the larger event, customer meetings, and so on. Each team had a dedicated room where they discussed what needs to get done in the next release, code-named Pike, and how they're going to get there. They also had cross-project meetings to discuss the places where projects need to interact with one another, where they overlap, and where they need to agree on common pieces.

During the event, I was on-site conducting engineer interviews. I talked with 23 OpenStack engineers about what they worked on in Ocata, and what's coming in Pike. Some of these interviews can already be seen on the RDO YouTube channel, in the [PTG playlist](https://www.youtube.com/playlist?list=PLOuHvpVx7kYksG0NFaCaQsSkrUlj3Oq4S) and more will be posted in the coming days as I work through editing them. You'll also see this content on the RDO blog once I get them transcribed over the coming weeks. So subscribe to the [RDO channel](https://www.youtube.com/channel/UCWYIPZ4lm4P3_pzZ9Hx9awg) to see those as soon as they become available.

These videos are a great insight both into what's new in Ocata, but also into the passion that drives the RDO community. It was really cool to be able to speak with all of these brilliant people, and share their excitement about the next chapter of OpenStack.

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/rbowen/32245238703/in/album-72157677087881734/" title="IMG_20170222_182316"><img src="https://c1.staticflickr.com/1/719/32245238703_bca3b7998d.jpg" width="500" height="375" alt="IMG_20170222_182316"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

On Wednesday evening, RDO contributors gathered at the Side Bar in downtown Atlanta where we sent the release announcement, and celebrated another successful delivery of RDO. We hope that you will be there the next time we do this.

### SCALE

Last week in Pasadena, RDO was represented at SCALE - the Southern California Linux Expo - as part of the Red Hat booth there. SCALE follows in the tradition of old-school Linux conferences, with lots of teaching, lots of desktop apps, and lots of kids learning about Linux for the first time. But there was also a lot of space for infrastructure projects like OpenStack, OpenShift, Ceph, and so on. We had many great conversations with school kids who wanted to learn about the world of technology.

If you have an opportunity to attend SCALE in coming years, we recommend it. It's a fun event, with lots of great content for people at all levels of expertise.

## Upcoming Events 

There's several events on the horizon that you should be aware of.

* [OpenStack Days Poland](http://www.openstackday.pl/) will be held March 22 in Warsaw. Community member Ana Krivokapic will be there representing RDO, so drop by the Red Hat booth for your RDO stickers.

* [OpenStack Summit, Boston](https://www.openstack.org/summit/boston-2017) is 2 months away - May 8-12 - and it's time to get registered, and book your hotels, since they'll fill up fast.

* And speaking of OpenStack Summit, it's just been announced that OpenStack Summit North America 2018 will be held in [Vancouver, May 21-24](https://www.openstack.org/summit/vancouver-2018/)!

Other RDO events, including the many OpenStack meetups around the
world, are always listed on the [RDO events page](http://rdoproject.org/events).
If you have an RDO-related event, please feel free to add it by submitting a pull
request [on Github](https://github.com/OSAS/rh-events/blob/master/2016/RDO-Meetups.yml).

## Mailing list catch-up

In case you missed it, here's a few highlights from rdo-list that you
may have missed.

## Blog Posts

There's been some great blog posts in the last month. Here's a sampling:

**RDO Ocata Release Behind The Scenes** by Haïkel Guémar

> I have been involved in 6 GA releases of RDO (From Juno to Ocata), and I wanted to share a glimpse of the preparation work.  Since Juno, our process has tremendously evolved: we refocused RDO on EL7, joined the CentOS Cloud SIG, moved to Software Factory.

Read more at [http://rdoproject.org/blog/2017/02/rdo-ocata-release-behind-the-scenes/](http://rdoproject.org/blog/2017/02/rdo-ocata-release-behind-the-scenes/)


**Developing Mistral workflows for TripleO** by Steve Hardy

> During the newton/ocata development cycles, TripleO made changes to the architecture so we make use of Mistral (the OpenStack workflow API project) to drive workflows required to deploy your OpenStack cloud.

Read more at [http://hardysteven.blogspot.com/2017/03/developing-mistral-workflows-for-tripleo.html](http://hardysteven.blogspot.com/2017/03/developing-mistral-workflows-for-tripleo.html)


**OpenStack Pike PTG: TripleO, TripleO UI  | Some highlights** by jpichon

> For the second part of the PTG (vertical projects), I mainly stayed in the TripleO room, moving around a couple of times to attend cross-project sessions related to i18n.

Read more at [http://www.jpichon.net/blog/2017/03/openstack-pike-ptg-tripleo-tripleo-ui/](http://www.jpichon.net/blog/2017/03/openstack-pike-ptg-tripleo-tripleo-ui/)


**OpenStack PTG, trip report** by rbowen

> last week, I attended the OpenStack PTG (Project Teams Gathering) in Atlanta.

Read more at [http://drbacchus.com/openstack-ptg-trip-report/](http://drbacchus.com/openstack-ptg-trip-report/)


**Installing TripleO Quickstart** by Carlos Camacho

> This is a brief recipe about how to  manually install TripleO Quickstart in a remote  32GB RAM box and not dying trying it.

Read more at [http://anstack.github.io/blog/2017/02/24/install-tripleo-quickstart.html](http://anstack.github.io/blog/2017/02/24/install-tripleo-quickstart.html)


**RDO Ocata released** by jpena

> The RDO community is pleased to announce the general availability of the RDO build for OpenStack Ocata for RPM-based distributions, CentOS Linux 7 and Red Hat Enterprise Linux.  RDO is suitable for building private, public, and hybrid clouds. Ocata is the 15th release from the OpenStack project, which is the work of more than 2500 contributors from around the world (source).

Read more at [http://rdoproject.org/blog/2017/02/rdo-ocata-released/](http://rdoproject.org/blog/2017/02/rdo-ocata-released/)

As always, you can catch up with great OpenStack blog posts on [Planet OpenStack](http://planet.openstack.org/).


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

