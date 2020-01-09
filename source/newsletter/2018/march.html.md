# March 2018 RDO Community Newsletter

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

Hi, RDO Community! I hope you like marshmallows and peanuts because we're into Rocky and it's going to be quite a road. TL;DR: Queens was released, we're excited that Cloud SIG meetings are back, and we're loving the idea of stable Fedora repositories for OpenStack. But that's not all -- be sure to read the rest of the newsletter to stay up to date with what's going on in our community.


## <a name="housekeeping"></a>Housekeeping Items
### Pony Mail Revamp (aka mail.rdoproject.org)
You might remember that we launched Pony Mail [back in January](https://www.rdoproject.org/newsletter/2018/january/). We’ve now put the hostname mail.rdoproject.org in place and made the experience a little better. As a quick refresher, we have this [Apache PonyMail](http://ponymail.apache.org/) open source software in place as a web-based interface to our mailing lists. This lets you, among other things:

* Revive an old thread from before you were subscribed
* See basic statistics about participation in mailing list threads
* Advanced searching features
* oAuth authentication - if there's an auth source you want to use that's not there, let us know, and we'll add it
* Compose email in the web interface or in your own mail client, as you prefer
* Keyboard shortcuts! (Press H for a list)


## <a name="rdo"></a>RDO Changes
### RDO Queens Released
We’re extremely happy to announce the general availability of the RDO build for OpenStack Queens! This is the SEVENTEENTH release from the OpenStack project, which is the work of more than 1600 contributors from around the world. Super big thanks for all your help - we could not do this without the RDO Community!

There’s more information in the detailed blog post from Rich Bowen: [https://blogs.rdoproject.org/2018/03/rdo-queens-released/](https://blogs.rdoproject.org/2018/03/rdo-queens-released/)

### Collaborating with Kolla for RDO Test Days Post-Queens Release
In true community form, we’ll be joining forces with the [Kolla](https://wiki.openstack.org/wiki/Kolla) core contributors during our RDO test days. We’ll supply the bare metal hardware and their core contributors will be able to deploy and operate a cloud with real users and developers poking around.

Keep an eye on the [Etherpad](https://etherpad.openstack.org/p/kolla-rdo-m3) and mailing lists for more information on the upcoming [test day](https://www.rdoproject.org/testday/), tentatively scheduled for 15-16 March.

### Stabilized Fedora repositories for OpenStack
In case you missed the discussion at the Feb 7 IRC meeting, we’re starting to move toward using stabilized Fedora repositories for OpenStack. As Haïkel Guémar detailed in a [follow-up email thread](https://rdo.fsn.ponee.io/thread.html/f122ccd93daf5e4ca26b7db0e90e977fb0fbb253ad7293f81b13a132@%3Cdev.lists.rdoproject.org%3E):

_Since Fedora has proven to be an unstable platform for OpenStack, we plan to provide "stabilized" repositories. The concept is quite simple: we provide a snapshot of Fedora repositories and then gate updates through CI. Any updates that fails CI will be blacklisted or overridden, we will also provides packages overrides for the ones we can't update in Fedora._

The plan is to have everything set to change over during the Rocky cycle. Given how much work this will entail, Haïkel has pulled together an [Etherpad](https://etherpad.openstack.org/p/stabilized-fedora-repositories-for-openstack) with more information, including the goals, technical requirements, and any open concerns.

Please contribute to the conversation either via the [mailing list](https://rdo.fsn.ponee.io/thread.html/f122ccd93daf5e4ca26b7db0e90e977fb0fbb253ad7293f81b13a132@%3Cdev.lists.rdoproject.org%3E) or [Etherpad](https://etherpad.openstack.org/p/stabilized-fedora-repositories-for-openstack) if you have any questions.


## <a name="community"></a>Community News
### Cloud SIG meeting restarting
The Cloud SIG is back up and running, thanks to the prompting of Rohit Yadav and Daan Hoogland! Hat tip to Rich Bowen for his help in getting it off the ground.

The meeting will take place every Thursday at 15:00 UTC in the #centos-devel channel on Freenode. Take a look at the [Etherpad](https://public.etherpad-mozilla.org/p/centos-cloud-sig) for the running agenda and the [Cloud SIG page](https://wiki.centos.org/SpecialInterestGroup/Cloud) on the CentOS wiki for more information.

### Recent Blogpost Roundups
Every two weeks or so we post the latest OpenStack and RDO-related blogposts to blogs.rdoproject.org. In case you’ve missed the last few, you can find them here:
[https://blogs.rdoproject.org/category/community-blog-round-up/](https://blogs.rdoproject.org/category/community-blog-round-up/)

If you blog about OpenStack, RDO, or anything related to those topics, feel free to add your RSS feed to the RDO [planet.ini](https://github.com/redhat-openstack/website/blob/master/planet-rdo.ini) file so we’re aware of it!

### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.

## <a name="openstack"></a>OpenStack News
### New Onboarding Docs for OpenStack
OpenStack has a new gorgeous community site and onboarding docs! From selecting the area you’d like to help out with to learning what being a contributor means or simply going straight to the contributor resources, the site is easy to navigate and wonderful to look at.

See more here: [https://www.openstack.org/community](https://www.openstack.org/community)

### Looking for Help with Translating Queens Release Notes
Do you speak another language? The documentation team could use your help! They’re looking for people to submit translations of the Queens release notes. For more information on what’s involved, following the thread in [openstack-dev](http://lists.openstack.org/pipermail/openstack-dev/2018-February/127518.html). To dive right in, here’s a full list of open reviews:
[https://review.openstack.org/#/q/status:open+topic:zanata/translations](https://review.openstack.org/#/q/status:open+topic:zanata/translations)

### Goals for Rocky Decided
With the release of Queens just behind us, it’s time to move on to Rocky! The goals have been discussed, and were voted on at the PTG in Dublin. The [current selection](https://governance.openstack.org/tc/goals/rocky/index.html) is a mix of one ops-facing goal (ability to set logs to debug without restarting the service, using mutable configuration), and one dev-facing tech debt reduction goal (going further in getting rid of mox/mox3).

### PTL & User Committee Election Results
For possibly the first time ever, all teams had at least one candidate for PTL for the Rocky cycle! Please join us in congratulating the new PTLs:
[http://lists.openstack.org/pipermail/openstack-dev/2018-February/127404.html](http://lists.openstack.org/pipermail/openstack-dev/2018-February/127404.html)

The User Committee also went through an election process recently. Congrats to the three new members!
More info: [http://lists.openstack.org/pipermail/community/2018-February/001814.html](http://lists.openstack.org/pipermail/community/2018-February/001814.html)


## <a name="events"></a>Events
### Dublin PTG Recap (+ Videos)
Twice a year, the OpenStack community gathers for the [Project Teams Gathering](http://openstack.org/ptg) - the PTG - to plan the next release of OpenStack. This past week, we gathered in Dublin, Ireland for 5 days of intense meetings about what specific features we want to implement in the Rocky release. While the major goals of Rocky have already been determined (see above), this is where the details get worked out.

As always, Rich was there to interview the project teams about their plans and give you a preview of what to expect. Those videos will be [on YouTube](https://www.youtube.com/watch?v=zmwYAZLsJ84&list=PLOuHvpVx7kYnVF3qjvIw-Isq2sQkHhy7q) as soon as they get edited - keep an eye out for them over the coming weeks. This is a great way to get a preview of what to expect in this next release, which will [come out in late August](https://releases.openstack.org/rocky/schedule.html).

### DevConf US CFP Open
If you missed out on DevConf in Brno, you’re in luck -- there are more opportunities to attend this awesome conference! The CFP for [DevConf US](https://devconf.info/us/) is open until April 3rd. Don’t miss a chance to talk about your favorite Free or Open Source technology.

Apply to speak here:
[https://docs.google.com/forms/d/e/1FAIpQLSfBUSs7rin0RPXo-6A-yoUkeVnVFXlSYkt7-tnTBJjoC72OBw/viewform](https://docs.google.com/forms/d/e/1FAIpQLSfBUSs7rin0RPXo-6A-yoUkeVnVFXlSYkt7-tnTBJjoC72OBw/viewform)

### Virtual Meetup Scheduled for April 12 -- CFP Open Now!
We’re planning for our first virtual meetup on April 12. We'll have several 30-minute presentations, which will happen via Google Hangouts, or something similar, and will be recorded. Presentations should be related to RDO or upstream OpenStack. We’ll start the presentations around 9am Eastern US time and will run for as long as we have content.

If you would like to present at this meetup, please provide details about your proposed talk at:
[https://docs.google.com/forms/d/e/1FAIpQLSdlSXcphEVCJpi0dQFV1SdFDrSi2cZljfc698P6p2Z-dhJgNQ/viewform?usp=sf_link](https://docs.google.com/forms/d/e/1FAIpQLSdlSXcphEVCJpi0dQFV1SdFDrSi2cZljfc698P6p2Z-dhJgNQ/viewform?usp=sf_link)

The call for papers will close on March 11th, at which time we will select a schedule, so that we have a few weeks to promote this event through the usual channels.

### Other Events
Other RDO events, including the many OpenStack meetups around the world, are always listed on the [RDO events page](http://rdoproject.org/events). If you have an RDO-related event, please feel free to add it by submitting a pull request [on Github](https://github.com/OSAS/rh-events/blob/master/2018/RDO-Meetups.yml).


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
