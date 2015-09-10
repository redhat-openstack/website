---
title: Package announce - Havana RC1 updates available in RDO
date: 2013-10-11 11:32:52
author: rbowen
---

(Via Pádraig Brady - see original mail thread at https://www.redhat.com/archives/rdo-list/2013-October/msg00046.html )

The full Havana RC1 package set is now available in the RDO repos,
for both el6 distros and Fedora 19.  Instructions to get started
with these repos are at: http://openstack.redhat.com/QuickStartLatest

In this release we have:

<pre>
openstack-swift-1.10.0-0.1.rc1
openstack-ceilometer-2013.2-0.12.rc1
openstack-keystone-2013.2-0.14.rc1
openstack-glance-2013.2-0.12.rc1
openstack-nova-2013.2-0.23.rc1
openstack-cinder-2013.2-0.11.rc1
python-django-horizon-2013.2-0.12.rc1
openstack-neutron-2013.2-0.12.rc1
openstack-heat-2013.2-0.9.rc1
</pre>

also these set of client packages:

<pre>
python-ceilometerclient-1.0.3-1
python-cinderclient-1.0.6-1
python-glanceclient-0.10.0-1
python-heatclient-0.2.4-1
python-keystoneclient-0.3.2-6
python-neutronclient-2.3.1-1
python-novaclient-2.15.0-1
python-swiftclient-1.7.0-1
python-troveclient-0.1.4-3
</pre>

Since these packages follow upstream development very closely,
the best list of changes from the existing milestone releases
that were already packaged in the RDO repos, can be seen at:
https://launchpad.net/openstack/+milestone/havana-rc1

A couple of support package updates worth mentioning are:

python-oslo-config-1.2.0-0.5.a3
 which now supports a more logical separation of
 distribution specific config and user specific config.

selinux-policy-3.7.19-216
 which now supports the quantum -> neutron renaming
 performed within the Havana cycle.