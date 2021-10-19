---
author: amoralej
title: TripleO in Xena
---

# TripleO in RDO Xena release

1. toc
{:toc}

### What has changed in TripleO during Xena release

In the Xena development cycle, [TripleO has moved to an Independent release model](https://specs.openstack.org/openstack/tripleo-specs/specs/xena/tripleo-independent-release.html). Since then, it will only maintain stable branches for selected OpenStack releases. In the case of Xena, TripleO will not support the Xena release. For TripleO users in RDO, this means that:
* RDO Xena will include packages for TripleO packages which have been [tested at OpenStack Xena GA time](https://review.rdoproject.org/r/c/rdoinfo/+/36340).
* Those packages will not be updated during the entire Xena maintenance cycle. RDO will not be able to include patches required to fix bugs in TripleO packages during the maintenance period in RDO Xena.
* TripleO will not provide container images based on OpenStack Xena release. Any user willing to deploy OpenStack Xena with TripleO will need to create the co
* TripleO project does not provide upgrade path from previous releases to Xena, or from Xena to next OpenStack releases.
* The lifecycle for the non-TripleO packages will follow the code merged and tested in upstream stable/xena branches.

### Note about RDO Trunk Xena repositories

As there are no stable/xena branches, the TripleO packages will also be pinned to the tags created at Xena GA time in [RDO Trunk repository](https://trunk.rdoproject.org/centos8-xena/report.html).

### How to create TripleO containers images in RDO Xena release

The RDO users willing to deploy RDO Xena with TripleO can build their own TripleO container images can do it by executing following process.

**Note:** If you plan to use the containers images to deploy OpenStack xena in different nodes you will need to push the containers to an external container images registry. The process to deploy a registry is out of the scope of this document.

1. In a CentOS Stream 8 environment install Xena repositories and enable required CentOS repos.

```
$ sudo dnf install -y centos-release-openstack-xena
$ sudo dnf install -y centos-release-opstools
$ sudo yum-config-manager --set-enable powertools
$ sudo yum-config-manager --set-enable ha
```

2. Make sure you have the right module stream for container-tools enabled:

```
$ sudo dnf module disable container-tools:rhel8 -y
$ sudo dnf module enable container-tools:3.0 -y
``

3. Install the package python3-tripleoclient

```
$ sudo dnf install -y python3-tripleoclient
```

4. Create the TripleO container images using the command

```
$ openstack tripleo container image build --base ubi8 --debug --distro centos \
 --namespace tripleoxena --prefix openstack --tag cloudsig-xena \
 --push --registry <registry_host>:<registry_port> \
 --volume /etc/yum.repos.d:/etc/distro.repos.d:z --volume /etc/pki/rpm-gpg:/etc/pki/rpm-gpg:z --volume /etc/dnf/vars:/etc/dnf/vars:z \
 --work-dir ~/workdir

```

Where:

* The options registry_host and registry_port must be the ip or hostname and port number of the container images registry where you plan to push the built containers.
* If you want to just build the containers and store them locally, skip options --push and --registry
* The option --work-dir can point to any user-writable directory in the system.

5. Once you have built your Xena based containers and pushed to your registry, you can follow the undercloud installation steps as described in the [TripleO official documentation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_undercloud.html). Make sure you follow the step "(OPTIONAL) Generate configuration for preparing container images" and to set up the required options to point to your custom parameters as specified in [the container image prepare section](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/container_image_prepare.html#default-registry) before running the container image preparation.

* Option `namespace` must be <registry_host>:<registry_port>/tripleoxena
* Option `tag` must be set to `cloudsig-xena`.

