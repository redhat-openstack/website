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

May Test Day information at [RDO_test_day_Kilo](RDO_test_day_Kilo)

## Workarounds

When you hit a problem, check out the [Workarounds](Workarounds) page first. Maybe the problem is already there including a workaround. If not, please add it to prevent duplicating effort.

## Packstack Based Installation (Neutron Networking)

| Config Name                                                          | Release          | BaseOS     | Status | HOWTO                                                        | Who | Date | BZ/LP | Notes Page |
|----------------------------------------------------------------------|------------------|------------|--------|--------------------------------------------------------------|-----|------|-------|------------|
| All-in-One w/ Neutron OVS (no tunnels, fake bridge) Networking       | Kilo 2015.1-0rc2 | RHEL 7.1   |        | [Neutron-Quickstart](Neutron-Quickstart)          |     |      | None  | None       |
|                                                                      |                  | CentOS 7.1 | ??     | [Neutron-Quickstart](Neutron-Quickstart)          |     |      | None  | None       |
|                                                                      |                  | Fedora 20  |        | [Neutron-Quickstart](Neutron-Quickstart)          |     |      | None  | None       |
| All-in-One w/ Neutron OVS (no tunnels, real provider net) Networking | Kilo 2015.1-0rc2 | RHEL 7.1   |        |                                                              |     |      | None  | None       |
|                                                                      |                  | CentOS 7.1 |        |                                                              |     |      | None  | None       |
|                                                                      |                  | Fedora 20  |        |                                                              |     |      |       |
| Multi-host w/ Neutron OVS (GRE) Networking                           | Kilo 2015.1-0rc2 | RHEL 7.1   | ??     | [ GRE Tenant Networks](Using_GRE_Tenant_Networks) |     |      | None  | None       |
|                                                                      |                  | CentOS 7.1 | ??     | [ GRE Tenant Networks](Using_GRE_Tenant_Networks) | ??  | ??   | None  | None       |
|                                                                      |                  | Fedora 20  | ??     | [ GRE Tenant Networks](Using_GRE_Tenant_Networks) | ??  | ??   | None  | None       |

## Advanced Installs (Foreman Based) -- Work in Progress

Please see [Deploying RDO Using Foreman](Deploying RDO Using Foreman) for directions on setting up compute and controller nodes using foreman (only RHEL (derivatives) for now)

