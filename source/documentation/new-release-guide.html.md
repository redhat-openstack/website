---
author: karolinku
title: Step by step RDO release guide
---

# Step by step RDO release guide

Creating a new release in RDO is a complex process with multiple dependencies. This overview provides users and contributors information on
what leads up to a release and what detailed steps are to be performed before a new release. Not all steps are frozen in the sequence, but
our experience shows that this is the most efficient way of working and some steps may be done in parallel.

These steps follow the processes found in [OpenStack releases](https://releases.openstack.org/reference/release_models.html) -
typically for the cycle-with-intermediary type of releasing - which is repeatable every 6 months. First there are provided non-client
libraries, followed by client libraries, then services and lastly there are provided release-trailing deliverables.

### 1. Create CBS tags for next release

At the very beginning, a new CBS tag for the next release should be created. This is needed before performing a switch to the new master.
This operation is performed by creating a bug on [pagure.io/centos-infra](https://pagure.io/centos-infra). An example can be found
[here](https://pagure.io/centos-infra/issue/1077).

### 2. Create a DLRN builder for the new OpenStack release in RDO Trunk servers.

#### Prepare new DLRN trunk builder.
DLRN builder is an instance used to build RDO Trunk repos (follow articles about [RDO Trunk repos](https://www.rdoproject.org/what/trunk-repos/)
and [RDO CloudSIG repos](https://www.rdoproject.org/what/repos/)). Before we start working on new packages, we have to set the builder.
The first step is a change in [rdo-infra/ansible-role-dlrn](https://github.com/rdo-infra/ansible-role-dlrn/), where we define new repositories for
the builder, as an [example](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-dlrn/+/47053). The second step is to define the
new builder in [sf-infra](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/27459). A patch to sf-infra will to depend on
the previous one from [ansible-role-dlrn](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-dlrn/+/47053).

Before starting the building process, some steps have to be performed on the builder:
1. Create the database, users and tables
2. Set up authentication from trunk-centos8.rdoproject.org host to trunk.rdoproject.org
3. Synchronize deps

#### Bootstrapping

Once the DLRN builder is ready, the bootstrap process can be started. This process is about building all DLRN packages in the proper sequence.
Building is automated, but due to dependencies it may need to be restarted several times, and sometimes requires fixes in spec files.


#### Enable usual operations for the new DLRN Trunk builder
The new builder, to be fully operated, needs to have enabled operations which were not possible before bootstrapping. Examples can be
found in [sf-infra](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/27702) and [ansible-role-dlrn](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-dlrn/+/47529).

This operation enables building new packages in the builders with any new commit in the projects (operated by cron), enables triggering
automated gerrit reviews in case of [FTBFS](https://www.rdoproject.org/documentation/package-building-overview/#FTBFS) and sets the new
builder visible on [trunk.rdoproject.org](https://trunk.rdoproject.org/) website.

#### Enable distgit CBS builds for next release branch

When reviews appear in the new release branch, appropriate jobs and builds have to be [triggered](https://review.rdoproject.org/r/c/config/+/47480).

### 3. Requirement check - reqcheck

Most of the projects we are packaging are constantly being developed on, so their requirements can change - added, removed, in the new version or
constrained. This check is being done manually, using the [rdopkg reqcheck](https://github.com/softwarefactory-project/rdopkg) tool. First libraries
and client packages are rechecked, then the core packages (like openstack-nova).

Even though the process seems to be not complicated, the appearing issues are often connected with missing dependencies.
An example requirement check can be found [here](https://review.rdoproject.org/r/c/openstack/barbican-distgit/+/47395).

### 4. Build libs, clients and core projects in CloudSIG repos on CBS.

Once the requirement check is completes, the next step can be performed - building. To proceed with this, the new releases has to be created upstream.
This step requires following steps:

1. Cut rpm-master branch of distgit repo to create the \<release\>-rdo branch. This can be done with branching
[script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/branch_projects.sh) from releng tooling, as an
[example](https://review.rdoproject.org/r/c/config/+/47675), or manually by modifying [config](https://review.rdoproject.org/r/q/project:config) repo.
2. Submit [review](https://review.rdoproject.org/r/c/openstack/glance-distgit/+/47699) with new version - a helpful [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/send_new_version.sh).


### 5. Pin, branch and build non-OpenStack puppet modules in CloudSIG repos
Non-OpenStack modules have to be pinned to the last promoted hash at branching time, since they don't follow the OpenStack lifecycle
and RDO stable releases do not follow the master branches for them. The package has to be built based on the commit snapshot.
This operation is done with the cooperation of the [Puppet OpenStack team](https://governance.openstack.org/tc/reference/projects/puppet-openstack.html) -
these modules can be pinned after p-o-i team confirmation.

1. Pin non OpenStack puppet modules, as [example](https://review.rdoproject.org/r/c/rdoinfo/+/47673), using releng [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/pin-non_os-puppet.sh).
2. Cut branches, as in this [review](https://review.rdoproject.org/r/c/config/+/47679).
3. Build, with releng [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/create_build_snap.sh).

### 6. Move master RDO Trunk to next release tags

Rdoinfo buildsys-tags and tags can be moved to the next-release after openstack/requirements is branched.
As in [review](https://review.rdoproject.org/r/c/rdoinfo/+/47877) and [review](https://review.rdoproject.org/r/c/rdoinfo/+/47880).
This action has to be coordinated with the reviews mentioned in the "Prepare new DLRN trunk builder" section above.


### 7. Branch OpenStack puppet modules and build them in CloudSIG repos

There is a bot which will automatically send the update reviews, when the tagged releases are created upstream.
To trigger this step, we have to [branch the distgit projects](https://review.rdoproject.org/r/c/config/+/47909) before
the upstream p-o-i project creates the releases for the OpenStack puppet modules.


### 8. Pin, branch and build tempest and tempest plugins in CloudSIG repos
Following steps are required to perform this operation:

1. Branch and build the tempest package with bootstrap mode enabled, as [here](https://review.rdoproject.org/r/c/openstack/tempest-distgit/+/45062)
2. Disable the bootstrap mode without bumping release, to have other Openstack-tempest packages in RDO Trunk - [example](https://review.rdoproject.org/r/c/openstack/tempest-distgit/+/45203)
3. Cut branches, as in this [review](https://review.rdoproject.org/r/c/config/+/47729)
4. Pin tempest plugins in [rdoinfo](https://review.rdoproject.org/r/c/rdoinfo/+/47796)
5. Review automatically created reviews
6. [Update](https://review.rdoproject.org/r/c/openstack/tempest-distgit/+/47727) version of tempest plugin project


### 9. Create the puppet promotion pipeline

The Puppet promotion pipelines have to be defined as in [patchset](https://review.rdoproject.org/r/c/rdo-jobs/+/47911). Tests
can be performed using [testinfo](https://review.rdoproject.org/r/c/testproject/+/31972).
Newly defined jobs have to be assigned to the project - [example](https://review.rdoproject.org/r/c/config/+/47936).

### 10. Create the next release branch for dependencies
As development of dependencies is still ongoing, the new branch has to be prepared for featuring builds - as in this
[review](https://review.rdoproject.org/r/c/config/+/47901).

New branches have to be created in the upstream [requirements](https://github.com/openstack/requirements/) repo to complete this task.

### 11. Add support of the new release in ansible-role-weirdo-puppet-openstack

This is an example [review](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-weirdo-puppet-openstack/+/45298) of this operation.

### 12. Create the rdo-release RPM

Following step needs to be performed:
1. Create next release branch in distgit repo, as in [example](https://review.rdoproject.org/r/c/config/+/47909)
2. [Edit](https://review.rdoproject.org/r/c/rdo-infra/rdo-release/+/47927) specification file
3. Trigger CBS build
4. Publish the RPM on repos.fedorapeople.org

More details about used commands can be found in [task](https://issues.redhat.com/browse/RDO-97) description.

### 13. Create weirdo jobs to promote to -release tag

The following jobs have to be defined in [rdo-jobs repo](https://review.rdoproject.org/r/c/rdo-jobs/+/47946). Such jobs will be
triggered whenever promoting the package to -release tag.


### 14. Add the new release to dashboards

Currently there are three dashboards to update with new release:

1. [rdo-dev dashboard](https://review.rdoproject.org/r/c/rdo-infra/rdo-dashboards/+/48199)
2. [Promotion dashboard](https://review.rdoproject.org/r/c/rdo-infra/ci-config/+/48196)
3. [FTBFS dashboard](https://review.rdoproject.org/r/c/rdo-infra/releng/+/47596)

### 15. Create the new centos-release-openstack-<release>
To prepare for final release, the [new release rpm](https://git.centos.org/rpms/centos-release-openstack/c/41a7fbac122dda2e5bbe36f733b90edb496f09ed?branch=c9s-sig-cloud-openstack-antelope) has to be created
 for CentOS CloudSIG in extras9s-extras-common-el9s, and later tagged in extras9s-extras-common-testing, -release, and finally [build](https://cbs.centos.org/koji/buildinfo?buildID=43646).

### 16. Promote GA builds to -testing and -release

The final step to publish the next RDO release is performed by review as following [one](https://review.rdoproject.org/r/c/rdoinfo/+/48279) and [another](https://review.rdoproject.org/r/c/rdoinfo/+/48266),
 which can be done only after completing previous step.

### 17.  Enable remaining monitoring on Grafana

Also monitoring, other than dashboards, should be activated for the new release: [Prometheus](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/26500) and [Grafana](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/26925).

### 18. Unpin non OpenStack puppet modules and tempest plugins in master release

After the release, these projects can go back to active master. To do so, they have to be unpinned in [rdoinfo](https://review.rdoproject.org/r/c/rdoinfo/+/42313).
