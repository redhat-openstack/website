# November 2019 RDO Community Newsletter

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
* [Train Release Schedule](https://releases.openstack.org/train/schedule.html)
* [Ussuri Release Schedule](https://releases.openstack.org/ussuri/schedule.html)
---
Do you hear that whistle? ALL ABOARD!! This month we're celebrating the release of the latest OpenStack RDO release cycle, Train, diving head first into the next release cycle, Ussuri, and zooming off to Shanghai in the process.

## <a name="housekeeping"></a>Housekeeping Items
### Volunteers Needed for the RDO Pod at Open Infrastructure Summit Shanghai
We are gearing up for [Open Infrastructure Summit Shanghai](https://www.openstack.org/summit/shanghai-2019) where we'll have our regular presence within the Red Hat booth. Our booth presence is substantially smaller at this event, so we will NOT be doing any community demos, BUT! 

We're looking for people to spend their precious free time [answering questions](https://etherpad.openstack.org/p/shanghai-summit-community-pod) at the RDO booth. If you're attending, please consider spending one or more of your free moments with us. 

Questions run the gamut from "What's RDO?" to "I found a bug in Neutron and need help troubleshooting it." Of course, you're not expected to know everything and you can always keep IRC open to access the RDO Community for help! Plus, you get cool stuff! If you show up for three or more shifts, we're going to hook you up with an RDO hoodie.

Reach out to Rain Leander on IRC (leanderthal) or email (rain@redhat.com) for more information.

## <a name="rdo"></a>RDO Changes
### All Aboard The RDO OpenStack Train!
The RDO community is pleased to announce the general availability of the RDO build for OpenStack Train for RPM-based distributions, CentOS Linux and Red Hat Enterprise Linux. RDO is suitable for building private, public, and hybrid clouds. Train is the 20th release from the OpenStack project, which is the work of more than [1115 contributors](https://www.stackalytics.com/?metric=commits) from around the world.

The release is already available on the CentOS mirror network at [http://mirror.centos.org/centos/7/cloud/x86_64/openstack-train/](http://mirror.centos.org/centos/7/cloud/x86_64/openstack-train/). While we normally also have the release available via [http://mirror.centos.org/altarch/7/cloud/ppc64le/](http://mirror.centos.org/altarch/7/cloud/ppc64le/) and [http://mirror.centos.org/altarch/7/cloud/aarch64/](http://mirror.centos.org/altarch/7/cloud/aarch64/) - there have been issues with the mirror network which is currently being addressed via [https://bugs.centos.org/view.php?id=16590](https://bugs.centos.org/view.php?id=16590). 

The RDO community project curates, packages, builds, tests and maintains a complete OpenStack component set for RHEL and CentOS Linux and is a member of the CentOS Cloud Infrastructure SIG. The Cloud Infrastructure SIG focuses on delivering a great user experience for CentOS Linux users looking to build and maintain their own on-premise, public or hybrid clouds.

All work on RDO and on the downstream release, Red Hat OpenStack Platform, is 100% open source, with all code changes going upstream first.

PLEASE NOTE: At this time, RDO Train provides packages for CentOS7 only. We plan to move RDO to use CentOS8 as soon as possible during Ussuri development cycle so Train will be the last release working on CentOS7.

### Now Availalbe On The Lists: Weekly Reports
Get the latest promotion, dependency, package, and other RDO updates straight from Red Hat engineering sent to both users@ and dev@ mailing lists. These are some fairly technical updates, but I’m sure if you asked for clarification directly on the list, via IRC or on ask.openstack.org, we’re happy to help. 

For example, one of the latest emails sent 28 October 2019 included:

Promotions
* Latest promotions (TripleO CI) for Stein from 23rd October, Train from 23rd October and Master from 22nd October.
* Jobs (both weirdo and tripleo os_tempest jobs) are facing issues due to issues with [download.cirros-cloud.net](http://download.cirros-cloud.net), it’s too slow to respond. Weirdo ones are worked to cache the image to avoid issues with download and fallback to download via https (which seems much more reliable).
* Master and Stein are facing intermittent issues due to performance and deployment getting timed out, currently being worked upon to improve it.
* [https://bugs.launchpad.net/tripleo/+bug/1844446](https://bugs.launchpad.net/tripleo/+bug/1844446)

Deps Update
* Work in progress to update OVN and OpenVswitch to 2.12 in master and Train
* Podman is being updated to 1.6.1 and buildah to 1.11.3 in master

Packages
* Unnecessary BuildRequires python-d2to1 is removed from all projects in master and Train:-
* [https://review.rdoproject.org/r/#/q/topic:remove-d2to1](https://review.rdoproject.org/r/#/q/topic:remove-d2to1)
* According to TripleO Upgrades team, tripleo-heat-templates-compat is not longer required for upgrades. Package removal will be proposed in master and train.

Other
* Train is released upstream last week on 16th October.
* [http://lists.openstack.org/pipermail/openstack-announce/2019-October/002024.html](http://lists.openstack.org/pipermail/openstack-announce/2019-October/002024.html)
* RDO Train release builds (x86_64) are ready including TripleO and Kolla RC packages and published in official CentOS repos.
* Altarch Train builds are still missing, reported issue [https://bugs.centos.org/view.php?id=16590](https://bugs.centos.org/view.php?id=16590)

We won’t be publishing those updates here in the newsletter every month - as you can imagine with a weekly update, it gets quite verbose after a full month - but if you’re keen to see them, be sure to subscribe to either [the dev or users lists](https://lists.rdoproject.org/mailman/listinfo).

## <a name="community"></a>Community News
### Community Meetings
Every Tuesday at 13:30 UTC, we have a weekly **TripleO CI community meeting** on [https://bluejeans.com/4113567798](https://bluejeans.com/4113567798) with the agenda on [https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw](https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw). The TripleO CI meeting focuses on a group of people focusing on Continuous Integration tooling and system who would like to provide a comprehensive testing framework that is easily reproducible for TripleO contributors. This framework should also be consumable by other CI systems (OPNFV, RDO, vendor CI, etc.), so that TripleO can be tested the same way everywhere. This is NOT a place for TripleO usage questions, rather, check out the next meeting listed just below.

Every Tuesday at 14:00 UTC, immediately following the TripleO CI meeting is the weekly **TripleO Community meeting** on the #TripleO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/tripleo-meeting-items). This is for addressing anything to do with TripleO, including usage, feature requests, and bug reports.

Every Wednesday at 15:00 UTC, we have a weekly **RDO Community meeting** on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra thingies (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### Explore the Ussuri River
[OpenStack Train](https://www.openstack.org/software/train) is [released](https://releases.openstack.org/train/index.html), but OpenStack development continues! Project teams are already planning work for the [Ussuri cycle](https://releases.openstack.org/ussuri/schedule.html), which should result in a final release on May 13, 2020. Some of that planning will happen at the [Project Teams Gathering in Shanghai](https://www.openstack.org/ptg).

### Python 2.7 Sails Away Soon
Remember that OpenStack Train is the last release tested on Python 2.7, and future releases will require newer Python 3 interpreters. Refer to [OpenStack's list of Tested Runtimes](https://governance.openstack.org/tc/reference/project-testing-interface.html#tested-runtimes) to find out more.

### OpenStack Governance Updates
If you’re interested in what happened in OpenStack governance recently, please read the [summary that Rico Lin posted to the openstack-discuss mailing-list](http://lists.openstack.org/pipermail/openstack-discuss/2019-October/010113.html).

### Become a Certified OpenStack Administrator
Interested in becoming a Certified OpenStack Administrator? The OpenStack Foundation is collaborating with Mirantis who has stepped up to donate resources, including the administration of the vendor-neutral OpenStack certification exam now running on OpenStack Rocky. [Register to take the COA today!](https://www.openstack.org/coa)

## <a name="events"></a>Recent and Upcoming Events
### Open Infrastructure Summit Shanghai
There’s a lot happening in and around Open Infrastructure Summit Shanghai! Here are a few highlights:
* **Let’s Celebrate** At Open Infrastructure Summit we’ll once again gather together to celebrate OpenStack with the Ansible community. Please register and join us at [Ansible + RDO Celebration of OpenStack](https://www.eventbrite.com/e/ansible-rdo-celebration-of-openstack-tickets-79188000441) on Wednesday night!
* **RDO-Specific Talks** We’re gathering a list of RDO-specific talks that will be happening at OpenInfrastructure Summit Shanghai. If you haven’t already, please [add yours to the list](https://etherpad.openstack.org/p/OISummitShanghai-RDOtalks). We’ll be promoting these talks via social media prior to as well as during the conference.
* **Looking for Volunteers** As mentioned [above](#housekeeping), we’re looking for volunteers to spend time answering questions at the RDO booth. Please consider [signing up for a shift](https://etherpad.openstack.org/p/shanghai-summit-community-pod).

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring out a good topic or finalizing your abstract? Feel free to reach out in the #RDO channel on IRC.

* **Open Source Festival Lagos Nigeria 20-22 February 2020** [Open Source Community Africa](https://festival.oscafrica.org/) is a community aimed at creating and supporting the open source movement within Africa. As a community, we intend to help integrate the act of open source contribution in African developers while strongly advocating the movement of free and open source software. OSCA is proud to announce a 3-day festival tagged Open Source Festival to be held in Lagos, Nigeria. [CFP closes 02 December 2019 11:41 UTC](https://www.papercall.io/osf)

* **DevOpsDays Prague 2020 Prague Czech Republic 18 March 2020** [DevOpsDays Prague 2020](https://devopsdays.org/events/2020-prague/welcome/) will be the first occurence of this volunteer-driven worldwide series in the Czech Republic. It will take place on March 18-19 (with possible extension to 17th for workshops) at City Conference Center. We are excited to bring this technical conference covering topics of Cloud Native, Containers and Microservices, Lean and DevOps approach to the heart of Europe. [CFP closes 31 December 2019 00:12 UTC](https://www.papercall.io/dev-ops-days-prague)

* **Codemotion Amsterdam Tech Conference Amsterdam Netherlands 27-28 May 2020** [Codemotion Amsterdam Tech Conference](https://www.eventbrite.co.uk/e/codemotion-amsterdam-2020-tech-conference-tickets-59101946513) is looking forward to paper proposals related to the following topics: Software Architectures Serverless Game Dev DevOps Mobile Languages Cloud Cybersecurity Blockchain IoT AI/Machine Learning Inspirational Diversity in Tech Front-End Dev Design/UX Voice & Digital Assistants IT Careers. Submissions that do not fit into these categories are also welcome, provided that they are relevant or inspirational for the tech community. [CFP closes 15 November 2019 00:10 UTC](https://www.papercall.io/codemotion-amsterdam-2020)

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
