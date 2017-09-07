---
title: Using a standalone Nodepool service to manage cloud instances
author: tristanC
tags: openstack, infra, nodepool, software-factory
date: 2017-03-29 00:00:01 UTC
---

[Nodepool](https://docs.openstack.org/infra/system-config/nodepool.html) is a
service used by the OpenStack CI team to deploy and manage a pool of
[devstack](https://docs.openstack.org/developer/devstack/)
images on a cloud server for use in OpenStack project testing.

This article presents how to use Nodepool to manage cloud instances.


## Requirements

For the purpose of this demonstration, we'll use a CentOS system and the
[Software Factory](https://softwarefactory-project.io/docs/)
distribution to get all the requirements:

```bash
sudo yum install -y --nogpgcheck https://softwarefactory-project.io/repos/sf-release-2.5.rpm
sudo yum install -y nodepoold nodepool-builder gearmand
sudo -u nodepool ssh-keygen -N '' -f /var/lib/nodepool/.ssh/id_rsa
```

Note that this installs nodepool version 0.4.0, which relies on Gearman and
still supports snapshot based images. More recent versions of Nodepool require
a Zookeeper service and only support diskimage builder images. Even though the
usage is similar and easy to adapt.


## Configuration

### Configure a cloud provider

Nodepool uses os-client-config to define cloud providers and it needs
a clouds.yaml file like this:

```bash
cat > /var/lib/nodepool/.config/openstack/clouds.yaml <<EOF
clouds:
  le-cloud:
    auth:
      username: "${OS_USERNAME}"
      password: "${OS_PASSWORD}"
      auth_url: "${OS_AUTH_URL}"
    project_name: "${OS_PROJECT_NAME}"
    regions:
      - "${OS_REGION_NAME}"
EOF
```

Using the OpenStack client, we can verify that the configuration is correct
and get the available network names:

```bash
sudo -u nodepool env OS_CLOUD=le-cloud openstack network list
```


### Diskimage builder elements

Nodepool uses [disk-image-builder](https://docs.openstack.org/developer/diskimage-builder/)
to create images locally so that the exact same image can be used across
multiple clouds. For this demonstration we'll use a minimal element to
setup basic ssh access:

```bash
mkdir -p /etc/nodepool/elements/nodepool-minimal/{extra-data.d,install.d}
```

In extra-data.d, scripts are executed outside of the image and the one bellow
is used to authorize ssh access:

```bash
cat > /etc/nodepool/elements/nodepool-minimal/extra-data.d/01-user-key <<'EOF'
#!/bin/sh
set -ex
cat /var/lib/nodepool/.ssh/id_rsa.pub > $TMP_HOOKS_PATH/id_rsa.pub
EOF
chmod +x /etc/nodepool/elements/nodepool-minimal/extra-data.d/01-user-key
```

In install.d, scripts are executed inside the image and the following
is used to create a user and install the authorized_key file:

```bash
cat > /etc/nodepool/elements/nodepool-minimal/install.d/50-jenkins <<'EOF'
#!/bin/sh
set -ex
useradd -m -d /home/jenkins jenkins
mkdir /home/jenkins/.ssh
mv /tmp/in_target.d/id_rsa.pub /home/jenkins/.ssh/authorized_keys
chown -R jenkins:jenkins /home/jenkins

# Nodepool expects this dir to exist when it boots slaves.
mkdir /etc/nodepool
chmod 0777 /etc/nodepool
EOF
chmod +x /etc/nodepool/elements/nodepool-minimal/install.d/50-jenkins
```


Note: all the examples in this articles are available in this repository:
[sf-elements](https://softwarefactory-project.io/r/gitweb?p=software-factory/sf-elements.git;a=snapshot;h=fef162aeed21b9a0ed744336bad3d5cc58ff94dd;sf=tgz).
More information to create elements is available [here](https://docs.openstack.org/developer/diskimage-builder/developer/developing_elements.html).


### Nodepool configuration

Nodepool main configuration is /etc/nodepool/nodepool.yaml:

```yaml
elements-dir: /etc/nodepool/elements
images-dir: /var/lib/nodepool/dib

cron:
  cleanup: '*/30 * * * *'
  check: '*/15 * * * *'

targets:
  - name: default

gearman-servers:
  - host: localhost

diskimages:
  - name: dib-centos-7
    elements:
      - centos-minimal
      - vm
      - dhcp-all-interfaces
      - growroot
      - openssh-server
      - nodepool-minimal

providers:
  - name: default
    cloud: le-cloud
    images:
      - name: centos-7
        diskimage: dib-centos-7
        username: jenkins
        private-key: /var/lib/nodepool/.ssh/id_rsa
        min-ram: 2048
    networks:
      - name: defaultnet
    max-servers: 10
    boot-timeout: 120
    clean-floating-ips: true
    image-type: raw
    pool: nova
    rate: 10.0

labels:
  - name: centos-7
    image: centos-7
    min-ready: 1
    providers:
      - name: default
```


Nodepool uses a gearman server to get node requests and to dispatch
image rebuild jobs. We'll uses a local gearmand server on localhost.
Thus, Nodepool will only respect the min-ready value and it won't
dynamically start node.

Diskimages define images' names and dib elements. All the elements
provided by dib, such as centos-minimal, are available, here is the
[full list](https://docs.openstack.org/developer/diskimage-builder/elements.html).

Providers define specific cloud provider settings such as the network name or
boot timeout. Lastly, labels define generic names for cloud images
to be used by jobs definition.

To sum up, labels reference images in providers that are constructed
with disk-image-builder.


## Create the first node

Start the services:

```bash
sudo systemctl start gearmand nodepool nodepool-builder
```


Nodepool will automatically initiate the image build, as shown in
/var/log/nodepool/nodepool.log: *WARNING nodepool.NodePool: Missing disk image centos-7*.
Image building logs are available in /var/log/nodepool/builder-image.log.

Check the building process:

```bash
# nodepool dib-image-list
+----+--------------+-----------------------------------------------+------------+----------+-------------+
| ID | Image        | Filename                                      | Version    | State    | Age         |
+----+--------------+-----------------------------------------------+------------+----------+-------------+
| 1  | dib-centos-7 | /var/lib/nodepool/dib/dib-centos-7-1490688700 | 1490702806 | building | 00:00:00:05 |
+----+--------------+-----------------------------------------------+------------+----------+-------------+
```


Once the dib image is ready, nodepool will upload the image:
*nodepool.NodePool: Missing image centos-7 on default*
When the image fails to build, nodepool will try again indefinitely,
look for "after-error" in builder-image.log.

Check the upload process:

```bash
# nodepool image-list
+----+----------+----------+----------+------------+----------+-----------+----------+-------------+
| ID | Provider | Image    | Hostname | Version    | Image ID | Server ID | State    | Age         |
+----+----------+----------+----------+------------+----------+-----------+----------+-------------+
| 1  | default  | centos-7 | centos-7 | 1490703207 | None     | None      | building | 00:00:00:43 |
+----+----------+----------+----------+------------+----------+-----------+----------+-------------+
```

Once the image is ready, nodepool will create an instance
*nodepool.NodePool: Need to launch 1 centos-7 nodes for default on default*:

```bash
# nodepool list
+----+----------+------+----------+---------+---------+--------------------+--------------------+-----------+------+----------+-------------+
| ID | Provider | AZ   | Label    | Target  | Manager | Hostname           | NodeName           | Server ID | IP   | State    | Age         |
+----+----------+------+----------+---------+---------+--------------------+--------------------+-----------+------+----------+-------------+
| 1  | default  | None | centos-7 | default | None    | centos-7-default-1 | centos-7-default-1 | XXX       | None | building | 00:00:01:37 |
+----+----------+------+----------+---------+---------+--------------------+--------------------+-----------+------+----------+-------------+
```

Once the node is ready, you have completed the first part of the process
described in this article and the Nodepool service should be working properly.
If the node goes directly from the building to the delete state, Nodepool will
try to recreate the node indefinitely. Look for errors in nodepool.log.
One common mistake is to have an incorrect provider network configuration,
you need to set a valid network name in nodepool.yaml.


## Nodepool operations

Here is a summary of the most common operations:

* Force the rebuild of an image: *nodepool image-build image-name*
* Force the upload of an image: *nodepool image-upload provider-name image-name*
* Delete a node: *nodepool delete node-id*
* Delete a local dib image: *nodepool dib-image-delete image-id*
* Delete a glance image: *nodepool image-delete image-id*

Nodepool "check" cron periodically verifies that nodes are available.
When a node is shutdown, it will automatically recreate it.


## Ready to use application deployment with Nodepool

As a Cloud developper, it is convenient to always have access to a fresh
OpenStack deployment for testing purpose. It's easy to break things and it
takes time to recreate a test environment, so let's use Nodepool.

First we'll add a new [elements](https://softwarefactory-project.io/r/gitweb?p=software-factory/sf-elements.git;a=tree;f=elements/rdo-requirements)
to pre-install the typical rdo requirements:

```yaml
diskimages:
  - name: dib-rdo-newton
    elements:
      - centos-minimal
      - nodepool-minimal
      - rdo-requirements
    env-vars:
      RDO_RELEASE: "ocata"

providers:
  - name: default
    images:
      - name: rdo-newton
        diskimage: dib-rdo-newton
        username: jenkins
        min-ram: 8192
        private-key: /var/lib/nodepool/.ssh/id_rsa
        ready-script: run_packstack.sh
```


Then using a [ready-script](https://softwarefactory-project.io/r/gitweb?p=software-factory/sf-elements.git;a=blob;f=scripts/run_packstack.sh),
we can execute packstack to deploy services after the node has been created:

```yaml
label:
  - name: rdo-ocata
    image: rdo-ocata
    min-ready: 1
    ready-script: run_packstack.sh
    providers:
      - name: default
```

Once the node is ready, use *nodepool list* to get the IP address:

```bash
# ssh -i /var/lib/nodepool/.ssh/id_rsa jenkins@node
jenkins$ . keystonerc_admin
jenkins (keystone_admin)$ openstack catalog list
+-----------+-----------+-------------------------------+
| Name      | Type      | Endpoints                     |
+-----------+-----------+-------------------------------+
| keystone  | identity  | RegionOne                     |
|           |           |   public: http://node:5000/v3 |
...
```

To get a new instance, either terminate the current one, or manually delete it
using *nodepool delete node-id*.
A few minutes later you will have a fresh and pristine environment!
