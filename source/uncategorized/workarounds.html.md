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
*   **Affects:** Fedora 19, RHEL 6.4

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

jruzicka: I always fully \`yum update\` my VM as part of provisioning so this is definitely **not working** for me.

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

## heat-api and heat-engine fail to start

*   **Bug:** <https://bugzilla.redhat.com/1006868>
*   **Affects:** RHEL/SLC 6.4

#### symptoms

*   ERROR : Error during puppet run : Error: Could not start Service[heat-api]: Execution of '/sbin/service openstack-heat-api start' returned 6
*   ERROR : Error during puppet run : Error: Could not start Service[heat-engine]: Execution of '/sbin/service openstack-heat-engine start' returned 6:

#### workaround

init scripts still expect heat-api.conf and heat-engine.conf to be present.

      # cd /etc/heat
      # ln -s heat.conf heat-api.conf
      # ln -s heat.conf heat-engine.conf

## heat-engine fail to start

*   **Bug:** <https://bugzilla.redhat.com/1006911>
*   **Affects:** RHEL/SLC 6.4

#### symptoms

*   Starting heat-engine: [FAILED]
*   2013-09-11 15:02:04.115 14992 ERROR heat.openstack.common.threadgroup [-] (ProgrammingError) (1146, "Table 'heat.stack' doesn't exist") 'SELECT stack.created_at AS stack_created_at, stack.updated_at AS stack_updated_at, stack.deleted_at AS stack_deleted_at, stack.id AS stack_id, stack.name AS stack_name, stack.raw_template_id AS stack_raw_template_id, stack.username AS stack_username, stack.tenant AS stack_tenant, stack.action AS stack_action, stack.status AS stack_status, stack.status_reason AS stack_status_reason, stack.parameters AS stack_parameters, stack.user_creds_id AS stack_user_creds_id, stack.owner_id AS stack_owner_id, stack.timeout AS stack_timeout, stack.disable_rollback AS stack_disable_rollback \\nFROM stack \\nWHERE stack.deleted_at IS NULL AND stack.owner_id IS NULL' ()

#### workaround

heat does not install python-pbr and so heat-db-setup fails to create mysql tables

      # yum install python-pbr

## horizon: no image format

*   **Bug:** [1006766](https://bugzilla.redhat.com/1006766), [1006483](https://bugzilla.redhat.com/1006483)
*   **Affects:** all (Havana)

#### symptoms

The dropdown list in the 'Create An Image" is empty and no image can be created.

#### workaround

Edit /etc/openstack-dashboard/local_settings and add the following in the end:

      OPENSTACK_IMAGE_BACKEND = {
         'image_formats': [
             ('', ''),
             ('aki', _('AKI - Amazon Kernel Image')),
             ('ami', _('AMI - Amazon Machine Image')),
             ('ari', _('ARI - Amazon Ramdisk Image')),
             ('iso', _('ISO - Optical Disk Image')),
             ('qcow2', _('QCOW2 - QEMU Emulator')),
             ('raw', _('Raw')),
             ('vdi', _('VDI')),
             ('vhd', _('VHD')),
             ('vmdk', _('VMDK'))
         ]
      }

## horizon: internal error accessing the login page

*   **Bug:** [1006766](https://bugzilla.redhat.com/1006766)
*   **Affects:** Fedora 19

#### symptoms

Just after installing with packstack it's impossible to access the login page of the dashboard which shows a generic error page.

#### workaround

Edit /etc/openstack-dashboard/local_settings and add one of the following in the end:

      ALLOWED_HOSTS = ['*'] 

or

      ALLOWED_HOSTS = ['`<host ip>`']
