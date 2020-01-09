---
title: Workarounds
authors: apevec, arifali, avladu, dustymabe, eglynn, ekuris, eyepv6, fbayhan, flaper87,
  hma, iovadia, jpichon, jruzicka, kashyap, larsks, mmagr, pixelbeat, rbowen, rdo,
  rohara, rwmjones, sasha, shardy, sschinna, stoner, stzilli, tshefi, vaneldik, weshayutin,
  whayutin, xqueralt
---

# Workarounds

This page lists known workarounds for problems with the current release
of RDO. For workarounds specific to a particular test day, see the
particular [test day](/testday).

### Example Problem Description

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=12345>
*   **Affects:** Operating Systems Affected

##### symptoms

### Run packstack behind a proxy

*   **Bug:** <https://bugs.launchpad.net/puppet-glance/+bug/1719874>

##### workaround

The installer fails to apply Puppet with the following error:

```
Error: Could not set 'present' on ensure: Network is unreachable - connect(2) at /var/tmp/packstack/f879707404cb448bb629827308990223/modules/packstack/manifests/provision/glance.pp:12
```

The installer cannot download the demo image because the puppet-glance
module does not support proxy.

##### symptoms

###  Nova instance provision fails when host is not mapped to any cell

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1480326>
*   **Affects:** RHEL 7
*   **Installation:** packstack

##### workaround

You can either disable the demo provisioning or use a local image.

* Disable the demo provisioning

```
# packstack --allinone --provision-demo=n
```

* Use a local image

```
# curl http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img -o /root/cirros-0.3.5-x86_64-disk.img
# packstack --allinone --provision-image-url=/root/cirros-0.3.5-x86_64-disk.img
```

The instance fails to start with the following error:

```
> Setup is incomplete.: HostMappingNotFound: Host '<hostname>' is not mapped to any cell
```

The host is not mapped to any cell:

```
[root@host ~(keystone_admin)]# nova-manage cell_v2 list_hosts
+-----------+-----------+----------+
| Cell Name | Cell UUID | Hostname |
+-----------+-----------+----------+
+-----------+-----------+----------+
```

Manually run cell_v2 discover_hosts

```
[root@host ~(keystone_admin)]# nova-manage cell_v2 discover_hosts --verbose
[root@host ~(keystone_admin)]# nova-manage cell_v2 list_hosts
+-----------+--------------------------------------+----------------+
| Cell Name |              Cell UUID               |    Hostname    |
+-----------+--------------------------------------+----------------+
|  default  | 88a398e2-846d-45ea-982b-58ae14dcf4df | host.lab.local |
+-----------+--------------------------------------+----------------+
```