# June 2018 RDO Community Newsletter

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
And just like that, the year is half complete! Hope your July is as warm and
eventful as it is here in RDO land - with happy birthday OpenStack
celebrations all over the world, we continue to make progress on a new TripleO Standalone Installer, migration to zuul3 is complete, and we're gearing up for the
upcoming PTG in Denver, Colorado! So, sit back, relax, and enjoy this month's
newsletter - the last half of the year is going to be AWESOME!

## <a name="housekeeping"></a>Housekeeping Items
### Upcoming Test Days
Our next test day is [August 2-3](https://www.rdoproject.org/testday/rocky/milestone3/) - Rocky Milestone 3! For more information on these test days and how to participate, keep an eye out on the dev@ list for details, reach out to Rain via [email](rain@redhat.com) or IRC (leanderthal).

Of course, you don't have to wait for a scheduled test day to test RDO. We would love to hear about your experiences, with either a [Packstack installation](https://www.rdoproject.org/install/packstack) or the [TripleO Quickstart](https://www.rdoproject.org/tripleo).

We also encourage you to work through the [upstream installation tutorial](https://docs.openstack.org/queens/install/) while keeping detailed notes on the following points:

* Did you know what the document assumed that you'd know?
* Did the steps work as described?
* What error conditions did you encounter? Could you work around them? If so, how?
* When you were done, did it work as expected? If not, what happened, and how did it differ from what you expected to happen?


## <a name="rdo"></a>RDO Changes
### TripleO Standalone Installer Status Update
If you were at the Dublin PTG, you know that there was discussion around
deploying a single node OpenStack where the provisioning happens on the same
node, with no separation between the overcloud or undercloud.

Emilien Macchi recently [sent out a status update](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131135.html) about the progress being made on Standalone (aka All-In-One).

TL;DR: They’ve been making good progress and have a [demo available for viewing](https://asciinema.org/a/185533). For more information about what’s happening and how to get involved, see his longer-form update [on the mailing list](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131135.html).

## <a name="community"></a>Community News
### A New Role for DMSimard
As many of you know, David Moreau Simard has been an integral part of RDO for the past 2 years. It’s now time for him to move on to a new role as he mentioned in a [recent email](http://post-office.corp.redhat.com/archives/rh-openstack-dev/2018-May/msg00403.html).

Please join us in thanking him for his time and efforts throughout the years and wishing him well on his new adventure as SRE for the OpenShift dedicated product.

### CentOS Pulse newsletter relaunched
As we mentioned in [last month’s newsletter](https://www.rdoproject.org/newsletter/2018/june/#community), Rich Bowen has relaunched the [CentOS Pulse newsletter](https://wiki.centos.org/Newsletter/), and we’re excited to announce that [the first issue is OUT](https://wiki.centos.org/Newsletter/1801)!

If you’d like to contribute to the next issue, please reach out to [Rich](rbowen@redhat.com) directly.

### RHOSP and Ansible win CODIE Awards
In case you’re not familiar, the CODiE Awards are annual awards given by the Software and Information Industry Association for products that display excellence in software development. There are two broad categories: Business Technology and Education Technology.

At this year’s awards ceremony, Red Hat OpenStack Platform walked away with the award for the Best API Management Platform, which is a great honor!

Ansible was also recognized as a standout product in technology, winning the Best Overall Business Technology Product award.

Congratulations to all those involved -- give yourselves a round of applause for a job well done!

### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

## <a name="openstack"></a>OpenStack News
### User Community Forum Session Results
If you missed the opportunity to participate in the User Community Forum Session at OpenStack Summit Vancouver, Marketing Associate Ashlee Ferguson has summarized it in the [OoenStack Community Mailing List](http://lists.openstack.org/pipermail/community/2018-June/001836.html).

From debating Meetup Pro account vs. the current groups portal to birthday celebrations, the Speakers Bureau, and more, be sure to take a look at the [full recap](http://lists.openstack.org/pipermail/community/2018-June/001836.html) to stay on top of what’s going on within the User Community.

### List of SIGs/Groups/WGs/Teams for PTG Announced
The list of SIGs, Groups, WGs, and Teams that will be attending the upcoming PTG in Denver, CO in September, have been finalized. To see the full list and get more information about accommodations, travel support, and more, take a look at [these](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131689.html) [two](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131470.html) [emails](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131881.html) from Upstream Developer Advocate Kendall Nelson and Thierry Carrez.

### OpenStack Mentoring Program
Looking to get an extra boost on your OpenStack skills? Or are you a veteran, looking to provide some knowledge for up-and-comers? The newly revived OpenStack Mentoring program is here for you! Interested in learning more or signing up to be a mentor or mentee? Get all of the details
[here](http://lists.openstack.org/pipermail/user-committee/2018-June/002684.html) 
### Stein Goals Proposed
After an exciting discussion at the User Forum at OpenStack Summit Vancouver (Missed it? [Read the recap](http://lists.openstack.org/pipermail/openstack-dev/2018-May/130999.html), Sean McGinnis sent around the following two goals as a proposal for the upcoming Stein release:

* Cold Upgrade Support  
* Python 3 first

You can read more about his reasoning and the community’s responses on the [OpenStack Dev Mailing List](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131099.html).

### Organizational Diversity Tags
There was an [intense thread](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131029.html) in the OpenStack Dev Mailing list that started in May and trailed into June.

It was all about organization diversity tags -- are these tags now irrelevant? Are they still helpful and necessary? What other options are there?

If you’re looking for the TL;DR version, Thierry Carrez took the time to [summarize the conversation](http://lists.openstack.org/pipermail/openstack-dev/2018-June/131399.html), which of course led to its own mini novela. What’s your opinion on the matter?

### OpenStack Survey
If you’re running OpenStack, please take part in the [2018 OpenStack User Survey](https://www.openstack.org/user-survey/survey-2018/landing?BackURL=/user-survey/survey-2018/). 

The survey is available in 7 languages -- English, German, Indonesian, Japanese, Korean, traditional Chinese and simplified Chinese -- and the results will be published in October, prior to the Berlin OpenStack Summit.

The deadline to complete the survey and be part of the next report is **Friday, August 3 at 23:59 UTC.** You can login and complete the OpenStack User Survey here: [http://www.openstack.org/user-survey](http://www.openstack.org/user-survey)

## <a name="events"></a>Recent and Upcoming Events
### Happy 8th Birthday, OpenStack!
It’s OpenStack’s 8th birthday and the community is celebrating all over the globe! With the addition of Kata Containers and Zuul to the OpenStack Foundation, the parties are sure to be full of exciting new open infrastructure content. Find one near you at [openstack.org/events](https://www.openstack.org/community/events/).

If you happen to be attending [Cloud Native Open Infrastructure Tech Day](https://groups.openstack.org/groups/san-francisco-bay-area/cloud-native-open-infrastructure-tech-day-incl-hands-labs-and-cupcakes) in San Jose, July 10-11, make sure you don’t miss the birthday celebration on Tuesday afternoon! Grab a cupcake, meet RDO Community Contractor [Mary Thengvall](https://twitter.com/mary_grace), and join us in wishing OpenStack a very happy birthday.

Can’t make it to an event near you? Let’s see your personalized happy birthday to OpenStack! Send your happy birthday selfies with balloons, candles, cake, or code to [Rain](rain@redhat.com) by 15 July who is going to write up a happy birthday blog post on our very own [blogs.rdoproject.org](http://blogs.rdoproject.org/).

### Volunteers Needed for Ohio LinuxFest
This year, CentOS is a Bronze sponsor at Ohio LinuxFest (Columbus, OH; Oct 12-13). Rich Bowen is looking for folks interested in giving demos from the CentOS table. If you’re working on a project that can reasonably claim that it's part of the CentOS ecosystem, you’re welcome to join in the fun!

Not sure if you have a project to share but still want to be involved? He’s looking for anyone who wants to hang out at the booth, be friendly, and answer questions as well. Bonus: he has awesome stickers to share!

Interested? Take a look at the [Wiki](https://wiki.centos.org/Events/2019/OhioLinux) and reach out to Rich via [rbowen@centosproject.org](rbowen@centosproject.org).

### Won't You Join Us At DevConf India?
If you’ll be attending [DevConf India](https://devconf.info/in) don’t miss out on the hour-long RDO BoF. Have ideas on what to talk about during the session? Please post them in the [Etherpad](https://review.rdoproject.org/etherpad/p/devconfin-openstackbof) and be sure to [sign up for the session](https://devconfin2018.sched.com/event/FA7j/openstackrdo).

### Call For Papers
There are a handful of relevant conferences with open CFPs. Need help figuring
out a good topic or finalizing your abstract? Feel free to reach out in the #RDO channel on IRC.

* The [2018 CentOS Dojo](http://cern.ch/centos) (Oct 19) is a one-day event, hosted at CERN in Genève, Switzerland. This event brings people together from the CentOS Communities to talk about systems administration, best practices in Linux centric activities and emerging technologies of note. Our own Rain Leander and Rich Bowen are leading the charge along with Jarek Polok and Thomas Oulevey. [The CFP closes **July 16**](https://indico.cern.ch/event/727150/abstracts/).
* [OpenStack Summit](https://www.openstack.org/summit/berlin-2018/) is back! Hosted in Berlin, Nov 13-15, there will be over 200 sessions and workshops on everything from Container Infrastructure and CI/CD to Telecom + NFV, Public Cloud, and of course, RDO. Let’s flood the CFP! [Be sure to submit your proposal(s) before **July 17**](https://www.openstack.org/summit-login/login?BackURL=%2Fsummit%2Fberlin-2018%2Fcall-for-presentations%2F).
* [All Systems Go!](https://all-systems-go.io) (Sept 28-30) is the foundational user-space Linux conference held in Berlin. It consists of 2 days of presentations followed by 1 hackfest day. Full presentation slots are 30-45 minutes in length and lightning talk slots are 5-10 minutes. [The CFP is **open until July 30!**](https://cfp.all-systems-go.io/de/ASG2018/cfp)
* The [Ohio LinuxFest](https://ohiolinux.org) (Oct 12-13)is a grassroots conference for the GNU/Linux/Open Source Software/Free Software community. It is a place for the community to gather and share information about Linux and Open Source Software. [The CFP closes **July 31**](https://ohiolinux.org/call-for-presentations/).

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
