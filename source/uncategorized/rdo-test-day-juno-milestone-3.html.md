---
title: RDO test day Juno milestone 3
authors: apevec, arif ali, avladu, cmyster, coolsvap, dron, eglynn, gszasz, mabrams,
  mloobo, nlevinki, nyechiel, pixelbeat, rbowen, tshefi, whayutin
wiki_title: RDO test day Juno milestone 3
wiki_revision_count: 29
wiki_last_updated: 2014-10-05
---

# RDO test day Juno milestone 3

We plan to hold a RDO test day on **October 1st and 2nd**, 2014. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the rdo-list mailing list.

We'll be testing the third Juno milestone release. If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

Quick Links:

*   [Quickstart](Quickstart)

## Who's Participating

*   rbowen - Wiki, IRC, testing (CentOS)
*   tshefi - IRC (RHEL 7)
*   arif-ali - IRC, packstack, allinone, (CentOS 7)
*   apevec - IRC, devel (CentOS7)
*   augol - IRC (RHEL 7)
*   ...

## Prerequisites

We plan to have have packages for the following platforms:

*   Fedora 20 and 21
*   EL7 (RHEL 7, CentOS 7)

You'll want a fresh install with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.)

... Other prerequisites go here, eg "before you start on CentOS 7, you need to ..."

## How To Test

    sudo yum install http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm

*   Check for any [ Workarounds](Workarounds) required for your platform before the main installation
*   For Packstack based deployment start at step 2 of -- <http://openstack.redhat.com/Quickstart#Step_2:_Install_Packstack_Installer>
*   For Foreman based deployment on RHEL & its derivatives, -- <http://openstack.redhat.com/Virtualized_Foreman_Dev_Setup>

### Test cases and results

**The things that should be tested are listed at [RDO_test_day_Juno_milestone_3_test_cases](RDO_test_day_Juno_milestone_3_test_cases).**

*   Pick an item from the list
*   Go through the scenario as though you were a beginner, just following the instructions. (Check the [ Workarounds](Workarounds) page for problems that others may have encountered and resolved.)
*   KEEP GOOD NOTES. You can use <https://etherpad.openstack.org/p/rdo_juno_test_day_sep_2014> for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.
*   Compare your results to the CI results @ <https://prod-rdojenkins.rhcloud.com/>
*   Execute the openstack test suite tempest @ [Testing IceHouse using Tempest](Testing IceHouse using Tempest)

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-packstack), [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder), [openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift), [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net) and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](TestedSetups) page, following the examples already there. Be sure to check the [ Workarounds](Workarounds) page for things that may have already have fixes or workarounds.
