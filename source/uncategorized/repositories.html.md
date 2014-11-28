---
title: Repositories
authors: apevec, kashyap, larsks, mangelajo, pixelbeat, pmyers, srikanth1239, strider
wiki_title: Repositories
wiki_revision_count: 20
wiki_last_updated: 2015-01-13
---

# Repositories

<div class="row">
<div class="offset1 span10">
Please see the [Quickstart](Quickstart) for summarized instructions for interacting with these repositories.

Here we expand on the details of the various repositories involved.

## Browsing

The RDO packages can be browsed at [RDO repositories](http://rdo.fedorapeople.org/openstack/)

## Fedora

If you are installing RDO on Fedora, you **do not** need to enable any additional repositories. The dependencies for the RDO OpenStack packages are already available in Fedora.

## EPEL

The RDO repositories for Enterprise Linux distributions in turn depend on [EPEL](http://fedoraproject.org/wiki/EPEL)

The packstack version in the RDO repositories, will auto enable EPEL

## Optional and Extras Channels

If using RHEL, then RDO and EPEL need the "Optional channel" enabled. On RHEL7, EPEL7 requires the "Extras channel" enabled, see <https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F> for details.

         $ subscription-manager repos --enable rhel-7-server-optional-rpms
         $ subscription-manager repos --enable rhel-7-server-extras-rpms

If using CentOS or Scientific Linux, there is no such optional repository, as those packages are included in the main repositories for those distributions. Extras is enabled by default on CentOS7.

## RHEL-Z

If using RHEL, then rhel-z must be enabled. In CentOS or Scientific Linux, that's not necessary.

The packages used from rhel-z channel are:

*   rubygems

## RHOSP

The separate [Red Hat Enterprise Linux OpenStack Platform](http://redhat.com/openstack) product does **not** require the Optional channel or EPEL enabled.

## Testing

To get the very latest packages for testing, like when participating in an RDO test day for example, please ensure you have the testing repositories enabled as follows.

*   Fedora: yum-config-manager --enable updates-testing
*   RHEL (derivatives): yum-config-manager --enable epel-testing

</div>
</div>
