---
title: RDO Infrastructure
category: documentation,infrastructure
---

# RDO Infrastructure

RDO is a packaging effort, but this involves a number of infrastructure
components, including CI, this website, and package repositories, among
other things. Here's what it all looks like. See also [this blog
post](https://www.rdoproject.org/blog/2016/07/improving-the-rdo-trunk-infrastructure/)

## www

[This site](http://rdoproject.org/).

## RDO Trunk

RDO Trunk, aka DLRN, aka Delorean. Builds upstream trunk to RDO packages. Its infrastructure
is composed of several servers:

* A private build server, running inside the ci.centos.org infrastructure.
* A public server, [trunk.rdoproject.org](http://trunk.rdoproject.org), hosting the repositories.
* A database server, running in the RDO Cloud (dlrn-db.rdoproject.org).
* A slave database server, which mirrors the main database and also serves as offsite backup server
  for other services (backup.rdoproject.org).

In addition to this, a separate DLRN instance is supporting the upstream
[rpm-packaging](https://github.com/openstack/rpm-packaging) project with up to date packages built
from its spec templates, [rpm-packaging-ci.rdoproject.org](https://rpm-packaging-ci.rdoproject.org/repos/status_report.html).

## Code Review and CI

The RDO Gerrit instance is running at [review.rdoproject.org](https://review.rdoproject.org/). It makes use
of a pool of VMs for CI managed by nodepool and running on the RDO Cloud.

The review.rdoproject.org configuration is managed by the [infrastructure core administrators](/infra/review-rdo-infra-core).

Some additional pieces of infrastructure used for CI are:

* [registry.rdoproject.org](https://console.registry.rdoproject.org/) is a Docker registry used for our
  containerization efforts.
* [logs.rdoproject.org](https://logs.rdoproject.org) provides a log storage service for our CI jobs.
* [images.rdoproject.org](https://images.rdoproject.org/master/rdo_trunk/) store disk images used by the TripleO CI.

## Blogs

Wordpress blog site for RDO engineers.
[blogs.rdoproject.org](http://blogs.rdoproject.org/)

## Dashboards

High-level status dashboards for the RDO project.
[dashboards.rdoproject.org](https://dashboards.rdoproject.org/rdo-dev)

## Status

[status.rdoproject.org](http://status.rdoproject.org/) 
aggregates status and monitoring information from
the different systems part of the RDO infrastructure.

## Planet

A subset of the planet.openstack.org, tracks RDO bloggers.
[planet.rdoproject.org](http://planet.rdoproject.org/)

## Code

The code lives on several organizations at GitHub:

* [Package specs](https://github.com/rdo-packages)
* [Infrastructure definition and CI](https://github.com/rdo-infra)
* [Website, rdoinfo and others](https://github.com/redhat-openstack) 

## Processes and maintenance windows

Refer to the [service continuity page](/infra/service-continuity) for details on our service continuity plans.

The [infrastructure maintenance window](/infra/maintenance-windows) page provides information on our planned
maintenance windows.

## CentOS

A number of parts of our infrastructure run at CentOS, including

* [Mirroring](http://buildlogs.centos.org/centos/7/cloud/x86_64/)
* [CI](https://ci.centos.org/view/rdo/view/promotion-pipeline/)
* [CentOS Cloud SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud)
  (not infrastructure, but governance/process)

