---
title: Using ThinLVM for Cinder with RDO Havana
authors: gfidente
wiki_title: Using ThinLVM for Cinder with RDO Havana
wiki_revision_count: 1
wiki_last_updated: 2014-01-03
---

# Using ThinLVM for Cinder with RDO Havana

The default backend driver configured for Cinder is LVM. It does support thin provisioning but such a feature is not enabled by default. Thin provisioning allows to overcommit the storage space. On Havana, enabling thin provisioning should be as simple as:

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT lvm_type thin
       # service openstack-cinder-volume restart
