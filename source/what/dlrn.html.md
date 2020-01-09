---
title: DLRN - What is it, what we use it for
---

# DLRN: What it is, what we use it for
[DLRN](https://github.com/softwarefactory-project/DLRN) (can be read as "Delorean") is an application that helps us do _continuous packaging_ of RDO. It is used to build packages using the latest commit from each of the OpenStack project repositories.

DLRN can be run as a standalone application to create a single package, or periodically (using a cron job) to rebuild all packages listed for a specific release.

## High-level DLRN flow
The basic DLRN flow is:

- For each package listed in the [RDO metadata file](https://github.com/redhat-openstack/rdoinfo/blob/master/rdo.yml):
    - Fetch the latest upstream commit from the OpenStack Git repositories
    - Fetch the latest commit from the [distgit](https://www.rdoproject.org/documentation/intro-packaging/#distgit---where-the-spec-file-lives) repositories
    - Build an RPM package using the source and distgit commits
    - Create a YUM repository with that package, and the latest build package for the other packages
    - If a package build fails, open a review in [the RDO Gerrit](https://review.rdoproject.org) to track and fix the issue.

The result of each DLRN run is an [RDO Trunk repository](/what/trunk-repos), containing the latest commit from each supported OpenStack project, ready to be consumed.

## Tips and tricks

### Multiple branch support
DLRN can build packages using different upstream branches, not only master. For example, we have DLRN workers building packages for the Newton and Mitaka releases. That allows us to test each commit landing to stable/newton and stable/mitaka before it is part of a release. We can select which releases we want to build a package for using tags in the RDO metadata file, for example:

```yaml
- project: watcher
  conf: rpmfactory-core
  tags:
    ocata-uc:
    ocata:
    newton:
```
This project (openstack-watcher) is built for Ocata (master) and Newton.

### Setting up a DLRN instance
You can follow the instructions from the [README file](https://github.com/softwarefactory-project/DLRN/blob/master/README.rst) to set up a test instance. The Puppet module we use to build the RDO instances [is also available](https://github.com/rdo-infra/puppet-dlrn) if you want to take a look at how to configure multiple instances on a single machine.

----

[← Workflow overview](/what/workflow-overview) | 
[→ RDO Trunk repos](/what/trunk-repos) |
[↑ TOC](/what) 
