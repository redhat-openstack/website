---
title: MidoNet integration
authors: adjohn, fernando, fiveohmike, red trela, techcet, yantarou, zbigniewficner
wiki_title: MidoNet integration
wiki_revision_count: 172
wiki_last_updated: 2015-08-07
---

# MidoNet integration

To install MidoNet on RDO follow the [<http://docs.midonet.org/docs/v1.8/quick-start-guide/rhel-7_icehouse/content/index.html>| Redhat Enterprise Linux 7 Quick Start Guide], with the exception of the repository configuration, and OpenStack installation, as outlined below.

## Enabling RDO repositories

Enable the EDO repositories using the following command (as root):

      yum install -y <nowiki>https://rdo.fedorapeople.org/rdo-release.rpm</nowiki>

To enable the EPEL repository use this command:

      su -c 'rpm -Uvh <nowiki>http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm</nowiki>'

To enable 'optional' and 'extras' from the RHEL subscription run these commands (as root):

`yum -y install yum-utils
yum-config-manager --enable rhel-7-server-optional-rpms
yum-config-manager --enable rhel-7-server-extras-rpms`

## Installing OpenStack

Install OpenStack using the procedure provided in the [<https://openstack.redhat.com/Quickstart>| RDO Quickstart].
