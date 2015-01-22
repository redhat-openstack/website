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

These are the current workarounds for the RDO Juno.

## Packstack fails when mariadb-server is installed

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148578>
*   **Affects:** Fedora 20

#### symptoms

    192.168.122.48_mysql.pp:                          [ ERROR ]        
    Applying Puppet manifests                         [ ERROR ]

    ERROR : Error appeared during Puppet run: 192.168.122.48_mysql.pp
    Error: Execution of '/usr/bin/yum -d 0 -e 0 -y install mariadb-galera-server' returned 1: Error: mariadb-galera-server conflicts with 1:mariadb-server-5.5.39-1.fc20.x86_64
    You will find full trace in log /var/tmp/packstack/20141001-084831-5JyrbC/manifests/192.168.122.48_mysql.pp.log
    Please check log file /var/tmp/packstack/20141001-084831-5JyrbC/openstack-setup.log for more information

#### workaround

Remove the mariadb-server package: yum remove mariadb-server

And rerun packstack

## packstack --allinone fails on Centos7 with: ERROR : Cinder's volume group 'cinder-volumes' could not be created.

*   Bug: <https://bugzilla.redhat.com/show_bug.cgi?id=1148552>

#### symptoms

packstack --allinone fails on Centos7 with: ERROR : Cinder's volume group 'cinder-volumes' could not be created.

#### workaround

    dd if=/dev/zero of=cinder-volumes bs=1 count=0 seek=2G && losetup /dev/loop2 cinder-volumes && pvcreate /dev/loop2 && vgcreate cinder-volumes /dev/loop2

## rabbitmq-server does not start

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148604>
*   **Affects:** Fedora 21

#### symptoms

Packstack fails with the following error

    Applying 192.168.1.127_mysql.pp
    192.168.1.127_amqp.pp:                            [ ERROR ]       
    Applying Puppet manifests                         [ ERROR ]

    ERROR : Error appeared during Puppet run: 192.168.1.127_amqp.pp
    Error: Could not start Service[rabbitmq-server]: Execution of '/sbin/service rabbitmq-server start' returned 1: Redirecting to /bin/systemctl start  rabbitmq-server.service
    You will find full trace in log /var/tmp/packstack/20141002-113627-IM6EYW/manifests/192.168.1.127_amqp.pp.log
    Please check log file /var/tmp/packstack/20141002-113627-IM6EYW/openstack-setup.log for more information

#### workaround

You can upgrade to a version of erlang-sd_notify >= 0.1-4 from F21 updates-testing: <https://admin.fedoraproject.org/updates/FEDORA-2014-11943/erlang-sd_notify-0.1-4.fc21>

    yum --enablerepo=updates-testing  install -y erlang-sd_notify-0.1-4

After making the above change, re-run packstack with:

     packstack --answer-file=<generated packstack file>

## mariadb fails to start

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1141458>
*   **Affects:** Fedora 21

#### symptoms

Packstack fails with the following error

    192.168.1.127_mysql.pp:                           [ ERROR ]       
    Applying Puppet manifests                         [ ERROR ]

    ERROR : Error appeared during Puppet run: 192.168.1.127_mysql.pp
    Error: Could not start Service[mysqld]: Execution of '/sbin/service mariadb start' returned 1: Redirecting to /bin/systemctl start  mariadb.service
    You will find full trace in log /var/tmp/packstack/20141002-123813-7E6EEK/manifests/192.168.1.127_mysql.pp.log
    Please check log file /var/tmp/packstack/20141002-123813-7E6EEK/openstack-setup.log for more information

#### workaround

For now comment out the "plugin-load-add=ha_connect.so" line in /etc/my.cnf.d/connect.cnf.

    sed -i s/plugin-load-add=ha_connect.so/#plugin-load-add=ha_connect.so/ /etc/my.cnf.d/connect.cnf

After making the above change, re-run packstack with:

     packstack --answer-file=<generated packstack file>

## nova boot: failure creating veth devices

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1149043>
*   **Affects:** Fedora 21

#### symptoms

Booting an instance fails and says 'No valid host was found.' In nova-compute.log:

     [instance: d9ad23e8-ebf6-4d21-9004-991f893fd500] ProcessExecutionError: Unexpected error while running command.
     [instance: d9ad23e8-ebf6-4d21-9004-991f893fd500] Command: sudo nova-rootwrap /etc/nova/rootwrap.conf ip link add qvb55064258-0a type veth peer name qvo55064258-0a
     [instance: d9ad23e8-ebf6-4d21-9004-991f893fd500] Exit code: 255
     [instance: d9ad23e8-ebf6-4d21-9004-991f893fd500] Stdout: ''
     [instance: d9ad23e8-ebf6-4d21-9004-991f893fd500] Stderr: 'Error: argument "qvb55064258-0a" is wrong: Unknown device\n'

#### workaround

