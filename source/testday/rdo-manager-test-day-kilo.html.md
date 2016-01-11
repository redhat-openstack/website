---
title: RDO-Manager test day template
authors: egallen, jcoufal, ohochman, shardy, snecklifter
wiki_title: RDO-Manager test day Kilo
wiki_revision_count: 8
wiki_last_updated: 2016-01-11
---

# RDO-Manager test day

We plan to hold a RDO-Manager test day on ???. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the rdo-list mailing list, using [RDO-Manager] tag.

We'll be testing deployment of RDO Kilo release.

Quick Links:

*   [RDO-Manager Website](https://www.rdoproject.org/RDO-Manager)
*   [RDO-Manager Documentation](http://docs.rdoproject.org/rdo-manager/master)

## Who's Participating

*   handle - Wiki, IRC, testing (CentOS)

## Prerequisites

Hardware:

*   For preferred **virtual setup** testing make sure you have **one dedicated physical machine**.
*   For testing baremetal deployment have at least three dedicated physical machines.
    -   For environment setup follow the [RDO-Manager documentation - Environments](https://repos.fedorapeople.org/repos/openstack-m/docs/master/environments/environments.html)

Operating system:

*   **CentOS v???**

## How To Test

Go to the RDO-Manager documentation: <http://docs.rdoproject.org/rdo-manager/master>

*   Click on "**Limit Environment Specific Content**" (left top corner):
    -   Select only: **CentOS**, **virtual**

Follow by:

*   Environment Setup
*   Undercloud Installation
*   Basic Deployment

## Goal for Testing Day

*   Use CentOS only
*   The goal is to deploy RDO ??? cloud having 1 Controller and 1 Compute.
*   To make sure that your RDO cloud works properly you can run testing script:
        instack-test-overcloud

    which will spin up a testing VM instance in your cloud and try to ping it.

## Keep Notes from Testing

You can use INSERT_ETHERPAD_LINK_HERE for notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

## Troubleshooting and Communication

In case of problems go to [Troubleshooting](https://repos.fedorapeople.org/repos/openstack-m/docs/master/troubleshooting/troubleshooting.html) section ind the docs.

If you find some bugs or you have suggestions for enhancements, follow [How to Contribute](https://repos.fedorapeople.org/repos/openstack-m/docs/master/contributions/contributions.html) section in the docs.

If you have any questions, just ask on IRC (#rdo, freenode.net) and we will help you.
