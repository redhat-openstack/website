---
title: Release workflow overview and infrastructure
---

# Release workflow: Overview and infrastructure

Once an OpenStack release is created, we use a different workflow to maintain the GA packages.

- Packages are built as part of the [CentOS Cloud SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud), signed and distributed via the [CentOS repositories](http://mirror.centos.org/centos/7/cloud/).
- When a project releases a new version on a stable branch, an automated process will propose a new version of the package in the appropriate stable release of the distgit repository.
- The package will then be built and uploaded to the [testing repository](/what/repos#Testing).
- Once the package has passed the required CI jobs, it will be moved to the [GA repository](/what/repos#GA).

## Infrastructure

The following pieces of infrastructure are used for GA packages:

- The [CentOS Community Build System](https://cbs.centos.org) is used to build the packages
- The CentOS distributed infrastructure is used to distribute the [testing](https://buildlogs.centos.org/centos/7/cloud/) and [GA](http://mirror.centos.org/centos/7/cloud/) repositories
- [review.rdoproject.org](https://review.rdoproject.org) is still used to review the changes to our distgit repositories.
- [Our distgit repositories](https://github.com/rdo-packages) contain one repository for each project built by RDO, where the spec files are located.

----

[← Release workflow](/what/release-workflow) |
[↑ TOC](/what) 

