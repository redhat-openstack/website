---
title: "[package announce] openstack-packstack updated"
date: 2013-08-13 14:09:08
author: rbowen
tags: updates
---

Greetings,

  Packstack packages has been updated in RDO Grizzly and Havana repos
to openstack-packstack-2013.1.1-0.24.dev660 (grizzly) and openstack-packstack-2013.2.1-0.2.dev702 (havana)

%changelog
* Tue Aug 13 2013 Martin Mágr <mmagr redhat com> - 2013.1.1-0.24.dev660
- ovs_use_veth=True is no longer required
- Allow tempest repo uri and revision configuration
- Update inifile module to support empty values

%changelog
* Tue Aug 13 2013 Martin Mágr <mmagr redhat com> - 2013.2.1-0.2.dev702
- ovs_use_veth=True is no longer required
- Remove libvirt's default network (i.e. virbr0) to avoid confusion
- Rename Quantum to Neutron
- Added support for configuration of Cinder NFS backend driver (#916301)
- Removed CONFIG_QUANTUM_USE_NAMESPACES option


(See https://www.redhat.com/archives/rdo-list/2013-August/msg00102.html for any followup posts.)