# May 2020 RDO Community Newsletter

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
* [Victoria Release Schedule](https://releases.openstack.org/victoria/schedule.html)

---
Is it time for an upgrade? The definition of DONE! OpenStack Foundation announces the 21st version of the most widely deployed open source cloud infrastructure software! And we send off our OpenStack Community Liaison with love. Welcome to RDO Project's May 2020 Newsletter.

## <a name="housekeeping"></a>Housekeeping Items
### All Your Repos Are Belong To Us
Ocata and Pike are in the [Extended Maintenance Phase](https://releases.openstack.org/) for more than a year now, The [promotion jobs](https://review.rdoproject.org/r/#/q/topic:remove_pike) used to test these repos were [dropped long ago]()https://review.rdoproject.org/r/#/c/16485/. Now we are planning to drop the [Okata](http://trunk.rdoproject.org/centos7-ocata/) and [Pike](http://trunk.rdoproject.org/centos7-pike/) trunk repos by the first week of June 2020. We have already [stopped building new commits](https://softwarefactory-project.io/r/#/c/18347/) for both repos.

If anyone is still using these repos, please consider an upgrade to queens or any later releases. If something is blocking you from an upgrade or migration away from ocata or pike, please [respond to this email thread](https://lists.rdoproject.org/pipermail/dev/2020-May/009380.html) so we may consider it before June.

## <a name="rdo"></a>RDO Changes
### What’s Done is Done
For the past few releases, we’ve been waiting until the trailing projects [TripleO](https://wiki.openstack.org/wiki/TripleO) and [Kolla](https://wiki.openstack.org/wiki/Kolla) were completed and published before sending out the official Release Announcement. Once upon a time, we officially posted [the technical definition of done](https://blogs.rdoproject.org/2016/05/technical-definition-of-done/) for the Mitaka release and we’ve decided in the RDO Community meeting yesterday to officially incorporate a ‘definition of done’ for each release cycle in the future starting with [Ussuri](https://docs.openstack.org/ussuri/).

To that end, the RDO Project agrees that before announcing a new release to the community formally, the following specific criteria must be confirmed within the CloudSIG builds:

* The three packstack all-in-one upstream scenarios can be executed successfully.
* The four puppet-openstack-integration scenarios can be executed successfully.
* TripleO container images can be built.
* TripleO standalone scenario001 can be deployed with the containers from CloudSIG builds.

This also needs to be completed before the next major event following the OpenStack release. In the case of Ussuri, since announcements cannot happen on a Friday, Saturday, or Sunday, the announcement will happen no later than Thursday, 28 May because the virtual PTG is 01-05 June. This criteria has been agreed for Ussuri GA and may be updated for next releases. If you would like to contribute, comment or commend this change, please feel free to join us on Wednesdays at 14:00 UTC for the weekly **RDO community meeting** on Freenode IRC channel #RDO.

## <a name="community"></a>Community News
### We Wish You All The Best
RDO Project’s OpenStack Community Liaison, Rain Leander, is leaving Red Hat and the RDO Project as a technical community manager. In their own words, “this is not actually a good bye.
ASIDE: I’m terrible at goodbyes. This is “I’ll See You Around”. Because the next chapter is within open source. Within cloud computing. Within edge. And while I absolutely cannot wait to tell you about it, this is not the time for looking forward, but for looking back. This is a time for celebrating the past. For thanking my beautiful collaboraters. Maybe for shedding a tear or two. Definitely for expressing those difficult emotions. I love you, RDO Project. Thank you. And I'll see you around.”

### Community Meetings
Every Tuesday at 13:30 UTC, we have a weekly **TripleO CI community meeting** on [https://meet.google.com/bqx-xwht-wky](https://meet.google.com/bqx-xwht-wky) with the agenda on [https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw](https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw). The TripleO CI meeting focuses on a group of people focusing on Continuous Integration tooling and system who would like to provide a comprehensive testing framework that is easily reproducible for TripleO contributors. This framework should also be consumable by other CI systems (OPNFV, RDO, vendor CI, etc.), so that TripleO can be tested the same way everywhere. This is NOT a place for TripleO usage questions, rather, check out the next meeting listed just below.

Every Tuesday at 14:00 UTC, immediately following the TripleO CI meeting is the weekly **TripleO Community meeting** on the #TripleO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/tripleo-meeting-items). This is for addressing anything to do with TripleO, including usage, feature requests, and bug reports.

Every Wednesday at 14:00 UTC, we have a weekly **RDO community meeting** on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra things (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### OpenStack Ussuri Release Delivers Automation for Intelligent Open Infrastructure
**AUSTIN, Texas - May 13, 2020** The OpenStack community today released [Ussuri](https://www.openstack.org/software/ussuri/), the 21st version of the most widely deployed open source cloud infrastructure software. The release delivers advancements in three core areas:

* Ongoing improvements to the reliability of the core infrastructure layer
* Enhancements to security and encryption capabilities
* Extended versatility to deliver support for new and emerging use cases 

These improvements were designed and delivered by a global community of upstream developers and operators. OpenStack software now powers more than 75 public cloud data centers and thousands of private clouds at a scale of more than 10 million compute cores. OpenStack is the one infrastructure platform uniquely suited to deployments of diverse architectures—bare metal, virtual machines (VMs), graphics processing units (GPUs) and containers. 

For the Ussuri release, OpenStack received over 24,000 code changes by 1,003 developers from 188 different organizations and over 50 countries. OpenStack is supported by a large, global open source community and is one of the top three open source projects in the world in terms of active contributions, along with the Linux kernel and Chromium. 

Learn more about the 21st release of this open source cloud software platform at [https://www.openstack.org/news/view/453/openstack-ussuri-release-lands-today-delivering-automation-for-intelligent-open-infrastructure](https://www.openstack.org/news/view/453/openstack-ussuri-release-lands-today-delivering-automation-for-intelligent-open-infrastructure)

## <a name="#events"></a>Recent and Upcoming Events
### Virtual Project Teams Gathering
The June Project Teams Gathering is going virtual since it is critical to producing the next release. The virtual event will be held from Monday, June 1 to Friday, June 5.

The event is open to all OSF projects, and teams are currently signing up for their time slots. Find participating teams below, and the schedule will be posted in the upcoming weeks.

[Registration is now open!](https://virtualptgjune2020.eventbrite.com)

Participating Teams include Airship, Automation SIG, Cinder, Edge Computing Group, First Contact SIG, Interop WG, Ironic, Glance, Heat, Horizon, Kata Containers, Kolla, Manila, Monasca, Multi-Arch SIG, Neutron, Nova, Octavia, OpenDev, OpenStackAnsible, OpenStackAnsibleModules, OpenStack-Helm, Oslo, QA, Scientific SIG, Security SIG, Tacker, and TripleO!

Continue to check [https://www.openstack.org/ptg/](https://www.openstack.org/ptg/) for event updates and if you have any questions, please email ptg@openstack.org.

### OpenDev: Three Part Virtual Event Series
OpenDev events bring together the developers and users of the open source software powering today's infrastructure, to share best practices, identify gaps, and advance the state of the art in open infrastructure. OpenDev events focused on [Edge Computing](https://superuser.openstack.org/articles/report-cloud-edge-computing/) in 2017 and CI/CD in 2018. In 2020, OpenDev is a virtual series of three separate events, each covering a different open infrastructure topic. Participants can expect discussion oriented, collaborative sessions exploring challenges, sharing common architectures, and collaborating around potential solutions.

**Event #1: Large Scale Usage of Open Infrastructure**
**June 29 - July 1, 2020**

Operating open infrastructure at scale presents common challenges and constraints. During this event, users will share case studies and architectures, discuss problem areas impacting their environments, and collaborate around open source requirements directly with upstream developers. 

Topics include:
* Scaling user stories with the goal of pushing back cluster scaling limits
* Upgrades
* Centralized compute vs distributed compute for NFV and edge computing use case
* User Stories - challenges based on size of the deployment

Register at [https://www.eventbrite.com/e/opendev-large-scale-usage-of-open-infrastructure-software-registration-102899719832](https://www.eventbrite.com/e/opendev-large-scale-usage-of-open-infrastructure-software-registration-102899719832)

**Event #2: Hardware Automation topics**
**July 20 - 22, 2020**

From hardware acceleration to running applications directly on bare metal, hardware automation enables organizations to save resources and increase productivity. During this OpenDev event, operators will discuss hardware limitations for cloud provisioning, share networking challenges, and collaborate on open source requirements directly with upstream developers. 

Topics include:
* End-to-end hardware provisioning lifecycle for bare metal / cradle to grave for hypervisors
* Networking
* Consuming bare metal infrastructure to provision cloud based workloads

Register at [https://www.eventbrite.com/e/opendev-hardware-automation-registration-104569991660](https://www.eventbrite.com/e/opendev-hardware-automation-registration-104569991660)

**Event #3: Containers in Production topics**
**August 10 - 12, 2020**

Whether you want to run containerized applications on bare metal or VMs, organizations are developing architectures for a variety of workloads. During this event, users will discuss the infrastructure requirements to support containers, share challenges from their production environments, and collaborate on open source requirements directly with upstream developers. 

Topics include:
* Using OpenStack and containers together
* Security and Isolation
* Telco and Network Functions
* Bare metal and containers
* Acceleration and optimization

Register at [https://www.eventbrite.com/e/opendev-containers-in-production-registration-105020424918](https://www.eventbrite.com/e/opendev-containers-in-production-registration-105020424918)

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
