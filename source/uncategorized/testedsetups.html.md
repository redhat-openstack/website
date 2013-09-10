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

## Packstack Based Installation (Nova Networking)

| Config Name                   | Release     | BaseOS     | Status  | HOWTO                                              | Who      | Date       | BZ/LP                                                          | Notes Page |
|-------------------------------|-------------|------------|---------|----------------------------------------------------|----------|------------|----------------------------------------------------------------|------------|
| All-in-One w/ Nova Networking | RDO Grizzly | RHEL 6.4   | ??      | [Quickstart](Quickstart)                | ??       | ??         | None                                                           | None       |
| All-in-One w/ Nova Networking | RDO Grizzly | CentOS 6.4 | ??      | [Quickstart](Quickstart)                | ??       | ??         | None                                                           | None       |
| All-in-One w/ Nova Networking | RDO Grizzly | Fedora 19  | ??      | [Quickstart](Quickstart)                | ??       | ??         | None                                                           | None       |
| All-in-One w/ Nova Networking | RDO Havana  | RHEL 6.4   | Blocked | [ Havana Quickstart ](QuickStartLatest) | nmagnezi | 2013-09-10 | [1006214](https://bugzilla.redhat.com/show_bug.cgi?id=1006214) | None       |
| All-in-One w/ Nova Networking | RDO Havana  | CentOS 6.4 | ??      | [ Havana Quickstart ](QuickStartLatest) | ??       | ??         | None                                                           | None       |
| All-in-One w/ Nova Networking | RDO Havana  | Fedora 19  | ??      | [ Havana Quickstart ](QuickStartLatest) | ??       | ??         | None                                                           | None       |
| Multi Host w/ Nova Networking | RDO Grizzly | RHEL 6.4   | ??      | ??                                                 | ??       | ??         | None                                                           | None       |
| Multi Host w/ Nova Networking | RDO Grizzly | CentOS 6.4 | | ??    | ??                                                 | ??       | ??         | None                                                           | None       |
| Multi Host w/ Nova Networking | RDO Grizzly | Fedora 19  | ??      | ??                                                 | ??       | ??         | None                                                           | None       |
| Multi Host w/ Nova Networking | RDO Havana  | RHEL 6.4   | ??      | ??                                                 | ??       | ??         | None                                                           | None       |
| Multi Host w/ Nova Networking | RDO Havana  | CentOS 6.4 | ??      | ??                                                 | ??       | ??         | None                                                           | None       |
| Multi Host w/ Nova Networking | RDO Havana  | Fedora 19  | ??      | ??                                                 | ??       | ??         | None                                                           | None       |

## Packstack Based Installation (Quantum & Neutron Networking)

| Config Name                                                                      | Status                                                      | HOWTO                                                                                                                                           | Who      | Date       | BZ/LP                                                          | Notes Page                                    |
|----------------------------------------------------------------------------------|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------|----------------------------------------------------------------|-----------------------------------------------|
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking RDO Grizzly       | <span style="background:#00ff00">Good</span>                | [Neutron-Quickstart](Neutron-Quickstart)                                                                                             | pmyers   | 2013-09-08 | None                                                           | None                                          |
| All-in-One w/ Neutron OVS (no tunnels, fake bridge) Networking RDO Havana        | <span style="background:#ffff00">Good w/ workarounds</span> | [Neutron-Quickstart](Neutron-Quickstart)                                                                                             | pmyers   | 2013-09-08 | [1003701](https://bugzilla.redhat.com/show_bug.cgi?id=1003701) | May need manual install of python-netaddr pkg |
| All-in-One w/ Quantum OVS (no tunnels, real provider net) Networking RDO Grizzly | ??                                                          | [Neutron-Quickstart w/ External Accessibility](http://allthingsopen.com/2013/08/23/openstack-packstack-installation-with-external-connectivity) | jlibosva | 2013-09-10 | None                                                           | None                                          |
| All-in-One w/ Neutron OVS (no tunnels, real provider net) Networking RDO Havana  | ??                                                          | [Neutron-Quickstart w/ External Accessibility](http://allthingsopen.com/2013/08/23/openstack-packstack-installation-with-external-connectivity) | ??       | ??         | None                                                           | None                                          |

| Multi-host w/ Quantum OVS (GRE) Networking RDO Grizzly                           | ??                                                          | [ GRE Tenant Networks](Using_GRE_Tenant_Networks)                                                                                    | ??       | ??         | None                                                           | None                                          |

| Multi-host w/ Neutron OVS (GRE) Networking RDO Havana                            | ??                                                          | [ GRE Tenant Networks](Using_GRE_Tenant_Networks)                                                                                    | ??       | ??         | None                                                           | None                                          |

## Advanced Installs (Foreman Based) -- Work in Progress

Please see [Deploying RDO Using Foreman](Deploying RDO Using Foreman) for directions on setting up compute and controller nodes using foreman (only RHEL (derivatives) for now)

| Config Name                                      | Status | HOWTO                                                      | Who | Date | BZ/LP | Notes Page |
|--------------------------------------------------|--------|------------------------------------------------------------|-----|------|-------|------------|
| Multi-host w/ Load Balanced Services RDO Grizzly | ??     | [ Load Balance API](Load_Balance_OpenStack_API) | ??  | ??   | None  | None       |
| Multi-host w/ Load Balanced Services RDO Havana  | ??     | [ Load Balance API](Load_Balance_OpenStack_API) | ??  | ??   | None  | None       |

## Other

| Config Name                                  | Status       | HOWTO                                                                        | Who    | Date       | BZ/LP                                                                                                                                                             | Notes Page |
|----------------------------------------------|--------------|------------------------------------------------------------------------------|--------|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| Securing Services w/ RDO Grizzly             | ??           | [Securing_Services](Securing_Services)                           | ??     | ??         | None                                                                                                                                                              | None       |
| Securing Services w/ RDO Havana              | ??           | [Securing_Services](Securing_Services)                           | ??     | ??         | None                                                                                                                                                              | None       |
| Keystone integration with IDM w/ RDO Grizzly | ??           | [Keystone_integration_with_IDM](Keystone_integration_with_IDM) | ??     | ??         | None                                                                                                                                                              | None       |
| Keystone integration with IDM w/ RDO Havana  | ??           | [Keystone_integration_with_IDM](Keystone_integration_with_IDM) | ??     | ??         | None                                                                                                                                                              | None       |
| TripleO                                      | experimental | [TripleO_images](TripleO_images)                                 | derekh | 2013-09-10 | [1006241](https://bugzilla.redhat.com/show_bug.cgi?id=1006241) [<span style="background:#FF0000">1221620</span>](https://bugs.launchpad.net/tripleo/+bug/1221620) | None       |
