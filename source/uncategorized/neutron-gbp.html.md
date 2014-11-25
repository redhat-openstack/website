---
title: Neutron GBP
authors: rkukura
wiki_title: Neutron GBP
wiki_revision_count: 21
wiki_last_updated: 2015-02-08
---

# Neutron GBP

Group Based Policy (GBP) is an optional service plugin for Neutron that provides declarative abstractions for achieving scalable intent-based infrastructure automation. GBP complements the OpenStack networking model with the notion of policies that can be applied between groups of network endpoints.

## GBP Status

Group Based Policy is currently being developed in StackForge as an add-on to the Juno release of Neutron, along with a supporting client library and integrations with Horizon and Heat. See the [GBP project wiki](https://wiki.openstack.org/wiki/GroupBasedPolicy) for upstream details. This page describes packaging of GBP for Fedora that is currently under development and review. As soon as that process is complete, packages for other Linux distributions supported by RDO will also be provided.

Note that this describes use of the GBP's resource_mapping reference policy driver, which should work with any Neutron core plugin, such as ML2. Other policy drivers are also included, but will be documented separately.

## Configuring GBP

*These instructions are preliminary, and the referenced RPMs are unofficial builds not yet included in Fedora. The information here intended to facilitate the Fedora review process. Use at your own risk!!!*

Start with a working packstack installation with neutron on Fedora 20 x86_64, such as is described in [Quickstart](Quickstart). The remaining steps are all executed as root on the controller node(s) where neutron-server runs. No changes are needed on compute or network nodes when using the resource_mapping policy driver.

Work in progress...

## Using GBP

TBD
