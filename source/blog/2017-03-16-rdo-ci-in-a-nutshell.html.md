---
title: RDO CI promotion pipelines in a nutshell
author: amoralej
tags:
date: 2017-03-16 15:26:14 CET
---


One of the key goals in RDO is to provide a set of **well tested and up-to-date**
repositories that can be smoothly used by our users:

* Operators deploying OpenStack with any of the available tools.
* Upstream projects using RDO repos to develop and test their patches, as OpenStack
puppet modules, TripleO or kolla.

To include new patches in RDO packages as soon as possible, in [RDO Trunk
repos](https://www.rdoproject.org/blog/2016/05/newbie-in-rdo-2-rdo-trunk-from-a-bird-s-eye-view/)
we build and publish new packages when commits are merged in upstream repositories.
To ensure the content of theses packages is trustworthy, we run different tests which
helps us to identify any problem introduced by the changes committed.

This post provides an overview of how we test RDO repositories. If you
are interested in collaborate with us in running an improving it, feel free to
let us know in #rdo channel in freenode or rdo-list mailing list.

## Promotion Pipelines

Promotion pipelines are composed by a set of related CI jobs that are executed
for each supported OpenStack release to test the content of a specific RDO repository.
Currently promotion pipelines are executed in diferent phases:
<img src="/images/blog/rdo-ci-1.png" width="70%">

1. **Define the repository to be tested.** RDO Trunk repositories are identified
by a hash based on the upstream commit of the last built package. The content of
these repos doesn't change over time. When a promotion pipeline is launched, it
grabs the latest **consistent** hash repo and sets it to be tested in following phases.

2. **Build TripleO images.** [TripleO](https://www.rdoproject.org/tripleo/) is
the recommended deployment tool for production usage in RDO and as such, is tested
in RDO CI jobs. Before actually deploying OpenStack using TripleO the required
images are built.

3. **Deploy and test RDO.** We run a set of jobs which deploy and test OpenStack
using different installers and scenarios to ensure they behave as expected. Currently,
following deployment tools and configurations are tested:
  * *TripleO deployments*. Using [tripleo-quickstart](https://github.com/openstack/tripleo-quickstart)
  we deploy two different configurations, [minimal](https://github.com/openstack/tripleo-quickstart/blob/master/config/general_config/minimal.yml)
  and [minimal_pacemaker](https://github.com/openstack/tripleo-quickstart/blob/master/config/general_config/minimal_pacemaker.yml)
  which apply different settings that cover most common options.
  * *OpenStack Puppet scenarios*. Project [puppet-openstack-integration](https://github.com/openstack/puppet-openstack-integration/) (a.k.a. p-o-i)
  maintains a set of puppet manifest to deploy different OpenStack services
  combinations and configurations (scenarios) in a single server using OpenStack
  puppet modules and run tempest smoke tests for the deployed services. The
  tested services on each scenario can be found in the
  [README](https://github.com/openstack/puppet-openstack-integration/blob/master/README.md#description)
  for p-o-i. Scenarios 1, 2 and 3 are currently tested in RDO CI as
  * *Packstack deployment.* As part of the upstream testing, packstack defines
  three deployment [scenarios](https://github.com/openstack/packstack/blob/master/README.md#packstack-integration-tests)
  to verify the correct behavior of the existing options. Note that tempest smoke tests
  are executed also in these jobs. In RDO-CI we leverage those scenarios to test
  new packages built in RDO repos.

4. **Repository and images promotion.** When all jobs in the previous phase succeed,
the tested repository is considered good and it is promoted so that users can use these
packages:
  * The repo is published using CentOS CDN in [https://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-&lt;release>-tested/](https://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-ocata-tested/))
  * The images are copied to [https://buildlogs.centos.org/centos/7/cloud/x86_64/tripleo_images/&lt;release>/delorean/](https://buildlogs.centos.org/centos/7/cloud/x86_64/tripleo_images/master/delorean/)
  to be used by TripleO users.

## Tools used in RDO CI

* Jobs definitions are managed using [*Jenkings Job Builder, JJB*](https://docs.openstack.org/infra/jenkins-job-builder/),
via gerrit review workflow in [review.rdoproject.org]( https://review.rdoproject.org/r/#/q/project:rdo-infra/ci-config)
* [*weirdo*](http://weirdo.readthedocs.io/en/latest/how.html) is the tool we
use to run p-o-i and Packstack testing scenarios defined upstream inside RDO CI.
It's composed of a set of ansible roles and playbooks that prepares the environment
and deploy and test the installers using the testing scripts provided by
the projects.
* [*TripleO Quickstart*](https://docs.openstack.org/developer/tripleo-quickstart/)
provides a set of scripts, ansible roles and pre-defined configurations to deploy
an OpenStack cloud using [TripleO](https://docs.openstack.org/developer/tripleo-docs/)
in a simple and fully automated way.
* [*ARA*](https://github.com/openstack/ara) is used to store and visualize
the results of ansible playbook runs, making easier to analize and troubleshoot
them.

## Infrastructure

RDO is part of the CentOS Cloud Special Interest Group so we run promotion pipelines
in [CentOS CI](https://wiki.centos.org/QaWiki/CI) infrastructure where Jenkins
is used as continuous integration server..

## Handling issues in RDO CI

An important aspect of running RDO CI is managing properly the errors found in the
jobs included in the promotion pipelines. The root cause of these issues sometimes
is in the OpenStack upstream projects:

* Some problems are not catched in devstack-based jobs running in upstream gates.
* In some cases, new versions of OpenStack services require changes in the deployment
tools (puppet modules, TripleO, etc...).

One of the contributions of RDO to upstream projects is to increase test coverage of
the projects and help to identify the problems as soon as possible. When we find them
we report it upstream as Launchpad bugs and propose fixes when possible.

Every time we find an issue, a new card is added to the [TripleO and RDO CI Status
Trello board](https://trello.com/b/WXJTwsuU/tripleo-and-rdo-ci-status) where
we track the status and activities carried out to get it fixed.

## Status of promotion pipelines

If you are interested in the status of the promotion pipelines in RDO CI you can
check:

* [*CentOS CI RDO view*](https://ci.centos.org/view/rdo/view/promotion-pipeline)
can be used to see the result and status of the jobs for each OpenStack
release.

* [*RDO Dashboard*](https://dashboards.rdoproject.org/rdo-dev) shows the overal
status of RDO packaging and CI.

<img src="/images/blog/rdo-ci-2.png" width="70%">


### More info

* [TripleO quickstart demostration](https://www.youtube.com/watch?v=4O8KvC66eeU) by trown
* [Weirdo: A talk about CI in OpenStack and RDO](https://dmsimard.com/2016/03/02/openstack-montreal-a-talk-about-ci-in-openstack-and-rdo/) by dmsimard.
* [ARA blog posts](https://dmsimard.com/tag/ara.html) - from dmsimard blog
* [Ci in RDO: What do we test?](https://amoralej.fedorapeople.org/slides/RDO-CI-summit-bcn-final.pdf) - presentation in RDO and Ceph Meetup BCN.
