---
title: Tuskar-UI
authors: akrivoka, jtomasek, rdopieralski, rwsu, tzumainn
wiki_title: Tuskar-UI
wiki_revision_count: 35
wiki_last_updated: 2015-03-24
---

# Tuskar-UI

The Tuskar UI is a management interface for OpenStack deployments. The deployment methodology is based upon [TripleO](https://wiki.openstack.org/wiki/TripleO) and [Tuskar](https://wiki.openstack.org/wiki/Tuskar); these in turn rely on OpenStack services such as Glance, Nova, and Heat.

The Tuskar UI is developed as a plugin for OpenStack Horizon; as such it is Django-based and stateless.

## Features

Key features of the Tuskar-UI include:

*   **Overcloud management** Plan and deploy your overcloud entirely through the UI.
*   **Node management:** Create an inventory of nodes through direct user input or bulk CSV upload. Use auto-discovery to have node attributes filled in for you. View summary statistics of current node usage, and detailed historical statistics for specific nodes.
*   **Role management:** Manage and update the flavors and images used by the compute, controller, object storage, and block storage roles.
*   **History:** View historical information about the overcloud deployment, as well as historical usage statistics for provisioned nodes.

## Quick Install

We recommend using Instack to install the Tuskar-UI:

*   Start by following the [Instack instructions](https://openstack.redhat.com/Deploying_RDO_using_Instack) through "Deploying an Undercloud".
*   Follow the [Instack overcloud steps](https://openstack.redhat.com/Deploying_an_RDO_Overcloud_with_Instack) in the "Deploying the Overcloud via the Tuskar UI" section.

The next section will cover usage of the Tuskar UI.

## Quick Usage

*   Login
*   Register nodes
*   Check flavors

        * Suggested flavors
        * Set role flavor if needed

*   Deploy
*   Initialize

## Detailed Information

### Additional install options

### Overcloud configuration

### Uploading images

### Using the Tuskar API
