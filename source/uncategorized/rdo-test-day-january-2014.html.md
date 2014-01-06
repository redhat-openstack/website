---
title: RDO test day January 2014
authors: adarazs, admiyo, amuller, cgirda, dbaxps, derez, dneary, dron, edu, eglynn,
  eharney, eyepv6, flaper87, gfidente, gparisse, gszasz, ihrachys, jary, jbernard,
  jistr, jpichon, jruzicka, kashyap, krwhitney, larsks, mbourvin, mjs, mpavlase, mrhodes,
  mrunge, ndipanov, nmagnezi, oblaut, ohochman, panda, pixelbeat, rbowen, rlandy,
  shardy, tkammer, verdurin, vladan, whayutin, yeylon, yrabl, zaitcev
wiki_title: RDO test day January 2014
wiki_revision_count: 80
wiki_last_updated: 2014-02-19
---

# RDO test day January 2014

We will be holding a RDO test day on January 7th and 8th, 2014. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the [rdo-list mailing list](http://www.redhat.com/mailman/listinfo/rdo-list).

We'll be testing the first Icehouse milestone release, and we'd like to test the scenarios enumerated below. If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

## Who's Participating

*Add your name, and how you're able to help out*

*   rbowen (Rich Bowen) - Testing, IRC, Documentation
*   Dafna (Dafna Ron) - Testing smi-deployed system with gluster backend for cinder and glance, IRC
*   yrabl (Yogev Rabl) - Testin Fully deployed system with Guster backend for cinder, IRC
*   tshefi (Tzach Shefi) - Testin Fully deployed system with local swift backend for Glance, IRC
*   gfidente (Giulio Fidente) - Testing Fuly depolyed system with EMC backend for cinder, IRC
*   oblaut(Ofer Blaut) - Testing Network components, IRC
*   yfried (Yair Fried) - Testing Network components, IRC
*   nmagnezi (Nir Magnezi) - Testing Network and Core components, IRC
*   amuller (Assaf Muller) - Testing network components, IRC
*   ajeain (Ami Jeain) - Testing Core components, IRC
*   ohochman (Omri Hochman) - Testing Foreman and Core components, IRC
*   ukalifon (Udi Kalifon ) - Testing Core components, IRC
*   dkorn (Daniel Korn ) - Testing Core components, IRC
*   yeylon (Yaniv Eylon) - Testing Foreman and Core components, IRC
*   dneary (Dave Neary) - Testing install of all in one and 2 node set-up in virt-manager instances
*   eharney (Eric Harney) - Testing Cinder, IRC
*   flaper87 (Flavio Percoco) - Testing Glance All-in-One: different Glance drivers only, IRC

## Prerequisite for Test Day

We'll have packages for the following platforms:

*   Fedora 20
*   RHEL 6.5
*   CentOS 6
*   CentOS 6.5

You'll want a fresh install with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

    sudo yum install http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

*   For Packstack based deployment start at step 2 of -- <http://openstack.redhat.com/Quickstart>
*   For Foreman based deployment on RHEL & its derivatives, -- <http://openstack.redhat.com/Virtualized_Foreman_Dev_Setup>

### Test cases and results

The things that should be tested are listed on the [Tested Setups](TestedSetups_2014_01) page.

*   Pick an item from the list
*   Go through the scenario as though you were a beginner, just following the instructions. (Check the [ Workarounds](Workarounds_2014_01) page for problems that others may have encountered and resolved.)
*   KEEP GOOD NOTES. You can use <https://etherpad.openstack.org/p/rdo_test_day_jan_2014> for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-packstack), [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder), [openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-neutron),[openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift) or [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net) and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](TestedSetups_2014_01) page, following the examples already there. Be sure to check the [ Workarounds](Workarounds_2014_01) page for things that may have already have fixes or workarounds.

## Blogs, Screencasts

We strongly encourage you to write narrative blogs about your test experiences, whether this is about the test day itself, or a howto style post about a particular install/test scenario. Link to those posts here.

Also, if you'd like to do an audio interview for a podcast about this event, please contact Rich Bowen (rbowen at redhat dot com) to set something up.

Use something like [RecordMyDesktop](http://recordmydesktop.sourceforge.net/about.php) to record a screencast of your tests, and let me (rbowen) know if you have any video that you think would make useful HowTo videos.
