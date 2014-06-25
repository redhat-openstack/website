---
title: Deployment methods
authors: aortega
wiki_title: Deployment methods
wiki_revision_count: 1
wiki_last_updated: 2014-06-25
---

# Deployment methods

## Packstack Use Case

Packstack is primarily a proof-of-concept (PoC) tool intended to be used in two different scenarios: All in one deployments with and without additional compute nodes. Due to its PoC nature, Packstack makes a number of simplifications to reduce the number of potential configuration parameters, which streamlines the installation process.

Packstack supports the following components: Nova, Keystone, Glance, Cinder, Ceilometer, Horizon, Swift, Heat, and Neutron. On top of it, Packstack will also support Sahara and Marconi.

The number of supported network set-ups have been reduced to two options: Neutron with ML2 and VxLAN, and Nova-network.

Packstack supports two AMQP brokers: RabbitMQ and Qpid. However it assumes the same message broker will be used for all services.

Finally, Packstack supports the deployment of simple, non-high availability configurations of OpenStack components.

## Foreman Use Case

TBC
