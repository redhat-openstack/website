---
title: RDO Mitaka Test Day
---

[ ← Test Days](/testday)

# Mitaka GA Test

[ [test day etherpad][] | [Tested Setups][] ]

We will be holding a RDO test day on April 13-14, 2016.
This will be coordinated through the **#rdo channel on Freenode**, and
through this website and the [rdo-list](http://www.redhat.com/mailman/listinfo/rdo-list)
mailing list.

We'll be testing the Mitaka GA release. If you can do
any testing on your own ahead of time, that will help ensure that
everyone isn't encountering the same problems.

Update this page by submitting pull requests to the
[redhat-openstack/website repo](https://github.com/redhat-openstack/website),
or by clicking the **Edit on Github** banner at the top right.

1. toc
{:toc}

## Prerequisites

We plan to have packages for the following platforms:

* RHEL 7
* CentOS 7

You'll want a fresh install with latest updates installed.
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

Run the following commands as root.

* Install the `yum-plugin-priorities` package:

  ```
  yum -y install yum-plugin-priorities
  ```

  Note: for RHEL 7, the `yum-plugin-priorities` package is available in the Optional channel.

* For CentOS 7 and RHEL 7, install the required `.repo` files:

  ```
  cd /etc/yum.repos.d/
  curl -O http://trunk.rdoproject.org/centos7/delorean-deps.repo
  curl -O http://trunk.rdoproject.org/centos7/current-passed-ci/delorean.repo
  ```

* Check the [test day etherpad][] for any workarounds required for your platform before the main installation
* For Packstack based deployment start at step 2 of the [packstack Quickstart](/install/quickstart#Step_2:_Install_Packstack_Installer)
* For TripleO (Former RDO Manager) based deployments follow the documentation in the [TripleO docs](https://www.rdoproject.org/tripleo/)

### Test cases and results

The things that should be tested are listed on the [Tested Setups][] page.

* Pick an item from the list
* Go through the scenario as though you were a beginner, just following the instructions. (Check the [test day etherpad][] for problems that others may have encountered and resolved.)
* KEEP GOOD NOTES. You can use the [test day etherpad][] for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.
* Execute the openstack test suite tempest @ [Testing Liberty using Tempest](/uncategorized/testing-liberty-using-tempest/)

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

Once you have completed the tests, add your results to the table on the [Tested Setups][] page, following the examples already there. Be sure to check the [test day etherpad][] page for things that may have already have fixes or workarounds.


[test day etherpad]: https://etherpad.openstack.org/p/rdo-test-days-mitaka-ga
[Tested Setups]: /testday/mitaka/testedsetupsga
