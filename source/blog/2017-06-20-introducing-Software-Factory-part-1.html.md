---
title: Introducing Software Factory - part 1
author: Software Factory Team
tags: openstack,infra,nodepool,software-factory,zuul,CI,CD
date: 2017-06-10 00:00:00 UTC
---

# Introducing Software Factory

Software Factory is an open source, [software development forge][1] with an emphasis
on collaboration and ensuring code quality through Continuous Integration (CI).
It is inspired by OpenStack's development workflow that has proven to be reliable
for fast-changing, interdependent projects driven by large communities.

Software Factory is batteries included, easy to deploy and fully leverages
OpenStack clouds. Software Factory is an ideal solution
for code hosting, feature and issue tracking, and Continuous Integration,
Delivery and Deployment.

## Why Software Factory ?

OpenStack, as a very large collection of open source projects with thousands of
contributors across the world, had to solve scale and interdependency problems
to ensure the quality of its codebase; this led to designing new best practices
and tools in the fields of software engineering, testing and delivery.

Unfortunately, until recently these tools were mostly custom-tailored for OpenStack,
meaning that deploying and configuring all these tools together to set up a similar
development forge would require a tremendous effort.

The purpose of Software Factory is to make these new tools easily available
to development teams, and thus help to spread these new best practices as well.
With a minimal effort in configuration, a complete forge can be deployed and
customized in minutes, so that developers can focus on what matters most to them:
delivering quality code!

## Innovative features

### Multiple repository project support

Software projects requiring multiple, interdependent repositories are very common.
Among standard architectural patterns, we have:

* Modular software that supports plugins,drivers, add-ons ...
* Clients and Servers
* Distribution of packages
* Micro-services

But being common does not mean being easy to deal with.

For starters, ensuring that code validation jobs are always built from the adequate
combination of source code repositories at the right version can be headache-inducing.

Another common problem is that issue tracking and task management solutions must
be aware that issues and tasks might and will span over several repositories at a time.

Software Factory supports multiple repository projects natively at every step of
the development workflow: code hosting, story tracking and CI.

### Smart Gating system

Usually, a team working on new features will split the tasks among its members.
Each member will work on his or her branch, and it will be up to one or more release
managers to ensure that branches get merged back correctly.
This can be a daunting task with long living branches, and prone to human errors
on fast-evolving projects. Isn't there a way to automate this?

Software Factory provides a CI system that ensures master branches are always
"healthy" using a smart gate pipeline. Every change proposed on
a repository is tested by the CI and must pass these tests before
being eligible to land on the master branch. Nowadays this is quite
common in modern CI systems, but Software Factory goes above and beyond to really
make the life of code maintainers and release managers easier:

#### Automatic merging of patches into the repositories when all conditions of eligibility are satisfied

Software Factory will automatically merge *mergeable patches* that have been
validated by the CI and at least one privileged repository maintainer (in Software Factory
terminology, a "core developer"). This is configurable and can be adapted to
any workflow or team size.

The Software Factory gating system takes care of some of the release manager's tasks, namely
managing the merge order of patches, testing them, and integrating them or requiring
further work from the author of the patch.

#### Speculative merging strategy

Actually, once a patch is deemed mergeable, it is not merged immediately into the
code base. Instead, Software Factory will run another batch of (fully customizable)
validation jobs on *what the master code base would look like if that patch plus others
mergeables patches was merged*. In other words, the validation jobs are run on a code base
consisting of:

* the latest commit on the master branch, plus
* any other mergeable patches for this repository (rebased on each others in approval order), plus
* the mergeable patch on top

This ensures not only that the patch to merge is always compatible with the current code base,
but also detects compatibility problems between patches before they can do any harm
(if the validation jobs fail, the patch remains at the gate and will need to be reworked by its author).

This speculative strategy minimizes greatly the time needed to merge patches because
the CI assumes by default that all mergeable patches will pass their validation jobs
successfully. And even if a patch in the middle of *the currently tested chain of patches* fails,
then the CI will discard only the failing patch and automatically rebase the others (those
previously rebased on the failed one) to the closest one. This is really powerful especially
when integration tests take a long time to run.

