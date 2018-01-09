# January 2018 RDO Community Newsletter

## Quick links:


### In This Newsletter
* [Housekeeping Items](#housekeeping)
* [Community News](#community)
* [RDO Changes](#rdo)
* [Upcoming Events](#events)
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


Happy New Year, RDO Community! We hope your year is off to a great start.

## <a name="housekeeping"></a>Housekeeping Items
### Pony Mail
We’re excited to announce [Pony Mail](https://rdo.fsn.ponee.io/)! This new integration for the RDO mailing list means that if you want to send a particular thread to someone who isn’t on the mailing list, they’ll still be able to see it. Not only that, but once you’ve convinced them to join the mailing list via the usual routes (because who wouldn’t want to!) they’ll be able to take part in conversations that happened prior to their joining. Note: We expect this service to have a .rdoproject.org hostname in the near future.

Check it out: [rdo.fsn.ponee.io](https://rdo.fsn.ponee.io/)


## <a name="community"></a>Community News
### We Take Pride in Our Work
David Moreau Simard‏ (dmsimard) recently tweeted about the RDO Community and what we accomplish on a regular basis. From detailed stats about the jobs run in November to what it means to be a part of the RDO Community, it’s a good look at what we’ve accomplished together.

Full Twitter thread: [https://twitter.com/dmsimard/status/941845128599056386](https://twitter.com/dmsimard)


### What Made 2017 Awesome for RDO?
On that note, Chandan Kumar is planning to write a blogpost about all of the awesome things that happened in and through the RDO community in 2017. He’s looking for help from you to put it together. Here are some questions to get you thinking about this past year:

* What good things have happened this year and what needs to be improved?
* If someone helped you in some way, feel free to drop a comment about
that, and what you appreciate.
* If you have photos from some RDO gathering, please share those

Got something to say? Reply to this thread: [https://rdo.fsn.ponee.io/thread.html/1e8105a4c9bc869d1d2754f1cf307c7b342abf5b7a89ffcde8f2832c@%3Cdev.lists.rdoproject.org%3E](https://rdo.fsn.ponee.io/thread.html/1e8105a4c9bc869d1d2754f1cf307c7b342abf5b7a89ffcde8f2832c@%3Cdev.lists.rdoproject.org%3E)


### OpenStack Possibly Moving to a 1-Year Release Schedule
Buckle up… this [discussion thread](http://lists.openstack.org/pipermail/openstack-dev/2017-December/125473.html) is intense (and long). TL;DR: Thierry Carrez, Release Manager for the OpenStack Project, has proposed a change from the long-standing 6 month release schedule. The change would involve having one coordinated release of the OpenStack components per year, and maintaining one stable branch per year. Take a look at the discussion thread to follow along with the full conversation. A final decision will be made by the Technical Committee.

Discussion Thread: [http://lists.openstack.org/pipermail/openstack-dev/2017-December/125473.html](http://lists.openstack.org/pipermail/openstack-dev/2017-December/125473.html)


### Intel & Bitergia Take a Closer Look at Gender Diversity in OpenStack
Intel and Bitergia just released the second version of the OpenStack community gender diversity report. This study covers two new sections: attendees representation and non-technical contributions, adding to the already indepth study of leadership, governance, and technical contributions.

Article: [http://superuser.openstack.org/articles/gender-diversity-report_v2_openstack/](http://superuser.openstack.org/articles/gender-diversity-report_v2_openstack/)
PDF Report: [http://superuser.openstack.org/wp-content/uploads/2017/12/Gender-Diversity-Analysis-in-the-OpenStack-Community-2017-S2.pdf](http://superuser.openstack.org/wp-content/uploads/2017/12/Gender-Diversity-Analysis-in-the-OpenStack-Community-2017-S2.pdf)


### Community Meetings
Every Wednesday at 15:00 UTC, we have the weekly RDO community meeting on the #RDO channel on Freenode IRC. The agenda for this meeting is posted each week in a [public etherpad](https://etherpad.openstack.org/p/RDO-Meeting) and the minutes from the meeting are posted [on the RDO website](https://www.rdoproject.org/community/community-meeting/). If there's something you'd like to see happen in RDO - a package that is missing, a tool that you'd like to see included, or a change in how things are governed - this is the best time and place to help make that happen.


## <a name="rdo"></a>RDO Changes
### Queens Milestone 2 Test Day Recap (Dec 14-15)
As you’ll remember from last month’s newsletter, the Q2 test day was a new start, and you’ll want to mark your calendar for [the next one](https://www.rdoproject.org/testday/).  In the past, we’ve struggled to get people to participate in test day because of the enormous barrier to entry -- not only do you need sufficient hardware to deploy OpenStack, you need the time and patience to get it to work. So in December we took that part off the table by providing a test cloud running the Q2 RDO release. This gave a way to participate in the functional testing without the drudgery of deployment.

We’re pleased to report that this resulted in better than usual turnout, and a higher than usual number of new issues opened during the testing. You can read up on who participated, what they tested, and the tickets that were opened, in [the test day wiki](https://etherpad.openstack.org/p/rdo-queens-m2-cloud).

We’ll continue this plan for the coming test days. Watch the RDO mailing lists for announcements of when you can sign up for service credentials.


### TripleO CI Sprints
**November 29** - The focus of this sprint was to reduce the tech debt generated by the other sprints as a way to reduce the work of the Ruck and Rover. At the end of the sprint, the team was able to successfully complete 10 cards. 4 others were pending review, and only 4 cards remained untouched in technical debt. You can see the results of the sprint here: [https://tinyurl.com/y8wwntvc](https://tinyurl.com/y8wwntvc).

**December 13** - The goal of this sprint was to make it easy to developers reproduce CI jobs on their own RDO Cloud. The epic task with more information can be found here: [https://trello.com/c/EWotWxGe](https://trello.com/c/EWotWxGe) You can see the progress that was made during this sprint in Trello here: [https://tinyurl.com/ycs4qelu](https://tinyurl.com/ycs4qelu).

**January 3** - Given the holidays, this tech debt sprint didn’t have specific goals associated with it, but the team worked toward closing tickets as they had time. You can see the results of the sprint here: [https://trello.com/c/fvLpZMF6/428-tech-debt](https://trello.com/c/fvLpZMF6/428-tech-debt).

Thanks to the team for continuing with these sprints! The amount of work that’s being accomplished is impressive and encouraging.

Interested in taking part in a future tech sprint or have an idea for a project? Contact [Arx Cruz](mailto:arxcruz@redhat.com).


## <a name="events"></a>Upcoming Events
There are two major events on the horizon that you should be aware of:


### RDO Presence @ DevConf
Per usual, we’ll have a significant presence at [DevConf.cz](https://devconf.cz/), Jan 26-28, in Brno, Czechia. Red Hat has a large office there, and it’s where many of our OpenStack engineers live and work. Many of them will be at DevConf demoing TripleO, RDO, and ManageIQ on the project’s NUC mini-cluster. [Register today](http://bit.ly/devconfcz-18-registration), and come with your questions. Registration is free.


### FOSDEM Volunteers
Going to be at FOSDEM in February? We’re still looking for folks to help out at the RDO booth! For more information and to sign up, see the Etherpad: [https://etherpad.openstack.org/p/fosdem-2018](https://etherpad.openstack.org/p/fosdem-2018).

Other RDO events, including the many OpenStack meetups around the world, are always listed on the [RDO events page](http://rdoproject.org/events).
If you have an RDO-related event, please feel free to add it by submitting a pull request [on Github](https://github.com/OSAS/rh-events/blob/master/2016/RDO-Meetups.yml).


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
