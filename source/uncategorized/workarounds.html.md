---
title: Workarounds
authors: apevec, arifali, avladu, dustymabe, eglynn, ekuris, eyepv6, fbayhan, flaper87,
  hma, iovadia, jpichon, jruzicka, kashyap, larsks, mmagr, pixelbeat, rbowen, rdo,
  rohara, rwmjones, sasha, shardy, sschinna, stoner, stzilli, tshefi, vaneldik, weshayutin,
  whayutin, xqueralt
wiki_title: Workarounds
wiki_revision_count: 100
wiki_last_updated: 2015-05-07
---

# Workarounds

See [Workaround_archive](Workaround_archive) for workarounds that we believe to be resolved. Please move them back here if they appear to still be necessary.

These are the current workarounds for the RDO Kilo.

## Example Problem Description

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=12345>
*   **Affects:** Operating Systems Affected

#### symptoms

Describe symptoms here

#### workaround

<strike>

## Neutron lbaas package not found

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1218398> ON_QA
*   **Affects:** RHEL / CentOS

#### symptoms

Execution of '/usr/bin/yum -d 0 -e 0 -y list openstack-neutron-lbaas' returned 1: Error: No matching Packages to list

#### workaround

CONFIG_LBAAS_INSTALL: n </strike>
