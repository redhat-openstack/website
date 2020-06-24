# March 2020 RDO Community Newsletter

[← Newsletters](/newsletter)
## Quick links:


### In This Newsletter
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

## <a name="community"></a>Community News
### Community Meetings
Every Tuesday at 13:30 UTC, we have a weekly **TripleO CI community meeting** on [https://meet.google.com/bqx-xwht-wky](https://meet.google.com/bqx-xwht-wky) with the agenda on [https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw](https://hackmd.io/IhMCTNMBSF6xtqiEd9Z0Kw). The TripleO CI meeting focuses on a group of people focusing on Continuous Integration tooling and system who would like to provide a comprehensive testing framework that is easily reproducible for TripleO contributors. This framework should also be consumable by other CI systems (OPNFV, RDO, vendor CI, etc.), so that TripleO can be tested the same way everywhere. This is NOT a place for TripleO usage questions, rather, check out the next meeting listed just below.

Every Tuesday at 14:00 UTC, immediately following the TripleO CI meeting is the weekly **TripleO Community meeting** on the #TripleO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/tripleo-meeting-items). This is for addressing anything to do with TripleO, including usage, feature requests, and bug reports.

Every Wednesday at 14:00 UTC, we have a weekly **RDO community meeting** on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

Every Thursday at 15:00 UTC, there is a weekly **CentOS Cloud SIG meeting** on the #centos-devel channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/centos-cloud-sig) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/contribute/cloud-sig-meeting/). This meeting makes sense for people that are involved in packaging OpenStack for CentOS and for people that are packaging OTHER cloud infra things (OpenNebula, CloudStack, Euca, etc) for CentOS. “Alone we can do so little; together we can do so much.” - Helen Keller

## <a name="openstack"></a>OpenStack News
### Spotlight On Certified OpenStack Administrator (COA)
The updated [OpenStack Certified OpenStack Administrator (COA)](https://www.openstack.org/coa/) exam became available in October 2019, and we have seen a resurgence in interest by both the global community and our training partners. Thousands of Stackers have demonstrated their skills and proven their expertise, helping organizations identify top talent in the industry. The COA exam remains a critical and respected certification for anyone working on OpenStack.

### Possible Data Loss Situation Within Cinder
Brian Rosmaita [reported an issue](http://lists.openstack.org/pipermail/openstack-discuss/2020-February/012641.html) that, in rare conditions, may cause data loss in Cinder volumes for the OpenStack Train release. Train deployments are advised to deploy the described workaround to avoid any issue.

### We’re Over Halfway Down The River
The project teams have just passed the [ussuri-2 milestone](https://releases.openstack.org/ussuri/schedule.html), in preparation for a final Ussuri release on May 13. Please read this [release countdown email](http://lists.openstack.org/pipermail/openstack-discuss/2020-February/012576.html) from Sean McGinnis for information on upcoming release cycle deadlines!

### Victoria Common Community Goals
Every cycle, our community sets [common goals](https://governance.openstack.org/tc/goals/index.html) for the next OpenStack release. Ghanshyam Mann just [started the process](http://lists.openstack.org/pipermail/openstack-discuss/2020-February/012396.html) for the Victoria development cycle, which will start after Ussuri is released in May. We are interested in goals that have user-visible impact and make OpenStack easier to operate. If you are interested in proposing a goal, please write down your idea on the [Victoria goals etherpad](https://etherpad.openstack.org/p/YVR-v-series-goals)!

### OpenStack Wants YOU!
Interested in investing in OpenStack development, but don't know where to maximize impact and returns? The [OpenStack Technical Committee](https://governance.openstack.org/tc/) just refreshed its [Investment opportunities list for 2020](https://governance.openstack.org/tc/reference/upstream-investment-opportunities/2020/index.html). Please have a look and don't hesitate to reach out!

## <a name="#events"></a>Recent and Upcoming Events
### OpenStack Track at OpenShift Commons
The OpenShift Commons Gathering will be co-located in San Francisco with [Red Hat Summit](https://www.redhat.com/en/summit) at the [Moscone Convention and Exhibition Center](http://www.moscone.com/site/do/index)!

The [OpenShift Commons Gathering](https://commons.openshift.org/gatherings/Red_Hat_Summit_2020.html) brings together experts from all over the world to discuss container technologies, best practices for cloud native application developers and the open source software projects that underpin the OpenShift ecosystem. This event will gather developers, devops professionals and sysadmins together to explore the next steps in making container technologies successful and secure. We’re particularly excited to have an entire afternoon track dedicated to OpenStack during this event!

Please note: **Pre-registration is required AND You must have a pass for Red Hat Summit to attend this event.** To register, add the OpenShift Commons Gathering as a co-located event during your Red Hat Summit registration. By being co-located in San Francisco with Red Hat Summit at the Moscone Convention and Exhibition Center, the OpenShift Commons Gathering will provide a platform for showcasing a full range of technologies that support the OpenShift ecosystem and help bring cloud native project communities together. We strongly encourage you to partake in the full week of events.

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring out a good topic or finalizing your abstract? Feel free to reach out in the #RDO channel on IRC.

* **Comcast Open Source Day Philadelphia Pennsylvania USA 12 May 2020** is a conference for Comcast technologists, open source contributors and open source consumers to collaborate, and learn about the latest in open source in the outside world and at Comcast. Our objective is to kickoff the sharing of best practices from both internal speakers at Comcast as well as external guest speakers, and we’d love to see where we need to go next in terms of building our OSS competency, practices and strategy as a company. [CFP closes 16 March 2020 12:03 UTC](https://www.papercall.io/osday)

* **ServerlessDays Ahmedabad India 20 June 2020** Serverless is a buzz word around cloud developers and at the same time, it [brings many different ways architecture can be utilized and implemented](https://ahmedabad.serverlessdays.io/). With this in mind, we are looking for diverse speakers with years of experience and mainly who have worked and implemented real-world problems using serverless platforms. [CFP closes 05 April 2020 20:44 UTC](https://www.papercall.io/serverlessamd)

* **DevOpsDays Chicago Illinois USA 01-02 September 2020** From fledgling startups to established industry, the Midwest is home to a large, vibrant technology community. Chicago, in particular, has been a flurry of activity in the past several years, drawing attention from around the globe. [DevOpsDays Chicago](https://devopsdays.org/events/2020-chicago/welcome/) brings development, operations, QA, InfoSec, management, and leadership together to discuss the culture and tools to make better organizations and products. The 2020 event will be the seventh time we have held DevOpsDays Chicago, and it should be bigger and better than ever before! [CFP closes 02 May 2020 05:00 UTC](https://www.papercall.io/devopsdays-chicago-2020)

* **Open UP Global Summit Taipei Taiwan 12-13 September 2020** s a tech conference organized by Star Rocket Foundation and WeTogether.co, focusing on open source projects/products and experts as well as bringing tech communities together. We believe that “It’s Better When It’s Shared.” We organized featured activities and networking events to discover potential technology teams/talents during the conference, aiming to provide a unique conference experience by integrating global resources and developing open source products with guided and enjoyable processes! [Open UP Global Summit](https://www.openup.global/) is the first interdisciplinary conference focused on open source projects and products in Asia. This year we welcome all types of projects related to the main theme, A Better Life with Open Source, and we aim to draw more discussion about how open source is being implemented in our daily life. No matter what industry or domain your projects/products belong, we would love to learn more about them. [CFP closes 
01 July 2020 11:42 UTC](https://www.papercall.io/open-up-summit-2020)

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
