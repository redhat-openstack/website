---
title: Using ThinLVM for Cinder with RDO Liberty
authors: coolsvap
---

# Using ThinLVM for Cinder with RDO

The default backend driver configured for Cinder is LVM. It does support thin provisioning but such a feature is not enabled by default. Thin provisioning allows to overcommit the storage space. Since the Liberty release, enabling thin provisioning should be as simple as:

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT lvm_type thin
       # service openstack-cinder-volume restart
