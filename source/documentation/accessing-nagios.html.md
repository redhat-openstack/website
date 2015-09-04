---
title: Accessing Nagios
category: documentation
authors: dneary
wiki_category: Documentation
wiki_title: Accessing Nagios
wiki_revision_count: 2
wiki_last_updated: 2013-04-29
---

# Accessing Nagios

## Nagios support

Nagios is pulled in as a dependency in the RDO installation. The change to include this support was in packstack [here](https://review.openstack.org/#/c/22521/).

After packstack completes it reports some summary info about the services that can be connected to it.

To access nagios you can log in at <http://CONTROL_IP/nagios> with the nagiosadmin user and the password which is in the CONFIG_NAGIOS_PW value in the packstack answers file which is generated in the directory where you ran packstack.

<Category:Documentation>
