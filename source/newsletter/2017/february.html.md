# February 2017 RDO Community Newsletter

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
* [Ocata release schedule](http://releases.openstack.org/ocata/schedule.html)

Thanks for being part of the RDO community!

## RDO Ocata

In less than 2 weeks - on February 22nd - [OpenStack Ocata](https://releases.openstack.org/ocata/schedule.html) will be released, and shortly after that (hopefully within hours!) RDO Ocata will be released. Please join us, March 2nd and 3rd, for the [Ocata Final GA test day](https://www.rdoproject.org/testday/ocata/final/), where we will put the release through its paces to ensure that it's the best RDO yet.

Meanwhile, you can track progress on the [RDO dashboard](http://dashboards.rdoproject.org) which gives the latest information on the status of the RDO packages currently available in DLRN.

## Updated process documentation

We're in the process of updating the documentation that describes how the RDO release cycle works. These new docs can be found at [https://www.rdoproject.org/what/](https://www.rdoproject.org/what/). They're not done yet, and if you can contribute to any portion of that, pick one of the docs that still marked *TODO* and get started. And watch that section over the coming weeks as it shapes up.

## Recent Events

In the past month, RDO has had a presence at two major events, as well as numerous small meetups.

### DevConf

On January 27th - 30th, RDO had a booth at [DevConf.cz](http://devconf.cz). DevConf is the annual open source developer conference held in Brno, Czechia, at the Faculty of Information Technology (VUT FIT). This is the second year that RDO has had a presence there. Watch the [RDO blog](http://rdoproject.org/blog/) for an upcoming blog post about that event.

### CentOS Dojo, Brussels

On February 3rd, CentOS held a Dojo (project gathering) in Brussels, Belgium, including presentations from many different CentOS SIGs (Special Interest Groups). You can see the full schedule of talks on the [Dojo website](https://wiki.centos.org/Events/Dojo/Brussels2017). Several of these presentations were related to RDO and the Cloud SIG. While there was no official videographer for the event, I did take my camera to the sessions that I attended, and you can find video from those sessions on [my YouTube channel](https://www.youtube.com/playlist?list=PL27cQhFqK1Qya8JJxM9mtmZTwudi7dOmh). This includes presentations on RDO CI, CERN's OpenStack Cloud, and the Skydive network visualization tool.

### FOSDEM

On the weekend of February 4th and 5th, RDO had a table at [FOSDEM](http://fosdem.org/), one of the largest gatherings of open source enthusiasts in the world, with as many as 7000 attendees. Once again, we shared space with our friends from the CentOS community. Members of the RDO community also helped staff the OpenStack booth at the event, spreading the word about what OpenStack is doing in the the world of cloud computing.

## Upcoming Events

In the coming months, we'll be present at a number of other events, and we hope to see you there.

### PTG

The OpenStack Project Teams Gathering (PTG) will be held in Atlanta, Georgia, USA, February 20-24. The PTG takes hte place of the developer summit at OpenStack Summit, and is where the next version of OpenStack - named Pike - will be planned.

While there, I'll be doing interviews with the various people who have been involved in making RDO Ocata a reality, and these interviews will appear on the RDO blog throughout the event, and in the weeks following. If you're going to be there, and aren't yet on my schedule, please contact me at rbowen@redhat.com to schedule your interview.

For more details about the PTG, and to register to attend, see [openstack.org/ptg](http://openstack.org/ptg/)

### SCALE

SCALE - the Southern California Linux Expo - will be held March 2-5, 2017 at the Pasadena Convention Center. RDO will have a booth there where we'll be showing off what the community has been working on, and answering OpenStack questions. We'll be sharing the space with CentOS, as well as a few other projects supported by the Red Hat Open Source and Standards group.

For more information about SCALE, and to register to attend, see [socallinuxexpo.org](https://www.socallinuxexpo.org/scale/15x)

### Mar 22, 2017: OpenStack Days Poland

We expect to be present at [OpenStack Days Poland](http://www.openstackday.pl/), which will be held in Warsaw, Poland, on March 22nd. If you expect to be present, please let me know!

### OpenStack Summit

While right now, May seems like a long way away, it will be here sooner than we expect. The call for papers closed on February 8th, and we expect to see a schedule published in the next few weeks. RDO will once again have a presence at this event, which will be helpd in Boston, USA, May 8th - 11th. You can learn more about the event, and register, at [openstack.org/summit](http://openstack.org/summit/).

### And ...

Other RDO events, including the many OpenStack meetups around the
world, are always listed on the [RDO events page](http://rdoproject.org/events).
If you have an RDO-related event, please feel free to add it by submitting a pull
request [on Github](https://github.com/OSAS/rh-events/blob/master/2016/RDO-Meetups.yml).

## Blog Posts

There's been some great blog posts in the last month. Here's a sampling:

**Gnocchi 3.1 unleashed** by Julien Danjou

> It's always difficult to know when to release, and we really wanted to do it  earlier. But it seems that each week more awesome work was being done  in Gnocchi, so we kept delaying it while having no  pressure to push it out.

Read more at [http://tm3.org/dr](http://tm3.org/dr)


**Testing RDO with Tempest: new features in Ocata** by ltoscano

> The release of Ocata, with its shorter release cycle, is close and  it is time to start a broader testing (even if one could argue that  it is always time for testing!).

Read more at [http://tm3.org/ds](http://tm3.org/ds)


**Barely Functional Keystone Deployment with Docker** by Adam Young

> My eventual goal is to deploy Keystone using Kubernetes.  However, I want to understand things from the lowest level on up.  Since Kubernetes will be driving Docker for my deployment, I wanted to get things working for a single node Docker deployment before I move on to Kubernetes.    As such, you’ll notice I took a few short cuts.  Mostly, these involve configuration changes.  Since I will need to use Kubernetes for deployment and configuration, I’ll postpone doing it right until I get to that layer.  With that caveat, let’s begin.  

Read more at [http://tm3.org/dt](http://tm3.org/dt)


**Standalone Cinder: The definitive SDS** by geguileo

> Are you looking for the best Software Defined Storage in the market? Look no further, Standalone Cinder is here! Let’s have an overview of the Standalone Cinder service, see some specific configurations, and find out how to make requests with no other OpenStack service is deployed. Cinder Until not so long ago Cinder was always […]

Read more at [http://tm3.org/dh](http://tm3.org/dh)

**What are Clouds?** by Zane Bitter

>   Like many in the community, I am often called upon to explain what OpenStack is to somebody completely unfamiliar with it. Usually this goes one of two ways: they turn out to be familiar enough with cloud computing to quickly grasp it by analogy, or their eyes glaze over at the mention of the words ‘cloud computing’ and no further explanation is sought or offered. When faced with someone who is persistently curious but not an industry insider, you immediately know you’re in trouble.  

Read more at [http://tm3.org/dm](http://tm3.org/dm)


**Update on TripleO with already provisioned servers** by slagle

> In a previous post, I talked about using TripleO with already deployed and provisioned servers. Since that was published, TripleO has made a lot of progress in this area. I figured it was about time for an update on where the project is with this feature.

Read more at [http://tm3.org/do](http://tm3.org/do)


If you blog about anything OpenStack, please let me know, so that I can add you to the list of blogs that I review each week. And see rdo-list, where I post a round-up of RDO bloggers almost every week.

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
