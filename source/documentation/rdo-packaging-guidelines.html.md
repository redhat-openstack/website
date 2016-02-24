---
author: hguemar
title: RDO OpenStack Packaging Guidelines
---

# RDO OpenStack Packaging Guidelines
1. toc
{:toc}

## Introduction

This document collects guidelines and practical tips


## Packaging Guidelines

RDO packages mostly follow [Fedora Packaging Guidelines](/packaging/rdopkg/rdopkg.1.html).
There are two exceptions:

 * Override rules listed in this document.
 * Exceptions granted by RDO Packaging Group (e.g. bundling)

## Packages Review Process

* All reviews **must** block the review tracker using the alias RDO-<release>-REVIEW.
Announcing reviews on the RDO mailing list is encouraged to raise awareness within the
community and speed up the process.

* General-purpose libraries and clients should be submitted through Fedora Package Review
[Process](https://fedoraproject.org/wiki/Package_Review_Process).

* As for OpenStack services, they should follow the same process but open a ticket under
the **RDO** product and **Package Review** component. Packagers are encouraged to create
a git repository with their packaging for pre-review.

### For reviewers

Reviewers are encouraged to use fedora-review tool to generate and post formal review
on the ticket.


## RDO Guidelines

### Systemd packaging

* All services must be configured to allow automated restart

```bash
Restart=[on-failure|always]
```

### General guidelines

* Remove requirements files used by pip to download dependencies from the network.
That may hide missing dependencies or integration issues (e.g. a dependency package only available in an incompatible version)

```bash
  rm -rf {,tests-}requirements.txt
```

* Use versioned python macros everywhere.

* Check your package dependencies with ```rdopkg reqcheck```.

* To enforce consistency accross OpenStack services packages, use the following snippet to set upstream project name.

```bash
%global service keystone
```

### Configuration files

* Use oslo-config-generator to generate configuration files.

```bash
oslo-config-generator --config-file=config-generator/keystone.conf
```

* Configuration files must be in /etc and not /usr/etc.


### Patches

RDO is and intends to remain a vanilla distribution of OpenStack.
Our default policy is to refuse downstream patches, but RDO Packaging Group may grant
exceptions on per-case basis

* Feature patches: must be submitted upstream

* Security patches: requires RDO Security team clearance.

* FTBFS patches: requires peer review, and must be submitted upstream when possible.
