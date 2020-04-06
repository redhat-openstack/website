# April 2020 RDO Community Newsletter

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
* [Facebook](https://www.facebook.com/rdocommunity/)
* [YouTube](https://www.youtube.com/RDOcommunity)
* [Ussuri Release Schedule](https://releases.openstack.org/ussuri/schedule.html)

---

## <a name="housekeeping"></a>Housekeeping Items
### Want to Help Us Prep for RDO Ussuri Test Day Milestone THREE?
We are conducting an [RDO test day](http://rdoproject.org/testday/ussuri/milestone3/) on **16 and 17 April 2020**.

This will be coordinated through the **#rdo channel on Freenode**, via [http://rdoproject.org/testday/ussuri/milestone1/](http://rdoproject.org/testday/ussuri/milestone1/) and the [dev@lists.rdoproject.org mailing list](https://lists.rdoproject.org/mailman/listinfo/dev).

We'll be testing the **THIRD** [Ussuri milestone release](https://releases.openstack.org/ussuri/schedule.html). If you can do any testing on your own ahead of time - that will help ensure that everyone isn't encountering the same problems.

If you’re keen to help set up, mentor, or debrief, please reach out to leanderthal on Freenode IRC #rdo and #tripleo.

## <a name="rdo"></a>RDO Changes
### RDO Project Continues Preparation for CentOS EIGHT
The TripleO CI team continues to make progress adding CentOS8 jobs on [https://hackmd.io/HrQd03c9SxOMtFPFrq50tg?view](https://hackmd.io/HrQd03c9SxOMtFPFrq50tg?view). 

Some [EPEL packages are now available](https://trello.com/c/OmeqSzC8/734-use-mock-from-non-epel-repo) within the RDO CentOS8 repositories.

The MessagingSIG has built [RabbitMQ for CentOS8](https://cbs.centos.org/koji/builds?tagID=2036) which is great for RDO as we install it from their repositories.

## <a name="community"></a>Community News
### Tips, Tricks, and Best Practices for Distributed RDO Teams
While a lot of RDO contributors are remote, there are many more who are not and now find themselves in lock down or working from home due to the coronavirus. A few members of the RDO community requested [tips, tricks, and best practices for working on and managing a distributed team](https://blogs.rdoproject.org/2020/03/tips-tricks-and-best-practices-for-distributed-rdo-teams/).

### Community Meetings
Every Tuesday at 13:30 UTC, we have a weekly **TripleO CI community meeting** on [https://meet.google.com/bqx-xwht-wky](https://meet.google.com/bqx-xwht-wky) with the agenda on [https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw](https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw). The TripleO CI meeting focuses on a group of people focusing on Continuous Integration tooling and system who would like to provide a comprehensive testing framework that is easily reproducible for TripleO contributors. This framework should also be consumable by other CI systems (OPNFV, RDO, vendor CI, etc.), so that TripleO can be tested the same way everywhere. This is NOT a place for TripleO usage questions, rather, check out the next meeting listed just below.

Every Tuesday at 14:00 UTC, immediately following the TripleO CI meeting is the weekly **TripleO Community meeting** on the #TripleO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/tripleo-meeting-items). This is for addressing anything to do with TripleO, including usage, feature requests, and bug reports.

Every Wednesday at 14:00 UTC, we have a weekly **RDO community meeting** on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra things (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### COVID-19 (Coronavirus Disease) Update
As we prepare for events this year, OpenStack Foundation (OSF) is closely monitoring the situation surrounding [COVID-19 (coronavirus disease)](https://www.openstack.org/events/covid-19-coronavirus-disease-updates) to ensure the safety and wellbeing of our attendees.

**OpenDev + PTG** (Vancouver 2020)
Based on the input from the community, board, and the latest information available from the health experts, we've made the decision not to hold the OpenDev + PTG in Vancouver in June. Instead, we're exploring ways to turn it into a virtual event and would love the help of everyone in the community. The [OpenDev + PTG landing page](https://www.openstack.org/events/opendev-ptg-2020) will be updated with event details as they are finalized.

**Open Infrastructure Summit** (Berlin 2020)
The [Open Infrastructure Summit](https://www.openstack.org/summit/berlin-2020/) on October 19-23, 2020 in Berlin, Germany is currently planned to proceed as scheduled. We will continue to publish updates as the situation develops and will be following the recommended guidelines provided by the Centers for Disease Control and Prevention (CDC) and the World Health Organization (WHO), as well as local health agencies, airports and venues.

Onsite at the Summit, we plan to take the following measures, and this list is subject to change as we approach the event:

* Keeping up to date information around this situation on our event websites, as well as emailing registered attendees.
* Posting signage on-site with best practices for yourself and fellow attendees, including implementing a "no handshake" rule.
* Providing sanitation stations throughout the venue.
* Requesting that anyone sick or experiencing any cold/flu-like symptoms stay home.
* Encouraging attendees and exhibitors to follow regular CDC guidance for everyday preventive actions.

We will be closely monitoring the situation leading up to the events and will be updating this page with any relevant facts as they're made available.

### Update on OpenDev + PTG Vancouver
The [OpenStack Foundation recently announced](http://lists.openstack.org/pipermail/foundation/2020-March/002854.html) that based on the input from the community, board, and the latest information available from the health experts, we've made the decision not to hold the OpenDev + PTG in Vancouver this June. Instead, we're exploring ways to turn it into a virtual event and would love the help of everyone in the community.

We will be reaching out to participants who have already registered to issue full refunds.

We have always aimed to produce events "of the community, by the community," and this change for OpenDev + PTG is no exception. We would like to virtualize the PTG, since it is critical to producing the next release, targeting the same timeframe. We would like to recruit community volunteers to form a Virtual PTG Organization Team to collaborate with the OSF staff to incorporate best practices and ensure the event continues to meet the goals of the upstream community. We will need to begin pulling this plan together soon, so please add your name ot this etherpad if you are interested in helping: [https://etherpad.openstack.org/p/Virtual_PTG_Planning](https://etherpad.openstack.org/p/Virtual_PTG_Planning). 
For OpenDev, discussions are also meant to be collaborative and free-flowing but are less time bound by the release schedule, so rather than trying to recreate that during a single virtual event at the same time as the virtual PTG, we are thinking about other ways to accomplish the same goals. We've already assembled an awesome team of Program Committee volunteers who have received proposals for moderated discussions, and we will be working with them on some ideas on the best way to move forward. 

For the time being, we are continuing with the plan for the Open Infrastructure Summit in Berlin October 19-23. For updates on OpenDev + PTG and the Summit, please continue to read and bookmark this status page which we will continue to update:  [https://www.openstack.org/events/covid-19-coronavirus-disease-updates](https://www.openstack.org/events/covid-19-coronavirus-disease-updates)

## <a name="#events"></a>Recent and Upcoming Events
### Virtual Red Hat Summit 27-29 April 2020
Immerse yourself in this free virtual event and find your inspiration at the intersection of choice and potential.

**Shape your path forward with new insights, skills, and connections**

The [Red Hat Summit virtual event](https://www.redhat.com/en/summit) will feature the keynotes, breakout sessions, and collaboration opportunities that you’ve come to expect from Red Hat Summit. This programming will be shared as a blend of live and recorded content designed to inspire and engage a global audience.
You will have access to the experts behind the code as you learn about the latest in open hybrid cloud, automation, cloud-native development, and so, so much more. [Red Hat Summit 2020 Virtual Experience](https://reg.summit.redhat.com/) is your platform to learn, network, and plot the next steps in your career as you find ways to unlock your potential.

### OpenDev Experience Summer 2020
For OpenDev, discussions are meant to be collaborative and free-flowing but are less time bound by the release schedule, so rather than trying to recreate that during a single virtual event at the same time as the virtual PTG, we are thinking about other ways to accomplish the same goals. We've already assembled an awesome team of Program Committee volunteers who have received proposals for moderated discussions, and we will be working with them on some ideas on the best way to move forward. 

### Virtual Project Teams Gathering June 2020
We would like to virtualize the PTG, since it is critical to producing the next release, targeting the same timeframe. We would like to recruit community volunteers to form a Virtual PTG Organization Team to collaborate with the OSF staff to incorporate current best practices and ensure the event continues to meet the goals of the upstream community. We will need to begin pulling this plan together soon, so please add your name to this list if you are interested in participating.

### Other Events
Other RDO events, including the many OpenStack meetups around the world, are always listed on the [RDO events page](http://rdoproject.org/events). If you have an RDO-related event, please feel free to add it by submitting a pull request [on Github](https://github.com/OSAS/rh-events/blob/master/2018/RDO-Meetups.yml).

## <a name="kit"></a>Keep in Touch

There are lots of ways to stay in in touch with what's going on in the RDO community. The best ways are ...

### WWW
* [RDO](http://rdoproject.org/)
* [OpenStack Q&A](http://ask.openstack.org/)

### Mailing Lists
* [Dev List](https://lists.rdoproject.org/mailman/listinfo/dev)
* [Users List](https://lists.rdoproject.org/mailman/listinfo/users)
* [This newsletter](https://lists.rdoproject.org/mailman/listinfo/newsletter)
* [CentOS Cloud SIG List](https://lists.centos.org/mailman/listinfo/centos-devel)
* [OpenShift on OpenStack SIG List](https://commons.openshift.org/sig/OpenshiftOpenstack.html)

### IRC on Freenode.irc.net
* RDO Project #rdo
* TripleO #tripleo
* CentOS Cloud SIG #centos-devel

### Social Media
* [Twitter](http://twitter.com/rdocommunity)
* [Facebook](http://facebook.com/rdocommunity)
* [Youtube](https://www.youtube.com/RDOcommunity)

As always, thanks for being part of the RDO community!
