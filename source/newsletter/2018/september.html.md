# September 2018 RDO Community Newsletter

[← Newsletters](/newsletter)
## Quick links:


### In This Newsletter
* [Housekeeping Items](#housekeeping)
* [RDO Changes](#rdo)
* [Community News](#community)
* [OpenStack News](#openstack)
* [Recent and Upcoming Events](#events)
* [Keep in Touch](#kit)

### RDO Resources
* [TripleO Quickstart](http://rdoproject.org/tripleo)
* [Packstack](http://rdoproject.org/install/packstack/)
* [Mailing Lists](https://www.rdoproject.org/contribute/mailing-lists/)
* [EasyFix](https://github.com/redhat-openstack/easyfix)
* [RDO release packages](https://trunk.rdoproject.org/)
* [Review.RDOProject.org](http://review.rdoproject.org/)
* [RDO blog](http://blogs.rdoproject.org)
* [Q&A](http://ask.openstack.org/)
* [Open Tickets](http://tm3.org/rdobugs)
* [Twitter](http://twitter.com/rdocommunity)
* [Stein release schedule](https://releases.openstack.org/stein/schedule.html)

---
OpenStack Rocky is officially here! OpenStack Stein is officially underway! OpenStack PTGs officially move to co-location with Summits! So much amazing impactful news happened recently that we're going to keep the introduction short and let the blurbs speak for themselves.

## <a name="housekeeping"></a>Housekeeping Items
### OpenStack PTG Project Interviews
Rain Leander is attending [OpenStack PTG]() this week to conduct [project interviews](https://docs.google.com/spreadsheets/d/19XjQPeE9ZobK1b49aM-J7P-xQC-OKLNeFnwxavyQCgU/edit?usp=sharing). If you’ll be there, please be sure to sign up! These interviews have several purposes. Please consider all of the following when thinking about what you might want to say:

* Tell the users/customers/press what you've been working on in Rocky
* Give them some idea of what's (what might be?) coming in Stein
* Put a human face on the OpenStack project and encourage new participants to join us
* You're welcome to promote your company's involvement in OpenStack but we ask that you avoid any kind of product pitches or job recruitment

Please note that there are only forty interview slots available, so consider coordinating with your project to designate the people that you want to represent the project, so we don't end up with twelve interviews about Neutron.

I mean, love me some Neutron, but twelve interviews is a bit too many, eh?

It's fine to have multiple people in one interview - maximum three, probably. Interview slots are thirty minutes, in which time we hope to capture somewhere between ten and twenty minutes of content. It's fine to run shorter but fifteen minutes is probably an ideal length.

## <a name="rdo"></a>RDO Changes
### Community Test Days
It was one week before Rocky GA Test Days when I realized quite a few things happen at this time. Not only is everyone focused on GA, but we also need to assemble the release announcement and head over to OpenStack PTG. I brought it up in the RDO Community Meeting, it was discussed, and decided - official test days will still be only twice per cycle, but on M1 and M3. 

Starting now. 

Therefore, in the upcoming cycle Stein, we’ll have M1 Test Days on 01-02 November 2018 and M3 Test Days 14-15 March 2019. 

As always, you don't have to wait for a scheduled test day to test RDO. We would love to hear about your experiences, with either a [Packstack installation](https://www.rdoproject.org/install/packstack) or the [TripleO Quickstart](https://www.rdoproject.org/install/packstack).

We also encourage you to work through the upstream installation tutorial while keeping detailed notes on the following points:
* Did you know what the document assumed that you'd know?
* Did the steps work as described?
* What error conditions did you encounter? Could you work around them? If so, how?
* When you were done, did it work as expected? If not, what happened, and how did it differ from what you expected to happen?

## <a name="community"></a>Community News
### RDO Community Celebration at OpenStack PTG
If you’re in Denver for PTG, [RDO Community is hosting a celebration](https://www.eventbrite.com/e/rdo-community-celebration-at-openstack-ptg-tickets-50022363235) at Station 26 Brewery on Monday night from 1800-2100 local time. Mostly we’re just looking to get everyone together for some free beer and food to celebrate the latest RDO release, Rocky. Tickets are free, but please do register so we know who is coming and can prep the right number of Steins.

### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra thingies (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### OpenStack Rocky is Officially Released!
Sean McGinnis and the whole Release Management team [announced on 30 August](http://lists.openstack.org/pipermail/openstack-announce/2018-August/002015.html) that the final releases for the components of OpenStack Rocky are here! Check out the complete list of all components and links to each project’s release notes documented on [https://releases.openstack.org/rocky/](https://releases.openstack.org/rocky/).

Congratulations to all of the teams who have contributed to this release!

### Future OpenStack Project Team Gatherings To Be Co-Located
Thierry Carrez, Release Manager for the OpenStack project, announced that future OpenStack PTGs will be co-located with OpenStack Summits. “The current plan is to run the first Summit in 2019 from Monday to Wednesday, then a 3-day PTG from Thursday to Saturday.” 

## <a name="events"></a>Recent and Upcoming Events
### OpenStack PTG in Denver Colorado
The [Project Teams Gathering (PTG)](https://www.openstack.org/ptg/) is an event organized by the [OpenStack Foundation](https://www.openstack.org/foundation/). It provides meeting facilities allowing the various technical community groups working with OpenStack (user workgroups, development teams, operators, SIGs) to meet in-person, exchange and get work done in a productive setting. It lets those various groups discuss their priorities for the upcoming cycle, assign work items, iterate quickly on solutions for complex problems, and make fast progress on critical issues. The co-location of those various meetings, combined with the dynamic scheduling of the event, make it easy to get specific people in the same room to discuss a specific topic, or participate in multiple team meetings. Evenings allow for relationship building and problem sharing.

### CentOS Dojo / RDO Day at CERN
We’re super excited to host an [RDO Day in conjunction with a CentOS Dojo](https://indico.cern.ch/event/727150/) at [CERN](https://home.cern/). The CentOS Dojos and RDO Days are one day events, organized around the world, that bring together people from the CentOS Communities and RDO Communities to talk about systems administration, OpenStack, best practices in Linux centric activities, and emerging technologies of note. The emphasis is to find local speakers and tutors to come together and talk about things that they care about most, and to share stories from their experiences working with CentOS in various scenarios.

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring out a good topic or finalizing your abstract? Feel free to reach out in the #RDO channel on IRC.

* **[Bristech Conference 06 December 2018](https://2018.bris.tech/)** Why are we passionate about organising tech events in Bristol? In essence, it is captured in our strap-line: “Knowledge. Shared.” An ideal talk for Bristech Conference 2018 would be from a relevant and interesting technical topic brought to life by the enthusiasm and knowledge of the speaker through a blend of both theoretical context and hands-on practice. CFP closes at  16 September 2018 22:09 UTC
* **[Windy City Devfest 01 February 2019](https://windycity.devfest.io/home)** A 100% community organized developer conference with industry experts presenting on exciting topics! Windy City Devfest is a community-run, one-day conference aimed to bring students, developers, tech-companies and awesome speakers together under one roof. Where they can learn about Google’s technologies along with other emerging technologies with topics such as Android, Flutter, Firebase, Google Cloud Platform, the Mobile Web, Google Assistant, Machine Learning and more. CFP closes at  December 01, 2018 14:12 UTC

### Other Events
Other RDO events, including the many OpenStack meetups around the world, are always listed on the [RDO events page](http://rdoproject.org/events). If you have an RDO-related event, please feel free to add it by submitting a pull request [on Github](https://github.com/OSAS/rh-events/blob/master/2018/RDO-Meetups.yml).

## <a name="kit"></a>Keep in Touch

There are lots of ways to stay in in touch with what's going on in the RDO community. The best ways are ...

### WWW
* [RDO](http://rdoproject.org/)
* [OpenStack Q&A](http://ask.openstack.org/)

### Mailing Lists:
* [Dev mailing list](https://lists.rdoproject.org/mailman/listinfo/dev)
* [Users mailing list](https://lists.rdoproject.org/mailman/listinfo/users)
* [This newsletter](https://lists.rdoproject.org/mailman/listinfo/newsletter)

### IRC
* IRC - #rdo on Freenode.irc.net

### Social Media
* [Follow us on Twitter](http://twitter.com/rdocommunity )
* [Google+](http://tm3.org/rdogplus )
* [Facebook](http://facebook.com/rdocommunity)

As always, thanks for being part of the RDO community!
