---
title: TestedSetups Mitaka GA
authors: rbowen
---

# Test cases for Mitaka GA test day

Tested Setups for [RDO test day Mitaka GA](/testday/mitaka/ga),
April 13-14, 2016.

See also the [Workarounds][] page.

Some steps from the official Quickstart guide
do not apply to Mitaka; make sure to follow the steps described in the
[How To Test](/testday/mitaka/ga#how-to-test) page instead.

For convenience, during the test day, please feel free to use the [test
day etherpad][], which we'll use to periodically update this page.

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
| All-in-One - Sanity | Mitaka  | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) | | | None |  
| All-in-One - Sanity | Mitaka  | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) | | | | 
|                     | Mitaka | RHEL 7.2  |   | [How To Test](/testday/mitaka/milestone3#how-to-test) | | | None | 
| Distributed -IPv6-Deployment- Sanity | Mitaka |  CentOS 7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) | | | In notes | | 
|                                      |Mitaka | RHEL 7.2   |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  |
| Distributed -ML2- OVS-VXLAN –  LbaaS |Mitaka | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
|                                      |Mitaka | RHEL 7.2   |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
| Distributed -ML2- OVS-VXLAN-VRRP     |Mitaka | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
| |Mitaka | RHEL7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   | | 
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS | Mitaka | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |  |  | 
| |Mitaka | RHEL7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) | |  |  | 
| Distributed -ML2-OVS- VXLAN Security Groups |Mitaka | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   |  | 
| |Mitaka | RHEL7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |  |   | | 
| Distributed -ML2-OVS- VXLAN DVR |Mitaka | RHEL 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | |   |  | 
|  |Mitaka | CentOS 7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |   |  |  | 
| 3,node  -ML2-OVS- VXLAN |Mitaka  | CentOS 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| | Mitaka | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| 3,node  -ML2-OVS- GRE   | Mitaka | CentOS 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| | Mitaka | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| 3,node  -ML2-OVS- VLAN  | Mitaka | CentOS 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 
| | Mitaka | RHEL 7.2 |    |[How To Test](/testday/mitaka/milestone3#how-to-test) |   |   |  | 

## TripleO

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|-------------|---------|--------|--------|-------|-----|------|-------|-----------
| Minimal | Mitaka | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Mitaka | RHEL 7.2 | |[Install Guide](https://www.rdoproject.org/tripleo/) | | | None  | 
| | Mitaka | RHEL 7.2 |  |[Install Guide](https://www.rdoproject.org/tripleo/) | | |None  | 
| | Mitaka | CentOS 7.2 | |[Install Guide](https://www.rdoproject.org/tripleo/) | | |   | 
| | Liberty | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | RHEL 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| HA | Mitaka | CentOS 7.2 |  |[Install Guide](https://www.rdoproject.org/tripleo/) | |  | 
| | Mitaka | CentOS 7.2 |  |[Install Guide](https://www.rdoproject.org/tripleo/) | | |  |
| | Mitaka | RHEL 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | CentOS 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 
| | Liberty | RHEL 7.2 | | [Install Guide](https://www.rdoproject.org/tripleo/) | | | | 

## Packstack Based Installation (Storage Components)

Please see [Docs - Storage](/documentation/storage) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [How To Test](testday/mitaka/milestone3#how-to-test) page when installing the base RDO system. '''Do not''' go through the Quickstart steps unmodified which will instead give you an RDO Liberty deployment.

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Glance=localfs, Cinder=lvm | Mitaka | CentOS 7.2 | | [QuickStart](/install/quickstart/) | |   |   |
| | Mitaka | RHEL 7.2 | | [QuickStart](/install/quickstart/) | |   |   | 
| Glance=localfs, Cinder=glusterfs | Mitaka | CentOS 7.2 | | [QuickStart](/install/quickstart/) | |  | | 
| | Mitaka | RHEL 7.2 | | [QuickStart](/install/quickstart/) | |  | |
| Glance=localfs, Cinder=windows_iscsi | Mitaka | CentOS 7.2 |  | [QuickStart](/install/quickstart/) |  |  |  |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/install/quickstart/) |  |  |  |
| Glance=swift, Cinder=thinlvm | Mitaka | CentOS 7.2 |  | [QuickStart](/install/quickstart/) | | | | 
| | Mitaka | RHEL 7.2 |  | [QuickStart](/install/quickstart/) | | | |
| Glance=s3(amazon s3), Cinder=nfs | Mitaka | CentOS 7.2 |  | [QuickStart](/install/quickstart/) | |    | | 
| | Mitaka | RHEL 7.2 |  | [QuickStart](/install/quickstart/) |  |    | |
| Glance=s3(swift s3), Cinder=nfs | Mitaka | CentOS 7.2 |  | [QuickStart](/install/quickstart/) | |    | |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/install/quickstart/) |  |    | |
| Glance=ceph, Cinder=ceph | Mitaka | CentOS 7.2 |  | [QuickStart](/install/quickstart/) |  |    |  |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/install/quickstart/) |  |    |  |
| Glance=XtreamIO, Cinder=XtreamIO | Mitaka | CentOS 7.2 |  | [QuickStart](/install/quickstart/) |  |   |  |
| | Mitaka | RHEL 7.2 |  |[QuickStart](/install/quickstart/) |  |   |  |
| Glance=lvm, Cinder=glusterfs | Mitaka |  CentOS 7.2 |  | [QuickStart](/install/quickstart/) |    |   |  |
| | Mitaka |  RHEL 7.2 |  | [QuickStart](/install/quickstart/) |    |   |  | 
| Glance=lvm, Cinder=netapp_iscsi | Mitaka |CentOS 7.2 |  |[QuickStart](/install/quickstart/) |  |    | |
| | Mitaka | RHEL 7.2 |  | [QuickStart](/install/quickstart/) |  |    | |
| Glance=lvm, Cinder=netapp_nfs | Mitaka | CentOS 7.2 |  |[QuickStart](/install/quickstart/) |   |    |  |
| | Mitaka | RHEL 7.2 |  |[QuickStart](/install/quickstart/) |   |    |  |
| Glance=nfs, Cinder=netapp_iscsi | Mitaka | CentOS 7.2 | | [QuickStart](/install/quickstart/) |  |    |   |
| | Mitaka | RHEL 7.2 | |[QuickStart](/install/quickstart/) |  |    |   |

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
| Distributed Horizon | Mitaka | RHEL 7.2 |   | [How To Test](/testday/mitaka/milestone3#how-to-test)  |     |  |   | 
| | Mitaka | CentOS 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | | | | | 
| Heat tests | Mitaka | RHEL 7.2 |   |[How To Test](/testday/mitaka/milestone3#how-to-test) |    |  | Packstack + environment creation sanity |
| | Mitaka | CentOS 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) | | | | |
| 2.node Nova tests | Mitaka | RHEL 7.2 | |[How To Test](/testday/mitaka/milestone3#how-to-test) |   | | Packstack + nova live migration (block / shared storage) |
|  | Mitaka | Centos 7.2 | | [How To Test](/testday/mitaka/milestone3#how-to-test) |     |  |  | 


## Manual configuration of OpenStack

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
|2,node+minimal OpenStack+Neutron+OVS+GRE | Mitaka | RHEL 7.2 |  |[How To Test](/testday/mitaka/milestone3#how-to-test)  |  |  |  |
| | Mitaka | CentOS 7.2 |  | [How To Test](/testday/mitaka/milestone3#how-to-test)  |  |  | |
| Ceph quickstart | Mitaka | CentOS 7 |  | [Ceph quickstart](https://wiki.centos.org/SpecialInterestGroup/Storage/ceph-Quickstart) | | | | 

## Post Installation Tests

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| Post Installation | Mitaka |  CentOS 7.2 |  |[Post Deployment Test](docs.openstack.org/developer/tripleo-docs/basic_deployment/basic_deployment_cli.html#post-deployment) |  |  |  | 
| | Mitaka | RHEL 7.2 | |[Post Deployment Test](docs.openstack.org/developer/tripleo-docs/basic_deployment/basic_deployment_cli.html#post-deployment)  | | | | 

[test day etherpad]: https://etherpad.openstack.org/p/rdo-test-days-mitaka-ga
[Tested Setups]: /testday/mitaka/testedsetupsga
[Workarounds]: /testday/mitaka/workaroundsga