| Config Name                          | Release    | BaseOS     | Status | HOWTO                                                                                                               | Who | Date | BZ/LP | Notes Page |
|--------------------------------------|------------|------------|--------|---------------------------------------------------------------------------------------------------------------------|-----|------|-------|------------|
| 2 Node install with Nova Networking  | Havana H-3 | RHEL 6.4   | ??     | [ 2 Node install with Nova Networking](Deploying_RDO_Using_Foreman #2_Node_install_with_Nova_Networking) | ??  | ??   | None  | None       |
|                                      |            | CentOS 6.4 | ??     | [ 2 Node install with Nova Networking](Deploying_RDO_Using_Foreman#2_Node_install_with_Nova_Networking)  | ??  | ??   | None  | None       |
| 3 Node install with Neutron          | Havana H-3 | RHEL 6.4   | ??     | [ 3 Node install with Neutron](Deploying_RDO_Using_Foreman#Neutron_with_Networker_Node)                  | ??  | ??   | None  | None       |
|                                      |            | CentOS 6.4 | ??     | [ 3 Node install with Neutron](Deploying_RDO_Using_Foreman#Neutron_with_Networker_Node)                  | ??  | ??   | None  | None       |
| Multi-host w/ Load Balanced Services | Havana H-3 | RHEL 6.4   | ??     | [ Load Balanced API](Load_Balance_OpenStack_API)                                                         | ??  | ??   | None  | None       |
|                                      |            | CentOS 6.4 | ??     | [ Load Balanced API](Load_Balance_OpenStack_API)                                                         | ??  | ??   | None  | None       |
| HA MySql                             | Havana H-3 | RHEL 6.4   | ??     | [ HA MySql](Deploying_RDO_Using_Foreman#HA_Database_Cluster)                                             | ??  | ??   | None  | None       |
|                                      |            | CentOS 6.4 | ??     | [ HA MySql](Deploying_RDO_Using_Foreman#HA_Database_Cluster)                                             | ??  | ??   | None  | None       |

## Other

| Config Name                                                 | Release          | BaseOS     | Status                                              | HOWTO                                                                        | Who        | Date          | BZ/LP                                                                                                                                                                                              | Notes Page             |
|-------------------------------------------------------------|------------------|------------|-----------------------------------------------------|------------------------------------------------------------------------------|------------|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------|
| Securing RDO Core Services (API Endpoints, Message Brokers) | Grizzly 2013.1.3 | RHEL 6.4   | ??                                                  | [Securing_Services](Securing_Services)                           | ??         | ??            | None                                                                                                                                                                                               | None                   |
|                                                             |                  | CentOS 6.4 | ??                                                  | [Securing_Services](Securing_Services)                           | ??         | ??            | None                                                                                                                                                                                               | None                   |
|                                                             | Havana H-3       | RHEL 6.4   | ??                                                  | [Securing_Services](Securing_Services)                           | ??         | ??            | None                                                                                                                                                                                               | None                   |
|                                                             |                  | CentOS 6.4 | ??                                                  | [Securing_Services](Securing_Services)                           | ??         | ??            | None                                                                                                                                                                                               | None                   |
| Keystone integration with IDM w/ RDO Grizzly                | Grizzly 2013.1.3 | RHEL 6.4   | ??                                                  | [Keystone_integration_with_IDM](Keystone_integration_with_IDM) | ??         | ??            | None                                                                                                                                                                                               | None                   |
|                                                             |                  | CentOS 6.4 | ??                                                  | [Keystone_integration_with_IDM](Keystone_integration_with_IDM) | ??         | ??            | None                                                                                                                                                                                               | None                   |
|                                                             | Havana H-3       | RHEL 6.4   | ??                                                  | [Keystone_integration_with_IDM](Keystone_integration_with_IDM) | ??         | ??            | None                                                                                                                                                                                               | None                   |
|                                                             |                  | CentOS 6.4 | ??                                                  | [Keystone_integration_with_IDM](Keystone_integration_with_IDM) | ??         | ??            | None                                                                                                                                                                                               | None                   |
| TripleO                                                     | Havana H-3       | Fedora 19  | experimental                                        | [TripleO_images](TripleO_images)                                 | derekh     | 2013-09-10    | [1006241](https://bugzilla.redhat.com/show_bug.cgi?id=1006241) [~~1221620~~](https://bugs.launchpad.net/tripleo/+bug/1221620)                                                                      | None                   |
| Multi-host w/ Quantum OVS (GRE) Networking w/o Packstack    | Havana H-3       | SL 6.4     | <span style="background:#ffff00">Workarounds</span> | N/A (custom setup)                                                           | red_trela | 2013-09-10/11 | ~~[996776](https://bugzilla.redhat.com/show_bug.cgi?id=996776)~~ ~~[1006766](https://bugzilla.redhat.com/show_bug.cgi?id=1006766)~~ [1006902](https://bugzilla.redhat.com/show_bug.cgi?id=1006902) | None                   |
| Two-node manual setup w/ Neutron Networking (OVS /GRE)      | Havana           | Fedora 20  |                                                     | N/A (custom setup)                                                           | kashyap    | 2013-09-10/11 | None                                                                                                                                                                                               | <http://goo.gl/k2UhH0> |

## How to Test

So, now you've followed one of the guides above and have a working RDO install. What next? How do you verify that things worked properly?

Following these two guides would be a good start:

*   [ Running an Instance ](Running_an_instance)
*   [ Creating a Floating IP Range and associating it to your instance ](Floating_IP_range)
