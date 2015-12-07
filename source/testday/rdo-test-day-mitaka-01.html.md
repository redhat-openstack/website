---
title: RDO Mitaka Test Day
---

# Mitaka Test Day 1

We will be holding a RDO test day on December 10th and 11th, 2015.
This will be coordinated through the **#rdo channel on Freenode**, and
through this website and the rdo-list mailing list.

We'll be testing the first Mitaka milestone release. If you can do
any testing on your own ahead of time, that will help ensure that
everyone isn't encountering the same problems.

We will also be available for people that want to try the stable
(Liberty) release.

Update this page by submitting pull requests to [this
repo](https://github.com/redhat-openstack/website).

## Prerequisites

We plan to have packages for the following platforms:

* RHEL 7
* CentOS 7

You'll want a fresh install with latest updates installed.
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

    yum -y install yum-plugin-priorities
    cd /etc/yum.repos.d/
    # for Centos 7 and RHEL 7
    sudo wget http://trunk.rdoproject.org/centos7-mitaka/delorean-deps.repo
    sudo wget http://trunk.rdoproject.org/centos7-mitaka/current-passed-ci/delorean.repo

* Check for any [workarounds](/testday/workarounds-mitaka-01) required for your platform before the main installation
* For Packstack based deployment start at step 2 of the [packstack Quickstart](/install/quickstart#Step_2:_Install_Packstack_Installer)
* For RDO Manager based deployments follow the documentation in the [RDO Manager liberty docs](https://repos.fedorapeople.org/repos/openstack-m/rdo-manager-docs/liberty/)

### Test cases and results

The things that should be tested are listed on the [Tested Setups](/testday/testedsetups-mitaka-01) page.

* Pick an item from the list
* Go through the scenario as though you were a beginner, just following the instructions. (Check the [workarounds](/testday/workarounds-mitaka-01) page for problems that others may have encountered and resolved.)
* KEEP GOOD NOTES. You can use [the test day etherpad](https://etherpad.openstack.org/p/rdo-test-days-mitaka-m1) for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.
* Compare your results to the [rdoproject f22 CI report](http://trunk.rdoproject.org/f22/report.html)
* Execute the openstack test suite tempest @ [Testing Liberty using Tempest](/uncategorized/testing-liberty-using-tempest/)

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](/testday/testedsetups-mitaka-01) page, following the examples already there. Be sure to check the [Workarounds](/testday/workarounds-mitaka-01) page for things that may have already have fixes or workarounds.
