---
title: TestedSetups
authors: acalinciuc, derekh, dron, gdubreui, jayg, jdennis, jlibosva, jruzicka, kashyap,
  mkolesni, mlessard, morazi, ndipanov, nmagnezi, pixelbeat, pmyers, rbowen, rcritten,
  red trela, rkukura, russellb, stzilli, vaneldik, whayutin, xqueralt
wiki_title: TestedSetups
wiki_revision_count: 134
wiki_last_updated: 2014-01-06
---

# Tested Setups

## Packstack/Quickstart Based Installation (Nova Networking)

| Config Name                               | Status | HOWTO                                                | Person who made last attempt | Date of last attempt | BZ/LP | Notes Page |
|-------------------------------------------|--------|------------------------------------------------------|------------------------------|----------------------|-------|------------|
| All-in-One w/ Nova Networking RDO Grizzly | ??     | [Quickstart](http://openstack.redhat.com/Quickstart) | ??                           | ??                   | None  | None       |
| All-in-One w/ Nova Networking RDO Havana  | ??     | [Quickstart](http://openstack.redhat.com/Quickstart) | ??                           | ??                   | None  | None       |
| All-in-One w/ Nova Networking RDO Trunk   | ??     | [Quickstart](http://openstack.redhat.com/Quickstart) | ??                           | ??                   | None  | None       |
| Multi Host w/ Nova Networking RDO Grizzly | ??     | ??                                                   | ??                           | ??                   | None  | None       |
| Multi Host w/ Nova Networking RDO Havana  | ??     | ??                                                   | ??                           | ??                   | None  | None       |
| Multi Host w/ Nova Networking RDO Trunk   | ??     | ??                                                   | ??                           | ??                   | None  | None       |

## Neutron-Quickstart Based Installation

| Config Name                                                                      | Status                                                      | HOWTO                                                                                                                                           | Who    | Date       | BZ/LP                                                          | Notes Page                                    |
|----------------------------------------------------------------------------------|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|--------|------------|----------------------------------------------------------------|-----------------------------------------------|
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking RDO Grizzly       | <span style="background:#00ff00">Good</span>                | [Neutron-Quickstart](Neutron-Quickstart)                                                                                             | pmyers | 2013-09-08 | None                                                           | None                                          |
| All-in-One w/ Neutron OVS (no tunnels, fake bridge) Networking RDO Havana        | <span style="background:#ffff00">Good w/ workarounds</span> | [Neutron-Quickstart](Neutron-Quickstart)                                                                                             | pmyers | 2013-09-08 | [1003701](https://bugzilla.redhat.com/show_bug.cgi?id=1003701) | May need manual install of python-netaddr pkg |
| All-in-One w/ Neutron OVS (no tunnels, fake bridge) Networking RDO Trunk         | ??                                                          | [Neutron-Quickstart](Neutron-Quickstart)                                                                                             | ??     | ??         | None                                                           | None                                          |
| All-in-One w/ Quantum OVS (no tunnels, real provider net) Networking RDO Grizzly | ??                                                          | [Neutron-Quickstart w/ External Accessibility](http://allthingsopen.com/2013/08/23/openstack-packstack-installation-with-external-connectivity) | ??     | ??         | None                                                           | None                                          |
| All-in-One w/ Neutron OVS (no tunnels, real provider net) Networking RDO Havana  | ??                                                          | [Neutron-Quickstart w/ External Accessibility](http://allthingsopen.com/2013/08/23/openstack-packstack-installation-with-external-connectivity) | ??     | ??         | None                                                           | None                                          |
| All-in-One w/ Neutron OVS (no tunnels, real provider net) Networking RDO Trunk   | ??                                                          | [Neutron-Quickstart w/ External Accessibility](http://allthingsopen.com/2013/08/23/openstack-packstack-installation-with-external-connectivity) | ??     | ??         | None                                                           | None                                          |

| Multi-host w/ Quantum OVS (GRE) Networking RDO Grizzly                           | ??                                                          | [ GRE Tenant Networks](Using_GRE_Tenant_Networks)                                                                                    | ??     | ??         | None                                                           | None                                          |

| Multi-host w/ Neutron OVS (GRE) Networking RDO Havana                            | ??                                                          | [ GRE Tenant Networks](Using_GRE_Tenant_Networks)                                                                                    | ??     | ??         | None                                                           | None                                          |

| Multi-host w/ Neutron OVS (GRE) Networking RDO Trunk                             | ??                                                          | [ GRE Tenant Networks](Using_GRE_Tenant_Networks)                                                                                    | ??     | ??         | None                                                           | None                                          |

## Advanced Installs (Foreman Based) -- Work in Progress

| Config Name                                           | Status | HOWTO                                                      | Who | Date | BZ/LP | Notes Page |
|-------------------------------------------------------|--------|------------------------------------------------------------|-----|------|-------|------------|
| Multi-host w/ Load Balanced Services RDO Grizzly      | ??     | [ Load Balance API](Load_Balance_OpenStack_API) | ??  | ??   | None  | None       |
| Multi-host w/ Load Balanced Services RDO Havana       | ??     | [ Load Balance API](Load_Balance_OpenStack_API) | ??  | ??   | None  | None       |
| Multi-host w/ Load Balanced Services RDO Havana Trunk | ??     | [ Load Balance API](Load_Balance_OpenStack_API) | ??  | ??   | None  | None       |
