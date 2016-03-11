---
title: TestedSetups Mitaka 1
authors: rbowen
---

# Test cases for Mitaka Milestone 3 test day

Tested Setups for [RDO test day Mitaka 3](/testday/mitaka/milestone3),
March 10-11, 2016.

See also the [workarounds page](/testday/mitaka/workarounds3).

Some steps from the official Quickstart guide
do not apply to Mitaka; make sure to follow the steps described in the
[How To Test](/testday/mitaka/milestone3#how-to-test) page instead.

For convenience, during the test day, please feel free to use [the test
day etherpad](https://etherpad.openstack.org/p/rdo-test-days-mitaka-m3),
which we'll use to periodically update this page.

1. toc
{:toc}

## Example Entry

Here's how you might fill out an entry once you've tested it. Mark a given test "Good" or "Fail", as appropriate, and link to any tickets that you've opened as a result, and to any place where you've written up your test notes. Mark as Workaround if you have a failure but can get past it. Link to your writeup of the workaround.

| Config Name                                                    | Release          | BaseOS    | Status                                       | HOWTO                                               | Who    | Date       | BZ/LP                                                              | Notes Page |
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One w/ Neutron OVS (no tunnels, fake bridge) Networking | Grizzly 2013.1.3 | RHEL 6.4  | <span style="background:#00ff00">Good</span> | [Neutron-Quickstart](Neutron-Quickstart) | pmyers | 2013-09-08 | None                                                               | None       |
|                                                                |                  | Fedora 19 | <span style="background:#ff0000">FAIL</span> | [Neutron-Quickstart](Neutron-Quickstart) | rbowen | 2013-10-09 | ~~[1017421](https://bugzilla.redhat.com/show_bug.cgi?id=1017421)~~ | None       |


## Packstack Based Installation (Neutron Networking)

Please make sure to use the steps described in the [How To Test](/testday/mitaka/milestone3#how-to-test)  when installing the base RDO system. Do not go through the Quickstart steps unmodified which will instead give you an RDO Liberty deployment. 

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One - Sanity |  | CentOS 7.2 | <span style="background:#00ff00">Good</span>  | [How To Test](/testday/mitaka/milestone3#how-to-test) | |    |    | 
|                     | Mitaka | RHEL 7.2  | <span style="background:#00ff00">Good</span>  | [How To Test](/testday/mitaka/milestone3#how-to-test) | leanderthal | 2016-03-10 | None | [Notes](http://groningenrain.nl/all-your-repos-are-belong-to-us/) 
| Distributed -IPv6-Deployment- Sanity |  |  CentOS 7.2 |  |[How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
|                                      |  | RHEL 7.2   |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  |
| Distributed -ML2- OVS-VXLAN –  LbaaS | | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
|                                      | | RHEL 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
| Distributed -ML2- OVS-VXLAN-VRRP     | | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
| | | RHEL7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   | | 
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS | | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |  |  | 
| | | RHEL7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) | |  |  | 
| Distributed -ML2-OVS- VXLAN Security Groups | | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
| | | RHEL7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |zgreenbe  |   | | 
| Distributed -ML2-OVS- VXLAN DVR | | RHEL 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | |   |  | 
| Distributed -ML2-OVS- VXLAN DVR | | CentOS 7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |   |  |  | 
| 3,node  -ML2-OVS- VXLAN |  | CentOS 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| |  | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| 3,node  -ML2-OVS- GRE   |  | CentOS 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| |  | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| 3,node  -ML2-OVS- VLAN  |  | CentOS 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| |  | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 

## TripleO

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|-------------|---------|--------|--------|-------|-----|------|-------|-----------
| Minimal | Mitaka | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Mitaka | RHEL 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | RHEL 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| HA | Mitaka | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Mitaka | RHEL 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 

## Packstack Based Installation (Storage Components)

Please see [Docs - Storage](/documentation/storage) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [How To Test](testday/mitaka/milestone3#how-to-test) page when installing the base RDO system. '''Do not''' go through the Quickstart steps unmodified which will instead give you an RDO Liberty deployment.

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Glance=localfs, Cinder=lvm | Mitaka | CentOS 7.2 | | [QuickStart](/Quickstart) | |   |   |-
| | Mitaka | RHEL 7.2 | | [QuickStart](/Quickstart) | |   |   | 
| Glance=localfs, Cinder=glusterfs | Mitaka | CentOS 7.2 | | [QuickStart](/Quickstart) | |  | | 
| | Mitaka | RHEL 7.2 | | [QuickStart](/Quickstart) | |  | |-
| Glance=localfs, Cinder=windows_iscsi | Mitaka | CentOS 7.2 |  | [QuickStart](/Quickstart) |  |  |  |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/Quickstart) |  |  |  |
| Glance=swift, Cinder=thinlvm | Mitaka | CentOS 7.2 |  | [QuickStart](/Quickstart) | | | | 
| | Mitaka | RHEL 7.2 |  | [QuickStart](/Quickstart) | | | |-
| Glance=s3(amazon s3), Cinder=nfs | Mitaka | CentOS 7.2 |  | [QuickStart](/Quickstart) | |    | | 
| | Mitaka | RHEL 7.2 |  | [QuickStart](/Quickstart) |  |    | |
| Glance=s3(swift s3), Cinder=nfs | Mitaka | CentOS 7.2 |  | [QuickStart](/Quickstart) | |    | |-
| | Mitaka | RHEL 7.2 |  | [QuickStart](/Quickstart) |  |    | |
| Glance=ceph, Cinder=ceph | Mitaka | CentOS 7.2 |  | [QuickStart](/Quickstart) |  |    |  |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/Quickstart) |  |    |  |
| Glance=XtreamIO, Cinder=XtreamIO | Mitaka | CentOS 7.2 |  | [QuickStart](/Quickstart) |  |   |  |
| | Mitaka | RHEL 7.2 |  |[QuickStart](/Quickstart) |  |   |  |
| Glance=lvm, Cinder=glusterfs | Mitaka |  CentOS 7.2 |  | [QuickStart](/Quickstart) |    |   |  |-
| | Mitaka |  RHEL 7.2 |  | [QuickStart](/Quickstart) |    |   |  | 
| Glance=lvm, Cinder=netapp_iscsi | Mitaka |CentOS 7.2 |  |[QuickStart](/Quickstart) |  |    | |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/Quickstart) |  |    | |
| Glance=lvm, Cinder=netapp_nfs | Mitaka | CentOS 7.2 |  |[QuickStart](/Quickstart) |   |    |  |
| | Mitaka | RHEL 7.2 |  |[QuickStart](/Quickstart) |   |    |  |
| Glance=nfs, Cinder=netapp_iscsi | Mitaka | CentOS 7.2 | | [QuickStart](/Quickstart) |  |    |   |
| | Mitaka | RHEL 7.2 | |[QuickStart](/Quickstart) |  |    |   |
| Swift | Mitaka | RHEL 7.2 | | [QuickStart](/Quickstart) |   |   |  |
|  | Mitaka | CentOS 7.2 | | [QuickStart](/Quickstart) | |   |  |

## Packstack Based Installation (Misc Components)

Various components which don't fit the large test efforts above.



| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Ceilometer: All-in-One w/ Neutron Networking | Mitaka | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test)| |    |    |   | 
| | Mitaka | CentOS 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test)|| | || 
| Nova Compute: 2 Distributed Compute nodes  | Mitaka | RHEL 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test)| | || 
| | Mitaka | CentOS 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test)| | || 


