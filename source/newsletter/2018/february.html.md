# February 2018 RDO Community Newsletter

[← Newsletters](/newsletter)
## Quick links:


### In This Newsletter
* [Housekeeping Items](#housekeeping)
* [Community News](#community)
* [RDO Changes](#rdo)
* [Events](#events)
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
* [Queens release schedule](http://releases.openstack.org/queens/schedule.html)

---

Hi, RDO Community! It's hard to believe that we're already almost a week into February. We hope the last few weeks have been good ones for you. They've been busy for us, so buckle up -- we're bringing you a lot of information in this newsletter!

## <a name="housekeeping"></a>Housekeeping Items
### Queens Release Coming Soon
We will be testing the RDO OpenStack Queens Milestone 3 packages on February 8th and 9th. We’ll be congregating on the #RDO channel on Freenode IRC for questions, commentary, and general conversation. We’ll also be deploying a test cloud similar to our last test day, so that you can test without having to deploy it yourself.

Details: [http://rdoproject.org/testday/queens/milestone3/](http://rdoproject.org/testday/queens/milestone3/)  
Signups: [https://etherpad.openstack.org/p/rdo-queens-m3-cloud](https://etherpad.openstack.org/p/rdo-queens-m3-cloud)  
Questions: Send an email to [<users@lists.rdoproject.org>].  
Subscribe here: [http://lists.rdoproject.org/](http://lists.rdoproject.org/).

Speaking of Queens… there was an interesting discussion about the proposed community goals for the new release on the openstack-dev mailing list. ICYMI: [http://lists.openstack.org/pipermail/openstack-dev/2018-January/126143.html](http://lists.openstack.org/pipermail/openstack-dev/2018-January/126143.html)

The official Queens release date is Feb 28 -- looking forward to celebrating! In the meantime, there’s still work to do on the final spec adjustments for RDO. Take a look at the Trello card to see what else still needs to happen and how you can help: [https://trello.com/c/4hiSJdKq/656-queens-release-preparation](https://trello.com/c/4hiSJdKq/656-queens-release-preparation)

### New Blog Site
We recently consolidated the RDO blogs into a single Wordpress installation - [http://blogs.rdoproject.org](http://blogs.rdoproject.org). Interested in blogging on the community site going forward? Fantastic! Reach out to Rich (rbowen) to make sure you have the right credentials and know where to go.

Here’s more from Rich via the RDO Dev Mailing List: [https://rdo.fsn.ponee.io/thread.html/936b05064ca81d35227e519479bfbb310dcf1230fdc52ca057ada7ac@%3Cdev.lists.rdoproject.org%3E](https://rdo.fsn.ponee.io/thread.html/936b05064ca81d35227e519479bfbb310dcf1230fdc52ca057ada7ac@%3Cdev.lists.rdoproject.org%3E)

### MongoDB retired from RDO for Queens
As announced previously on the [RDO-dev mailing list](https://rdo.fsn.ponee.io/thread.html/44451f40e1110e9af798fe1733509921fc30d9e0446fe104d0ed6013@%3Cdev.lists.rdoproject.org%3E), MongoDB has been retired from the RDO repository for Queens. Reach out to Alfredo Moralejo Alonso [<amoralej@redhat.com>] if you see this causing any issues or odd behaviors in CI jobs or deployments.

### DLRN Fedora Builder Updates
The RDO Trunk builder was updated to the latest DLRN version on January 30th and a new DLRN Fedora builder machine was created. Fedora RDO Trunk could no longer be built on an CentOS-based DLRN machine, due to incompatibilities between yum and the rich dependencies found in some Fedora packages. If you have any questions about the update or have been running into any problems which you think might be related, reach out to Javier Pena [<jpena@redhat.com>].


## <a name="community"></a>Community News
### OpenStack Technical Committee 2017 Overview
Curious about what the OpenStack Technical Committee accomplished in 2017? Chris Dent [compiled a great summary of decisions made](https://anticdent.org/tc-report-2017-in-review.html), topics discussed, and common themes.  

Want to keep up with the breaking news as it happens in 2018? Watch for regular reports on his blog. Here’s the first report of 2018: [https://anticdent.org/tc-report-18-02.html](https://anticdent.org/tc-report-18-02.html)

### New Resource Management SIG
Founded by Zhipeng (Howard) Huang, there’s a new SIG for anyone involved in resource management for various communities. If you’re interested, check out the [new wiki](https://wiki.openstack.org/wiki/Res_Mgmt_SIG) or add your name to the list of participants.

More information: [https://wiki.openstack.org/wiki/Res_Mgmt_SIG](https://wiki.openstack.org/wiki/Res_Mgmt_SIG)

### Women of OpenStack
The Women of OpenStack kicked off a new year of meetings a few weeks ago. Not familiar with the group? The group strives to increase the diversity of the OpenStack community by overcoming OpenStack's barrier to entry through educational sessions, professional networking, mentorship, social inclusion, and enhanced resource access.

They meet every other week at 2000 UTC. For more information, see their wiki:
[https://wiki.openstack.org/wiki/Women_of_OpenStack](https://wiki.openstack.org/wiki/Women_of_OpenStack)

### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.


## <a name="rdo"></a>RDO Changes
### New configuration and infrastructure core nominations
[Wes Hayutin nominated Ronelle Landy](http://eavesdrop.openstack.org/meetings/rdo_meeting___2018_01_17/2018/rdo_meeting___2018_01_17.2018-01-17-15.00.log.html#l-64) as a configuration core for RDO's [review.rdoproject.org](https://review.rdoproject.org/sf/welcome.html) deployment. Ronelle is knowledgeable about how the different jobs work and is definitely a deserving candidate.

David Moreau Simard, on his end, nominated four new RDO infrastructure cores:  
Tristan Cacqueray  
Nicolas Hicher  
Matthieu Huin  
Fabien Boucher

Their work on Software Factory, amongst other things, has been crucial to RDO's success and David briefly [explained his nominations](http://eavesdrop.openstack.org/meetings/rdo_meeting___2018_01_17/2018/rdo_meeting___2018_01_17.2018-01-17-15.00.log.html#l-22) at the 17 Jan RDO meeting.

A formal announcement with additional details will be made to the mailing list soon.

### Opportunity to merge review.rdoproject.org and softwarefactory-project.io
David Moreau Simard [brought up at a RDO meeting](http://eavesdrop.openstack.org/meetings/rdo_meeting___2018_01_17/2018/rdo_meeting___2018_01_17.2018-01-17-15.00.log.html#l-76) that it could be interesting to merge [review.rdoproject.org](https://review.rdoproject.org/sf/welcome.html) and [softwarefactory-project.io](https://softwarefactory-project.io/sf/welcome.html). The two clusters are deployed through Software Factory, which provides (amongst other things) the Zuul/Nodepool/Gerrit implementation for code review and CI.

Combining these two deployments could make things more efficient from a resource, maintenance, and operational standpoint. There's a lot of things to think about and discussions will begin soon to understand what we need to do if we want to move forward with this idea.

Stay tuned on the [RDO meetings](https://www.rdoproject.org/contribute/community-meeting/) and the [mailing list](https://lists.rdoproject.org/mailman/listinfo/dev) for more details soon.

### Easily search code in RDO's repositories
RDO's hundreds of packaging and tooling repositories makes it tedious if you want to search for a pattern that could be used in different projects. OpenStack provides an implementation of [Hound](https://github.com/etsy/hound), a source code search engine, in order to let the community search its 1500+ git repositories easily: [codesearch.openstack.org](http://codesearch.openstack.org)

We managed to stand up a proof of concept for the RDO community repositories and it is available at [codesearch.rdoproject.org](https://codesearch.rdoproject.org). The implementation required a lot of fine tuning due to some particularities of our repositories but the code will be pushed up to rdo-infra soon.

### RDO’s Infrastructure Server Metrics are now Available
Curious about the inner working of the RDO servers? From network packets to disk and swap usage, these metrics will show you the current status of RDO, allowing for improved visibility and accessibility.

View the graphs:
[https://review.rdoproject.org/grafana/?orgId=1](https://review.rdoproject.org/grafana/?orgId=1)  
For more information about why we switched, see the email thread:
[https://rdo.fsn.ponee.io/thread.html/71eba78db3681759d19cc0a7b561726b6cc86632ade5315d484faf6b@%3Cdev.lists.rdoproject.org%3E](https://rdo.fsn.ponee.io/thread.html/71eba78db3681759d19cc0a7b561726b6cc86632ade5315d484faf6b@%3Cdev.lists.rdoproject.org%3E)

### Providing service VM images in RDO
Bernard Cafarelli has been working on Octavia in order to automate the process of providing service VM (called amphorae) images in RDO. This allows for a far easier install and maintenance for the user, since TripleO can consume the image directly. It also ensures up-to-date amphora images, and allows us to test and confirm that amphora works properly with the latest changes.

The current plan is to create a periodic job to rebuild the images daily, then upload them to images.rdoproject.org. This ensures that the packages in the image will be up-to-date at all times, and will help Octavia adoption.

Follow along with the up-to-date information here:
[https://rdo.fsn.ponee.io/thread.html/1b523836b5fcde773e28d528273b805e6a657547cae1d81a1ed4cb81@%3Cdev.lists.rdoproject.org%3E](https://rdo.fsn.ponee.io/thread.html/1b523836b5fcde773e28d528273b805e6a657547cae1d81a1ed4cb81@%3Cdev.lists.rdoproject.org%3E)

### Continuation of OpenStack Release Schedule Conversation
The conversation we referenced in [last month’s newsletter](http://rdoproject.org/newsletter/2018/january/#community) is still ongoing. Thierry posted a [helpful TL;DR](http://lists.openstack.org/pipermail/openstack-dev/2017-December/125688.html) for those of you who chose to stay away from the 118-message convo. The temporary conclusion, which Thierry detailed in a [separate message](http://lists.openstack.org/pipermail/openstack-dev/2018-January/126080.html), is that the discussions with the Technical Committee will happen in Dublin (PTG) and continue in Vancouver (Forum at Summit). In the meantime, Rocky will be a 6-month development cycle, as proposed in [https://review.openstack.org/#/c/528772/](https://review.openstack.org/#/c/528772/)


## <a name="events"></a>Events
Things have been busy in the events realm this month! There are two major events to be aware of, and two more that are just wrapping up:

### CFP for Vancouver Open Source Summit Closes Feb 8
You’ve still got 48 hours to submit your CFP for the 2018 Vancouver Open Source Summit! They’re focusing on open infrastructure integration more than ever before.

As VP of Marketing & Community Services Lauren Sell said to the [OpenStack Community mailing list](http://lists.openstack.org/pipermail/community/2018-January/001802.html
), “We’re making an even bigger effort to attract speakers across the open infrastructure ecosystem. In addition to OpenStack-related sessions, we’ll be featuring the newest project at the Foundation -- Kata Containers -- as well as recruiting many others from projects like Ansible, Ceph, Kubernetes, ONAP and many more.”

For more information about what types of talks they’re looking for, read the rest of the thread on the mailing list:
[http://lists.openstack.org/pipermail/community/2018-January/001802.html](http://lists.openstack.org/pipermail/community/2018-January/001802.html)

Submit your CFP:
[https://www.openstack.org/summit/vancouver-2018/call-for-presentations](https://www.openstack.org/summit/vancouver-2018/call-for-presentations)

### Upcoming PTG in Dublin
As the Dublin PTG approaches, teams are starting to gather topics for discussion. Take a look at the [various etherpads](https://wiki.openstack.org/wiki/PTG/Rocky/Etherpads) and be sure to include the topics you’d like to talk about.

Here’s a first look at the schedule:
[https://docs.google.com/spreadsheets/d/e/2PACX-1vRmqAAQZA1rIzlNJpVp-X60-z6jMn_95BKWtf0csGT9LkDharY-mppI25KjiuRasmK413MxXcoSU7ki/pubhtml?gid=1374855307&single=true](https://docs.google.com/spreadsheets/d/e/2PACX-1vRmqAAQZA1rIzlNJpVp-X60-z6jMn_95BKWtf0csGT9LkDharY-mppI25KjiuRasmK413MxXcoSU7ki/pubhtml?gid=1374855307&single=true)

Rich Bowen will once again be conducting interviews at the upcoming Dublin PTG. If you’re working on something interesting and want to chat about it on camera, send Rich a message or sign up here: [https://docs.google.com/spreadsheets/d/1MK7rCgYXCQZP1AgQ0RUiuc-cEXIzW5RuRzz5BWhV4nQ/edit#gid=0](https://docs.google.com/spreadsheets/d/1MK7rCgYXCQZP1AgQ0RUiuc-cEXIzW5RuRzz5BWhV4nQ/edit#gid=0).

### DevConf Recap (Jan 26-28)
Our RDO booth presence at [Devconf 2018](https://devconf.cz/cz/2018) was the most successful yet! We put together a team of 7 people who all focused on slightly different areas, which allowed us to answer a variety of questions. We had some great conversations about OpenStack and RDO, and received positive feedback as well as suggestions for improvement in specific areas.

We also helped several people who were looking into getting started with TripleO and RDO. This year we had far more people asking about the technology and interested in specific details. One of the highlights of the show was the fact that our demo was connected with the ManageIQ instance in the neighbor booth. This was a great example of cooperation between teams and also a good demonstration to show how these technologies fit together.

### FOSDEM Recap (Feb 3-4)
After DevConf, several members of the RDO community were at [FOSDEM](http://fosdem.org) -- the annual Free and Open Source software conference. The event draws more than 8,000 free software enthusiasts from all over Europe and around the world. The RDO community showed up in force to staff the OpenStack table in the expo hall. Several OpenStack presentations were given in the Virtualization devroom.

Also, on the day before FOSDEM (Friday, February 2nd), we participated in the [CentOS Dojo at the Marriott](https://wiki.centos.org/Events/Dojo/Brussels2018). RDO community members Haïkel Guémar, Matthias Runge, Thomas Oulevey, and Spyros Trigazis gave presentations on a variety of topic. The videoS from these talks will be appearing on [YouTube](https://www.youtube.com/user/TheCentOSProject) over the coming days.


## <a name="kit"></a>Keep in Touch

There are lots of ways to stay in in touch with what's going on in the
RDO community. The best ways are ...

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

Thanks again for being part of the RDO community!
