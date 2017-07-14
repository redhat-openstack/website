---
title: RDO repositories
authors: apevec, kashyap, larsks, mangelajo, pixelbeat, pmyers, srikanth1239, strider
---

# RDO repositories

See the [Packstack quickstart](/install/packstack/) for summarized instructions on how to interact with the repositories described in this document.

This document expands on the details of the various repositories involved.

### Enabling the Optional, Extras, and RH Common channels on RHEL

If using RHEL it is assumed that you have registered your system using Red Hat Subscription Management and that you have the `rhel-7-server-rpms` repository enabled by default. RDO also needs the `Optional`, `Extras`, and `RH Common` channels to be enabled:

    $ sudo subscription-manager repos --enable=rhel-7-server-optional-rpms \
    --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-rh-common-rpms

The `Optional` channel does not exist in CentOS or Scientific Linux. The required packages are included in the main repositories for those distributions. `Extras` is enabled by default on CentOS 7.

### Red Hat OpenStack Platform

The separate [Red Hat OpenStack Platform](https://access.redhat.com/products/red-hat-openstack-platform/) product has different repository requirements. For more information, see the [Red Hat OpenStack Platform Release Notes](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/10/html/release_notes/content_delivery_network_cdn_channels).
