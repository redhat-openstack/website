---
title: RDO Newton Test Day
---

# Newton RC Test Day

We will be holding a RDO test day on September 29th and 30th, 2016

This will be coordinated through the **#rdo channel on Freenode**, and
through this website and the rdo-list mailing list.

We'll be testing the [Release Candidate for 
Newton](http://releases.openstack.org/newton/schedule.html). If you can do
any testing on your own ahead of time, that will help ensure that
everyone isn't encountering the same problems.

We will also be available for people that want to try the stable
(Mitaka) release.

Update this page by submitting pull requests to [this
repo](https://github.com/redhat-openstack/website).

## Prerequisites

We plan to have packages for the following platforms:

* RHEL 7
* CentOS 7

You'll want a fresh install with latest updates installed.
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

    yum -y install https://rdoproject.org/repos/openstack-newton/rdo-release-newton.rpm

* For Packstack make sure you set CONFIG_ENABLE_RDO_TESTING=y in your answer file, or that you use the –enable-rdo-testing=y command-line argument.
* Check for any [workarounds](/testday/newton/workarounds_rc) required for your platform before the main installation
* For Packstack based deployment start at step 2 of the [packstack Quickstart](/install/quickstart#Step_2:_Install_Packstack_Installer)
* For a TripleO-based installs, try the [TripleO quickstart](https://www.rdoproject.org/tripleo/).
* See also the [baremetal deployment
  docs](http://images.rdoproject.org/docs/baremetal/) and [(minimal)
  virt deployment docs](http://images.rdoproject.org/docs/virt/) for the
  TripleO Quickstart. (Ping hrybacki on IRC for questions/comments.)

### Test cases and results

The things that should be tested are listed on the [Tested Setups](/testday/newton/testedsetups_rc) page.

* Pick an item from the list
* Go through the scenario as though you were a beginner, just following the instructions. (Check the [workarounds](/testday/newton/workarounds_rc) page for problems that others may have encountered and resolved.)
* KEEP GOOD NOTES. You can use [the test day etherpad](https://etherpad.openstack.org/p/rdo-test-days-newton-rc) for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](/testday/newton/testedsetups_rc) page, following the examples already there. Be sure to check the [Workarounds](/testday/newton/workarounds_rc) page for things that may have already have fixes or workarounds.
