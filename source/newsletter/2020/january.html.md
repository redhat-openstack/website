# January 2020 RDO Community Newsletter

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
Welcome to the new decade of 2020 where it's a mere five months to Ussuri release! Ready? Set? GO!

## <a name="housekeeping"></a>Housekeeping Items
### Thanks for all the help on RDO Ussuri Test Day Milestone ONE!
We did a [RDO test day on 19 and 20 December 2019](http://rdoproject.org/testday/ussuri/milestone1/) and it went great! While we didn't open any tickets, we had 26 participants and 869 messages. The next RDO test day is for Milestone three on 16-17 April 2020.

## <a name="rdo"></a>RDO Changes
## <a name="community"></a>Community News
### Community Meetings
Every Tuesday at 13:30 UTC, we have a weekly **TripleO CI community meeting** on [https://meet.google.com/bqx-xwht-wky](https://meet.google.com/bqx-xwht-wky) with the agenda on [https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw](https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw). The TripleO CI meeting focuses on a group of people focusing on Continuous Integration tooling and system who would like to provide a comprehensive testing framework that is easily reproducible for TripleO contributors. This framework should also be consumable by other CI systems (OPNFV, RDO, vendor CI, etc.), so that TripleO can be tested the same way everywhere. This is NOT a place for TripleO usage questions, rather, check out the next meeting listed just below.

Every Tuesday at 14:00 UTC, immediately following the TripleO CI meeting is the weekly **TripleO Community meeting** on the #TripleO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/tripleo-meeting-items). This is for addressing anything to do with TripleO, including usage, feature requests, and bug reports.

Every Wednesday at 14:00 UTC, we have a weekly **RDO community meeting** on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra things (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### TripleO CI Summary: Sprint 40
The TripleO CI team has just completed Sprint 40 / Unified Sprint 19 (Nov 21 thru Dec 18).  The following is a summary of completed work during this sprint cycle:

* Created a PoC for 3rd-party testing jobs for podman and ceph-ansible. The 3rd-party jobs are now running and being triggered from github pull requests.
* Closed-out work on the design enhancements to the promotion server. Tested the new promoter code and fixed issues related to manifests and quay.io.
* Working w/ quay support re: performance and api issues.
* Implemented [component pipeline](http://dashboard-ci.tripleo.org/d/UDA4H3aZk/component-pipeline?orgId=1) running daily and promoting separated from the integration jobs. Job that promotes the component still under testing and fixing bugs. Component jobs have been also created in downstream.
* Addressed issues and technical debt tasks in TripleO CI realm, including issues in the zuul reproducer.

Next sprint starts Jan 3rd. The planned work for [the next sprint](https://tree.taiga.io/project/tripleo-ci-board/taskboard/unified-sprint-20) are still going to be defined, and may include component pipeline work and build out CentOS8 promotion and check jobs upstream.

## <a name="#events"></a>Recent and Upcoming Events
### DevConf.CZ Brno Czech Republic 24-26 January 2020
[DevConf.CZ](devconf.info/cz/) 2020 is the 12th annual, free, Red Hat sponsored community conference for developers, admins, DevOps engineers, testers, documentation writers and other contributors to open source technologies. The conference includes topics on Linux, Middleware, Virtualization, Storage, Cloud and mobile. At DevConf.CZ, FLOSS communities sync, share, and hack on upstream projects together in the beautiful city of Brno, Czech Republic.

### FOSDEM Brussels Belgium 01-02 February 2020
[FOSDEM](https://fosdem.org/2020/) is a free event for software developers to meet, share ideas and collaborate. Every year, thousands of developers of free and open source software from all over the world gather at the event in Brussels. No registration necessary.

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring out a good topic or finalizing your abstract? Feel free to reach out in the #RDO channel on IRC.

* **DecompileD Conference Dresden Germany 27 March 2020** is a conference for [like-minded engineers](https://www.decompiled.de/)! We cover new technologies, industry trends, and best practices in the areas of Mobile, Cloud, Big Data. Learn new technologies and improve your skills in joint workshops. Grow your network and discuss your solutions during the lunch and coffee breaks, and at the after-show party. [CFP closes 31 January 2020 00:00 UTC](https://www.papercall.io/decompiled20)

* **Serverless Days Boston Massachusetts USA 06 April 2020** is a developer-oriented conference about serverless technologies. We believe in and encourage practical sessions, in which developers share their experience and lessons from real-world projects. [ServerlessDays Boston](https://boston.serverlessdays.io/) is part of ServerlessDays (formerly JeffConf), a global series of events around the world fostering communities around serverless technologies. [CFP closes 15 February 2020 04:00 UTC](https://www.papercall.io/serverlessboston2020)

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
