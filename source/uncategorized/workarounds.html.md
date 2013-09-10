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

## openvswitch fails to start

*   **Bug:** [1006412](https://bugzilla.redhat.com/show_bug.cgi?id=1006412)
*   **Affects:** Fedora 19

#### symptoms

      A dependency job for openvswitch.service failed. See 'journalctl -xn' for details.
      Dependency failed for Open vSwitch Unit.

#### workaround

      mkdir /var/lock/subsys

## Could not start Service[ovs-cleanup-service]

*   **Bug:** [1006342](https://bugzilla.redhat.com/show_bug.cgi?id=1006342)
*   **Affects:** Fedora 19

#### symptoms

      ERROR : Error during puppet run : Error: Could not start Service[ovs-cleanup-service]: Execution of '/sbin/service neutron-ovs-cleanup start' returned 1:

#### workaround

      yum install -y python-pbr