Patch the /usr/lib/python2.7/site-packages/nova/network/linux_net.py file to give arguments that /usr/sbin/ip will accept:

    patch -b -d/ -p0  << EOF
    --- /usr/lib/python2.7/site-packages/nova/network/linux_net.py.orig     2014-10-02 17:00:19.620007092 -0400
    +++ /usr/lib/python2.7/site-packages/nova/network/linux_net.py  2014-10-02 16:40:31.514361599 -0400
    @@ -1316,7 +1316,7 @@
         for dev in [dev1_name, dev2_name]:
             delete_net_dev(dev)

    -    utils.execute('ip', 'link', 'add', dev1_name, 'type', 'veth', 'peer',
    +    utils.execute('ip', 'link', 'add', 'name', dev1_name, 'type', 'veth', 'peer',
                       'name', dev2_name, run_as_root=True)
         for dev in [dev1_name, dev2_name]:
             utils.execute('ip', 'link', 'set', dev, 'up', run_as_root=True)
    EOF

After making the above change, restart openstack services:

     openstack-service restart

## Example Problem Description

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=12345>
*   **Affects:** Operating Systems Affected

#### symptoms

Describe symptoms here

#### workaround

      packstack --allinone

Welcome to the Packstack setup utility

The installation log file is available at: /var/tmp/packstack/20150122-154949-6C pXhi/openstack-setup.log Packstack changed given value to required value /root/.ssh/id_rsa.pub

Installing: Clean Up [ DONE ] Setting up ssh keys [ DONE ] Discovering hosts' details [ DONE ] Adding pre install manifest entries [ DONE ] Preparing servers [ DONE ] Adding AMQP manifest entries [ DONE ] Adding MariaDB manifest entries [ DONE ] Adding Keystone manifest entries [ DONE ] Adding Glance Keystone manifest entries [ DONE ] Adding Glance manifest entries [ DONE ] Adding Cinder Keystone manifest entries [ DONE ] Checking if the Cinder server has a cinder-volumes vg[ DONE ] Adding Cinder manifest entries [ DONE ] Adding Nova API manifest entries [ DONE ] Adding Nova Keystone manifest entries [ DONE ] Adding Nova Cert manifest entries [ DONE ] Adding Nova Conductor manifest entries [ DONE ] Creating ssh keys for Nova migration [ DONE ] Gathering ssh host keys for Nova migration [ DONE ] Adding Nova Compute manifest entries [ DONE ] Adding Nova Scheduler manifest entries [ DONE ] Adding Nova VNC Proxy manifest entries [ DONE ] Adding OpenStack Network-related Nova manifest entries[ DONE ] Adding Nova Common manifest entries [ DONE ] Adding Neutron API manifest entries [ DONE ] Adding Neutron Keystone manifest entries [ DONE ] Adding Neutron L3 manifest entries [ DONE ] Adding Neutron L2 Agent manifest entries [ DONE ] Adding Neutron DHCP Agent manifest entries [ DONE ] Adding Neutron LBaaS Agent manifest entries [ DONE ] Adding Neutron Metering Agent manifest entries [ DONE ] Adding Neutron Metadata Agent manifest entries [ DONE ] Checking if NetworkManager is enabled and running [ DONE ] Adding OpenStack Client manifest entries [ DONE ] Adding Horizon manifest entries [ DONE ] Adding Swift Keystone manifest entries [ DONE ] Adding Swift builder manifest entries [ DONE ] Adding Swift proxy manifest entries [ DONE ] Adding Swift storage manifest entries [ DONE ] Adding Swift common manifest entries [ DONE ] Adding Provisioning Demo manifest entries [ DONE ] Adding Provisioning Glance manifest entries [ DONE ] Adding MongoDB manifest entries [ DONE ] Adding Redis manifest entries [ DONE ] Adding Ceilometer manifest entries [ DONE ] Adding Ceilometer Keystone manifest entries [ DONE ] Adding Nagios server manifest entries [ DONE ] Adding Nagios host manifest entries [ DONE ] Adding post install manifest entries [ DONE ] Installing Dependencies [ DONE ] Copying Puppet modules and manifests [ DONE ] Applying 172.31.8.223_prescript.pp 172.31.8.223_prescript.pp: [ DONE ] Applying 172.31.8.223_amqp.pp Applying 172.31.8.223_mariadb.pp 172.31.8.223_amqp.pp: [ DONE ] 172.31.8.223_mariadb.pp: [ DONE ] Applying 172.31.8.223_keystone.pp Applying 172.31.8.223_glance.pp Applying 172.31.8.223_cinder.pp 172.31.8.223_keystone.pp: [ ERROR ] Applying Puppet manifests [ ERROR ]

ERROR : Error appeared during Puppet run: 172.31.8.223_keystone.pp Error: Execution of '/usr/bin/yum -d 0 -e 0 -y install openstack-keystone' retur ned 1: Error: Package: python-keystone-2014.2.1-1.el7.centos.noarch (openstack-j uno) You will find full trace in log /var/tmp/packstack/20150122-154949-6CpXhi/manife sts/172.31.8.223_keystone.pp.log Please check log file /var/tmp/packstack/20150122-154949-6CpXhi/openstack-setup. log for more information
