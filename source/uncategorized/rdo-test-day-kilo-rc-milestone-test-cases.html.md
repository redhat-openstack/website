---
title: RDO test day Kilo RC milestone test cases
authors: ajeain, apevec, berendt, bkopilov, dbaxps, ekuris, eyepv6, iovadia, itzikb,
  jmarko, mabrams, mpavlase, panbalag, prad, stef, stoner, tonifreger, tshefi, yprokule,
  yrabl
wiki_title: RDO test day Kilo RC milestone test cases
wiki_revision_count: 67
wiki_last_updated: 2015-05-12
---

# RDO test day Kilo RC milestone test cases

Tested Setups for **[RDO_test_day_Kilo](RDO_test_day_Kilo)**. Tests should be executed against the Kilo RDO.

## Example Entry

Here's how you might fill out an entry once you've tested it. Mark a given test "Good" or "Fail", as appropriate, and link to any tickets that you've opened as a result, and to any place where you've written up your test notes. Mark as Workaround if you have a failure but can get past it. Link to your writeup of the workaround.

| Config Name                                                    | Release          | BaseOS    | Status                                       | HOWTO                                               | Who    | Date       | BZ/LP                                                              | Notes Page |
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking | Grizzly 2013.1.3 | RHEL 6.4  | <span style="background:#00ff00">Good</span> | [Neutron-Quickstart](Neutron-Quickstart) | pmyers | 2013-09-08 | None                                                               | None       |
|                                                                |                  | Fedora 20 | <span style="background:#ff0000">FAIL</span> | [Neutron-Quickstart](Neutron-Quickstart) | rbowen | 2013-10-09 | ~~[1017421](https://bugzilla.redhat.com/show_bug.cgi?id=1017421)~~ | None       |

## Packstack Based Installation (Neutron Networking)

Please make sure to use the steps described in the RDO_test_day_Kilo#How_To_Test page when installing the base RDO system. Do not go through the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name                               | Release          | BaseOS     | Status | HOWTO                                                                                              | Who | Date       | BZ/LP | Notes Page |
|-------------------------------------------|------------------|------------|--------|----------------------------------------------------------------------------------------------------|-----|------------|-------|------------|
| All-in-One - Sanity                       | Kilo 2015.1-0rc2 | CentOS 7   |        | [QuickStart](QuickStart)                                                                |     |            |       | None       |
|                                           |                  | F20        | ??     | [QuickStart](QuickStart)                                                                |     |            |       |            |
|                                           |                  | F21BetaTC1 |        | [Quickstart](Quickstart)                                                                |     |            |       |            |
| All-in-One                                | Kilo 2015.1-0rc2 | RHEL7      |        | [QuickStart](QuickStart)                                                                |     |            | None  | None       |
| Distributed -ML2-OVS- VXLAN-IPv6- Sanity  | Kilo 2015.1-0rc2 | CentOS 7   | ??     | [QuickStart](QuickStart)                                                                | ?   |            | None  | None       |
|                                           |                  | F20        | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | RHEL7      |        | [QuickStart](QuickStart)                                                                |     | 2015-00-00 |       | None       |
| Distributed -ML2- OVS-GRE – IPv6 - LbaaS  | Kilo 2015.1-0rc2 | CentOS 7   | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | F20        | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | RHEL7      |        | [QuickStart](QuickStart)                                                                |     | 2015-00-00 |       | None       |
| Distributed -ML2- OVS-VLAN – IPv6 -FwaaS  | Kilo 2015.1-0rc2 | CentOS 7   | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | F20        | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | RHEL7      | ??     | [QuickStart](QuickStart)                                                                |     | 2015-00-00 |       | None       |
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS | Kilo 2015.1-0rc2 | CentOS 7   | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | F20        | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
|                                           |                  | RHEL7      | ??     | [QuickStart](QuickStart)                                                                | ?   | 2015-00-00 | None  | None       |
| 3,node -ML2-OVS- VXLAN                    | Kilo 2015.1-0rc2 | CentOS 7   |        | [1](https://gitlab.arif-ali.co.uk/arif/openstack-lab/wikis/RDO-Juno-test-M3-Notes-multinode-VXLAN) |     | 2015-00-00 | None  | None       |
| 3,node -ML2-OVS- GRE                      | Kilo 2015.1-0rc2 | CentOS 7   |        |                                                                                                    |     | 2015-00-00 | None  | None       |
| 3,node -ML2-OVS- VLAN                     | Kilo 2015.1-0rc2 | CentOS 7   | -      | [2](https://gitlab.arif-ali.co.uk/arif/openstack-lab/wikis/RDO-Juno-test-M3-Notes-multinode-VLAN)  |     | 2015-00-00 | None  | None       |

## Packstack Based Installation (Storage Components)

Please see [Docs/Storage](Docs/Storage) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [RDO_test_day_January_2014#How_To_Test](RDO_test_day_January_2014#How_To_Test) page when installing the base RDO system. **Do not** go through the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name | Backend                               | BaseOS   | Status | HOWTO                               | Who | Date       | BZ/LP | Notes Page |
|-------------|---------------------------------------|----------|--------|-------------------------------------|-----|------------|-------|------------|
| All-in-One  | Glance=localfs, Cinder=lvm            | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=swift, Cinder=thinlvm          | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=s3(amazon s3), Cinder=nfs      | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=s3(swift s3), Cinder=nfs       | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=ceph, Cinder=ceph              | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=XtreamIO, Cinder=XtreamIO      | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=localfs, Cinder=windows_iscsi | CentOS 7 |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=ceph, Cinder=ceph              | F20      |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=swift, Cinder=thinlvm          | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=s3, Cinder=nfs                 | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=ceph, Cinder=ceph              | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=lvm, Cinder=glusterfs          | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=lvm, Cinder=netapp_iscsi      | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | Glance=lvm, Cinder=netapp_nfs        | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |
| All-in-One  | swift                                 | RHEL7    |        | [QuickStart](QuickStart) |     | 2015-00-00 | None  | None       |

## Packstack Based Installation (Misc Components)

Various components which don't fit the large test efforts above.

| Item/Area Name                                     | Release      | BaseOS   | Status | HOWTO | Who | Date | BZ/LP | Notes Page |
|----------------------------------------------------|--------------|----------|--------|-------|-----|------|-------|------------|
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO icehouse | RHEL 6.5 |        |       |     |      |       |            |
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO icehouse | RHEL 7.0 |        |       |     |      |       |            |

## Core Tests

General openstack tests

| Item/Area Name                | Release  | BaseOS    | Status                                       | HOWTO                                                                                                                                             | Who            | Date | BZ/LP                                                                                                       | Notes Page |
|-------------------------------|----------|-----------|----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|----------------|------|-------------------------------------------------------------------------------------------------------------|------------|
| All-in-one Keystone tests     | RDO Juno | CentOS 7  | <span style="background:#ff0000">FAIL</span> |                                                                                                                                                   | ukalifon       |      | <https://bugzilla.redhat.com/show_bug.cgi?id=1148348>                                                       |            |
| All-in-one Keystone tests     | RDO Juno | RHEL 7    | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | mabrams        |      |                                                                                                             |            |
| All-in-one Keystone tests     | RDO Juno | Fedora 20 | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | mabrams        |      |                                                                                                             |            |
| All-in-one installation tests | RDO Juno | RHEL 7    | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | ajeain         |      |                                                                                                             |            |
| All-in-one Horizon            | RDO Juno | Fedora 20 | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | iovadia        |      | PackStack installation + Sanity                                                                             |            |
| Heat tests                    | RDO Juno | RHEL7     | <span style="background:#00ff00">PASS</span> | [3](https://github.com/cmyster/readme/blob/master/juno_test_env.pdf) [4](https://github.com/cmyster/scripts/blob/master/rdo-packstack-install.sh) | augol          |      | Packstack + environment creation + sanity                                                                   |            |
| All-in-one Nova tests         | RDO Juno | RHEL7     | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | gszasz         |      | Packstack + nova sanity                                                                                     |            |
| All-in-one Nova tests         | RDO Juno | Centos7   | <span style="background:#ff0000">FAIL</span> |                                                                                                                                                   | sasha          |      | <https://bugzilla.redhat.com/show_bug.cgi?id=1148552> <https://bugzilla.redhat.com/show_bug.cgi?id=1148949> |            |
|                               | RDO Juno | Fedora 20 | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | stoner         |      |                                                                                                             |            |

| 2.node Nova tests             | RDO Juno | RHEL7     | <span style="background:#ff0000">FAIL</span> |                                                                                                                                                   | gszasz         |      | Packstack + nova live migration (block / shared storage)                                                    |            |
|                               | RDO Juno | Fedora 20 | <span style="background:#00ff00">PASS</span> |                                                                                                                                                   | stoner tdunnon |      | with workaround, <https://bugzilla.redhat.com/show_bug.cgi?id=1144181>                                      |            |

## Manual configuration of OpenStack

| Config Name                              | Release | BaseOS     | Status                                                                                    | HOWTO                                                                                                                                                                                                                                                                            | Who      | Date       | BZ/LP                                                            | Notes Page |
|------------------------------------------|---------|------------|-------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------|------------------------------------------------------------------|------------|
| 2,node+minimal OpenStack+Neutron+OVS+GRE | Juno M3 | Fedora 21  |                                                                                           | [IceHouse-Notes](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) [IceHouse-Configs](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt)                                                      | kashyapc | 2013-17-09 | None                                                             | None       |
| 2,node+minimal OpenStack+Neutron+OVS+GRE | Juno M3 | Centos 7.0 | <span style="background:#00ff00">Instalation Good</span>, 122 (full tempest run) failures | [QuickStart](https://openstack.redhat.com/QuickStart)[IceHouse-Notes](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) [IceHouse-Configs](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) | mpavlase | 2014-17-09 | [BZ1149682](https://bugzilla.redhat.com/show_bug.cgi?id=1149682) | None       |

## Post Installation Tests

| Config Name       | Release          | BaseOS     | Status                                       | HOWTO                                                         | Who      | Date  | BZ/LP | Notes Page |
|-------------------|------------------|------------|----------------------------------------------|---------------------------------------------------------------|----------|-------|-------|------------|
| Post Installation | Juno Milestone 3 | CentOS 7.0 | <span style="background:#00ff00">PASS</span> | [Post Installation Tests](Post Installation Tests) | mkrcmari | 02-10 | None  | None       |
