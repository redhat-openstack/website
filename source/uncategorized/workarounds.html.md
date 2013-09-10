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

## Could not prefetch glance_image provider 'glance'

*   **Bug:** none yet?
*   **Affects:** Fedora 19

#### symptoms

      ERROR : Error during puppet run : Error: Could not prefetch glance_image provider 'glance': Execution of '/usr/bin/glance -T services -I glance -K da3cb42f56224b0

#### workaround

Just run packstack once again on the generated answer file, for example:

      packstack --answer-file packstack-answers-20130910-113355.txt

#### more info

<dneary>`  Seems like it's a time out on testing Puppet module application which is funky.`

## glance: Error communicating with <http://192.168.8.96:9292> timed out

*   **Bug:** <https://bugzilla.redhat.com/1006484>
*   **Affects:** Fedora 19

#### symptoms

      ERROR : Error during puppet run : Error: Execution of '/usr/bin/glance -T services -I glance -K 8ecff593f85544c1 -N `[`http://192.168.8.96:35357/v2.0/`](http://192.168.8.96:35357/v2.0/)` add name=cirros is_public=Yes container_format=bare disk_format=qcow2 copy_from=`[`http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img`](http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img)`' returned 1: Error communicating with `[`http://192.168.8.96:9292`](http://192.168.8.96:9292)` timed out

Check if glance is hitting AVCs on connecting to qpid:

      # grep 'WARNING qpid.messaging' /var/log/glance/api.log
      2013-09-10 11:56:30.573 28749 WARNING qpid.messaging [-] recoverable error[attempt 1]: [Errno 13] EACCES
      2013-09-10 11:56:30.574 28749 WARNING qpid.messaging [-] sleeping 1 seconds
      2013-09-10 11:56:31.574 28749 WARNING qpid.messaging [-] trying: localhost:5672
      2013-09-10 11:56:31.577 28749 WARNING qpid.messaging [-] recoverable error[attempt 2]: [Errno 13] EACCES
      2013-09-10 11:56:31.577 28749 WARNING qpid.messaging [-] sleeping 2 seconds
      2013-09-10 11:56:33.577 28749 WARNING qpid.messaging [-] trying: localhost:5672
      2013-09-10 11:56:33.579 28749 WARNING qpid.messaging [-] recoverable error[attempt 3]: [Errno 13] EACCES
      2013-09-10 11:56:33.580 28749 WARNING qpid.messaging [-] sleeping 4 seconds
      2013-09-10 11:56:37.583 28749 WARNING qpid.messaging [-] trying: localhost:5672
      ...

#### workaround

Disabling glance notifications:

      sudo sed -i 's/notifier_strategy = qpid/notifier_strategy = noop/' /etc/glance/glance-api.conf
      sudo service openstack-glance-api restart
