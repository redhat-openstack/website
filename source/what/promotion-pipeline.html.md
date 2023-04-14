---
title: Workflow - Promotion pipeline
author: amoralej, kkula
---

# Workflow: Promotion pipeline

<img src="/images/blog/rdo-zuul-ci.png" width="90%">

Promotion pipelines are composed by a set of related CI jobs that are executed
for each supported OpenStack release to test the content of a specific RDO repository.
For each OpenStack release Puppet promotion pipelines are proceeded, to validate RDO packages with OpenStack Puppet
 Modules and to promote the RDO packages used in upstream OpenStack Puppet modules check and gate jobs.

This pipeline run in parallel and is composed of different jobs.

The promotion workflow can be described with following schema:

1. **Define the repository to be tested.** RDO Trunk repositories are identified
by a hash based on the upstream commit of the last built package. The content of
these repos doesn't change over time. When a promotion pipeline is launched, it
grabs the latest **consistent** hash repo and sets it to be tested in the following phases.

2. **Deploy and test RDO.** We run a set of jobs which deploy and test OpenStack
using different installers and scenarios to ensure they behave as expected. Currently,
there are following promotion testing method:
  * *OpenStack Puppet scenarios*. Project [puppet-openstack-integration](https://github.com/openstack/puppet-openstack-integration/) (a.k.a. p-o-i)
  maintains a set of Puppet manifests to deploy different OpenStack services
  combinations and configurations (scenarios) in a single server using OpenStack
  Puppet Modules, and run tempest smoke tests for the deployed services. The
  tested services on each scenario can be found in the
  [README](https://github.com/openstack/puppet-openstack-integration/blob/master/README.md#description)
  for p-o-i. These scenarios, together with Packstack deployment ones, are executed in puppet
  promotion pipelines to test new packages build in RDO Repos.
  Part of scenarios are currently tested in RDO CI as Packstack deployment.

3. **Repository and images promotion.** When all jobs in the previous phase succeed,
the tested repository is considered good and it is promoted so that users can use these
packages:
  * The repo is published using RDO Trunk servers in [https://trunk.rdoproject.org/centos9-\<openstack_version\>/current-passed-ci/delorean.repo](https://trunk.rdoproject.org/centos9-master/current-passed-ci/delorean.repo)

## Tools used in RDO CI

* Jobs definitions are managed using [*Zuul*](https://review.rdoproject.org/zuul/status),
via a gerrit review workflow in [review.rdoproject.org](https://github.com/rdo-infra/rdo-jobs)
* [*WeIRDO*](http://weirdo.readthedocs.io/en/latest/how.html) is the tool we
use to run p-o-i and Packstack testing scenarios defined upstream inside RDO CI.
It is composed of a set of ansible roles and playbooks that prepare the environment
and deploy and test the installers using the testing scripts provided by
the projects.
* [*ARA*](https://github.com/openstack/ara) is used to store and visualize
the results of ansible playbook runs, making it easier to analize and troubleshoot
them.

## Infrastructure

RDO runs the promotion pipelines in the CI infrastructure managed by [Software Factory](https://softwarefactory-project.io/).

## Handling issues in RDO CI

An important aspect of running RDO CI is properly managing the errors found in the
jobs included in the promotion pipelines. The root cause of these issues sometimes
is in the OpenStack upstream projects:

* Some problems are not caught in devstack-based jobs running in upstream gates.
* In some cases, new versions of OpenStack services require changes in the deployment
tools

One of the contributions of RDO to upstream projects is to increase test coverage of
the projects and help to identify the problems as soon as possible. When we find them,
we report it upstream as Launchpad bugs and propose fixes when possible.


## Status of promotion pipelines

If you are interested in the status of the promotion pipelines in RDO CI you can
check:

* [*Zuul pipelines status view*](https://review.rdoproject.org/zuul/builds?project=rdoinfo)
can be used to see the result and status of each kind of puppet promotion pipeline
and OpenStack release.

* [*RDO Dashboard*](https://dashboards.rdoproject.org/rdo-dev) shows the overall
status of RDO promotion pipelines.

<img src="/images/blog/rdo-ci-2.png" width="70%">

* [*RDO FTBFS Dashboard*](https://dashboards.rdoproject.org/report-ftbfs) shows status
of currently failed package build attempts.

<img src="/images/blog/rdo-ftbfs-dashboard.png" width="90%">


### More info

* [Weirdo: A talk about CI in OpenStack and RDO](https://dmsimard.com/2016/03/02/openstack-montreal-a-talk-about-ci-in-openstack-and-rdo/) by dmsimard.
* [ARA blog posts](https://dmsimard.com/categories/ara) - from dmsimard blog
* [Ci in RDO: What do we test?](https://amoralej.fedorapeople.org/slides/RDO-CI-summit-bcn-final.pdf) - presentation in RDO and Ceph Meetup BCN.
* [RDO dashboards repo](https://github.com/rdo-infra/rdo-dashboards)

----

[← Trunk repos](/what/trunk-repos) |
[→ Adding packages](/what/new-package) |
[↑ TOC](/what)
