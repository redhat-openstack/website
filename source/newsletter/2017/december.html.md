# December 2017 RDO Community Newsletter

## Quick links:

### In This Newsletter
* [Housekeeping Items](#housekeeping)
* [Community News](#community)
* [RDO Changes](#rdo)
* [Recent Events](#events)
* [Keep in Touch](#kit)

### RDO Resources

* [TripleO Quickstart](http://rdoproject.org/tripleo)
* [Packstack](http://rdoproject.org/install/packstack/)
* [Mailing Lists](https://www.rdoproject.org/contribute/mailing-lists/)
* [EasyFix](https://github.com/redhat-openstack/easyfix)
* [RDO release packages](https://trunk.rdoproject.org/)
* [Review.RDOProject.org](http://review.rdoproject.org/)
* [RDO blog](http://rdoproject.org/blog)
* [Q&A](http://ask.openstack.org/)
* [Open Tickets](http://tm3.org/rdobugs)
* [Twitter](http://twitter.com/rdocommunity)
* [Queens release schedule](http://releases.openstack.org/queens/schedule.html)

Thanks for being part of the RDO community!

## <a name="housekeeping"></a>Housekeeping Items
### Fedora OpenStack SIG - Please reassign packages
We've created the [Fedora OpenStack SIG](https://fedoraproject.org/wiki/SIGs/OpenStack) to allow shared maintenance of clients and an easier sync from RDO. In order for this to happen, we need you to reassign OpenStack-related packages and core dependencies to the SIG. Note: if these are currently located in [rdoinfo](https://github.com/redhat-openstack/rdoinfo/blob/master/rdo.yml), then they should already be owned by the SIG.

More information: [https://lists.rdoproject.org/pipermail/dev/2017-November/008387.html](https://lists.rdoproject.org/pipermail/dev/2017-November/008387.html)

### Reminder about mailing list changes
In case you missed it in [last month’s newsletter](http://rdoproject.org/newsletter/2017/november/), we’ve made some changes to the mailing list setup. Here’s a recap:
* This list - the RDO Community Newsletter - is now delivered to the address [newsletter@lists.rdoproject.org](mailto:newsletter@lists.rdoproject.org) rather than the old [rdo-newsletter@redhat.com](mailto:rdo-newsletter@redhat.com).
* The main rdo-list mailing list has been split into two lists - [dev@lists.rdoproject.org](mailto:dev@lists.rdoproject.org) and [users@lists.rdoproject.org](mailto:users@lists.rdoproject.org) - in order to make the users mailing list more welcoming to operators and users of RDO, while the more technical, development-centric discussions will take place on the dev mailing list.

tl;dr: You don't need to do anything if you want to keep receiving this newsletter. However, if you wish to post to either the dev list or the users list, you will, of course, have to send to the new addresses. You can see the list archives and manage your preferences at [lists.rdoproject.org](https://lists.rdoproject.org).

### RDO Office Hours
In case you missed the announcement in [early October](https://lists.rdoproject.org/pipermail/dev/2017-October/008376.html), the RDO Office Hours have changed. Here’s the new structure:
* Bi-weekly meetings
* Duration: 1h
* Next meeting is on Dec 12, 2017
* New timing: 13:30 UTC to 14:30 UTC

Unfamiliar with RDO Office Hours? They were established to keep up with increasing participation in RDO. We use this time to triage tickets, add more [EasyFix items](http://rdoproject.org/blog/2017/08/easyfix-getting-started-contributing-to-rdo/), and provide mentoring to newcomers. There are occasional presentations by special guests as well.

For instance, Attila Darazs (adarazs) and Sagi Shnaidm (sshnaidm) gave an overview about the config project during RDO Office Hours on Oct 17. It’s a fascinating conversation about how we add and manage RDO package repositories as well as how we roll out different CI jobs against Tripleo and RDO. Check out the [log](http://eavesdrop.openstack.org/meetings/rdo_office_hour___2017_10_17/2017/rdo_office_hour___2017_10_17.2017-10-17-13.31.log.html#l-17) and the [summary of the conversation](https://review.rdoproject.org/etherpad/p/rdo-config-office-hours).

## <a name="community"></a>Community News
### Queens Milestone 1 Test Day (Nov 16-17)
We recently had a test day for Queens Milestone 1. It was a learning experience, in that very few people attended and even fewer actively helped to test the new release. We discussed the outcome in a recent [RDO meeting](http://eavesdrop.openstack.org/meetings/rdo_meeting___2017_11_22/2017/rdo_meeting___2017_11_22.2017-11-22-15.00.log.html) and came to a few conclusions:
* The current format no longer works, as it came from a time when we didn’t have automated testing
* While the automated systems are great, a new plan is needed for upcoming test days
* Having a test leader would help keep things on track
* We either need clear instructions that attendees can follow, or a test install of RDO cloud already set up so that folks can put it through the paces of various testing scenarios

To this end, for our upcoming test days, December 14-15th, we’ll be providing a test cloud running RDO packages of Queens Milestone 2, which you can use to run tests on a live OpenStack cloud without having to deploy it yourself. For more details about how this will work and to sign up for login credentials, please read the description on the mailing list:
[https://lists.rdoproject.org/pipermail/users/2017-November/000077.html](https://lists.rdoproject.org/pipermail/users/2017-November/000077.html)

For even more information, see David’s blog post:
[https://dmsimard.com/2017/11/29/come-try-a-real-openstack-queens-deployment/](https://dmsimard.com/2017/11/29/come-try-a-real-openstack-queens-deployment/)

Haikel Guemar will be the test leader for the December test days, and we’re interested in your feedback on how to make these days more collaborative and effective for the community.

### Infrastructure core administrators
Congrats to Attila Darazs (adarazs), John Trowbridge (trown), and Sagi Shnaidm (sshnaidm) who were named as part of the the config-core group for review.rdoproject.org. This group takes care of managing all configuration for the Software Factory instance used by the RDO project.

Javier Pena created a new website that gives information about this group, including information and guidelines about how you can contribute, as well as how to become a config core.

More information: [https://www.rdoproject.org/infra/review-rdo-infra-core/](https://www.rdoproject.org/infra/review-rdo-infra-core/)

### New OpenStack SIG Launched by Kubernetes
Are you working on projects that involve both OpenStack and Kubernetes? You’ll want to join the new OpenStack SIG launched by Kubernetes, which coordinates the cross-community efforts of the two communities. Meetings occur every other Wednesday at 15:00 UTC.

More information: [https://github.com/kubernetes/community/tree/master/sig-openstack](https://github.com/kubernetes/community/tree/master/sig-openstack)

### Virtual RDO Quarterly Meetup
In a recent thread, David Moreau Simard (dmsimard) suggested a virtual RDO meetup. We’re exploring the idea of hosting the first one in February or March. Interested in speaking or helping organize? Reach out to Rich Bowen for more information, or follow up on this thread: [https://lists.rdoproject.org/pipermail/users/2017-November/000061.html](https://lists.rdoproject.org/pipermail/users/2017-November/000061.html)

### OpenStack PTG Videos
In case you missed it, here’s a playlist of interviews recorded at OpenStack PTG Denver: [https://www.youtube.com/playlist?list=PLOuHvpVx7kYm2b9tmpUJt8lC75fdDr4zx](https://www.youtube.com/playlist?list=PLOuHvpVx7kYm2b9tmpUJt8lC75fdDr4zx)

From Cinder and Vitrage to PackStack and containerization, there’s sure to be something to pique your interest.

Interested in recording a short video conversation about what you’re doing with RDO? Let Rich Bowen know or reply to this thread: [https://lists.rdoproject.org/pipermail/dev/2017-November/008393.html](https://lists.rdoproject.org/pipermail/dev/2017-November/008393.html)

Please subscribe to the [RDO Community](https://youtube.com/RDOcommunity) on YouTube -- we will be doing more interviews like this at future events.

## <a name="rdo"></a>RDO Changes
### images.rdoproject server Changes
In order to allow rdophase2 cache servers to have the time to download the images for caching purposes, we are stopping the automatic removal of all previous promoted images at each promotion. We'll change the cleanup process to delete images after a configurable threshold in days/images numbers.

More information: [https://lists.rdoproject.org/pipermail/dev/2017-October/008307.html](https://lists.rdoproject.org/pipermail/dev/2017-October/008307.html)

### Now Shipping python-virtualbmc in Newton
In order to facilitate fast-forward upgrades from Newton to Queens, we are now shipping python-virtualbmc in Newton.

More information: [https://lists.rdoproject.org/pipermail/dev/2017-October/008311.html](https://lists.rdoproject.org/pipermail/dev/2017-October/008311.html)

### Technical Sprints
There have been several sprints in the last few months and the team has accomplished a lot! Led by Arx Cruz, the team tackles a particular problem over a span of 2 weeks:
* [Sprint 1](https://trello.com/c/5FnfGByl/334-base-the-promotion-pipeline-of-upstream-phase1-and-phase2-on-dlrn-api-dlrn-links-containers-and-images) (ended Oct 10): Implement the Delorean API across TripleO and RDO in order to report job status and promotions
* [Sprint 2](https://trello.com/c/wyUOPIhP/377-ovb-migration-to-rdo-cloud-and-related-work) (ended Oct 25): Migrate a few OVB jobs from RH1 cloud to RDO cloud
* [Sprint 3](https://trello.com/c/aPuHTfo4/404-reproduce-of-upstream-ci-jobs-against-rdo-cloud-personal-tenant) (ended Nov 13): Reproduce upstream CI jobs against RDO cloud personal tenant in order to help our Ruck and Rover to reproduce CI issues.

The [most recent sprint](https://trello.com/c/fvLpZMF6/428-tech-debt?menu=filter&filter=label:Sprint%203%20%20(%20Oct%2026%20-%20Nov%208)) ended on Nov 29 and didn’t focus on a single task, but rather on fixing the technical debt created by previous sprints.

Interested in taking part in a future tech sprint or have an idea for a project? Contact [Arx Cruz](mailto:arxcruz@redhat.com).

## <a name="events"></a>Recent Events
### OpenStack Summit Recap
Many of you were able to join us in Sydney for the semi-annual [OpenStack Summit](https://www.openstack.org/summit/sydney-2017/). For those who weren’t, August Simonelli wrote a [fantastic wrap-up](http://redhatstackblog.redhat.com/2017/11/16/hooroo-australia-bids-farewell-to-incredible-openstack-summit/) about the RedHat presence and our experiences. Petr Kovar also wrote a great summary of the [OpenStack Summit Docs sessions](https://www.rdoproject.org/blog/2017/11/summary-openstack-summit-docs-sessions/).

We had a great gathering of RDO folks at the Pumphouse on Tuesday night ([watch the timelapse!](https://www.youtube.com/watch?v=n9L5U5LhAww)). We also said goodbye and good luck to Tom Fifield, OpenStack Community Manager on Wednesday as this was his [last OpenStack Summit](http://lists.openstack.org/pipermail/openstack/2017-October/045595.html).

Lastly, Rich had a chance to meet up with Emilien Macchi and talk to him about deploying TripleO in OpenStack Pike and Queens. Watch the video: [https://youtu.be/ot50Hdq--Do](https://youtu.be/ot50Hdq--Do)

### OpenStack Days France Recap (Nov 21)
350 people gathered two weeks ago at the second annual OpenStack Days France. Martin Andre has a [great recap of his talk](http://blog.mandre.org/2017/12/01/essential_tools_of_an_openstack_contributor.html) on his blog in case you missed it. Stay tuned for more recaps and videos to come on [openstack.fr](https://openstack.fr)

### Open Source Summit, Prague Recap
We had a very small presence at the Open Source Summit in Prague, Czechia, at the end of October. Rich has a brief writeup on the [RDO blog](https://rdoproject.org/blog/2017/11/open-source-summit-prague/).

### OpenStack India Recap
Chandan Kumar spoke about RDO at the recent OpenStack India half-day track within [Open Source India](https://opensourceindia.in/osidays/open-source-india-2017/). Couldn’t make it? Check out his slides for [Delivering a bleeding edge community-led OpenStack distribution - RDO](https://www.slideshare.net/ChandanKumar612/delivering-a-bleeding-edge-community-led-open-stack-distribution-rdo).


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
