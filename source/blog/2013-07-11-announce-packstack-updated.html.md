---
title: 'Announce: packstack updated'
date: 2013-07-11 10:58:42
author: rbowen
---

From the RDO-list mailing list (https://www.redhat.com/mailman/listinfo/rdo-list)

update: openstack-packstack-2013.1.1-0.20.dev642.el6

**Wed Jul 10 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.20.dev642

* Fixed provider network option (#976380)
* Made token_format configurable (#978853)
* Enable LVM snap autoextend (#975894)
* MariaDB support (#981116)


**Older releases:**

**Tue Jun 18 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.19.dev632

* Restart openstack-cinder-volume service (#975007)


**Wed Jun 12 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.17.dev631

* Updated Keystone puppet module to have token_format=PKI as default

**Tue Jun 11 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.16.dev630

* Always update kernel package (#972960)

**Mon Jun 10 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.15.dev625

* Omit Nova DB password only on compute nodes (#966325)
* Find free device during host startup (#971145)

**Mon Jun 10 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.14.dev622

* Reverted Nova sql_connection changes because of introduced regression (#966325, #972365)

**Thu Jun 06 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.12.dev621

* Install qemu-kvm before libvirt (#957632)
* Add template for quantum API server (#968513)
* Removed SQL password in sql_connection for compute hosts (#966325)
* Fixed color usage (#971075)
* Activate cinder-volumes VG and scan PVs after reboot (#971145)

**Wed Jun 05 2013** - Martin Mágr <mmagr@redhat.com> - 2013.1.1-0.9.dev605

* Added whitespace filter to Nova and Quantum plugins (rhbz#970674)
* Removed RDO repo installation procedure