---
title: Upgrading from Liberty to Mitaka
authors: larsks, pmkovar
---

# Upgrading from Liberty to Mitaka: Overview

This document is primarily intended to cover upgrading from Liberty to
Mitaka for environments deployed manually or with Packstack. The document
describes different upgrade scenarios that you can use.

The following holds true for all of the described upgrade scenarios:

* All scenarios involve some service interruptions.
* Running instances will not be affected by the upgrade process unless
  you (a) reboot a compute node or (b) explicitly shut down an
  instance.

## Scenario 1: All at once

In this scenario, you will take down all of your OpenStack
services at the same time, and will not bring them back up until the
upgrade process is complete.

**Pros**: This process is very simple. Because everything is down
there is no orchestration involved.

**Cons**: All of your services are unavailable all at once. In a large
environment, this can result in a potentially extensive downtime as
you wait for database schema upgrades to complete.

Read about this scenario in [Upgrade scenario 1](/install/upgrading-rdo-1/).

## Scenario 2: Service-by-service with live compute upgrade

In this scenario, you upgrade one service at a time. You perform
rolling upgrades of your compute hosts, taking advantage of the fact
that `nova-compute` from Liberty can communicate with a Mitaka control
plane.

This is our recommended upgrade procedure for most environments.

**Pros**: This process minimizes the downtime to your existing
compute workloads.

**Cons**: This is a more complex procedure, and mistakes or
undiscovered compatibility issues can unexpectedly turn it into
[Scenario 1](/install/upgrading-rdo-1/).

Read about this scenario in [Upgrade scenario 2](/install/upgrading-rdo-2/).

