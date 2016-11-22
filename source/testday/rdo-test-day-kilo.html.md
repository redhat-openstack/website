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

*   [Quickstart](/install/quickstart/)
*   [Workarounds](/testday/workarounds/)

**Note:** We are going to push **RDO-Manager** testing ahead a few more days to give us time to stabilize the Kilo repositories we depend on. The exact date will be announced on rdo-list but you can expect it to happen during the week of May 11.

## Who's Participating

*   rbowen - Wiki, IRC, testing (CentOS)
*   arif-ali - IRC, packstack AIO (CentOS)
*   pbrady - IRC, CentOS
*   bkopilov - Packstack AIO on RHEL 7.1 ,Automation coverage
*   itzikb - Wiki, IRC, testing (RHEL7.1)
*   tshefi - IRC, (RHEL7.1), cinder netapp iscsi
*   iovadia - IRC, (RHEL7.1)
*   yrabl - IRC, (RHEL7.1)
*   stoner - IRC, (CentOS 7.1) nova live migration
*   nyechiel - IRC, Neutron testing (CentOS 7.1)
*   berendt - IRC, Packstack Multi Node (CentOS 7.1)
*   ekuris - IRC ,Neutron testing (RHEL 7.1)
*   ajeain - IRC, Horizon, Packstack (RHEL 7.1)
*   mabrams - IRC, Packstack, Keystone (RHEL 7.1)
*   gchamoul - IRC, Packstack, testing (CentOS7.1, RHEL7.1)
*   panbalag - IRC, Packstack, testing (CentOS7.1, RHEL7.1)
*   hguemar - IRC, testing (CentOS 7.1)
*   weshay - IRC, testing (CentOS 7.1) RDO-Manager
*   jruzicka - IRC, `packstack --allinone` (CentOS 7.1)
*   verdurin - IRC, testing (CentOS 7.1)
*   yprokule - IRC, (RHEL 7.1) ceilometer
*   mpavlase - IRC, Fedora 21, Packstack AIO
*   ushkalim - IRC, RHEL 7.1, DIS IPv6 Packstack
*   rook - IRC, RHEL7.1, Packstack
*   shmcfarl- IRC, (CentOS7.1), Neutron, IPv6, L3 HA, Packstack, AIO/Multinode

## Prerequisites

We plan to have have packages for the following platforms:

*   EL7 (RHEL 7, CentOS 7)

You'll want a fresh install (or VM) with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.) 3GB RAM is the suggested minimum

## How To Test

    sudo yum install http://rdoproject.org/repos/openstack-kilo/rdo-testing-kilo.rpm

*   Check for any [Workarounds](/testday/workarounds/) required for your platform before the main installation
*   For Packstack based deployment start at step 2 of -- <https://www.rdoproject.org/Quickstart#Step_2:_Install_Packstack_Installer>
*   Install and run tempest:

<!-- -->

    sudo yum install openstack-tempest

    yum install -y gcc libxml2-devel libxslt-devel  python-devel openssl-devel python-testtools libffi-devel libffi
    pip install virtualenv 
    virtualenv /usr/share/openstack-tempest-kilo/.venv
    source /usr/share/openstack-tempest-kilo/.venv/bin/activate
    # install under virtual env
    pip install -r /usr/share/openstack-tempest-kilo/requirements.txt
    pip install -r /usr/share/openstack-tempest-kilo/test-requirements.txt
    # you are ready , its the time to configure tempest.conf

### Test cases and results

**[RDO_test_day_Kilo_RC_milestone_test_cases](/testday/rdo-test-day-kilo-rc-milestone-test-cases/)**

*   Pick an item from the list
*   Go through the scenario as though you were a beginner, just following the instructions. (Check the [Workarounds](/testday/workarounds/) page for problems that others may have encountered and resolved.)
*   KEEP GOOD NOTES. You can use <https://etherpad.openstack.org/p/rdo_kilo_test_day> for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-packstack), [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder), [openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift), [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net) and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](/testday/rdo-test-day-kilo-rc-milestone-test-cases/) page, following the examples already there. Be sure to check the [Workarounds](/testday/workarounds/) page for things that may have already have fixes or workarounds. Please also upload the tempest results to a public site and add the link to the test entry in [TestedSetups](/testday/rdo-test-day-kilo-rc-milestone-test-cases/) page.
