---
title: RDO repositories
authors: apevec, kashyap, larsks, mangelajo, pixelbeat, pmyers, srikanth1239, strider
wiki_title: Repositories
wiki_revision_count: 20
wiki_last_updated: 2015-01-13
---

# RDO repositories

See the [Packstack quickstart](/install/quickstart/) for summarized instructions on how to interact with the repositories described in this document.

This document expands on the details of the various repositories involved.

### Browsing

The RDO packages can be browsed at [RDO repositories](http://rdoproject.org/repos/).

### Enabling the Optional, Extras, and RH Common channels on RHEL

If using RHEL, then RDO needs the `Optional`, `Extras`, and `RH Common` channels to be enabled:

    $ sudo subscription-manager repos --enable rhel-7-server-optional-rpms

    $ sudo subscription-manager repos --enable rhel-7-server-extras-rpms

    $ sudo subscription-manager repos --enable=rhel-7-server-rh-common-rpms

The `Optional` channel is not available for CentOS or Scientific Linux. The required packages are included in the main repositories for those distributions. `Extras` is enabled by default on CentOS 7.

### RHEL-OSP

The separate [Red Hat Enterprise Linux OpenStack Platform](http://www.redhat.com/en/technologies/linux-platforms/openstack-platform) product does **not** require the `Optional`, `Extras`, and `RH Common` channels enabled.

