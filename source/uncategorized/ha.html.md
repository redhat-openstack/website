---
title: HA
authors: beekhof, radez, rbowen
wiki_title: HA
wiki_revision_count: 19
wiki_last_updated: 2015-03-09
---

# HA

## Purpose

This document will outline the process to set up multiple control nodes that have services highly available and load balanced across the nodes. For demonstration purposes each node will all of the api services, mysql and qpid installed and running as appropriate. The concepts in this document could be applied to break the services on each node further into smaller collections of services.

## Overview

Start by setting each control node up as you would a non-HA/LB control node. Once each control node is installed without being aware of each other the nodes will be clustered together using Pacemaker. This involves clustering the database and messaging as pacemaker resources. MySQL wil be clustered in an active/passive fail over using shared storage only mounted on one node at a time. Qpid will be also be configured in an active/passive fail over configuration, this document will be updated in the future to demonstrate how to deploy qpid in a clustered configuration. Most of the other control services are stateless and, therefore, can be load balanced without further configuration. Exceptions to this include the nova-consoleauth service and the neutron L2 agent. The will be added as pacemaker resources and only run on a single host at a time.

## Openstack Installation

[ Installing Multinode Havana w/GRE](GettingStartedHavana_w_GRE) will walk through a multinode installation using GRE. This is the installation needed to proceed with HA and LB configuration. Use that document to install each of your control nodes. The number of compute nodes is up to you. You can specify the same or different compute node(s) for each install. You will update their settings later to make sure they're talking to the control nodes properly. The important piece in this installation is to separate your control from your compute nodes, that you do multiple control node installations (run that doc once for each control node) and that GRE is setup.

## High Availability Configuration

Now that the control nodes are installed, the next step is to cluster them. This is accomplished by having them share a database store and ensuring that messaging is highly available.
