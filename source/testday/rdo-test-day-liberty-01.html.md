---
title: RDO Liberty Test Day
---

# Liberty Test Day 1

We will be holding a RDO test day on September 23rd and 24th, 2015. 
This will be coordinated through the **#rdo channel on Freenode**, and 
through this website and the rdo-list mailing list.

We'll be testing the second Liberty milestone release. If you can do
any testing on your own ahead of time, that will help ensure that 
everyone isn't encountering the same problems.

Update this page by submitting pull requests to [this
repo](https://github.com/redhat-openstack/website).

## Prerequisites

We plan to have have packages for the following platforms:

* Fedora 22
* RHEL 7
* CentOS 7

You'll want a fresh install with latest updates installed. 
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

    cd /etc/yum.repos.d/
    sudo wget http://trunk.rdoproject.org/centos7-liberty/delorean-deps.repo
    sudo wget http://trunk.rdoproject.org/centos7-liberty/current-passed-ci/delorean.repo

* Check for any [workarounds](/testday/workarounds-liberty-01) required for your platform before the main installation
* For Packstack based deployment start at step 2 of the [packstack Quickstart](http://openstack.redhat.com/Quickstart#Step_2:_Install_Packstack_Installer)
* For RDO-Manager based installs, *doc goes here* **TODO**

### Test cases and results

The things that should be tested are listed on the [Tested Setups](/testday/testedsetups-liberty-01) page.

* Pick an item from the list
* Go through the scenario as though you were a beginner, just following the instructions. (Check the [workarounds](/testday/workarounds-liberty-01) page for problems that others may have encountered and resolved.)
* KEEP GOOD NOTES. You can use [the test day etherpad](https://etherpad.openstack.org/p/rdo_test_day_sep_2015) for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.
* Compare your results to the [rdoproject f22 CI report](http://trunk.rdoproject.org/f22/report.html)
* Execute the openstack test suite tempest @ [Testing Liberty using Tempest](/uncategorized/testing-liberty-using-tempest/)

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the 
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack), 
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](/testday/testedsetups-liberty-01) page, following the examples already there. Be sure to check the [Workarounds](/testday/workarounds-2015-01) page for things that may have already have fixes or workarounds.
