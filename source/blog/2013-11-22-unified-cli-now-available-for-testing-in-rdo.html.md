---
title: Unified CLI now available for testing in RDO
date: 2013-11-22 13:01:46
author: jruzicka
tags: client, cli
---

Unified OpenStack Client command-line tool is now available for testing as `python-openstackclient` package at RDO Havana repository.

OpenStack Client is on a mission to provide a single consistent CLI for interacting with OpenStack services. It's a thin wrapper to the stock `python-*client` modules that implement the actual REST API client actions. Although OpenStack Client is considered to be **alpha quality** as of 0.2, it already provides commands to interact with:

 * Keystone
 * Nova
 * Cinder
 * Glance

## Tips
 
 * With RDO Havana repository in place, install using `yum install python-openstackclient`
 * As with all clients, you need to supply your credentials. If you installed with packstack, `. ~root/keystonerc_admin` might do the trick.
 * Executable is called `openstack`
 * To get list of available commands, use `openstack -h`
 * To get usage of a specific command, use `openstack help COMMAND`


## Example usage

<pre>
$ openstack help image
Command "image" matches:
  image delete
  image list
  image show
  image set
  image save
  image create


$ openstack help image list
usage: openstack image list [-h] [-f {csv,table}] [-c COLUMN]
                            [--quote {all,minimal,none,nonnumeric}]
                            [--page-size <size>]
List available images
[...]


$ openstack image list
INFO: urllib3.connectionpool Starting new HTTP connection (1): 192.168.8.81
+--------------------------------------+---------+
| ID                                   | Name    |
+--------------------------------------+---------+
| bfc2109b-ab0b-4fd7-99b7-ec394bebd355 | cirros  |
| b0b22e14-4d20-4174-a2f8-b6dcafdb88bd | El Niño |
+--------------------------------------+---------+
</pre>
