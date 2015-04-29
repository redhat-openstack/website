---
title: RDO test day Kilo
authors: apevec, arifali, berendt, bkopilov, ekuris, eyepv6, hguemar, iovadia, itzikb,
  jcoufal, jruzicka, jtaleric, mabrams, mpavlase, nyechiel, panbalag, pixelbeat, rbowen,
  stoner, strider, tshefi, ushkalim, verdurin, whayutin, yprokule, yrabl
wiki_title: RDO test day Kilo
wiki_revision_count: 53
wiki_last_updated: 2015-05-06
---

# RDO test day Kilo

We plan to hold a RDO test day on **May 5th and 6th**, 2015. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the rdo-list mailing list.

We'll be testing the Kilo release. If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

Quick Links:

*   [Quickstart](Quickstart)
*   [Workarounds](Workarounds)

## Who's Participating

*   rbowen - Wiki, IRC, testing (CentOS)

## Prerequisites

We plan to have have packages for the following platforms:

*   Fedora 21
*   EL7 (RHEL 7, CentOS 7)

You'll want a fresh install (or VM) with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.)

... Other prerequisites go here, eg "before you start on CentOS 7, you need to ..."

## How To Test

    sudo yum install http://rdoproject.org/repos/openstack/openstack-kilo/rdo-release-kilo.rpm

*   Check for any [ Workarounds](Workarounds) required for your platform before the main installation
*   For Packstack based deployment start at step 2 of -- <http://openstack.redhat.com/Quickstart#Step_2:_Install_Packstack_Installer>

### Test cases and results

**[RDO_test_day_Kilo_RC_milestone_test_cases](RDO_test_day_Kilo_RC_milestone_test_cases)**

*   Pick an item from the list
*   Go through the scenario as though you were a beginner, just following the instructions. (Check the [ Workarounds](Workarounds) page for problems that others may have encountered and resolved.)
*   KEEP GOOD NOTES. You can use <https://etherpad.openstack.org/p/rdo_kilo_test_day> for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-packstack), [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder), [openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift), [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net) and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](RDO_test_day_Kilo_RC_milestone_test_cases) page, following the examples already there. Be sure to check the [ Workarounds](Workarounds) page for things that may have already have fixes or workarounds.
