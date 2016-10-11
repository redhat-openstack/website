---
title: RDO Newton GA Test Day
---

# Newton GA test day

We will be holding a RDO test day on October 13th and 14th, 2016.

This will be coordinated through the **#rdo channel on Freenode**, and
through this website and the [rdo-list](https://www.redhat.com/mailman/listinfo/rdo-list) mailing list.

We'll be testing the [Release Newton GA release packages](http://releases.openstack.org/newton/schedule.html). If you can do
any testing on your own ahead of time, that will help ensure that
everyone isn't encountering the same problems.

### Quick links:

* [Test scenarios](https://etherpad.openstack.org/p/rdo-newton-ga-testday-testplan)
* [Known workarounds](https://etherpad.openstack.org/p/rdo-newton-ga-testday-workarounds)

## Prerequisites

We plan to have packages for the following platforms:

* [RHEL 7](https://access.redhat.com/products/red-hat-enterprise-linux/)
* [CentOS 7](https://www.centos.org/download/)

You'll want a fresh install with latest updates installed.
(Fresh so that there's no hard-to-reproduce interactions with other things.)

## How to test?

### Summary for the impatient

    $ sudo yum -y install https://rdoproject.org/repos/openstack-newton/rdo-release-newton.rpm

* Check for any [known workarounds](https://etherpad.openstack.org/p/rdo-newton-ga-testday-workarounds) required for your platform before the main installation.

[//]: # * For Packstack make sure you set `CONFIG_ENABLE_RDO_TESTING=y` in your answer file, or that you use the `--enable-rdo-testing=y` command-line argument.

### Using the Packstack installer

Assuming you have a VM running [CentOS 7](https://www.centos.org/download/) or [RHEL 7](https://access.redhat.com/products/red-hat-enterprise-linux/), follow these steps.

1. Install the `rdo-release-newton` package:

       $ sudo yum -y install https://rdoproject.org/repos/openstack-newton/rdo-release-newton.rpm

2. Update your VM and reboot:

       $ sudo yum -y update

3. Install the `openstack-packstack` package:

       $ sudo yum install -y openstack-packstack

4. Run the Packstack installer:

       $ packstack --allinone

[//]: # 4. Run the Packstack installer by enabling the RDO testing repo:

[//]: #        $ packstack --enable-rdo-testing=y --allinone

For additional information, see the [Packstack quickstart](/install/quickstart#Step_2:_Install_Packstack_Installer).

### Using TripleO

For TripleO-based installs, try the [TripleO quickstart](/tripleo/).

See also the [baremetal deployment docs](http://images.rdoproject.org/docs/baremetal/) and [(minimal) virt deployment docs](http://images.rdoproject.org/docs/virt/) for the TripleO quickstart. Ping hrybacki on IRC for questions or comments.

## Test cases and results

The scenarios we want to test are listed in the [test matrix
etherpad](https://etherpad.openstack.org/p/rdo-newton-ga-testday-testplan).
Please update that with scenarios that you think we should be testing.

1. Pick an item from the list.
1. Go through the scenario as though you were a beginner, just following the instructions. (Check the [known workarounds](https://etherpad.openstack.org/p/rdo-newton-ga-testday-workarounds) page for problems that others may have encountered and resolved.)
1. **Keep good notes.** Update the [test matrix](https://etherpad.openstack.org/p/rdo-newton-ga-testday-testplan) with your results, comments, and any tickets that you open.

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the
[openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-packstack),
[openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder),
[openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift),  [python-django-horizon](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=python-django-horizon), [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net)  and we will help you.

