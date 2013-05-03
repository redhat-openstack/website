---
title: Installation errors
category: documentation
authors: dneary, rbowen
wiki_category: Documentation
wiki_title: Installation errors
wiki_revision_count: 4
wiki_last_updated: 2014-03-21
---

__NOTOC__

# Installation issues

### Execution of '/usr/bin/yum -d 0 -e 0 -y install openstack-nova-conductor' returned 1

When installing RDO packages on top of an existing Folsom OpenStack install, you will have several issues, starting with this one.

If you remove the old `*openstack*` packages and re-run packstack, you will hit a different issue:

PackStackError: Error during puppet run : notice: /Stage[main]/Cinder::Api/Exec[cinder-manage db_sync]/returns: OperationalError: (OperationalError) (1005, "Can't create table 'cinder.volume_glance_metadata' (errno: 150)")

This issue is caused by old databases still existing from a previous install, causing foreign key constraints to fail when tables are recreated.

The simplest solution, if the host is to be dedicated as an OpenStack Compute or Control node, is [ to take off and nuke the entire site from orbit](Uninstalling RDO) (in a manner of speaking). This is not advisable if you are using the host for anything except OpenStack, as it will delete all MySQL databases and remove the packages.

<Category:Documentation>
