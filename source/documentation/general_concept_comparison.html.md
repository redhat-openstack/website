---
author: karolinku
title: Overview and comparison of RDO's deliverables
---

# Overview and comparison of RDO's deliverables

The RDO project has turning around two main concepts of deliverables: packages and repositories. Differences between them and their purpose may be confusing, so this documents is created to summarize the knowledge and emphasise divergences to help fully understand them.

## Packages

Packages in RDO are the most atomic unit in RDO and there are basically two kinds of them:
* OpenStack RDO packages (i.e. openstack-nova, openstack-neutron, python-osprofiler)
* dependencies (i.e. python-hatchling, python-eventlet)

Both types of package have distgits (repositories containing spec files) in common, as necessary part of package building process. \\
The table below shows main characteristic of each kind of package.

&nbsp;
&nbsp;

|| OpenStack RDO packages | dependencies |
| :---: | :---: | :---: |
|1.| Code comes from upstream OpenStack project | Code comes from any upstream project |
|2.| Created in RDO | Comes from Fedora |
|3.| Build by DLRN (Trunks) or CentOS CBS (CloudSIG) | Build by CentOS Community Build Service |

The first row of the table compares the origin of each kind of package. \\
The second row describes how packages land in RDO projects. In other words, each dependency's distgit has to be present in [Fedora](https://src.fedoraproject.org/) first, while distgits for OpenStack packages are created by package maintainers, as in this [example review](https://review.rdoproject.org/r/c/openstack/whitebox-neutron-tempest-plugin-distgit/+/45917). \\
The third row compares how packages are built.

These two kinds of packages are what composes the RDO repositories, in addition RDO project also takes part in maintaining and developing [Fedora OpenStackSIG](https://fedoraproject.org/wiki/SIGs/OpenStack) packages. The purpose of this special interest group is to maintain and ship latest packages such as: OpenStack clients, libraries and dependencies in Fedora.


## Repositories

In RDO we deliver two types of repositories:
* RDO Trunks
* RDO CloudSIGs

Each of them is managed and delivered in different way. Both of them are **composed from OpenStack packages and dependencies**, but they are shipped differently.

&nbsp;
&nbsp;

| | RDO Trunks | RDO CloudSIGs |
| :---: | :---: | :---: |
|1.| build by DLRN | build by CentOS Community Build Service |
|2.| new package with every new commit | new package with every new tag released upstream |
|3.| Delivered very close in time after new commit | Delivered in days |
|4.| Fetch source code through involved repo | Fetch tarball for point release |
|5.| Continuous delivery of master branch | Repo released after OpenStack GA |
|6.| Unsigned packages | Signed packages |
|7.| Delivered in trunk.rdoproject.org server | Delivered in official Centos mirrors in CloudSIG |

### Building
The first row shows that each repository is build by different system. All [trunk](https://trunk.rdoproject.org/) repos are created and managed by [DLRN](https://dlrn.readthedocs.io/en/latest/), while CloudSIGs is managed by [CBS](cbs.centos.org/).

### Handling new packages
The second and third row compare ways of handling new packages. In trunks, any time a new commit is merged in upstream project, the package building process is triggered and new repositories containing this package are published, so the time of publishing new deliverable is very short. For RDO CloudSIGs the process in slightly longer, because publishing new repo is happening when new tag is released in upstream, as in [example review](https://review.rdoproject.org/r/c/openstack/magnum-distgit/+/46543).

### Origin of sources

Package process building is fetching project source code directly from repository, while RDO CloudSIGs are basing on tarballs.

### Frequency of releasing

Trunk repositories are constantly following master branch for all projects, so new packages and repositories are delivered in continuous way. RDO CloudSIGs are released only after OpenStack GA.

### Security
 Trunks contains only unsigned packages on the contrary to RDO CloudSIGs.

### Distribution

Trunks are distributed by [trunk servers](https://trunk.rdoproject.org/). RDO CloudSIGs are delivered in official [Centos mirrors](https://mirror.stream.centos.org/).
