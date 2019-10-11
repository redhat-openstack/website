---
title: RDO Ussuri Test Day
---

# Ussuri Milestone1 Test Day

We will be holding a RDO test day on **19 and 20 December 2019.**

This will be coordinated through the **#rdo channel on Freenode**, and through
this website and the [dev@lists.rdoproject.org](https://lists.rdoproject.org/mailman/listinfo/dev) mailing list.

We'll be testing the first [Ussuri milestone release](http://releases.openstack.org/ussuri/schedule.html). If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

We will also be available for people that want to try the stable (Rocky) release.

### Quick links

* [Test matrix](/testday/tests)
* [Workarounds](https://etherpad.openstack.org/p/rdo-test-days-ussuri1-workarounds)

## Prerequisites

We plan to have packages for the following platforms:

* [RHEL 7](https://access.redhat.com/products/red-hat-enterprise-linux/)
* [CentOS 7](https://www.centos.org/download/)

You'll want a fresh install with latest updates installed.
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How to test?

    $ yum -y install yum-plugin-priorities
    $ cd /etc/yum.repos.d/
    $ sudo curl -O http://trunk.rdoproject.org/centos7/delorean-deps.repo
    $ sudo curl -O http://trunk.rdoproject.org/centos7/current-passed-ci/delorean.repo
    $ sudo yum update -y

* These steps apply to both RHEL 7 and CentOS 7.

### Next steps

* Check for any [workarounds](https://etherpad.openstack.org/p/rdo-test-days-ussuri1-workarounds) required for your platform before the main installation.

* For a TripleO-based installation, try the [TripleO quickstart](https://www.rdoproject.org/tripleo/).

* For a Packstack-based deployment, start at step 2 of the [All-in-one quickstart](/install/packstack#Step_2:_Install_Packstack_Installer).

### Test cases and results

The scenarios that should be tested are listed on the [test matrix](/testday/tests) page. This will be copied to [https://etherpad.openstack.org/p/rdo-ussuri-m1-test-matrix](https://etherpad.openstack.org/p/rdo-ussuri-m1-test-matrix) the day of the test, for easier annotation during the event.

1. Pick an item from the list.
2. Go through the scenario as though you were a beginner, just following the instructions. (Check the [workarounds](https://etherpad.openstack.org/p/rdo-test-days-ussuri1-workarounds) page for problems that others may have encountered and resolved.)
3. **Keep good notes.** You can use [the test day etherpad](https://etherpad.openstack.org/p/rdo-test-days-ussuri-m1) for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on [https://etherpad.openstack.org/p/rdo-ussuri-m1-test-matrix](https://etherpad.openstack.org/p/rdo-ussuri-m1-test-matrix). Be sure to check the [workarounds](https://etherpad.openstack.org/p/rdo-test-days-ussuri1-workarounds) page for things that may have already have fixes or workarounds.
