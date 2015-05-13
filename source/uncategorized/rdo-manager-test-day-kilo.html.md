---
title: RDO-Manager test day Kilo
authors: egallen, jcoufal, ohochman, shardy
wiki_title: RDO-Manager test day Kilo
wiki_revision_count: 8
wiki_last_updated: 2015-05-14
---

# RDO-Manager test day Kilo

We plan to hold a RDO-Manager test day on **May 14th**, 2015. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the rdo-list mailing list, using [RDO-Manager] tag.

We'll be testing deployment of RDO Kilo release.

Quick Links:

*   [RDO-Manager Website](https://www.rdoproject.org/RDO-Manager)
*   [RDO-Manager Documentation](http://docs.rdoproject.org/rdo-manager/master)

## Who's Participating

*   jcoufal - Wiki, IRC, testing (CentOS)
*   egallen - IRC, testing (CentOS)

## Prerequisites

Hardware:

*   For preferred **virtual setup** testing make sure you have **one dedicated physical machine**.
*   For testing baremetal deployment have at least three dedicated physical machines.
    -   For environment setup follow the [RDO-Manager documentation - Environments](https://repos.fedorapeople.org/repos/openstack-m/docs/master/environments/environments.html)

Operating system:

*   **CentOS 7.1**

## How To Test

Go to the RDO-Manager documentation: <http://docs.rdoproject.org/rdo-manager/master>

*   Click on "**Limit Environment Specific Content**" (left top corner):
    -   Select only: **CentOS**, **virtual**

Follow by:

*   Environment Setup
*   Undercloud Installation
*   Basic Deployment

## Keep Notes from Testing

You can use <https://etherpad.openstack.org/p/rdo_kilo_test_day> for notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.

## Troubleshooting and Communication

In case of problems go to [Troubleshooting](https://repos.fedorapeople.org/repos/openstack-m/docs/master/troubleshooting/troubleshooting.html) section ind the docs.

If you find some bugs or you have suggestions for enhancements, follow [How to Contribute](https://repos.fedorapeople.org/repos/openstack-m/docs/master/contributions/contributions.html) section in the docs.

If you have any questions, just ask on IRC (#rdo, freenode.net) and we will help you.
