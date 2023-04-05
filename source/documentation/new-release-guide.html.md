---
author: karolinku
title: Step by step RDO release guide
---

# Step by step RDO release guide

Creating new release in RDO is quite complex process full of dependencies. This overview is created to give to users and contributors an idea, how it is proceeded and what are detailed steps to perform before new release. Not all steps are frozen in the sequence, but our experience shows that this is most efficient way of working.  Some steps may be done in parallel.

This process is imitating the process of [OpenStack releases](https://releases.openstack.org/reference/release_models.html) - typically cycle-with-intermediary type of releasing - its repeatable every 6 months. First there are provided non-client libraries, then client libraries, then services and in the end there are provided release-trailing deliverables.

### 1. Create CBS tags for next release

At the very beginning new CBS tag for next release should be created. It is needed before performing a switch to new master. This operation is performed by creating a bug on [pagure.io/centos-infra](https://pagure.io/centos-infra). The example can be found [here](https://pagure.io/centos-infra/issue/1077).

### 2. Create a DLRN builder for the new OpenStack release in RDO Trunk servers.

#### Prepare new DLRN trunk builder.
DLRN builder is an instance used to build RDO Trunk repos (follow articles about [RDO Trunk repos](https://www.rdoproject.org/what/trunk-repos/) and [RDO CloudSIG repos](https://www.rdoproject.org/what/repos/)). Before we start working on new packages, we have to set the builder. The first step is a change in [rdo-infra/ansible-role-dlrn](https://github.com/rdo-infra/ansible-role-dlrn/), where we define new repositories for builder, as an [example](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-dlrn/+/47053). Second step is to actual definition of new builder in [sf-infra](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/27459). A patch to sf-infra has to depend on previous one from [ansible-role-dlrn](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-dlrn/+/47053).

Before starting building process, some steps has to be performed on builder:
1. Create de database, users and tables
2. Set up authentication from trunk8 host to trunk.rdoproject.org
3. Synchronize deps

#### Bootstrapping

Once the dlrn builder is ready, the bootstrap process can be started. This process is about building all dlrn packages in proper sequence. Building is automated, but due to dependencies it has to be restarted several times, also sometimes fixes in spec files are necessary.


#### Enable usual operations for the new DLRN Trunk builder
The new builder, to be fully operated, needs to have enabled operations which were not possible before bootstrapping. Examples can be found in [sf-infra](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/27702) and [ansible-role-dlrn](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-dlrn/+/47529).

This operation will enable building new packages in builders with any new commit in projects (operated by cron), enable triggering automated gerrit reviews in case of [FTBFS](https://www.rdoproject.org/documentation/package-building-overview/#FTBFS) and set new builder visible on [trunk.rdoproject.org](https://trunk.rdoproject.org/) website.

#### Enable distgit CBS builds for next release branch

When review will appear in new release branch, appropriate jobs and builds have to be [triggered](https://review.rdoproject.org/r/c/config/+/47480).

### 6. Requirement check - reqcheck

Most of projects we are packaging are constantly being developed, so their requirements can change - added, removed, in new version or constrained. This check is being done manually, using [rdopkg reqcheck](https://github.com/softwarefactory-project/rdopkg) tool. First libs and client packages are reqchecked, then core packages (like openstack-nova).

Even though the process seems to be not complicated, the appearing issues are often connected with missing dependencies.
Example requirement check can be found [here](https://review.rdoproject.org/r/c/openstack/barbican-distgit/+/47395).

### 7. Build libs, clients and core projects in CloudSIG repos on CBS.

Once requirement check is done, next stage can be performed - building. To proceed with this, first new releases has to be created upstream. This stage requires following steps:

1. Cut rpm-master branch of distgit repo to create the \<release\>-rdo branch. This can be done with branching [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/branch_projects.sh) from releng tooling, as an [example](https://review.rdoproject.org/r/c/config/+/47675), or manualy by modifying [config](https://review.rdoproject.org/r/q/project:config) repo.
2. Submit [review](https://review.rdoproject.org/r/c/openstack/glance-distgit/+/47699) with new version - a helpful [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/send_new_version.sh).


### 8. Pin, branch and build non-OpenStack puppet modules in CloudSIG repos
Non-OpenStack modules have to be pinned to the last promoted hash at branching time, since they don't follow the OpenStack lifecycle and RDO stable releases shouldn't follow master branches for them. The package has to be build basing on commit snapshot. This operation has to be done with cooperation with [Puppet OpenStack team](https://governance.openstack.org/tc/reference/projects/puppet-openstack.html) - these modules can be pinned after p-o-i team confirmation.

1. Pin non OpenStack puppet modules, as [example](https://review.rdoproject.org/r/c/rdoinfo/+/47673), using releng [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/pin-non_os-puppet.sh).
2. Cut branches, as in this [review](https://review.rdoproject.org/r/c/config/+/47679).
3. Build, with releng [script](https://github.com/rdo-infra/releng/blob/master/scripts/new_release_scripts/create_build_snap.sh).

### 9. Move master RDO Trunk to next release tags

Rdoinfo buildsys-tags and tags can be moved to next-release after openstack/requirements being branched. As in [review](https://review.rdoproject.org/r/c/rdoinfo/+/47877) and [review](https://review.rdoproject.org/r/c/rdoinfo/+/47880). This action has to be coordinated with reviews mentioned in "Prepare new DLRN trunk builder" paragraph.


### 10. Branch OpenStack puppet modules and build them in CloudSIG repos

There is a bot which will automatically send the update reviews, when the tagged releases are created upstream. To trigger this step, we have to [branch the distgit projects](https://review.rdoproject.org/r/c/config/+/47909) before upstream p-o-i project creates releases for the OpenStack puppet modules.


### 11. Pin, branch and build tempest and tempest plugins in CloudSIG repos
Following steps are required to perform this operation:

1. Branch and build the tempest package with bootstrap mode enabled, as [here](https://review.rdoproject.org/r/c/openstack/tempest-distgit/+/45062)
2. Disable the bootstrap mode without bumping release, to make possibility building other plugins - [example](https://review.rdoproject.org/r/c/openstack/tempest-distgit/+/45203)
3. Cut branches, as in this [review](https://review.rdoproject.org/r/c/config/+/47729)
4. Pin tempest plugins in [rdoinfo](https://review.rdoproject.org/r/c/rdoinfo/+/47796)
5. Review automatically created reviews
6. [Update](https://review.rdoproject.org/r/c/openstack/tempest-distgit/+/47727) version of tempest plugin project


### 12. Create the puppet promotion pipeline

Puppet promotion pipelines has to be defined as in [patchset](https://review.rdoproject.org/r/c/rdo-jobs/+/47911). Tests can be performed using [testinfo](https://review.rdoproject.org/r/c/testproject/+/31972).
Newly defined jobs have to be assigned to project - [example](https://review.rdoproject.org/r/c/config/+/47936).

### 13. Create the next release branch for dependencies
As development of dependencies is still ongoing, new branch has to be prepared for featuring builds - as in this [review](https://review.rdoproject.org/r/c/config/+/47901).

New branch have to be created in upstream [requirements](https://github.com/openstack/requirements/) repo to complete this task.

### 14. Add support of the new release in ansible-role-weirdo-puppet-openstack

This is an example [review](https://review.rdoproject.org/r/c/rdo-infra/ansible-role-weirdo-puppet-openstack/+/45298) of this operation.

### 15. Create the rdo-release RPM

Following step needs to be performed:
1. Create next release branch in distgit repo, as in [example](https://review.rdoproject.org/r/c/config/+/47909)
2. [Edit](https://review.rdoproject.org/r/c/rdo-infra/rdo-release/+/47927) specification file
3. Trigger CBS build
4. Publish the RPM on repos.fedorapeople.org

More details about used commands can be found in [task](https://issues.redhat.com/browse/RDO-97) description.

### 16. Create weirdo jobs to promote to -release tag

Following jobs has to be defined in [rdo-jobs repo](https://review.rdoproject.org/r/c/rdo-jobs/+/47946). Such jobs will be triggered whenever promoting package to -release tag.


### 17. Add the new release to dashboards

Currently there are three dashboards to update with new release:

1. [rdo-dev dashboard](https://review.rdoproject.org/r/c/rdo-infra/rdo-dashboards/+/48199)
2. [Promotion dashboard](https://review.rdoproject.org/r/c/rdo-infra/ci-config/+/48196)
3. [FTBFS dashboard](https://review.rdoproject.org/r/c/rdo-infra/releng/+/47596)

### 18. Create the new centos-release-openstack-<release>
To prepare for final release, there has to be created [new release rpm](https://git.centos.org/rpms/centos-release-openstack/c/41a7fbac122dda2e5bbe36f733b90edb496f09ed?branch=c9s-sig-cloud-openstack-antelope) for CentOS CloudSIG in extras9s-extras-common-el9s, later tagged in extras9s-extras-common-testing and -release and finally [build](https://cbs.centos.org/koji/buildinfo?buildID=43646).

### 19. Promote GA builds to -testing and -release

The final step to publish next RDO release is performed by review as following [one](https://review.rdoproject.org/r/c/rdoinfo/+/48279) and [another](https://review.rdoproject.org/r/c/rdoinfo/+/48266), which can be proceed only after completing previous step.

### 20.  Enable remaining monitoring on Grafana

Also monitoring other than dashboards should be activated for new release: [Prometheus](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/26500) and [Grafana](https://softwarefactory-project.io/r/c/software-factory/sf-infra/+/26925).

### 21. Unpin non OpenStack puppet modules and tempest plugins in master release

After the release, these projects can go back to active master following. To do so, they have to be unpin in [rdoinfo](https://review.rdoproject.org/r/c/rdoinfo/+/42313).
