---
title: Repositories
authors: apevec, kashyap, larsks, mangelajo, pixelbeat, pmyers, srikanth1239, strider
wiki_title: Repositories
wiki_revision_count: 20
wiki_last_updated: 2015-01-13
---

# Repositories

Please see the [Quickstart](Quickstart) for summarized instructions for interacting with these repositories.

Here we expand on the details of the various repositories involved.

## Browsing

The RDO packages can be browsed at [RDO repositories?testing](http://rdo.fedorapeople.org/openstack/)

## EPEL

The RDO repositories for Enterprise Linux distributions in turn depend on [EPEL](http://fedoraproject.org/wiki/EPEL)

The packstack version in the RDO repositories, will auto enable EPEL

## Optional Channel

If using RHEL, then RDO and EPEL need the "Optional channel" enabled.

If using CentOS or Scientific Linux, there is no such optional repository, as those packages are included in the main repositories for those distributions.

For completeness, currently on RHEL, the Optional channel is used for:

*   yum-plugin-priorities (packstack)
*   dnsmasq-utils (nova)
*   python-sphinx, python-docutils, python-jinja2 (ceilometer (only to support v1 api), nova (since havana))

## RHOS

The separate [Red Hat OpenStack](http://redhat.com/openstack) product does **not** require the Optional channel or EPEL enabled.

## Testing

To get the very latest packages for testing, like when participating in an RDO test day for example, please ensure you have the testing repositories enabled as follows.

*   Fedora: yum-config-manager --enable updates-testing
*   RHEL (derivatives): yum-config-manager --enable epel-testing
