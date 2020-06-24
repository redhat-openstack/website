# December 2019 RDO Community Newsletter

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
We're solidly setting sail on the Ussuri river for the next six months - soon we'll arrive at our first port of call, the RDO Test Day of Milestone ONE! In the meantime, we're trying to avoid troubled waters as we shift the RDO Community meeting time EARLIER by one whole hour. And initial navigation has been mapped via last month's Project Teams Gathering - if you didn't get a chance to attend, the reports are arriving on the openstack-discuss list.

## <a name="housekeeping"></a>Housekeeping Items
### Want to Help Us Prep for RDO Ussuri Test Day Milestone ONE?
We are conducting an [RDO test day on 19 and 20 December 2019](http://rdoproject.org/testday/ussuri/milestone1/).

This will be coordinated through the **#rdo channel on Freenode**, via [http://rdoproject.org/testday/ussuri/milestone1/](http://rdoproject.org/testday/ussuri/milestone1/) and the [dev@lists.rdoproject.org](https://lists.rdoproject.org/mailman/listinfo/dev) mailing list.

We'll be testing the first [Ussuri milestone release](https://releases.openstack.org/ussuri/schedule.html). If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

If you’re keen to help set up, mentor, or debrief, please reach out to leanderthal on Freenode IRC #rdo and #tripleo.

## <a name="rdo"></a>RDO Changes
### RDO Community Meeting Shifts Times
After two weeks of discussion on the mailing list and within the weekly meeting, RDO Community has shifted their [weekly irc meeting time](https://etherpad.openstack.org/p/RDO-Meeting) to one hour **EARLIER** making it begins at 1400 UTC/ 1500 CET / 1000 EDT / 0730 IST as of Wednesday 05th December 2019. Many thanks to everyone who collaborated to make this change!

## <a name="community"></a>Community News
### Community Meetings
Every Tuesday at 13:30 UTC, we have a weekly **TripleO CI community meeting** on [https://meet.google.com/bqx-xwht-wky](https://meet.google.com/bqx-xwht-wky) with the agenda on [https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw](https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw). The TripleO CI meeting focuses on a group of people focusing on Continuous Integration tooling and system who would like to provide a comprehensive testing framework that is easily reproducible for TripleO contributors. This framework should also be consumable by other CI systems (OPNFV, RDO, vendor CI, etc.), so that TripleO can be tested the same way everywhere. This is NOT a place for TripleO usage questions, rather, check out the next meeting listed just below.

Every Tuesday at 14:00 UTC, immediately following the TripleO CI meeting is the weekly **TripleO Community meeting** on the #TripleO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/tripleo-meeting-items). This is for addressing anything to do with TripleO, including usage, feature requests, and bug reports.

Every Wednesday at 14:00 UTC, we have a weekly **RDO community meeting** on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra things (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### Project Teams Gathering Reports Are Here
Several OpenStack project teams, SIGs and working groups met during the [Project Teams Gathering](https://www.openstack.org/ptg) in Shanghai to prepare the [Ussuri development cycle](https://releases.openstack.org/ussuri/schedule.html). Reports are starting to be posted to the [openstack-discuss mailing-list](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/thread.html). Here are the ones that are posted so far:

* [TripleO PTG Summary](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010726.html)
* [Glance PTG Summary](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010752.html)
* [Neutron PTG Summary](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010702.html)
* [Oslo PTG Summary on openstack-discuss mailing list](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010858.html) and [bnemec’s blog post “Oslo in Shanghai”](http://blog.nemebean.com/content/oslo-shanghai)
* [Octavia PTG Summary](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010682.html)
* [Ironic PTG Summary](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010789.html)
* [Keystone PTG Summary](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010741.html) and Colleen’s [Shanghai Open Infrastructure Forum and PTG](http://www.gazlene.net/shanghai-forum-ptg.html)

### Neutron Needs YOU!
Sławek Kapłoński, the Neutron PTL, recently reported that [neutron-fwaas](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010929.html), [neutron-vpnaas](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010931.html), [neutron-bagpipe and neutron-bgpvpn](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010930.html) are lacking interested maintainers. The Neutron team will drop those modules from future official OpenStack releases if nothing changes by the ussuri-2 milestone, February 14. If you are using those features and would like to step up to help, now is your chance!

### What’s In A Name
We are looking for a name for the ‘V’ release of OpenStack, to follow the Ussuri release. Learn more about it in this [post by Sean McGinnis](http://lists.openstack.org/pipermail/openstack-discuss/2019-November/010880.html).

### Fancy a Cup of Tea?
Why, yes, please - with plenty of milk and two sugars. The next [OpenStack Ops meetup is in London, UK on 7-8 January](https://go.bloomberg.com/attend/invite/openstack-operators-meetup-london2020/).

## <a name="#events"></a>Recent and Upcoming Events
### Open Infrastructure Summit Shanghai
Attendees from over 45 countries attended the [Open Infrastructure Summit](https://www.openstack.org/summit/shanghai-2019) earlier last month that was hosted in Shanghai, followed by the [Project Teams Gathering (PTG)](https://www.openstack.org/ptg/). Use cases, tutorials, and demos covering 40+ open source projects including Airship, Ceph, Hadoop, Kata Containers, Kubernetes, OpenStack, StarlingX, and Zuul were featured at the Summit.

Summit keynote videos are already available, and breakout videos will be available on the [Open Infrastructure videos](https://www.openstack.org/videos) page in the upcoming weeks.

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring out a good topic or finalizing your abstract? Feel free to reach out in the #RDO channel on IRC.

* **Oπe\n conf Athens Greece 20-21 March 2020** is an annual technical conference organized by Greek SW development and IT ecosystem together with Nokia Hellas. Its vision is to [interconnect and foster the tech ecosystem in Greece](http://www.open-conf.gr/) -in the Software Engineering and IT sector-, so that it helps it gain a prominent position evolving to a big draw for other companies in the area, while contributing to the reduction of brain drain. [CFP closes 25 November 2019 12:00 UTC](https://www.papercall.io/open-2020)

* **Indy Cloud Conf Indianapolis Indiana USA 26-27 March 2020** focuses on cloud solutions for DevOps, Machine Learning and IoT. There will be 3 tracks of talks: DevOps, Machine Learning / AI / Big Data, and Hardware / IOT. Join us for this focused day of [cloud architecture, meet fellow techies, & advance your knowledge](https://2020.indycloudconf.com/) on cloud computing. [CFP closes December 21, 2019 05:00 UTC](https://www.papercall.io/indycloudconf2020)

* **DevOpsDays Prague 18-19 March 2020** will be the first occurence of this volunteer-driven worldwide series in the Czech Republic. It will take place on March 18-19 (with possible extension to 17th for workshops) at City Conference Center. We are excited to bring [this technical conference](https://devopsdays.org/events/2020-prague/) covering topics of Cloud Native, Containers and Microservices, Lean and DevOps approach to the heart of Europe. [CFP closes 31 December 2019 00:12 UTC](https://www.papercall.io/dev-ops-days-prague)

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
