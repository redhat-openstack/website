---
title: Workflow - Promotion pipeline
author: amoralej, kkula
---

# Workflow: Promotion pipeline

Promotion pipelines are composed by a set of related CI jobs that are executed
for each supported OpenStack release to test the content of a specific RDO repository.

1. **Define the repository to be tested.** RDO Trunk repositories are identified
by a hash based on the upstream commit of the last built package. The content of
these repos doesn't change over time. When a promotion pipeline is launched, it
grabs the latest **consistent** hash repo and sets it to be tested in the following phases.

2. **Build TripleO images.** [TripleO](https://www.rdoproject.org/tripleo/) is
the recommended deployment tool for production usage in RDO and as such, is tested
in RDO CI jobs. Before actually deploying OpenStack using TripleO, the required
images are built.

3. **Deploy and test RDO.** We run a set of jobs which deploy and test OpenStack
using different installers and scenarios to ensure they behave as expected. Currently,
there are following main promotion testing methods:
  * *TripleO deployments* - this kind of deployment (with many kinds of config) is managed by Tripleo
  team. Documentation of these pipelines and whole process description
  can be found [here](https://docs.openstack.org/tripleo-docs/latest/ci/stages-overview.html).
  * *OpenStack Puppet scenarios*. Project [puppet-openstack-integration](https://github.com/openstack/puppet-openstack-integration/) (a.k.a. p-o-i)
  maintains a set of Puppet manifests to deploy different OpenStack services
  combinations and configurations (scenarios) in a single server using OpenStack
  Puppet Modules, and run tempest smoke tests for the deployed services. The
  tested services on each scenario can be found in the
  [README](https://github.com/openstack/puppet-openstack-integration/blob/master/README.md#description)
  for p-o-i. Part of scenarios are currently tested in RDO CI as Packstack deployment.
  In RDO-CI we leverage those scenarios to test new packages built in RDO repos. OpenStack Puppet scenarios
  are usage is managed by RDO team.

4. **Repository and images promotion.** When all jobs in the previous phase succeed,
the tested repository is considered good and it is promoted so that users can use these
packages:
  * The repo is published using CentOS CDN in [https://trunk.rdoproject.org/centos9-<openstack_version>/puppet-passed-ci/delorean.repo](https://trunk.rdoproject.org/centos9-master/puppet-passed-ci/delorean.repo))
  * The images are copied to [http://images.rdoproject.org/centos8/](http://images.rdoproject.org/centos8/) and [http://images.rdoproject.org/centos9/](http://images.rdoproject.org/centos9/).
  to be used by TripleO users.

## Tools used in RDO CI

* Jobs definitions are managed using [*Zuul*](https://review.rdoproject.org/zuul/status),
via a gerrit review workflow in [review.rdoproject.org](https://github.com/rdo-infra/rdo-jobs)
* [*WeIRDO*](http://weirdo.readthedocs.io/en/latest/how.html) is the tool we
use to run p-o-i and Packstack testing scenarios defined upstream inside RDO CI.
It is composed of a set of ansible roles and playbooks that prepare the environment
and deploy and test the installers using the testing scripts provided by
the projects.
* [*TripleO Quickstart*](https://docs.openstack.org/developer/tripleo-quickstart/)
provides a set of scripts, ansible roles and pre-defined configurations to deploy
an OpenStack cloud using [TripleO](https://docs.openstack.org/developer/tripleo-docs/)
in a simple and fully automated way.
* [*ARA*](https://github.com/openstack/ara) is used to store and visualize
the results of ansible playbook runs, making it easier to analize and troubleshoot
them.

## Infrastructure

RDO is part of the CentOS Cloud Special Interest Group so we run promotion pipelines
in the Software Factory's [Zuul](https://softwarefactory-project.io/zuul/t/local/status).


## Handling issues in RDO CI

An important aspect of running RDO CI is properly managing the errors found in the
jobs included in the promotion pipelines. The root cause of these issues sometimes
is in the OpenStack upstream projects:

* Some problems are not caught in devstack-based jobs running in upstream gates.
* In some cases, new versions of OpenStack services require changes in the deployment
tools (puppet modules, TripleO, etc...).

One of the contributions of RDO to upstream projects is to increase test coverage of
the projects and help to identify the problems as soon as possible. When we find them,
we report it upstream as Launchpad bugs and propose fixes when possible.

Tripleo uses [launchpad](https://bugs.launchpad.net/tripleo/+bugs?orderby=-datecreated&start=0)
to manage bugs, so any issues should be reported there. Overall Tripleo approach to CI is decribed
in this [document](https://docs.openstack.org/tripleo-docs/latest/ci/ruck_rover_primer.html).

## Status of promotion pipelines

If you are interested in the status of the promotion pipelines in RDO CI you can
check:

* [*CentOS CI RDO view*](https://ci.centos.org/view/rdo/view/promotion-pipeline)
can be used to see the result and status of the jobs for each OpenStack
release.

* [*RDO Dashboard*](https://dashboards.rdoproject.org/rdo-dev) shows the overall
status of RDO packaging and CI.

<img src="/images/blog/rdo-ci-2.png" width="70%">

### More info

* [TripleO quickstart demostration](https://www.youtube.com/watch?v=4O8KvC66eeU) by trown
* [Weirdo: A talk about CI in OpenStack and RDO](https://dmsimard.com/2016/03/02/openstack-montreal-a-talk-about-ci-in-openstack-and-rdo/) by dmsimard.
* [ARA blog posts](https://dmsimard.com/categories/ara) - from dmsimard blog
* [Ci in RDO: What do we test?](https://amoralej.fedorapeople.org/slides/RDO-CI-summit-bcn-final.pdf) - presentation in RDO and Ceph Meetup BCN.

----

[← Trunk repos](/what/trunk-repos) |
[→ Adding packages](/what/new-package) |
[↑ TOC](/what)
