---
title: Introducing opstools-ansible
author: atc
tags: 
date: 2017-08-14 10:10:10 PDT
---


Introducing Opstools-ansible

# Ansible

Ansible is an agentless, declarative configuration management tool. Ansible can be used to install and configure packages on a wide variety of targets. Targets are defined in the [inventory](http://docs.ansible.com/ansible/latest/intro_inventory.html) file for Ansible to apply the predefined actions.  Actions are defined as [playbooks](http://docs.ansible.com/ansible/latest/playbooks.html) or sometime [roles](https://docs.ansible.com/ansible-container/roles/index.html) in the form of YAML files. Details of Ansible can be found [here](http://docs.ansible.com/ansible/latest/index.html).

# Opstools-ansible

The project [opstools-ansible](https://github.com/centos-opstools/opstools-ansible) hosted in Github is to use Ansible to configure an environment that provides the support of opstools, namely centralized logging and analysis, availability monitoring, and performance monitoring.

One prerequisite to run opstools-ansible is that the servers have to be running with CentOS 7 or RHEL 7 (or a compatible distribution).

## Inventory file

These servers are to be defined in the inventory file with reference structure to this [file](https://github.com/centos-opstools/opstools-ansible/blob/master/inventory/structure) that defines 3 high level host groups:

- am\_hosts
- pm\_hosts
- logging\_host

There are lower level host groups but documentation stated that they are not tested.

## Configuration File

Once the inventory file is defined, the Ansible configuration files can be used to tailor to individual needs.  The [READM.rst](https://github.com/centos-opstools/opstools-ansible/blob/master/README.rst) file for opstools-ansible suggests the following as an example:

fluentd\_use\_ssl: true

fluentd\_shared\_key: secret

fluentd\_ca\_cert: |

  -----BEGIN CERTIFICATE-----

  ...

  -----END CERTIFICATE-----

fluentd\_private\_key: |

  -----BEGIN RSA PRIVATE KEY-----

  ...

  -----END RSA PRIVATE KEY-----

If there is no Ansible configuration file to tune the system, the default settings/options are applied.

## Playbooks and roles

The [playbook](https://github.com/centos-opstools/opstools-ansible/blob/master/playbook.yml) specifies what packages are to be installed in for the opstools environment by Ansible. Basically, the packages to be installed are:

- [ElasticSearch](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/elasticsearch)
- [Fluentd](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/fluentd)
- [Kibana](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/kibana)
- [Redis](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/redis)
- [RabbitMQ](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/rabbitmq)
- [Sensu](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/sensu)
- [Uchiwa](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/uchiwa)
- [CollectD](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/collectd)
- [Grafana](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/grafana)

Besides the above packages, opstools-ansible playbook also applies these additional roles

- [Firewall](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/firewall) – this role manages the firewall rules for the servers.
- [Prereqs](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/prereqs) – this role checks and installs all the dependency packages such as python-netaddr or libselinux-python … etc. for the successful installation of opstools.
- [Repos](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/repos) - this is a collection of roles for configuring additional package repositories.
- [Chrony](https://github.com/centos-opstools/opstools-ansible/tree/master/roles/chrony) – this role installs and configures the NTP client to make sure the time in each server is in sync with each other.

## opstools environment

Once these are done, we can simply apply the following command to create the opstools environment:

        ansible-playbook playbook.yml -e @config.yml

# TripleO Integration

TripleO (OpenStack on OpenStack) has the concept of Undercloud and Overcloud

- **Undercloud** : for deployment, configuration and management of OpenStack nodes.
- **Overcloud** : the actual OpenStack cluster that is consumed by user.

RedHat has an in-depth blog [post](http://redhatstackblog.redhat.com/2016/07/27/tripleo-director-components-in-detail/) on TripleO and OpenStack has this [document](https://docs.openstack.org/tripleo-docs/latest/) on contributing and installing TripleO

When opstools is installed at the TripleO Undercloud, the OpenStack instances running on the Overcloud can be configured to run the opstools service when it deployed. For example:

openstack overcloud deploy ... \

  -e /usr/share/openstack-tripleo-heat-templates/environments/monitoring-environment.yaml \

  -e /usr/share/openstack-tripleo-heat-templates/environments/logging-environment.yaml \

  -e params.yaml

There are only 3 steps to integrate opstools with TripleO with opstools-ansible. Detail of the steps can be found [here](https://github.com/centos-opstools/opstools-ansible/blob/master/docs/source/tripleo_integration.rst).

1. Use opstools-ansible to create the opstools environment at the Undercloud.
2. Create the params.yaml for TripleO to points to the Sensu and Fluentd agents at the opstools hosts.
3. Deploy with the &quot;openstack overcloud deploy …&quot; command.


