---
title: RDO Wallaby Test Day
---

# Wallaby Milestone3 Test Day

We will be holding a RDO test day on **XX and XX MONTH 2021.**

This will be coordinated through the **#rdo channel on Freenode**, and through this website and the [dev@lists.rdoproject.org](https://lists.rdoproject.org/mailman/listinfo/dev) mailing list.

We'll be testing the third [Wallaby milestone release](http://releases.openstack.org/wallaby/schedule.html). If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

We will also be available for people that want to try the stable (Victoria) release.

### Quick links

* [Test matrix](/testday/tests)
* [Workarounds](https://etherpad.openstack.org/p/rdo-test-days-wallaby3-workarounds)

## Prerequisites

We plan to have packages for the following platforms:

* [RHEL 8](https://access.redhat.com/products/red-hat-enterprise-linux/)
* [CentOS 8](https://www.centos.org/download/)

You'll want a fresh install with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.)

## How to test?

    $ cd /etc/yum.repos.d/
    $ sudo curl -L -O http://trunk.rdoproject.org/centos8/delorean-deps.repo
    $ sudo curl -L -O http://trunk.rdoproject.org/centos8/current-passed-ci/delorean.repo
    $ sudo dnf update -y

* These steps apply to both RHEL 8 and CentOS 8.

### Next steps

* Check for any [workarounds](https://etherpad.openstack.org/p/rdo-test-days-wallaby3-workarounds) required for your platform before the main installation.
* For a TripleO-based installation, try the [TripleO quickstart](https://www.rdoproject.org/tripleo/).
* For a Packstack-based deployment, start at step 2 of the [All-in-one quickstart](/install/packstack#Step_2:_Install_Packstack_Installer).

### Test cases and results

The scenarios that should be tested are listed on the [test matrix](/testday/tests) page. This will be copied to [https://etherpad.openstack.org/p/rdo-wallaby-m3-test-matrix](https://etherpad.openstack.org/p/rdo-wallaby-m3-test-matrix) the day of the test, for easier annotation during the event.

1. Pick an item from the list.
2. Go through the scenario as though you were a beginner, just following the instructions. (Check the [workarounds](https://etherpad.openstack.org/p/rdo-test-days-wallaby3-workarounds) page for problems that others may have encountered and resolved.)
3. **Keep good notes.** You can use [the test day etherpad](https://etherpad.openstack.org/p/rdo-test-days-wallaby-m3) for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on [https://etherpad.openstack.org/p/rdo-wallaby-m3-test-matrix](https://etherpad.openstack.org/p/rdo-wallaby-m3-test-matrix). Be sure to check the [workarounds](https://etherpad.openstack.org/p/rdo-test-days-wallaby3-workarounds) page for things that may have already have fixes or workarounds.
