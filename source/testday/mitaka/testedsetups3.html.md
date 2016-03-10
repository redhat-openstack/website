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
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking | Grizzly 2013.1.3 | RHEL 6.4  | <span style="background:#00ff00">Good</span> | [Neutron-Quickstart](Neutron-Quickstart) | pmyers | 2013-09-08 | None                                                               | None       |
|                                                                |                  | Fedora 19 | <span style="background:#ff0000">FAIL</span> | [Neutron-Quickstart](Neutron-Quickstart) | rbowen | 2013-10-09 | ~~[1017421](https://bugzilla.redhat.com/show_bug.cgi?id=1017421)~~ | None       |


## Packstack Based Installation (Neutron Networking)

Please make sure to use the steps described in the [How To Test](/testday/mitaka/milestone2#how-to-test)  when installing the base RDO system. Do not go through the Quickstart steps unmodified which will instead give you an RDO kilo deployment. 

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One - Sanity |  | CentOS 7 | <span style="background:#00ff00">Good</span>  | [How To Test](/testday/mitaka/milestone2#how-to-test) | |    |    | 
|                     |  | F22      |   | [How To Test](/testday/mitaka/milestone2#how-to-test) |  |    |    | 
|                     |  | RHEL7.2  |   | [How To Test](/testday/mitaka/milestone2#how-to-test) | |  |    | 
| Distributed -IPv6-Deployment- Sanity |  |  CentOS 7 |  | [QuickStart](/Quickstart) |  |   |  | 
|                                      |  | F22       |  | [QuickStart](/Quickstart) |  |   |  | 
|                                      |  | RHEL7.1   |  | [QuickStart](/Quickstart) |  |   |  |
| Distributed -ML2- OVS-VXLAN –  LbaaS | | CentOS 7.1 |  | [QuickStart](/Quickstart) |  |   |  | 
|                                      | | F22        |  | [QuickStart](/Quickstart) |  |   |  | 
|                                      | | RHEL7.1    |  | [QuickStart](/Quickstart) |  |   |  | 
| Distributed -ML2- OVS-VXLAN-VRRP     | | CentOS 7.1 |  | [QuickStart](/Quickstart) |  |   |  | 
| | | F22 |  | [QuickStart](/Quickstart) |  |   | | 
| | | RHEL7.1 | | [QuickStart](/Quickstart) |  |   | | 
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS | | CentOS 7.1 |  | [QuickStart](/Quickstart) |  |  |  | 
| | | F22 |  | [QuickStart](/Quickstart) |  |   |  | 
| | | RHEL7.1 |  | [QuickStart](/Quickstart) | |  |  | 
| Distributed -ML2-OVS- VXLAN Security Groups | | CentOS 7.1 |  | [QuickStart](/Quickstart) |  |   |  | 
| | | F22 | | [QuickStart](/Quickstart) |  |  |  | 
| | | RHEL7.1 | | [QuickStart](/Quickstart) |zgreenbe  |   | | 
| Distributed -ML2-OVS- VXLAN DVR | | RHEL 7.1 | | [QuickStart](/Quickstart) | |   |  | 
| Distributed -ML2-OVS- VXLAN DVR | | CentOS 7.1 | | [QuickStart](/Quickstart) |   |  |  | 
| 3,node  -ML2-OVS- VXLAN |  | CentOS 7.1 |    | |   |   |  | 
| 3,node  -ML2-OVS- GRE   |  | CentOS 7.1 |    | |   |   |  | 
| 3,node  -ML2-OVS- VLAN  |  | CentOS 7.1 |    | |   |   |  | 

## TripleO

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|-------------|---------|--------|--------|-------|-----|------|-------|-----------
| Minimal | Mitaka | CentOS 7 | | [Install Guide](https://www.rdoproject.org/rdo-manager/) | rwsu | | | 
| | Liberty | CentOS 7 | | [Install Guide](https://www.rdoproject.org/rdo-manager/) | | | | 
| HA | Mitaka | CentOS 7 | | [Install Guide](https://www.rdoproject.org/rdo-manager/) | | | | 
| | Liberty | CentOS 7 | | [Install Guide](https://www.rdoproject.org/rdo-manager/) | | | | 

## Packstack Based Installation (Storage Components)

Please see [Docs - Storage](/documentation/storage) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [How To Test](testday/mitaka/milestone2#how-to-test) page when installing the base RDO system. '''Do not''' go through the Quickstart steps unmodified which will instead give you an RDO Liberty deployment.

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One | Glance=localfs, Cinder=lvm| CentOS 7.1 | | [QuickStart](/Quickstart) | |   |  None | 
| All-in-One | Glance=localfs, Cinder=glusterfs| CentOS 7.1 | | [QuickStart](/Quickstart) | |  |  None | 
| All-in-One | Glance=swift, Cinder=thinlvm| CentOS 7.1 |  | [QuickStart](/Quickstart) | | | None | 
| All-in-One | Glance=s3(amazon s3), Cinder=nfs| CentOS 7.1 |  | [QuickStart](/Quickstart) | |    | None | None
| All-in-One | Glance=s3(swift s3), Cinder=nfs| CentOS 7.1 |  | [QuickStart](/Quickstart) |  |    |  None|  None
| All-in-One | Glance=ceph, Cinder=ceph| CentOS 7.1 |  | [QuickStart](/Quickstart) |  |    | None | None
| All-in-One | Glance=XtreamIO, Cinder=XtreamIO| CentOS 7.1 |  | [QuickStart](/Quickstart) |  |   | None | None
| All-in-One | Glance=localfs, Cinder=windows_iscsi| CentOS 7.1 |  | [QuickStart](/Quickstart) |  |  | None | None
| All-in-One | Glance=swift, Cinder=thinlvm|  RHEL7.1 |   | [QuickStart](/Quickstart) |   |    | None | None
| All-in-One | Glance=s3, Cinder=nfs|  RHEL7.1 |   | [QuickStart](/Quickstart) |    |   | None | None
| All-in-One | Glance=ceph, Cinder=ceph|  RHEL7.1 | | [QuickStart](/Quickstart) |   |    | None | None
| All-in-One | Glance=lvm, Cinder=glusterfs|  RHEL7.1 |  | [QuickStart](/Quickstart) |    |   | None | None
| All-in-One | Glance=lvm, Cinder=netapp_iscsi|  RHEL7.1 |  | [QuickStart](/Quickstart) |  |    | None | None
| All-in-One | Glance=nfs, Cinder=netapp_iscsi|  RHEL7.1 | | [QuickStart](/Quickstart) |  |    |   | None
| All-in-One | Glance=lvm, Cinder=netapp_nfs|  RHEL7.1 |  | [QuickStart](/Quickstart) |   |    | None | None
| All-in-One | swift|  RHEL7.1 | | [QuickStart](/Quickstart) |   |   | None | None
| All-in-One | Glance=lvm, Cinder=lvm, Manila=Generic | Fedora 22 | | [QuickStart](/Quickstart) | dustins/dschoenb | | | None

## Packstack Based Installation (Misc Components)

Various components which don't fit the large test efforts above.



| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Ceilometer: All-in-One w/ Neutron Networking | RDO Mitaka | RHEL 7.1 |    |    |    |    |   |     
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO Mitaka | CentOS 7.1 | || | || 
| Nova Compute: 2 Distributed Compute nodes  | RDO Mitaka | RHEL 7.1 | |[How To Test](/testday/mitaka/milestone2#how-to-test)| | || 
| Nova Compute: 2 Distributed Compute nodes  | RDO Mitaka | CentOS 7.1 | |[How To Test](/testday/mitaka/milestone2#how-to-test)| | || 


## Core Tests

### General openstack tests

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
|All-in-one Keystone tests | RDO Mitaka | CentOS 7.1 |   |   |   |  |  | 
|All-in-one Keystone tests | RDO Mitaka | RHEL 7.1 |   |   |  |    | | | 
|All-in-one Keystone tests | RDO Mitaka | Fedora 21 |  |  |    | |  | 
|All-in-one installation tests | RDO Mitaka | RHEL 7.1 |   |   |   |   | |    |
| Distributed Horizon | RDO Mitaka | RHEL7.1 |   |   |     |  |   | 
| Heat tests | RDO Mitaka | RHEL7.1|   | |    |  | Packstack + environment creation + sanity |
| All-in-one Nova tests | RDO Mitaka | RHEL7.1 |  |  |   |  | Packstack + nova sanity |
| All-in-one Nova tests | RDO Mitaka | Centos7.1 |   |  |    |  |  |
| RDO Mitaka | Fedora 21 |   |  |   |  |  | |
| 2.node Nova tests | RDO Mitaka | RHEL7.1 | | |   | | Packstack + nova live migration (block / shared storage) |
|  | RDO Mitaka | Fedora 21 |   |  |    |  |  |
|  | RDO Mitaka | Centos7.1 | |  |     |  |  | 


## Manual configuration of OpenStack

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
|2,node+minimal OpenStack+Neutron+OVS+GRE |RDO Mitaka | Fedora 21 |  |  |  |  | None | None
|2,node+minimal OpenStack+Neutron+OVS+GRE |RDO Mitaka | CentOS 7.1 |  |   |  |  | None | None

## Post Installation Tests

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Post Installation | RDO Mitaka |  CentOS 7.1 |  | [[Post Installation Tests]]|  |  | None | 


