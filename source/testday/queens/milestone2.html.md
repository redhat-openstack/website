---
title: RDO Queens Test Day
---

# Queens Test Day 2

We will be holding a RDO test day on **December 14th and 15th, 2017.**

This will be coordinated through the **#rdo channel on Freenode**, and
through this website and the [rdo-list](https://www.redhat.com/mailman/listinfo/rdo-list) mailing list.

We'll be testing the second [Queens milestone
release](http://releases.openstack.org/queens/schedule.html). If you can do
any testing on your own ahead of time, that will help ensure that
everyone isn't encountering the same problems.

We will be hosting a test installation of OpenStack Queens, for those
who don't want to (or don't have the resources to) spin up your own
cloud. Details of this test cloud may be found [in this
etherpad](https://etherpad.openstack.org/p/rdo-queens-m2-cloud)

### Quick links

* [Test matrix](/testday/tests)
* [Workarounds](/testday/queens/workarounds2)

## Prerequisites

We plan to have packages for the following platforms:

* [RHEL 7](https://access.redhat.com/products/red-hat-enterprise-linux/)
* [CentOS 7](https://www.centos.org/download/)

You'll want a fresh install with latest updates installed.
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How to test?

There are two ways to test. 

### Test on our test cloud.

You can test OpenStack on our [test
cloud](https://etherpad.openstack.org/p/rdo-queens-m2-cloud). Read more
about it on [David's
blog](https://dmsimard.com/2017/11/29/come-try-a-real-openstack-queens-deployment/).

### Test on your own hardware

You can deploy OpenStack yourself, on your
own hardware:

    $ yum -y install yum-plugin-priorities
    $ cd /etc/yum.repos.d/
    $ sudo curl -O https://trunk.rdoproject.org/centos7/delorean-deps.repo
    $ sudo curl -O https://trunk.rdoproject.org/centos7/current-passed-ci/delorean.repo
    $ sudo yum update -y

* These steps apply to both RHEL 7 and CentOS 7.

### Next steps

* Check for any [workarounds](/testday/queens/workarounds2) required for your platform before the main installation.

* For a TripleO-based installation, try the [TripleO quickstart](https://www.rdoproject.org/tripleo/).

* For a Packstack-based deployment, start at step 2 of the [All-in-one quickstart](/install/packstack#Step_2:_Install_Packstack_Installer).

### Test cases and results

The scenarios that should be tested are listed on the [test matrix](/testday/tests) page. This will be copied to an etherpad the day of the test, for easier annotation during the event.

2. Pick an item from the list.
1. Go through the scenario as though you were a beginner, just following the instructions. (Check the [workarounds](/testday/queens/workarounds2) page for problems that others may have encountered and resolved.)
1. **Keep good notes.** You can use [the test day etherpad](https://etherpad.openstack.org/p/rdo-test-days-queens-m2) for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on the [test matrix](/testday/tests) page, following the examples already there. Be sure to check the [workarounds](/testday/queens/workarounds2) page for things that may have already have fixes or workarounds.
