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

Describe symptoms here

##### workaround

Describe workaround here

###  Nova instance provision fails when host is not mapped to any cell

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1480326>
*   **Affects:** RHEL 7
*   **Installation:** packstack

##### symptoms

The instance fails to start with the following error:

> Setup is incomplete.: HostMappingNotFound: Host '<hostname>' is not mapped to any cell

The host is not mapped to any cell:

```
[root@host ~(keystone_admin)]# nova-manage cell_v2 list_hosts
+-----------+-----------+----------+
| Cell Name | Cell UUID | Hostname |
+-----------+-----------+----------+
+-----------+-----------+----------+
```

##### workaround

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
