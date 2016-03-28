---
title: Repositories
authors: apevec, kashyap, larsks, mangelajo, pixelbeat, pmyers, srikanth1239, strider
wiki_title: Repositories
wiki_revision_count: 20
wiki_last_updated: 2015-01-13
---

# RDO repositories

Please see the [Quickstart](/install/quickstart/) for summarized instructions for interacting with these repositories.

Here we expand on the details of the various repositories involved.

### Browsing

The RDO packages can be browsed at [RDO repositories](http://rdo.fedorapeople.org/openstack/).

### Optional, Extras, and RH Common channels

If using RHEL, then RDO needs the `Optional`, `Extras`, and `RH Common` channels enabled:

`# subscription-manager repos --enable rhel-7-server-optional-rpms`

`# subscription-manager repos --enable rhel-7-server-extras-rpms`

`# subscription-manager repos --enable=rhel-7-server-rh-common-rpms`

The `Optional` channel is not available for CentOS or Scientific Linux. The required packages are included in the main repositories for those distributions. `Extras` is enabled by default on CentOS7.

### RHEL-OSP

The separate [Red Hat Enterprise Linux OpenStack Platform](http://www.redhat.com/en/technologies/linux-platforms/openstack-platform) product does **not** require the `Optional`, `Extras`, and `RH Common` channels enabled.

