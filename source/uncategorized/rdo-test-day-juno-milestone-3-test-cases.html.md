---
title: RDO test day Juno milestone 3 test cases
authors: ajeain, arifali, avladu, cmyster, coolsvap, dron, gszasz, iovadia, kashyap,
  mabrams, mkrcmari, mpavlase, nlevinki, nmagnezi, nyechiel, panbalag, rbowen, rcritten,
  roshi, sasha, stoner, tdunnon, tkammer, tonifreger, tosky, tshefi, ukalifon, vaneldik,
  yfried
wiki_title: RDO test day Juno milestone 3 test cases
wiki_revision_count: 101
wiki_last_updated: 2014-10-14
---

# RDO test day Juno milestone 3 test cases

Tested Setups for **[RDO_test_day_Juno_milestone_3](RDO_test_day_Juno_milestone_3)**. Tests should be executed against the Juno RDO **not** Icehouse, some steps from the official Quickstart guide **do not** apply to Juno; make sure to follow the steps described in the [RDO_test_day_Juno_milestone_3#How_To_Test](RDO_test_day_Juno_milestone_3#How_To_Test) page instead.

## Example Entry

Here's how you might fill out an entry once you've tested it. Mark a given test "Good" or "Fail", as appropriate, and link to any tickets that you've opened as a result, and to any place where you've written up your test notes. Mark as Workaround if you have a failure but can get past it. Link to your writeup of the workaround.

| Config Name                                                    | Release          | BaseOS    | Status                                       | HOWTO                                               | Who    | Date       | BZ/LP                                                              | Notes Page |
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking | Grizzly 2013.1.3 | RHEL 6.4  | <span style="background:#00ff00">Good</span> | [Neutron-Quickstart](Neutron-Quickstart) | pmyers | 2013-09-08 | None                                                               | None       |
|                                                                |                  | Fedora 20 | <span style="background:#ff0000">FAIL</span> | [Neutron-Quickstart](Neutron-Quickstart) | rbowen | 2013-10-09 | ~~[1017421](https://bugzilla.redhat.com/show_bug.cgi?id=1017421)~~ | None       |

## Packstack Based Installation (Neutron Networking)

Please make sure to use the steps described in the RDO_test_day_January_2014#How_To_Test page when installing the base RDO system. Do not go trough the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name                               | Release | BaseOS   | Status | HOWTO                               | Who      | Date       | BZ/LP | Notes Page        |
|-------------------------------------------|---------|----------|--------|-------------------------------------|----------|------------|-------|-------------------|
| All-in-One - Sanity                       |         | CentOS 7 | ??     | [QuickStart](QuickStart) | nyechiel | 2014-00-00 | None  | None              |
|                                           |         | F20      | ??     | [QuickStart](QuickStart) |          |            | None  |                   |
|                                           |         | RHEL7    | ??     | [QuickStart](QuickStart) | yfreid   | 2014-00-00 | None  | tempest automated |
| Distributed -ML2-OVS- VXLAN-IPv6- Sanity  |         | CentOS 7 | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |
|                                           |         | F20      | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |
|                                           |         | RHEL7    | ??     | [QuickStart](QuickStart) | tfreger  | 2014-00-00 | None  | None              |
| Distributed -ML2- OVS-GRE – IPv6 - LbaaS  |         | CentOS 7 | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |
|                                           |         | F20      | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |
|                                           |         | RHEL7    | ??     | [QuickStart](QuickStart) | oblaut   | 2014-00-00 | None  | None              |
| Distributed -ML2- OVS-VLAN – IPv6 -FwaaS  |         | CentOS 7 | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |
|                                           |         | F20      | ??     | [QuickStart](QuickStart) | stoner   | 2014-00-00 | None  | None              |
|                                           |         | RHEL7    | ??     | [QuickStart](QuickStart) | nmagnezi | 2014-00-00 | None  | None              |
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS |         | CentOS 7 | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |
|                                           |         | F20      | ??     | [QuickStart](QuickStart) | tdunnon  | 2014-00-00 | None  | None              |
|                                           |         | RHEL7    | ??     | [QuickStart](QuickStart) | ?        | 2014-00-00 | None  | None              |

## Packstack Based Installation (Storage Components)

Please see [Docs/Storage](Docs/Storage) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [RDO_test_day_January_2014#How_To_Test](RDO_test_day_January_2014#How_To_Test) page when installing the base RDO system. **Do not** go trough the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name | Backend                          | BaseOS   | Status | HOWTO                               | Who                | Date       | BZ/LP | Notes Page |
|-------------|----------------------------------|----------|--------|-------------------------------------|--------------------|------------|-------|------------|
| All-in-One  | Glance=localfs, Cinder=lvm       | CentOS 7 | ??     | [QuickStart](QuickStart) | ?                  | 2014-09-22 | None  | None       |
| All-in-One  | Glance=swift, Cinder=thinlvm     | CentOS 7 | ??     | [QuickStart](QuickStart) | Prasanth Anbalagan | 2014-09-22 | None  | None       |
| All-in-One  | Glance=s3, Cinder=nfs            | CentOS 7 | ??     | [QuickStart](QuickStart) | Benny Kopilov      | 2014-09-22 | None  | None       |
| All-in-One  | Glance=ceph, Cinder=ceph         | CentOS 7 | ??     | [QuickStart](QuickStart) | Luigi Toscano      | 2014-09-22 | None  | None       |
| All-in-One  | Glance=XtreamIO, Cinder=XtreamIO | CentOS 7 | ??     | [QuickStart](QuickStart) | ?                  | 2014-09-22 | None  | None       |
| All-in-One  | Glance=ceph, Cinder=ceph         | F20      | ??     | [QuickStart](QuickStart) | Nathan Levinkind   | 2014-09-22 | None  | None       |
| All-in-One  | Glance=swift, Cinder=thinlvm     | RHEL7    | ??     | [QuickStart](QuickStart) | ?                  | 2014-09-22 | None  | None       |
| All-in-One  | Glance=s3, Cinder=nfs            | RHEL7    | ??     | [QuickStart](QuickStart) | Benny Kopilov      | 2014-09-22 | None  | None       |
| All-in-One  | Glance=ceph, Cinder=ceph         | RHEL7    | ??     | [QuickStart](QuickStart) | Tomas Rusnak       | 2014-09-22 | None  | None       |
| All-in-One  | Glance=lvm, Cinder=glusterfs     | RHEL7    | ??     | [QuickStart](QuickStart) | Tzach Shefi        | 2014-09-22 | None  | None       |
| All-in-One  | Glance=lvm, Cinder=netapp_iscsi | RHEL7    | ??     | [QuickStart](QuickStart) | Yogev Rabl         | 2014-09-22 | None  | None       |
| All-in-One  | Glance=lvm, Cinder=netapp_nfs   | RHEL7    | ??     | [QuickStart](QuickStart) | Yogev Rabl         | 2014-09-22 | None  | None       |
| All-in-One  | swift                            | RHEL7    | ??     | [QuickStart](QuickStart) | Prasanth Anbalagan | 2014-09-22 | None  | None       |

## Packstack Based Installation (Misc Components)

Various components which don't fit the large test efforts above.

| Item/Area Name                                     | Release      | BaseOS   | Status | HOWTO | Who | Date | BZ/LP | Notes Page |
|----------------------------------------------------|--------------|----------|--------|-------|-----|------|-------|------------|
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO icehouse | RHEL 6.5 |        |       |     |      |       |            |
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO icehouse | RHEL 7.0 |        |       |     |      |       |            |

## Core Tests

General openstack tests

| Item/Area Name            | Release  | BaseOS    | Status | HOWTO | Who      | Date | BZ/LP                           | Notes Page |
|---------------------------|----------|-----------|--------|-------|----------|------|---------------------------------|------------|
| All-in-one Keystone tests | RDO Juno | CentOS 7  |        |       | ukalifon |      |                                 |            |
| All-in-one Horizon        | RDO Juno | Fedora 20 |        |       | iovadia  |      | PackStack installation + Sanity |            |

## Manual configuration of OpenStack

| Config Name                              | Release | BaseOS     | Status | HOWTO                                                                                                                                                                                                                                                                            | Who       | Date       | BZ/LP | Notes Page |
|------------------------------------------|---------|------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|------------|-------|------------|
| 2,node+minimal OpenStack+Neutron+OVS+GRE | Juno M3 | Fedora 21  |        | [IceHouse-Notes](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) [IceHouse-Configs](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt)                                                      | kashyapc  | 2013-17-09 | None  | None       |
| 2,node+minimal OpenStack+Neutron+OVS+GRE | Juno M3 | Centos 7.0 |        | [QuickStart](https://openstack.redhat.com/QuickStart)[IceHouse-Notes](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) [IceHouse-Configs](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) | mpavlasek | 2014-17-09 | None  | None       |

## Post Installation Tests

| Config Name       | Release          | BaseOS | Status | HOWTO                                                         | Who | Date  | BZ/LP | Notes Page |
|-------------------|------------------|--------|--------|---------------------------------------------------------------|-----|-------|-------|------------|
| Post Installation | Juno Milestone 3 | ALL    | ??     | [Post Installation Tests](Post Installation Tests) | ALL | 18-09 | None  | None       |
