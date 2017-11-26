---
title: Workflow - RDO Trunk repos
---

# Workflow: RDO Trunk repos

RDO Trunk repositories are built using the most recent commit from each of the OpenStack projects. We host the RDO Trunk repositories at [https://trunk.rdoproject.org/](https://trunk.rdoproject.org/). On that server, you will find several repositories:

- CentOS 7 master
- CentOS 7 master, using versions from upper-constraints
- CentOS 7 stable releases for the currently supported versions
- Fedora Rawhide master

## The upper-constraints based repositories

The gate jobs for each OpenStack project use a common set of dependencies, defined by the [requirements repository](https://github.com/openstack/requirements/). One of the files on that repository is [upper-constraints.txt](https://github.com/openstack/requirements/blob/master/upper-constraints.txt), which contains the latest supported version for each component.

Why is this file important? It defines an upper cap for every gate job, meaning those are the versions all OpenStack projects are being tested against. For example, if the specified version for ``python-novaclient`` in the file is 9.0.0, we can safely assume that this version will work fine for all projects, but we cannot say the same for any commit beyond that point.

This is also important when packaging, because we want our generated repositories to be usable by upstream CIs, so we need to provide a set of packages that matches the versions available in the ``upper-constraints.txt`` file. Thus, we have two separate repositories for master:

- [CentOS 7 master, using versions from upper-constraints](https://trunk.rdoproject.org/centos7), where all libraries and clients are built from the latest versions in ``upper-constraints.txt``, and every other project is built from the master branch.
- [CentOS 7 master, with everything from master](https://trunk.rdoproject.org/centos7-master-head), where every project is built from the current master. This is used as a _canary in a coal mine_, as an early warning method for upcoming issues, so they can be fixed before they reach the upstream gates.

For stable releases, we also follow the upper-constraints approach.

## Hashed repos and special repos

When each new upstream commit is built, a repository is created with the new package and the latest versions from every other package built by RDO Trunk. This new repository is located in a hashed URL, for example [https://www.rdoproject.org/what/trunk-repos/](https://www.rdoproject.org/what/trunk-repos/). This hash is built using:

- The hash of the commit for the project that triggered the build. In the above example, it is [commit 51299ba from openstack-zaqar](https://github.com/openstack/zaqar/commit/51299ba1eca22462c5560854f53b668ad7872ac7).
- The short hash of the distgit repo for the project. In the above example, it is [commit 18d76a1f from the zaqar-distgit repo](https://github.com/rdo-packages/zaqar-distgit/commit/18d76a1f8b95171e418b52a17001473af7d6fde5).

Besides hashed repositories, we have some special directories, created as symlinks to hashed repos:

- **current** points to the repository with contains the last successfully built package from every project.
- **consistent** points to the latest repository where none of the packages have current build failures.
- **current-passed-ci** points to the last consistent repository that passed all the promotion CI tests.

----

[← DLRN](/what/dlrn) |
[→ Promotion pipeline](/what/promotion-pipeline) |
[↑ TOC](/what) 