#### Jobs orchestration in parallel or chained

For developers, a fast CI feedback is critical to avoid context switching. Software Factory can run
CI jobs in parallel for any given patch, thus reducing the time it takes to assess the quality of
submissions.

Software Factory also supports chaining CI jobs, allowing artifacts from a job
to be consumed by the next one (for example, making sure software can be built
in a job, then running functional tests on that build in the next job).

### Complete control on jobs environments

One of the most common and annoying problems in Continuous Integration
is dealing with **jobs flakiness**, or **unstability**, meaning that successive runs of
the same job in the same conditions might not have the same results. This is often
due to running these jobs on the same, long-lived worker nodes, which is prone to
interferences especially if the environment is not correctly cleaned up between runs.

Despite all this, long-lived nodes are often used because recreating a test environment
from scratch might be costly, in terms of time and resources.

The Software Factory CI system brings a simple solution to this problem by managing
a pool of virtual machines on an OpenStack cloud, where jobs will be executed. This
consists in:

* Provisioning worker VMs according to developers' specifications
* Ensuring that a given minimal amount of VMs are ready for new jobs at any time
* Discarding and destroying VMs once a job has run its course
* Keeping VMs up to date when their image definitions have changed
* Abiding by cloud usage quotas as defined in Software Factory's configuration

A fresh VM will be selected from the pool as soon as a job must be executed.

This approach has several advantages:

* The flakiness due to environment decay is completely eliminated
* Great flexibility and liberty in the way you define your images
* CI costs can be decreased by using computing resources only when needed

On top of this Software Factory can support multiple OpenStack cloud providers at
the same time, improving service availability via failover.

### User-driven platform configuration, and configuration as code

In lots of organizations, development teams rely on operational teams to manage
their resources, like adding contributors with the correct access credentials to
a project, or provisioning a new test node. This can induce a lot of delays for
reasons ranging from legal issues to human error, and be very frustrating for
developers.

With Software Factory, everything can be managed by development teams themselves.

Software Factory's general configuration is stored in a Git repository, aptly named
**config**, where the following resources among others can be defined:

* Git projects/repositories/ACLs
* job running VM images and provisioning
* validation jobs and gating strategies

Users of a Software Factory instance can propose, review and approve (with the adequate accreditations)
configuration changes that are validated by a built-in CI workflow. When a configuration
change is approved and merged the platform
re-configures itself automatically, and the configuration change is immediately applied.

This simplifies the work of the platform operator, and gives more freedom, flexibility
and trust to the community of users when it comes to managing projects and
resources like job running VMs.

## Others features included in Software Factory

As we said at the beginning of this article Software Factory is a complete
development forge. Here is the list of its main features:

* Code hosting
* Code review
* Issue tracker
* Continuous Integration, Delivery and Deployment
* Job logs storage
* Job logs search engine
* Notification system over IRC
* Git repository statistics and reporting
* Collaboration tools: etherpad, pasteboard, voip server

## To sum up

We can list how Software Factory may improve your team's productivity.
Software Factory will:

* help ensure that your code base is always healthy, buildable and deployable
* ease merging patches into the master branch
* ease managing projects scattered across multiple Git repositories
* improve community building and knowledge sharing on the code base
* help reduce test flakiness
* give developers more freedom towards their test environments
* simplify projects creation and configuration
* simplify switching between services (code review, CI, ...) thanks to its navigation panel

Software Factory is also operators friendly:

* 100% Open source, self hosted, ie no vendor lock-in or dependency to external providers
* based on Centos 7 and benefits from the stability of this Linux distribution
* fast and easy to deploy and upgrade
* simple configuration and documentation

This article is the first in a series that will introduce the components of
Software Factory and explain how they provide those features.

In the meantime you may want to check out [softwarefactory-project.io][2] and [review.rdoproject.org][3]
(both are Software Factory deployments) to explore the features we discussed in this article.

Thank you for reading and stay tuned !

[1]: https://en.wikipedia.org/wiki/Forge_(software)
[2]: https://softwarefactory-project.io
[3]: https://review.rdoproject.org
