# April 2018 RDO Community Newsletter

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
* [Rocky release schedule](https://releases.openstack.org/rocky/schedule.html)

---

Welcome to another month of the RDO Newsletter! I'm super excited that we've started work on an all in one installation for TripleO - if you've got use cases, thoughts, comments, or snarky feedback, we want to hear it, of course. And, as always, we absolutely can't wait to see YOU in Vancouver at OpenStack Summit NEXT MONTH! 

## <a name="housekeeping"></a>Housekeeping Items
### Volunteers Needed for the RDO Booth at OpenStack Summit Vancouver
We are gearing up for OpenStack Summit Vancouver where we'll have our regular presence within the Red Hat booth. This spring we'll continue the ManageIQ / RDO demo we started last year and we'd love to see your demos, too! If you've got something you'd like to demo via video OR LIVE because you're not afraid of ANYTHING, [sign up](https://etherpad.openstack.org/p/rdo-vancouver-summit-booth).

We're also looking for people to spend their precious free time [answering questions](https://etherpad.openstack.org/p/rdo-vancouver-summit-booth) at the RDO booth. If you're attending, please consider spending one or more of your free moments with us. Questions run the gamut from "What's RDO?" to "I found a bug in Neutron and need help troubleshooting it." Of course, you're not expected to know everything and you can always keep IRC open to access the RDO Community for help! Plus, you get cool stuff! If you sign up for three or more shifts, we're going to hook you up with an RDO hoodie.

Reach out to Rain Leander on IRC (leanderthal) or email (rain@redhat.com) for more information.

## <a name="rdo"></a>RDO Changes
### How to Package External Dependencies in RDO
Emilien Macchi brought an interesting discussion to the table regarding how to handle the increasing number of dependencies outside of OpenStack, including Ceph, MariaDB, Ansible, OVS, and more.

Follow along on the mailing list for more information:
[https://mail.rdoproject.org/thread.html/948c7436e8877d59286f972f2f0df3712376bc5a795807a8d6dd9a71@%3Cdev.lists.rdoproject.org%3E](https://mail.rdoproject.org/thread.html/948c7436e8877d59286f972f2f0df3712376bc5a795807a8d6dd9a71@%3Cdev.lists.rdoproject.org%3E)

### Building Power Containers for TripleO
Michael Turek has proposed building containers for TripleO. The goal is to have the first step of the TripleO job pipeline that builds the containers and uploads them to Docker hub set up for ppc64le. The first step is to identify the hardware that would make this possible. If you have any insight into these issues or would like to help, chime in on the mailing list:
[https://mail.rdoproject.org/thread.html/eb924d6d5ec84e81f92add066eb5662a36046c902824254bf4018d8c@%3Cdev.lists.rdoproject.org%3E](https://mail.rdoproject.org/thread.html/eb924d6d5ec84e81f92add066eb5662a36046c902824254bf4018d8c@%3Cdev.lists.rdoproject.org%3E)

### Simplifying Namespaces
Historically we’ve used different namespaces for releases in docker.io and trunk.rdoproject.org registries, for example, 
* trunk.registry.rdoproject.org/pike/centos-binary-nova-api:fc8ded09c37a2e258dac7f2103b5b9406be5502e_758ddb1e
* docker.io/tripleopike/centos-binary-aodh-api:fc8ded09c37a2e258dac7f2103b5b9406be5502e_758ddb1e

In rdoproject the namespace is "pike", but in docker.io is "tripleopike". This creates a mess in our configuration files when setting release for upgrades job. 

Sagi Shnaidman recommended that going forward we use the same namespace - tripleo(release) - in order to simplify configuration and reduce confusion.


## <a name="community"></a>Community News
### Tentative Test Dates Listed
The tentative test day schedule has been [posted](https://www.rdoproject.org/testday) - please mention serious conflicts to Rain <rain@redhat.com> so we can fix them before the schedule goes live.

* M1 test day - April 26th, 27th
* M2 test day - June 14th, 15th
* M3 test day - August 2nd, 3rd
* Rocky release test day - September 6th, 7th

### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

## <a name="openstack"></a>OpenStack News
### All-in-One Installer Discussion
During PTG Dublin, the idea of an All-In-One installer was discussed. The core idea, as described in the [OpenStack-Dev mailing thread](http://lists.openstack.org/pipermail/openstack-dev/2018-March/128900.html) by Emilien Macchi, is to use 100% of the TripleO bits to deploy a single node OpenStack very similar with what we have today with the containerized undercloud and what we also have with other tools like Packstack or Devstack. One of the problems that we're trying to solve here is to give a simple tool for developers so they can both easily and quickly deploy an OpenStack for their needs.

Interested in more information? Check out the following places:
* Mailing List: [http://lists.openstack.org/pipermail/openstack-dev/2018-March/128900.html](http://lists.openstack.org/pipermail/openstack-dev/2018-March/128900.html)
* Etherpad: [https://etherpad.openstack.org/p/tripleo-rocky-all-in-one](https://etherpad.openstack.org/p/tripleo-rocky-all-in-one)
* Doc patch: [https://review.openstack.org/#/c/547038/](https://review.openstack.org/#/c/547038/)
* Proposed blueprint: [https://blueprints.launchpad.net/tripleo/+spec/all-in-one](https://blueprints.launchpad.net/tripleo/+spec/all-in-one)

### Thank You, TryStack!
The decision was recently made to end the TryStack services as of March 29, 2018. As Jimmy Mcarthur said in a [recent email](http://lists.openstack.org/pipermail/openstack-dev/2018-March/128757.html), thank you to those of you who were part of the TryStack community! 

If you’re looking for new resources with which to try OpenStack, you can find them at [openstack.org/start][http://www.openstack.org/start], including the [Passport Program](https://www.openstack.org/passport), where you can test on any participating public cloud. If you’re looking to test different tools or application stacks with OpenStack clouds, you should check out [Open Lab](https://openlabtesting.org).

The Facebook group will be officially retired this month and folks can move either into the [OpenStack Facebook group](https://www.facebook.com/groups/637144716425889/) or onto [ask.openstack.org](http://ask.openstack.org).


## <a name="events"></a>Recent and Upcoming Events
### FOSSAsia Recap
At the recent [FOSSAsia Summit](https://2018.fossasia.org/) in Singapore, RDO was well represented with presentations from Chandan Kumar, and Janki Chhatbar, covering the basics of RDO, and a deep dive into packaging OpenStack for CentOS.

You can watch Chandan’s presentation about RDO on the [FOSSAsia YouTube channel](https://youtu.be/HPzkf_qHuSo).

Chandan and Janki’s joint presentation, as part of the CentOS Dojo on Sunday, will be coming to the [CentOS YouTube channel](https://www.youtube.com/user/TheCentOSProject) soon.

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring out a good topic? Feel free to reach out in the #RDO channel on IRC.

* [OpenStack Day Sao Paulo (Brazil)](http://openstackbr.com.br/events/2018/) - July 27-28
CFP closes May 5
Topics: Container Infrastructure, Edge Computing, the Open Source Community +more
[https://goo.gl/V8zSCA](https://goo.gl/V8zSCA).

* [DevConf India](https://devconf.info/in) - Aug 4-5
CFP closes May 4
Topics: containerization, TripleO, Kubernetes, storage, app development on Linux +more
[https://devconf.info/in/cfp](https://devconf.info/in/cfp)

### OpenStack Summit Vancouver
There’s a lot happening in and around OpenStack Summit Vancouver! Here are a few highlights:

* An Evening of Ceph and RDO - Get-Together at OpenStack Summit Vancouver
If you’re attending OpenStack Summit Vancouver, you won’t want to miss celebrating the recent releases of Mimic (Ceph) and Queens (RDO). Join us from 6-8pm on Wednesday night at The Portside Pub for free food & drinks and to get to know your fellow community members. For more information and to get a (FREE!) ticket, see: [https://www.eventbrite.com/e/an-evening-of-ceph-and-rdo-tickets-43215726401](https://www.eventbrite.com/e/an-evening-of-ceph-and-rdo-tickets-43215726401)
* RDO-Specific talks
We’re gathering a list of RDO-specific talks that will be happening at OpenStack Summit Vancouver. If you haven’t already, please [add yours to the list](https://etherpad.openstack.org/p/OSSummit-RDOtalks). We’ll be promoting these talks via social media prior to as well as during the conference.
* Looking for Volunteers
As mentioned <a name=”housekeeping”>above</a>, we’re looking for volunteers to spend time answering questions at the RDO booth. Please consider [signing up for a shift](https://etherpad.openstack.org/p/rdo-vancouver-summit-booth).

### Interviews are Live from PTG Dublin
Rich Bowen conducted 18 interviews at the recent PTG in Dublin. From Zuul to TripleO to various SIGs and a look at the coming year from Thierry Carrez, there’s a lot of great content in this playlist:
[https://youtu.be/zmwYAZLsJ84](youtu.be/zmwYAZLsJ84). Did you miss your chance to get interviewed and want to record a video? Ping rbowen on IRC or shoot him an email: <rbowen@redhat.com>.

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
