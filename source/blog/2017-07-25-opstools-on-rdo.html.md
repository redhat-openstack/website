---
title: OpsTools on RDO
author: atc
tags: 
date: 2017-07-25 10:10:10 PDT
---


OpsTools for RDO

# CentOS SIG

In the CentOS community there are [Special Interest Groups](https://wiki.centos.org/SpecialInterestGroup) (SIG) that focus on specific issues such as cloud, storage, virtualization, or operational tools (OpsTools).  These special interest groups are created to either to create awareness or to tackle the development of that subject with focus. Among the groups there is the [Operational tools group](https://wiki.centos.org/SpecialInterestGroup/OpsTools) (OpsTools) that focus on

- Performance Monitoring
- Availability Monitoring
- Centralized Logging

# OpenStack Operational Tools

While the OpsTools are created for the CentOS community, it is also applicable and available for RDO. More information can be found at [GitHub](https://github.com/centos-opstools/opstools-doc).

## Centralized Logging

The centralized logging has the following components:

|
- A Log Collection Agent (Fluentd)
 |
| --- |
|   |

|
- A Log relay/transformer (Fluentd)
 |
| --- |
|   |

|
- A Data store (Elasticsearch)
 |
| --- |
|   |

- An API/Presentation Layer (Kibana)

With the minimum hardware requirement:

|
- 8GB of Memory
 |
| --- |
|   |

|
- Single Socket Xeon Class CPU
 |
| --- |
|   |

- 500GB of Disk Space

Detailed instruction to install can be found [here](https://github.com/centos-opstools/opstools-doc/blob/master/centralised-logging.txt).

## Availability Monitoring

The Availability Monitoring has the following components:

- A Monitoring Agent (sensu)
- A Monitoring Relay/proxy (rabbitmq)
- A Monitoring Controller/Server (sensu)
- An API/Presentation Layer (uchiwa)

With the minimum hardware requirement:

- 4GB of Memory
- Single Socket Xeon Class CPU
- 100GB of Disk Space

Detailed instruction to install can be found [here](https://github.com/centos-opstools/opstools-doc/blob/master/availability-monitoring.txt).

## Performance Monitoring

The Performance Monitoring has the following components:

- A Collection Agent (collectd)
- A Collection Aggregator/Relay (graphite)
- A Data Store (whisperdb)
- An API/Presentation Layer (grafana)

With the minimum hardware requirement:

- 4GB of Memory
- Single Socket Xeon Class CPU
- 500GB of Disk Space

Detailed instruction to install can be found [here](https://github.com/centos-opstools/opstools-doc/blob/master/performance-monitoring.txt).

## Ansible playbooks for deploying OpsTools

Besides manually install the OpsTools, there are Ansible roles and playbooks to automate the installation process and instructions can be found [here](https://github.com/centos-opstools/opstools-ansible).

