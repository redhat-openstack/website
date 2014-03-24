---
title: RDO test day Icehouse milestone 3
authors: ajeain, bkopilov, cmyster, iovadia, lon, nlevinki, nmagnezi, ohochman, rbowen,
  rlandy, tshefi, ukalifon, yeylon, yrabl
wiki_title: RDO test day Icehouse milestone 3
wiki_revision_count: 22
wiki_last_updated: 2014-03-25
---

# RDO test day Icehouse milestone 3

**Due to build system failures, we are rescheduling the test day for March 25th and 26th.**

We plan to hold a RDO test day on March 25th and 26th, 2014. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the rdo-list mailing list.

We'll be testing the second Icehouse milestone release. If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

Quick Links:

*   Test Day App - <http://testdays.qa.fedoraproject.org/testdays/show_event?event_id=16>
*   Test cases - <https://fedoraproject.org/wiki/Test_Day:2014-03-19_RDOMetadata>
*   [Quickstart](Quickstart)

## Who's Participating

*   rbowen - Wiki, IRC, testing (CentOS)
*   yeylon - IRC, testing foreman installation with rhel7
*   ohochman - IRC, OpenStack- Foreman-Installer, Nova .
*   ajeain - IRC, OpenStack-Horizon, Nova
*   augol / cmyster - IRC OpenStack Heat, Fedora20
*   nlevinki - foreman installation with rhel7, Swift
*   iovadia - IRC, OpenStack-Horizon on RHEL7
*   ukalifon - OpenStack-Keystone
*   tshefi - IRC, Openstack , RHEL7, Glance
*   rlandy - TripleO, Tuskar
*   bkopilov - IRC, OpenStack - LVM , RHEL 6.5

## Prerequisites

We plan to have have packages for the following platforms:

*   Fedora 20
*   RHEL 6.5
*   RHEL 7 beta
*   CentOS 6.5

You'll want a fresh install with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

    sudo yum install http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

*   Check for any [ Workarounds](Workarounds_2014_02) required for your platform before the main installation
*   For Packstack based deployment start at step 2 of -- <http://openstack.redhat.com/Quickstart#Step_2:_Install_Packstack_Installer>
*   For Foreman based deployment on RHEL & its derivatives, -- <http://openstack.redhat.com/Virtualized_Foreman_Dev_Setup>

### Test cases and results

The things that should be tested are listed in the [test day app](http://testdays.qa.fedoraproject.org/testdays/show_event?event_id=16).

*   Pick an item from the list
*   Go through the scenario as though you were a beginner, just following the instructions. (Check the [ Workarounds](Workarounds_2014_01) page for problems that others may have encountered and resolved.)
*   KEEP GOOD NOTES. You can use <https://etherpad.openstack.org/p/rdo_test_day_feb_2014> for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.
*   Compare your results to the CI results @ <https://prod-rdojenkins.rhcloud.com/>
*   Enter your results in the test day app by clicking the 'Enter Result' link.
*   Execute the openstack test suite tempest @ [Testing IceHouse using Tempest](Testing IceHouse using Tempest)

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-packstack), [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder), [openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift), [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net) and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](TestedSetups_2014_02) page, following the examples already there. Be sure to check the [ Workarounds](Workarounds_2014_01) page for things that may have already have fixes or workarounds.
