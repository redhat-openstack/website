---
title: Workflow overview and infrastructure
---

# Workflow: Overview and infrastructure

During the cycle of a given OpenStack release, we have the following recurring activities:

- [New packages are created when needed](https://www.rdoproject.org/documentation/rdo-packaging/#how-to-add-a-new-package-to-rdo-trunk).
- Each package is rebuilt anytime a new commit is available in the repository upstream on the RDO Trunk builder.
  - If the package build fails, a review is automatically opened in our [Gerrit review system](https://review.rdoproject.org), so the package maintainers can work on a fix.
- Periodically, the latest repository where all packages had been successfully built goes through a number of CI jobs. If all jobs are successful, the repository is _promoted_, meaning it is considered as good enough for other upstream CIs to rely on it for their jobs.

## Infrastructure

The following pieces of infrastructure are used during the cycle:

- [review.rdoproject.org](https://review.rdoproject.org) is the central system for our workflow, powered by [SoftwareFactory](https://softwarefactory-project.io/docs/). It contains a Gerrit instance to manage all changes to the repositories where the spec files used to build our packages are contained, as well as the components managing our CI infrastructure.
- [Our distgit repositories](https://github.com/rdo-packages) contain one repository for each project built by RDO, where the spec files are located. Every change submitted via review.rdoproject.org is synchronized to the repos at GitHub.
- [The RDO Trunk repositories](what/trunk-repos) contain the latest packages.
- [The Centos CI infrastructure](https://ci.centos.org/view/rdo/view/promotion-pipeline/) is used to run the periodic jobs to promote the latest repositories.
- Our own RDO Cloud is used to host most of our infrastructure servers, as well as a pool of test VMs used by review.rdoproject.org to verify all incoming changes.

----

[← Workflow](/what/workflow) |
[→ DLRN](/what/dlrn) |
[↑ TOC](/what) 
