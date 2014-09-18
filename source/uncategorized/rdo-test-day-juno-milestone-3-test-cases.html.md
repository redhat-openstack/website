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

| Config Name | Release | BaseOS   | Status | HOWTO                               | Who | Date       | BZ/LP | Notes Page |
|-------------|---------|----------|--------|-------------------------------------|-----|------------|-------|------------|
| All-in-One  |         | CentOS 7 | ??     | [QuickStart](QuickStart) | ?   | 2014-00-00 | None  | None       |
| All-in-One  |         | F20      | ??     | [QuickStart](QuickStart) | ?   | 2014-00-00 | None  | None       |
| All-in-One  |         | RHEL 7   | ??     | [QuickStart](QuickStart) | ?   | 2014-00-00 | None  | None       |

## Packstack Based Installation (Storage Components)

Please see [Docs/Storage](Docs/Storage) for configuration guides as well as suggestions on what could be tested for both Cinder and Glance and make sure to use the steps described in the [RDO_test_day_January_2014#How_To_Test](RDO_test_day_January_2014#How_To_Test) page when installing the base RDO system. **Do not** go trough the Quickstart steps unmodified which will instead give you an RDO Havana deployment.

| Config Name | Backend | BaseOS     | Status | HOWTO | Who | Date | BZ/LP | Notes Page |
|-------------|---------|------------|--------|-------|-----|------|-------|------------|
|             |         | CentOS 6.5 | ??     |       | ??  | ??   | None  | None       |

## Packstack Based Installation (Misc Components)

Various components which don't fit the large test efforts above.

| Item/Area Name                                     | Release      | BaseOS   | Status | HOWTO | Who | Date | BZ/LP | Notes Page |
|----------------------------------------------------|--------------|----------|--------|-------|-----|------|-------|------------|
| Ceilometer: All-in-One w/ Neutron Networking, Heat | RDO icehouse | RHEL 6.5 |        |       |     |      |       |            |

## Manual configuration of OpenStack

| Config Name                              | Release | BaseOS    | Status | HOWTO                                                                                                                                                                                                                       | Who      | Date       | BZ/LP | Notes Page |
|------------------------------------------|---------|-----------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------|-------|------------|
| 2,node+minimal OpenStack+Neutron+OVS+GRE | Juno M3 | Fedora 21 |        | [IceHouse-Notes](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) [IceHouse-Configs](https://kashyapc.fedorapeople.org/virt/openstack/rdo/IceHouse-Nova-Neutron-ML2-GRE-OVS.txt) | kashyapc | 2013-17-09 | None  | None       |

## Other

| Config Name       | Release          | BaseOS | Status | HOWTO                                                         | Who | Date  | BZ/LP | Notes Page |
|-------------------|------------------|--------|--------|---------------------------------------------------------------|-----|-------|-------|------------|
| Post Installation | Juno Milestone 3 | ALL    | ??     | [Post Installation Tests](Post Installation Tests) | ALL | 18-09 | None  | None       |
