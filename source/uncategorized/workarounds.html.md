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

*   **Bug:** [1006342](https://bugzilla.redhat.com/show_bug.cgi?id=1006342) (should be solved)
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

## /usr/sbin/tuned-adm profile virtual-host returned 2 instead of one of [0]

*   **Bug:** none yet?
*   **Affects:** Fedora 19

#### symptoms

ERROR : Error during puppet run : Error: /usr/sbin/tuned-adm profile virtual-host returned 2

#### workaround

Your mileage may vary, but I found this issue disappeared after I started doing a full update **before** installing openstack, packstack etc.

       sudo yum --enablerepo=updates-testing clean all
       sudo yum update -y

#### more info

      # service tuned status
       tuned.service - Dynamic System Tuning Daemon
         Loaded: loaded (/usr/lib/systemd/system/tuned.service; disabled)
         Active: active (running) since Út 2013-09-10 13:35:22 EDT; 1min 22s ago
       Main PID: 16101 (tuned)
         CGroup: name=systemd:/system/tuned.service
                 └─16101 /usr/bin/python -Es /usr/sbin/tuned -l -P
      zář 10 13:35:22 rdo-havana systemd[1]: Starting Dynamic System Tuning Daemon...
      zář 10 13:35:22 rdo-havana systemd[1]: Started Dynamic System Tuning Daemon.

      # /usr/sbin/tuned-adm profile virtual-host
      2013-09-10 13:44:22,474 ERROR    dbus.proxies: Introspect error on :1.245:/Tuned: dbus.exceptions.DBusException: org.freedesktop.DBus.Error.NoReply: Did not receive a reply. Possible causes include: the remote application did not send a reply, the message bus security policy blocked the reply, the reply timeout expired, or the network connection was broken.
      ERROR:dbus.proxies:Introspect error on :1.245:/Tuned: dbus.exceptions.DBusException: org.freedesktop.DBus.Error.NoReply: Did not receive a reply. Possible causes include: the remote application did not send a reply, the message bus security policy blocked the reply, the reply timeout expired, or the network connection was broken.
      DBus call to Tuned daemon failed (org.freedesktop.DBus.Error.NoReply: Did not receive a reply. Possible causes include: the remote application did not send a reply, the message bus security policy blocked the reply, the reply timeout expired, or the network connection was broken.).

*   setenforce 0 doesn't help.
*   dbus is running

## keystone-manage db_sync fails

*   **Bug:** [1006768](https://bugzilla.redhat.com/show_bug.cgi?id=1006768)
*   **Affects:** RHEL / SLC 6.4

#### symptoms

      # keystone-manage db_sync

Traceback (most recent call last):

` File "/usr/bin/keystone-manage", line 31, in `<module>
         from keystone.openstack.common import gettextutils
` File "/usr/lib/python2.6/site-packages/keystone/__init__.py", line 20, in `<module>
         replace_dist("WebOb >= 1.2")
       File "/usr/lib/python2.6/site-packages/keystone/__init__.py", line 18, in replace_dist
         return pkg_resources.require(requirement)
       File "/usr/lib/python2.6/site-packages/pkg_resources.py", line 648, in require
         needed = self.resolve(parse_requirements(requirements))
       File "/usr/lib/python2.6/site-packages/pkg_resources.py", line 546, in resolve
         raise DistributionNotFound(req)
      pkg_resources.DistributionNotFound: WebOb>=1.2

#### workaround

yum install python-webob1.2.noarch --enablerepo=epel
