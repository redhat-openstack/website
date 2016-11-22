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

Tested Setups for **[RDO_test_day_Kilo](/testday/rdo-test-day-kilo/)**. Tests should be executed against the Kilo RDO.

## Example Entry

Here's how you might fill out an entry once you've tested it. Mark a given test "Good" or "Fail", as appropriate, and link to any tickets that you've opened as a result, and to any place where you've written up your test notes. Mark as Workaround if you have a failure but can get past it. Link to your writeup of the workaround.

| Config Name                                                    | Release          | BaseOS    | Status                                       | HOWTO                                               | Who    | Date       | BZ/LP                                                              | Notes Page |
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking | Grizzly 2013.1.3 | RHEL 6.4  | <span style="background:#00ff00">Good</span> | [Neutron-Quickstart](Neutron-Quickstart) | pmyers | 2013-09-08 | None                                                               | None       |
|                                                                |                  | Fedora 20 | <span style="background:#ff0000">FAIL</span> | [Neutron-Quickstart](Neutron-Quickstart) | rbowen | 2013-10-09 | ~~[1017421](https://bugzilla.redhat.com/show_bug.cgi?id=1017421)~~ | None       |

## Packstack Based Installation (Neutron Networking)

Please make sure to use the steps described in the [RDO_test_day_Kilo#How_To_Test](/testday/rdo-test-day-kilo/#how-to-test) when installing the base RDO system. Do not go through the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name                                 | Release       | BaseOS     | Status                                            | HOWTO                                                                                              | Who      | Date       | BZ/LP                                                                                                                                                 | Notes Page |
|---------------------------------------------|---------------|------------|---------------------------------------------------|----------------------------------------------------------------------------------------------------|----------|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| All-in-One - Sanity                         | Kilo 2015.1.0 | CentOS 7.1 | *' <span style="background:#00ff00">Good</span>*' | [QuickStart](/install/quickstart/)                                                                | shmcfarl | 2015-05-06 |                                                                                                                                                       | None       |
| |                                           |               | F21        | *' <span style="background:#f77">Failed</span>*'  | [QuickStart](/install/quickstart/)                                                                | mpavlase | 2015-05-06 | [BZ 1219148](https://bugzilla.redhat.com/show_bug.cgi?id=1219148)                                                                                     |            |
| |                                           |               | RHEL7.1    | *' <span style="background:#00ff00">Good</span>*' | [QuickStart](/install/quickstart/)                                                                | stafaev  | 2015-05-06 | None                                                                                                                                                  | None       |
| Distributed -IPv6-Deployment- Sanity        | Kilo 2015.1.0 | CentOS 7.1 | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        |            | None                                                                                                                                                  | None       |
|                                             |               | F21        | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | RHEL7.1    |                                                   | [QuickStart](/install/quickstart/)                                                                | ushkalim | 2015-00-00 |                                                                                                                                                       | None       |
| Distributed -ML2- OVS-VXLAN – LbaaS         | Kilo 2015.1.0 | CentOS 7.1 | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | F21        | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | RHEL7.1    |                                                   | [QuickStart](/install/quickstart/)                                                                | rdekel   | 2015-00-00 |                                                                                                                                                       | None       |
| Distributed -ML2- OVS-VXLAN-VRRP            | Kilo 2015.1.0 | CentOS 7.1 | ??                                                | [QuickStart](/install/quickstart/)                                                                |          | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | F21        | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | RHEL7.1    | *' <span style="background:#00ff00">Good</span>*' | [QuickStart](/install/quickstart/)                                                                | tfreger  | 2015-00-00 | None                                                                                                                                                  | None       |
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS   | Kilo 2015.1.0 | CentOS 7.1 | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | F21        | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | RHEL7.1    | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
| Distributed -ML2-OVS- VXLAN Security Groups | Kilo 2015.1.0 | CentOS 7.1 | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | F21        | ??                                                | [QuickStart](/install/quickstart/)                                                                | ?        | 2015-00-00 | None                                                                                                                                                  | None       |
|                                             |               | RHEL7.1    | *' <span style="background:#f77">Failed</span>*'  | [QuickStart](/install/quickstart/)                                                                | ekuris   | 2015-06-05 | <https://bugs.launchpad.net/neutron/+bug/1453667> ,https://bugs.launchpad.net/neutron/+bug/1453671, <https://bugs.launchpad.net/horizon/+bug/1453676> | None       |
| Distributed -ML2-OVS- VXLAN DVR             | Kilo 2015.1.0 | RHEL 7.1   | ??                                                | [QuickStart](/install/quickstart/)                                                                | itzikb   | 2015-00-00 | None                                                                                                                                                  | None       |
| 3,node -ML2-OVS- VXLAN                      | Kilo 2015.1.0 | CentOS 7.1 |                                                   | [1](https://gitlab.arif-ali.co.uk/arif/openstack-lab/wikis/RDO-Juno-test-M3-Notes-multinode-VXLAN) |          | 2015-00-00 | None                                                                                                                                                  | None       |
| 3,node -ML2-OVS- GRE                        | Kilo 2015.1.0 | CentOS 7.1 |                                                   |                                                                                                    |          | 2015-00-00 | None                                                                                                                                                  | None       |
| 3,node -ML2-OVS- VLAN                       | Kilo 2015.1.0 | CentOS 7.1 | -                                                 | [2](https://gitlab.arif-ali.co.uk/arif/openstack-lab/wikis/RDO-Juno-test-M3-Notes-multinode-VLAN)  |          | 2015-00-00 | None                                                                                                                                                  | None       |

## Packstack Based Installation (Storage Components)

Please see [Docs/Storage](/storage/) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [RDO_test_day_Kilo#How_To_Test](/testday/rdo-test-day-kilo/#how-to-test) page when installing the base RDO system. **Do not** go through the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name | Backend                               | BaseOS     | Status | HOWTO                               | Who                | Date       | BZ/LP     | Notes Page |
|-------------|---------------------------------------|------------|--------|-------------------------------------|--------------------|------------|-----------|------------|
| All-in-One  | Glance=localfs, Cinder=lvm            | CentOS 7.1 | Passed | [QuickStart](/install/quickstart/) | Christian Berendt  | 2015-05-07 | None      | None       |
| All-in-One  | Glance=swift, Cinder=thinlvm          | CentOS 7.1 | Passed | [QuickStart](/install/quickstart/) | Prasanth Anbalagan | 2015-00-00 | None      | None       |
| All-in-One  | Glance=s3(amazon s3), Cinder=nfs      | CentOS 7.1 |        | [QuickStart](/install/quickstart/) |                    | 2015-00-00 | None      | None       |
| All-in-One  | Glance=s3(swift s3), Cinder=nfs       | CentOS 7.1 |        | [QuickStart](/install/quickstart/) |                    | 2015-00-00 | None      | None       |
| All-in-One  | Glance=ceph, Cinder=ceph              | CentOS 7.1 |        | [QuickStart](/install/quickstart/) |                    | 2015-00-00 | None      | None       |
| All-in-One  | Glance=XtreamIO, Cinder=XtreamIO      | CentOS 7.1 |        | [QuickStart](/install/quickstart/) |                    | 2015-00-00 | None      | None       |
| All-in-One  | Glance=localfs, Cinder=windows_iscsi | CentOS 7.1 |        | [QuickStart](/install/quickstart/) |                    | 2015-00-00 | None      | None       |
| All-in-One  | Glance=swift, Cinder=thinlvm          | RHEL7.1    | Passed | [QuickStart](/install/quickstart/) | Prasanth Anbalagan | 2015-00-00 | None      | None       |
| All-in-One  | Glance=s3, Cinder=nfs                 | RHEL7.1    |        | [QuickStart](/install/quickstart/) | bkopilov           | 2015-00-00 | None      | None       |
| All-in-One  | Glance=ceph, Cinder=ceph              | RHEL7.1    |        | [QuickStart](/install/quickstart/) | yrabl              | 2015-00-00 | None      | None       |
| All-in-One  | Glance=lvm, Cinder=glusterfs          | RHEL7.1    |        | [QuickStart](/install/quickstart/) | bkopilov           | 2015-00-00 | None      | None       |
| All-in-One  | Glance=lvm, Cinder=netapp_iscsi      | RHEL7.1    |        | [QuickStart](/install/quickstart/) | bkopilov           | 2015-00-00 | None      | None       |
| All-in-One  | Glance=nfs, Cinder=netapp_iscsi      | RHEL7.1    | failed | [QuickStart](/install/quickstart/) | tshefi             | 2015-00-00 | BZ1219406 | None       |
| All-in-One  | Glance=lvm, Cinder=netapp_nfs        | RHEL7.1    |        | [QuickStart](/install/quickstart/) | Juraj Marko        | 2015-00-00 | None      | None       |
| All-in-One  | swift                                 | RHEL7.1    | Passed | [QuickStart](/install/quickstart/) | Prasanth Anbalagan | 2015-00-00 | None      | None       |

## Packstack Based Installation (Misc Components)

Various components which don't fit the large test efforts above.

| Item/Area Name                                     | Release  | BaseOS     | Status                                       | HOWTO | Who      | Date       | BZ/LP                     | Notes Page |
|----------------------------------------------------|----------|------------|----------------------------------------------|-------|----------|------------|---------------------------|------------|
| Ceilometer: All-in-One w/ Neutron Networking       | RDO Kilo | RHEL 7.1   | <span style="background:#00ff00">Good</span> |       | yprokule | 2015-05-07 | 1219372, 1219376, 1219381 |            |
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO Kilo | CentOS 7.1 |                                              |       |          |            |                           |            |

## Core Tests

General openstack tests

| Item/Area Name                | Release  | BaseOS     | Status | HOWTO                                        | Who      | Date | BZ/LP                                                    | Notes Page                                |
|-------------------------------|----------|------------|--------|----------------------------------------------|----------|------|----------------------------------------------------------|-------------------------------------------|
| All-in-one Keystone tests     | RDO Kilo | CentOS 7.1 |        |                                              |          |      |                                                          |                                           |
| All-in-one Keystone tests     | RDO Kilo | RHEL 7.1   |        | <span style="background:#00ff00">Good</span> | |mabrams |      | packstack allinone                                       |                                           |
| All-in-one Keystone tests     | RDO Kilo | Fedora 21  |        |                                              |          |      |                                                          |                                           |
| All-in-one installation tests | RDO Kilo | RHEL 7.1   |        |                                              | |ajeain  |      | 1218555,1218627                                          |                                           |
| Distributed Horizon           | RDO Kilo | RHEL7.1    |        |                                              | iovadia  |      | 1218894                                                  |                                           |
| Heat tests                    | RDO Kilo | RHEL7.1    |        |                                              |          |      | Packstack + environment creation + sanity                |                                           |
| All-in-one Nova tests         | RDO Kilo | RHEL7.1    |        |                                              |          |      | Packstack + nova sanity                                  |                                           |
| All-in-one Nova tests         | RDO Kilo | Centos7.1  |        |                                              |          |      |                                                          |                                           |
|                               | RDO Kilo | Fedora 21  |        |                                              |          |      |                                                          |                                           |
| 2.node Nova tests             | RDO Kilo | RHEL7.1    |        |                                              |          |      | Packstack + nova live migration (block / shared storage) |                                           |
|                               | RDO Kilo | Fedora 21  |        |                                              |          |      |                                                          |                                           |
|                               | RDO Kilo | Centos7.1  |        | <span style="background:#00ff00">Good</span> | stoner   |      |                                                          | still requires selinux in permissive mode |

## Manual configuration of OpenStack

| Config Name                              | Release  | BaseOS     | Status | HOWTO | Who | Date | BZ/LP | Notes Page |
|------------------------------------------|----------|------------|--------|-------|-----|------|-------|------------|
| 2,node+minimal OpenStack+Neutron+OVS+GRE | RDO Kilo | Fedora 21  |        |       |     |      | None  | None       |
| 2,node+minimal OpenStack+Neutron+OVS+GRE | RDO Kilo | CentOS 7.1 |        |       |     |      | None  | None       |

## Post Installation Tests

| Config Name       | Release  | BaseOS     | Status | HOWTO                                                         | Who | Date | BZ/LP | Notes Page |
|-------------------|----------|------------|--------|---------------------------------------------------------------|-----|------|-------|------------|
| Post Installation | RDO Kilo | CentOS 7.1 |        | [Post Installation Tests](/install/post-installation-tests/) |     |      | None  |            |
