---
title: Workflow - RDO Trunk repos
---

# Workflow: RDO Trunk repos

RDO Trunk repositories are built using the most recent commit(or from the pin to a commit/tag/branch if ``source-branch`` is set for a release in [rdoinfo](https://github.com/redhat-openstack/rdoinfo/tree/master/tags)) from each of the OpenStack projects defined for a release. We host the RDO Trunk repositories at [https://trunk.rdoproject.org/](https://trunk.rdoproject.org/). On that server, you will find several repositories:

- [CentOS Stream 9 master, using versions from upper-constraints](https://trunk.rdoproject.org/centos9-master/consistent/)
- [CentOS Stream 8 and 9 stable releases for the currently supported versions](https://trunk.rdoproject.org)

These repos contain packages build for each OpenStack project defined for a particular release in ``rdoinfo``. This mapping of repo and release is as follows:-

- **CentOS Stream 9 master**, using versions from upper-constraints with current release rdoinfo tag i.e [zed-uc](https://github.com/redhat-openstack/rdoinfo/blob/master/tags/zed-uc.yml)
- **CentOS Stream 8 and 9 stable releases for the currently supported versions** with stable release rdoinfo tag other than current release [zed-uc](https://github.com/redhat-openstack/rdoinfo/blob/master/tags/)

## The upper-constraints based repositories

The gate jobs for each OpenStack project use a common set of dependencies, defined by the [requirements repository](https://github.com/openstack/requirements/). One of the files on that repository is [upper-constraints.txt](https://github.com/openstack/requirements/blob/master/upper-constraints.txt), which contains the supported version for each library on each OpenStack release.

Why is this file important? It defines an upper cap for every gate job, meaning those are the versions all OpenStack projects are being tested against. For example, if the specified version for ``python-novaclient`` in the file is X.Y.Z, we can safely assume that this version will work fine for all projects, but we cannot say the same for any commit beyond that point.

This is also important when packaging, because we want our generated repositories to be usable by upstream CIs, so we need to provide a set of packages that matches the versions available in the ``upper-constraints.txt`` file. For this reason RDO builds all libraries and clients from the latest versions in ``upper-constraints.txt``, and every other project is built from the master or stable branch.

## Hashed repos and special repos

When each new upstream commit is built, a repository is created with the new package and the latest versions from every other package built by RDO Trunk. This new repository is located in a hashed URL. This URL is built using:

- The hash of the commit for the project that triggered the build. I'll take as example, [commit 5848c0dd from openstack-neutron](https://github.com/openstack/neutron/commit/5848c0dd1c951e916c0b769f711d8aafa6aa72b1), long hash is 5848c0dd1c951e916c0b769f711d8aafa6aa72b1.
- The short hash of the distgit repo for the project. In the same example, it is [commit 21f87ec3 from the neutron-distgit repo](https://github.com/rdo-packages/neutron-distgit/commit/21f87ec3c18ca01bd0681ad8c14578a6ff52f012) which was the latest commit when the neutron patch was merged.
- The component for the pacakge. For each project, a component is defined in [rdoinfo openstack packages file](https://github.com/redhat-openstack/rdoinfo/blob/master/rdo.yml). For neutron the component is `network` (you can find it easily with [`rdopkg info`](/documentation/intro-packaging/#rdopkg) tool).

With that info we can figure out the repo URL:

https://trunk.rdoproject.org/centos9-master/component/network/58/48/5848c0dd1c951e916c0b769f711d8aafa6aa72b1_21f87ec3/

**Note the pattern:**

**`https://trunk.rdoproject.org/centos<centos version>-<release>/component/<component name>/<1:2 code hash>/<3:4 code hash>/<long code hash>_<short distgit hash>/`**

Besides hashed repositories, we have some special directories, created as symlinks to hashed repos:

- **current** points to the repository with contains the last successfully built package from every project.
- **consistent** points to the latest repository where none of the packages have current build failures.
- **current-passed-ci** points to the last consistent repository that passed all the promotion CI tests.

----

[← DLRN](/what/dlrn) |
[→ Promotion pipeline](/what/promotion-pipeline) |
[↑ TOC](/what)

