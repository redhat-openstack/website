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

Tested Setups for [RDO_test_day_Juno_milestone_3](RDO_test_day_Juno_milestone_3). Tests should be executed against the Juno RDO **not** Icehouse, some steps from the official Quickstart guide **do not** apply to Juno; make sure to follow the steps described in the [RDO_test_day_Juno_milestone_3#How_To_Test](RDO_test_day_Juno_milestone_3#How_To_Test) page instead.

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

## Advanced Installs (Foreman Based) -- Work in Progress

Please see [Deploying RDO Using Foreman](Deploying RDO Using Foreman) for directions on setting up compute and controller nodes using foreman (only RHEL (derivatives) for now)

| Config Name                              | Release      | BaseOS     | Status                                       | HOWTO                                                                                                               | Who      | Date     | BZ/LP | Notes Page    |
|------------------------------------------|--------------|------------|----------------------------------------------|---------------------------------------------------------------------------------------------------------------------|----------|----------|-------|---------------|
| 2 Node install with Nova Networking      | RDO Icehouse | RHEL 6.5   |                                              | [ 2 Node install with Nova Networking](Deploying_RDO_Using_Foreman #2_Node_install_with_Nova_Networking) | ohochman | 2014 -02 |       | |             |
|                                          |              | CentOS 6.5 | ??                                           | [ 2 Node install with Nova Networking](Deploying_RDO_Using_Foreman#2_Node_install_with_Nova_Networking)  | ??       | ??       | None  | None          |
| 3 Node install with Neutron              | RDO Icehouse | RHEL 6.5   | <span style="background:#00ff00">Good</span> | [ 3 Node install with Neutron](Deploying_RDO_Using_Foreman#Neutron_with_Networker_Node)                  | ohochman | 2014 -02 |       | | Bz#1061613 |
|                                          |              | CentOS 6.5 | ??                                           | [ 3 Node install with Neutron](Deploying_RDO_Using_Foreman#Neutron_with_Networker_Node)                  |          |          | None  | None          |
| 4 node (Compute x2) install with Neutron | RDO Icehouse | RHEL 6.5   | <span style="background:#00ff00">Good</span> | [ 4 Node install (Compute x2) with Neutron](Deploying_RDO_Using_Foreman#Neutron_with_Networker_Node)     | ohochman | 2014 -02 | None  | None          |
| Multi-host w/ Load Balanced Services     | RDO Icehouse | RHEL 6.5   | None                                         | [ Load Balanced API](Load_Balance_OpenStack_API)                                                         | ??       | ??       | None  | None          |
|                                          |              | CentOS 6.5 | ??                                           | [ Load Balanced API](Load_Balance_OpenStack_API)                                                         | ??       | ??       | None  | None          |
| HA MySql                                 | RDO Icehouse | RHEL 6.5   | ??                                           | [ HA MySql](Deploying_RDO_Using_Foreman#HA_Database_Cluster)                                             | ??       | ??       | None  | None          |
|                                          |              | CentOS 6.5 | ??                                           | [ HA MySql](Deploying_RDO_Using_Foreman#HA_Database_Cluster)                                             | ??       | ??       | None  | None          |

## Other

| Config Name                                                 | Release | BaseOS    | Status | HOWTO                                                                                            | Who    | Date  | BZ/LP | Notes Page                                                                                                                                                                                                                                                                |
|-------------------------------------------------------------|---------|-----------|--------|--------------------------------------------------------------------------------------------------|--------|-------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Savanna, hadoop cluster provisioning                        |         |           | ??     | [Savanna installation and setup](https://savanna.readthedocs.org/en/latest/)                     | ??     | ??    | None  | None                                                                                                                                                                                                                                                                      |
| Securing RDO Core Services (API Endpoints, Message Brokers) |         |           | ??     | [Securing_Services](Securing_Services)                                               | ??     | ??    | None  | None                                                                                                                                                                                                                                                                      |
| Tuskar and TripleO                                          |         |           |        | [Deploying_RDO_Using_Tuskar_And_TripleO](Deploying_RDO_Using_Tuskar_And_TripleO) |        |       | None  | <https://etherpad.openstack.org/p/rdo_test_day_jan_2014>. These instructions are likely out of date (per discussion with slagle). Adding a task below for testing TripleO Setup                                                                                           |
| OpenStack deployment using TripleO                          |         | Fedora 20 | ??     | [TripleO_VM_Setup](TripleO_VM_Setup)                                                | rlandy | 02/04 | None  | Could run through TripleO_VM_Setup, pick up devtest_overcloud.html at step 10 and ping the VM deployed by the demo user. Task uses vm images are based on the icehouse-2 milestone tarballs. Tripleo setup for icehouse RDO packages are not yet available for testing |
