# May 2018 RDO Community Newsletter

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
Can you believe it's MAY ALREADY?!? We've had our first round of RDO Rocky M1
Test Days, prepped for OpenStack Days Vancouver, and taken our first steps in
getting Power TripleO Containers. I can't wait to see what we do NEXT! 

## <a name="housekeeping"></a>Housekeeping Items
### DEMOS Needed for the RDO Booth at OpenStack Summit Vancouver
We are gearing up for OpenStack Summit Vancouver where we'll have our regular presence within the Red Hat booth. This spring we'll continue the ManageIQ / RDO demo we started last year (NOW WITH MORE CEPH!) and we'd love to see your demos, too! If you've got something you'd like to demo via video OR LIVE because you're not afraid of ANYTHING, [sign up](https://etherpad.openstack.org/p/rdo-vancouver-summit-booth).

And, of course, you ALSO get cool stuff! If you DEMO or otherwise hang out with us for three or more shifts, we're going to hook you up with an RDO hoodie. Reach out to Rain Leander on IRC (leanderthal) or email (rain@redhat.com) for more information.

## <a name="rdo"></a>RDO Changes
### We Want YOU! To Go To OpenStack Days
There are EIGHT [OpenStack Days](https://www.openstack.org/community/events/openstackdays) coming up around the world and we want to send you to represent RDO! If you’ve ever been interested in attending an OpenStack Days event, now is your opportunity. Send Rain Leander an email (rain@redhat.com) stating where you’re located, what your role is in relation to RDO, and why you’d like to attend a particular event and she’ll follow up with more information. Priorities go to people who get a talk accepted and are located nearest the event. Here are the upcoming OpenStack Days posted so far:

* OpenStack Days Budapest, 6 June, Budapest, Akvárium Klub - [http://openstackceeday.com/](http://openstackceeday.com/)
* 2018 OpenInfra Days China, 21-22 June, China National Convention Center Beijing - [http://china.openinfradays.org/En](http://china.openinfradays.org/En)
* Open Infra Days Korea, 28-29 June, COEX Hall E - [https://openinfradays.kr/](https://openinfradays.kr/)
* OpenStack Days São Paulo, 28 July - [http://openstackbr.com.br/events/2018/](http://openstackbr.com.br/events/2018/)
* OpenStack Days Tokyo, 2-3 Aug., Belle Salle Tokyo Nihonbashi, Tokyo - [http://openstackdays.com/en/](http://openstackdays.com/en/)
* VietOpenStack, 25 Aug. - [https://2018.vietopenstack.org/](https://2018.vietopenstack.org/)
* Benelux OpenStack Day, 14 Sept. - [http://www.openstack.nl/en/events/](http://www.openstack.nl/en/events/)
* OpenStack Days Nordic, 9-10 Oct., Münchenbryggeriet - [http://stockholm.openstacknordic.org/](http://stockholm.openstacknordic.org/)

### We Want YOU! To Do RDO Webinars
Interested in talking about a recent project you’re excited about? We’re looking for a handful of folks to record a 15 minute presentation which will later be aired for the RDO community. We’ll host a live Q&A while the recording plays. We’ll follow up after the event with a blogpost featuring the video recording as well as a transcript of the Q&A. More details coming soon, but let Rain Leander know if you’re interested via IRC (leanderthal) or email (rain@redhat.com).

### Building Power Containers for TripleO
Last month Michael Turek proposed building containers for TripleO. The goal is to have the first step of the TripleO job pipeline that builds the containers and uploads them to Docker hub set up for ppc64le. The first step is to identify the hardware that would make this possible. If you have any insight into these issues or would like to help, chime in on the mailing list: [https://mail.rdoproject.org/thread.html/eb924d6d5ec84e81f92add066eb5662a36046c902824254bf4018d8c@%3Cdev.lists.rdoproject.org%3E](https://mail.rdoproject.org/thread.html/eb924d6d5ec84e81f92add066eb5662a36046c902824254bf4018d8c@%3Cdev.lists.rdoproject.org%3E)

In the meantime, the first configuration for jobs patch is uploaded and ready for review at [https://review.rdoproject.org/r/#/c/13606/](https://review.rdoproject.org/r/#/c/13606/). This patch introduces configuration to add jobs for building tripleo containers for ppc64le. Sure, this is work in progress as the cloud provider used in this patch does not yet exist, but if you build it, they will come.

We’re super excited to see this project continue moving forward and can’t wait for the end results!

## <a name="community"></a>Community News
### RDO Rocky M1 Test Days Report!
On the 03rd and 04th May we had our first test days on Rocky with 40 participants, 1678 messages, one ticket opened [on bugzilla for packstack](https://bugzilla.redhat.com/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=POST&bug_status=MODIFIED&bug_status=ON_DEV&bug_status=ON_QA&bug_status=VERIFIED&bug_status=RELEASE_PENDING&chfield=%5BBug%20creation%5D&chfieldfrom=2018-05-03&chfieldto=2018-05-04&classification=Community&product=RDO&query_format=advanced) and one ticket opened [directly upstream with OpenStack for documentation](https://bugs.launchpad.net/openstack-manuals/+bug/1769186).

Exciting stuff!

Upcoming test days are:

* [M2 test day - June 14th, 15th](https://www.rdoproject.org/testday/rocky/milestone2/)
* [M3 test day - August 2nd, 3rd](https://www.rdoproject.org/testday/rocky/milestone3/)
* [Rocky release test day - September 6th, 7th](https://www.rdoproject.org/testday/rocky/final/)

Of course, you don't have to wait for a scheduled test day to test RDO. We would love to hear about your experiences, with either a [Packstack installation](https://www.rdoproject.org/install/packstack) or the [TripleO Quickstart](https://www.rdoproject.org/tripleo).

We also encourage you to work through the [upstream installation tutorial](https://docs.openstack.org/queens/install/) while keeping detailed notes on the following points:

* Did you know what the document assumed that you'd know?
* Did the steps work as described?
* What error conditions did you encounter? Could you work around them? If so,
* how?
* When you were done, did it work as expected? If not, what happened, and how
* did it differ from what you expected to happen?

### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

## <a name="openstack"></a>OpenStack News
### OpenStack PTG Announced!
[https://www.openstack.org/ptg/](https://www.openstack.org/ptg/)
September 10-14, 2018
Denver, Colorado

The Project Teams Gathering (PTG) is an event organized by the OpenStack Foundation. It provides meeting facilities allowing the various technical community groups working with OpenStack (user workgroups, development teams, operators, SIGs) to meet in-person, exchange and get work done in a productive setting. It lets those various groups discuss their priorities for the upcoming cycle, assign work items, iterate quickly on solutions for complex problems, and make fast progress on critical issues. The co-location of those various meetings, combined with the dynamic scheduling of the event, make it easy to get specific people in the same room to discuss a specific topic, or participate in multiple team meetings. Evenings allow for relationship building and problem sharing.

## <a name="events"></a>Recent and Upcoming Events
### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring
out a good topic? Feel free to reach out in the #RDO channel on IRC.

* [LISA18 October 29–31, 2018 Nashville, TN, USA](https://www.usenix.org/conference/lisa18) is the premier conference for operations professionals, where sysadmins, systems engineers, IT operations professionals, SRE practitioners, developers, IT managers, and academic researchers share real-world knowledge about designing, building, securing, and maintaining the critical systems of our interconnected world. [The CFP Closes **Thursday, May 24, 2018, 11:59 pm PDT**](https://www.usenix.org/conference/lisa18/call-for-participation).

* [OpenStack Days Nordic 09-10 October 2018 Stockholm Sweden](http://stockholm.openstacknordic.org/] is a two-day event with a mission to increase Awareness, Utilization, and Competence surrounding OpenStack, Containers, and related software/infrastructure. The event consists of presentations and educational opportunities over two days and the topics span everything from cloud strategy and business case development to operational best practices and technical deep dives. The event is a platform for collaboration and discussion between existing and potential community members. Here you will find the majority of OpenStack experts, potential partners, customers and vendors in the nordic region. Apart from getting to know one of the largest open source communities in the world, you get insights from the core of the OpenStack project, success stories, technical briefs, training sessions and future development plans by users of the platform. The [CFP closes on **June 17, 2018 21:50 UTC**](https://www.papercall.io/osdn2018-stockholm).

* [Open Source Summit Europe October 22-24, 2018 Edinburgh UK](https://events.linuxfoundation.org/events/open-source-summit-europe-2018/) is the leading conference for developers, architects and other technologists – as well as open source community and industry leaders – to collaborate, share information, learn about the latest technologies and gain a competitive advantage by using innovative open solutions. [The CFP closes **Sunday, July 1 2018**](https://events.linuxfoundation.org/events/open-source-summit-europe-2018/program/cfp/).

### OpenStack Summit Vancouver
There’s a lot happening in and around OpenStack Summit Vancouver! Here are a
few highlights:

* An Evening of Ceph and RDO - Get-Together at OpenStack Summit Vancouver
If you’re attending OpenStack Summit Vancouver, you won’t want to miss
celebrating the recent releases of Mimic (Ceph) and Queens (RDO). Join us from
6-8pm on Wednesday night at The Portside Pub for free food & drinks and to get
to know your fellow community members. For more information and to get a
(FREE!) ticket, see:
[https://www.eventbrite.com/e/an-evening-of-ceph-and-rdo-tickets-43215726401](https://www.eventbrite.com/e/an-evening-of-ceph-and-rdo-tickets-43215726401)
* RDO, ManageIQ, and Ceph combined booth presence
Starting at Red Hat Summit and continuing at OpenStack Summit Vancouver, RDO is sharing a booth with [ManageIQ](https://www.openstack.org/community/events/openstackdays) and [Ceph](https://ceph.com/) which is particularly exciting because last year RDO and ManageIQ were RIGHT NEXT TO one another so we started a hardware demo that could show each of our projects separately or merge to show them working together. Yes, that’s right, totally like VOLTRON. And now the demos have evolved to include Ceph! Be sure to drop by to see the fully formed (not a) robot and interact with it yourself.
* RDO-Specific Talks
We’re gathering a list of RDO-specific talks that will be happening at OpenStack Summit Vancouver. If you haven’t already, please [add yours to the list](https://etherpad.openstack.org/p/OSSummit-RDOtalks). We’ll be promoting these talks via social media prior to as well as during the conference.
* Looking for Volunteers
As mentioned <a name=”housekeeping”>above</a>, we’re looking for volunteers give demonstrations at the RDO booth. Please consider [signing up for a shift](https://etherpad.openstack.org/p/rdo-vancouver-summit-booth).

### Other Events
Other RDO events, including the many OpenStack meetups around the world, are always listed on the [RDO events page](http://rdoproject.org/events). If you have an RDO-related event, please feel free to add it by submitting a pull request [on Github](https://github.com/OSAS/rh-events/blob/master/2016/RDO-Meetups.yml).


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
