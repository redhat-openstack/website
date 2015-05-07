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

### Example Problem Description

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=12345>
*   **Affects:** Operating Systems Affected

##### symptoms

Describe symptoms here

##### workaround

<strike>

### Neutron lbaas package not found

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1218398> ON_QA
*   **Affects:** RHEL / CentOS

##### symptoms

Execution of '/usr/bin/yum -d 0 -e 0 -y list openstack-neutron-lbaas' returned 1: Error: No matching Packages to list

##### workaround

CONFIG_LBAAS_INSTALL: n </strike>

## Neutron l3-agent failed when FWAAs enabled

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1218543>
*   **Affects:** Neutron l3-agent failed

##### symptoms

Neutron l3-agent failed when FWAAS enabled

##### workaround

when adding the config file /etc/neutron/fwaas_driver.ini to /usr/lib/systemd/system/neutron-l3-agent.service and restarted the l3 agent the l3 agent is started

## Packstack fails on openstack-selinux check

*   **Bug:** None
*   **Affects:** Tested on CentOS 7.1

##### symptoms

When Packstack runs the prescript.pp against another node it fails on: "PuppetError: Error appeared during Puppet run: 192.168.80.xxx_prescript.pp Error: Execution of '/usr/bin/yum -d 0 -e 0 -y list openstack-selinux' returned 1: Error: No matching Packages to list"

##### workaround

Copy the /etc/yum.repos.d/rdo-testing.repo file from the AIO to the 2nd node and re-run Packstack

## Re-login to Horizon fail after timeout

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1218894>
*   **Affects:** All OS, all browzers, tested on RHEL 7.1

##### symptoms

Can't re-login to Horizon after timeout. "ValidationError" on browzer and log file

##### workaround

Clear cookies for horizon machine.
