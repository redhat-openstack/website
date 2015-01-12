---
title: 2015 January
authors: rbowen
wiki_title: Newsletters/2015 January
wiki_revision_count: 1
wiki_last_updated: 2015-01-12
---

# 2015 January

January 2015 RDO Community Newsletter

Thanks for being part of the RDO community.

2015 is already shaping up to be an exciting year for RDO, and for OpenStack in general. In this first newsletter of the year, we'd like to talk about some of what's coming this year.

Quick links:

*   Quick Start - <http://openstack.redhat.com/quickstart>
*   Mailing Lists - <https://openstack.redhat.com/Mailing_lists>
*   RDO packages - <https://repos.fedorapeople.org/repos/openstack/openstack-juno/>
*   RDO blog - <http://rdoproject.org/blog>
*   Q&A - <http://ask.openstack.org/>

<!-- -->

*   RDO and CentOS

We've been talking for a long time about the relationship between RDO and CentOS. CentOS is where you get the best experience with RDO, because it's where it's getting the most testing. It's the perfect platform to do your testing and proof of concept installs. Then, when you're ready to go to production, you can stick with CentOS, or, if you want a supported enterprise platform, the transition to RHEL is a is a simple one because of how close it is to Red Hat Enterprise Linux.

In the last few weeks of 2014, we strengthened that relationship with CentOS in several ways, largely as a result of conversations in Paris, at the OpenStack Summit in November.

The first of these shifts is that we've moved the CI (Continuous Integration) effort to the CentOS community, where we can get a wider involvement in the process from people outside of Red Hat. So, starting early this year, you'll find RDO testing happening on <http://ci.centos.org/> so that we're always certain that everything is working on this important platform.

Then, at our meeting in Paris, many people said that the packaging effort needed to be entirely in the open, whereas we'd been doing some of it "behind the wall" at Red Hat. So we're moving the RDO packaging effort into the CentOS CBS - the Community Build System. You can read more about the CBS at <http://wiki.centos.org/HowTos/CommunityBuildSystem> and you can read our documentation about packaging RDO at <http://openstack.redhat.com/packaging/> We need your feedback about this document, and your experiences as you try it out, so that we can improve that process, and get more people involved in packaging RDO.

And, as an umbrella for these efforts, we're working to create a Cloud Infrastructure SIG to coordinate the efforts of packaging OpenStack, and other cloud infrastructures, on the CentOS platform, as well as the interactions with other SIGs to ensure interoperability, so that people running CentOS can use all of these various things together seamlessly. You can read more about the Cloud SIG effort at <http://wiki.centos.org/SpecialInterestGroup/Cloud> and expect that to progress rapidly in the coming weeks and months.

*   Juno, Kilo, L___

In October 2014, OpenStack Juno was released, and the OpenStack Summit in Paris focuses on planning for the next release, code-named Kilo.

On April 30th, OpenStack Kilo will be released - <https://wiki.openstack.org/wiki/Kilo_Release_Schedule> - featuring many significant improvements that were planned at the OpenStack Summit in Paris. Starting in February of this year, expect a series of posts by various OpenStack engineers telling you what will be coming in Kilo.

Then, in May (18th - 22nd), we'll be gathering in Vancouver for the OpenStack Summit,/ where work will begin on the 'L' version. You'll find some preliminary information about the event at <https://www.openstack.org/summit/vancouver-2015/>

If you're looking for RDO enthusiasts, we'll be at lots of other events, too, including:

         * FOSDEM - `[`http://fosdem.org/`](http://fosdem.org/)` where we're hoping to find a room
           for an RDO community meetup. While you're there, drop by the
           CentOS table, and the OpenStack table, as well as the numerous
           other great community projects that will be represented. January
           31 and February 1, in Brussels, Belgium.

         * SCALE - The Southern California Linux Expo -
           `[`http://www.socallinuxexpo.org/scale13x`](http://www.socallinuxexpo.org/scale13x)` , February 19-22 in Los
           Angeles.

         * Meetups - there are dozens of OpenStack meetups every week,
           around the world. Some of these include deep technical content,
           while others are primarily social in nature. These informal
           gatherings are the best place to get together with other
           OpenStack enthusiasts and discuss the daily struggle. If you're
           presenting at a Meetup, please let me know so that I can help
           you get the word out to the community. And if you attend an
           OpenStack meetup, we'd like to hear about your experience, and
           what you learned. Find meetups in your area at
           `[`http://meetup.com/`](http://meetup.com/)` or look for our weekly meetup announcements
           on the rdo-list mailing list.

*   Ask.OpenStack.org

As you're no doubt aware, the very best place to ask questions about OpenStack is the site that says it in its name - <http://ask.openstack.org/> We've long encouraged RDO users to ask their questions there, because it gives a wider pool of experts to answer the questions. Also, since RDO is a packaging of OpenStack, without any changes or patches, most of the questions that you might ask about it are, in fact, questions about upstream OpenStack.

It's also a great way to sharpen your own expertise, by trying to answer the questions that you know something about, or identify questions that have already been answered, and direct the asker to the answer that's already been provided.

If you're interested in being on the list of people that I contact with unanswered questions, please let me know, along with what topics you'd like to be contacted for. This helps us get people's questions answered quickly without you having to check the site every day.

*   Keep in touch

There's lots of ways to stay in in touch with what's going in in the RDO community. The best ways are ...

       * Follow us on Twitter - `[`http://twitter.com/rdocommunity`](http://twitter.com/rdocommunity)` 
       * Google+ - `[`http://tm3.org/rdogplus`](http://tm3.org/rdogplus)` 
` * Facebook - `[`http://facebook.com/rdocommunity`](http://facebook.com/rdocommunity)
       * rdo-list mailing list - `[`http://www.redhat.com/mailman/listinfo/rdo-list`](http://www.redhat.com/mailman/listinfo/rdo-list)` 
       * This newsletter - `[`http://www.redhat.com/mailman/listinfo/rdo-newsletter`](http://www.redhat.com/mailman/listinfo/rdo-newsletter)` 
       * RDO Q&A - `[`http://ask.openstack.org/`](http://ask.openstack.org/)` 
       * IRC - #rdo on Freenode.irc.net

Finally, remember that the OpenStack User Survey is always open, so every time you deploy a new OpenStack cloud, go update your records at <https://www.openstack.org/user-survey/> so that, when Vancouver rolls around, we have a clearer picture of the OpenStack usage out in the wild.

Thanks again for being part of the RDO community!
