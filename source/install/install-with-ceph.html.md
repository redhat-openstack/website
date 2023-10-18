---
title: Install with Ceph
category: documentation
authors: jcapitao
---

# Install RDO with Ceph as storage

## The Ceph releases used for each RDO release

| RDO Release | Ceph Release |
| ------ | ----- |
| Bobcat | Reef |
| Antelope | Quincy |
| Zed | Quincy |
| Yoga | Pacific |

## Enable EPEL repository for Ceph Reef

Since the Ceph Reef release, the [CentOS Stream Storage SIG](https://sigs.centos.org/storage/) decided to pull some dependencies from the EPEL repo instead of rebuilding and providing them itself.<br>
As a result, the EPEL repository needs to be enabled on the target host in order to be able to install `centos-release-ceph-reef` sucessfully.<br>
However, enabling the EPEL repository with the default parameters might conflict with the RDO repository (i.e duplicate packages with different NVR). To avoid this conflict, you must set the EPEL repository with a lower priority and include only the packages needed, see below:

  ```
  $ sudo dnf update
  $ sudo dnf install 'dnf-command(config-manager)'
  $ sudo dnf config-manager --enable crb
  $ sudo dnf install epel-release
  $ sudo sed -i '/^gpgcheck.*/a priority=100' /etc/yum.repos.d/epel.repo
  $ sudo sed -i '/^priority=100/a includepkgs=libarrow*,parquet*,python3-asyncssh,re2,python3-grpcio,grpc*,abseil*' /etc/yum.repos.d/epel.repo
  $ sudo dnf install centos-release-ceph-reef
  $ sudo dnf install ceph
  ```
  Note: installing `centos-release-ceph-reef` is not needed if `centos-releae-openstack-bobcat` is already installed (i.e it's a requirement).