## Core Tests

### General openstack tests

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
|All-in-one Keystone tests | Mitaka | CentOS 7.2 |   | [How To Test](/testday/mitaka/milestone3#how-to-test)  |   |  |  | 
| | Mitaka | RHEL 7.2 |   | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |    | | | 
| Distributed Horizon | Mitaka | RHEL 7.2 |   | [How To Test](/testday/mitaka/milestone3#how-to-test)  |     |  |   | 
| | Mitaka | CentOS 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | | | | | 
| Heat tests | Mitaka | RHEL 7.2 |   |[How To Test](/testday/mitaka/milestone3#how-to-test) |    |  | Packstack + environment creation sanity |
| | Mitaka | CentOS 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | | | | |-
| All-in-one Nova tests | Mitaka | RHEL 7.2 |  |[How To Test](/testday/mitaka/milestone3#how-to-test)  |   |  | Packstack + nova sanity |
| | Mitaka | Centos 7.2 |   |[How To Test](/testday/mitaka/milestone3#how-to-test)  |    |  |  |
| 2.node Nova tests | Mitaka | RHEL 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) |   | | Packstack + nova live migration (block / shared storage) |
|  | Mitaka | Centos 7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |     |  |  | 


## Manual configuration of OpenStack

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
|2,node+minimal OpenStack+Neutron+OVS+GRE | Mitaka | RHEL 7.2 |  |[How To Test](/testday/mitaka/milestone3#how-to-test)  |  |  |  |
| | Mitaka | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test)  |  |  | |

## Post Installation Tests

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Post Installation | Mitaka |  CentOS 7.2 |  |[How To Test](/testday/mitaka/milestone3#how-to-test) |  |  |  | 
| | Mitaka | RHEL 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | | | | 


