---
title: Workarounds 2014 01
authors: afazekas, flaper87, larsks, pixelbeat, radez, rbowen, syspimp, thaha, whayutin
wiki_title: Workarounds 2014 01
wiki_revision_count: 28
wiki_last_updated: 2014-05-23
---

# Workarounds 2014 01

This page documents workarounds that may be required for installing RDO Icehouse Milestone 1. This page is associated with the [RDO_test_day_January_2014](RDO_test_day_January_2014). Please see [Workarounds](Workarounds) for a recommended format for writing up these workarounds.

## Failed to start glance api (Fedora 20)

*   **Bug:** ~~[1048946](https://bugzilla.redhat.com/show_bug.cgi?id=1048946)~~
*   **Affects:** Fedora 20

#### symptoms

avc denial when starting glance-api service

#### workaround (Before running packstack)

       setenforce 0

#### notes

Ticket is resolved. Workaround should no longer be necessary.

## Failed to start mysqld (Fedora 20)

*   **Bug:** [981116](https://bugzilla.redhat.com/show_bug.cgi?id=981116)
*   **Affects:** Fedora 20

#### symptoms

ERROR : Error appeared during Puppet run: error running /sbin/chkconfig mysqld on

#### workaround (Before running packstack)

       yum install -y mariadb-server
       rm /usr/lib/systemd/system/mysqld.service
       cp /usr/lib/systemd/system/mariadb.service /usr/lib/systemd/system/mysqld.service

If you hit this during a packstack run, you can still apply the workaround and resume with:

       packstack --answer-file=$answerfile

An alternative packstack workaround for this issue is to change /usr/lib/python2.7/site-packages/packstack/puppet/modules/mysql/manifests/params.pp to include "$service_name = 'mariadb'" in the Fedora >= 19 section

## Failed to parse /etc/nova/nova.conf (RHEL)

*   **Bug:** ~~[1047156](https://bugzilla.redhat.com/show_bug.cgi?id=1047156)~~, ~~[1048315](https://bugzilla.redhat.com/show_bug.cgi?id=1048315)~~, ~~[1048319](https://bugzilla.redhat.com/show_bug.cgi?id=1048319)~~
*   **Affects:** RHEL, CentOS

#### symptoms

ERROR : Error appeared during Puppet run: <all-in-one-host>_api_nova.pp Notice: /Stage[main]/Nova::Api/Exec[nova-db-sync]/returns: oslo.config.cfg.ConfigFileParseError: Failed to parse /etc/nova/nova.conf

and other similar errors

#### workaround

         sed -i '/^nil$/d' /etc/nova/nova.conf
         test -e /var/log/nova/nova-manage.log && chown nova:nova /var/log/nova/nova-manage.log
       
         sed -i '/^nil$/d' /etc/heat/heat.conf
         test -e /var/log/nova/heat-manage.log && chown heat:heat /var/log/nova/heat-manage.log
       
          openstack-db --service nova --rootpw redhat --password redhat --drop
          openstack-db --service nova --rootpw redhat --password redhat --init

Then run packstack again:

       packstack --answer-file=$answerfile

## Failed to start mongodb

*   **Bug:** [1028690](https://bugzilla.redhat.com/show_bug.cgi?id=1028690)
*   **Affects:** Fedora 20, RHEL

#### symptoms

ERROR : Error appeared during Puppet run: ...ceilometer.pp: error starting mongodb

#### workaround

       Starting the mongo service manually

Then run packstack again:

       packstack --answer-file=$answerfile

## Failed to start mongodb in an environment under heavy load (Fedora 20)

*   **Bug:** [1040573](https://bugzilla.redhat.com/show_bug.cgi?id=1040573)
*   **Affects:** Fedora 20

#### symptoms

ERROR : Error appeared during Puppet run: ...ceilometer.pp: error starting mongodb

#### workaround (Before running packstack)

       yum install -y mongodb-server
       sed -e 's|`\(ExecStart.*\)`|\1\nTimeoutStartSec=10m|' -i /lib/systemd/system/mongod.service

If you hit this during a packstack run, you can still apply the workaround and resume with:

       packstack --answer-file=$answerfile

## Installation fails on Fedora 20 if tempest is enabled

*   **Bug:** [1049114](https://bugzilla.redhat.com/show_bug.cgi?id=1049114)
*   **Affects:** Fedora 20

#### symptoms

ERROR : Error appeared during Puppet run: ...provision.pp: mysql-devel does not exist

#### workaround (Before running packstack)

       sed -e 's/mysql/mariadb/g' -i  /usr/lib/python2.7/site-packages/packstack/puppet/modules/tempest/manifests/params.pp

If you hit this during a packstack run, you can still apply the workaround and resume with:

       packstack --answer-file=$answerfile

## ceilometer: notifications from openstack services not processed

*   **Bug:** [1049369](https://bugzilla.redhat.com/1049369)
*   **Affects:** All

#### symptoms

Data for any meter derived from notifications emitted by the openstack services are not recorded.

#### workaround

Explicitly start the new openstack-ceilometer-agent-notification service immediately post-installation:

       sudo service openstack-ceilometer-agent-notification start

## neutron-openvswitch-agent fails to start

*   **Bug:** [1049235](https://bugzilla.redhat.com/show_bug.cgi?id=1049235)
*   **Affects:** Fedora 20

#### symptoms

neutron-openvswitch-agent fails to start with "No module named psutil"

    $ service neutron-openvswitch-agent restart
    [. . .]
    Jan 07 02:45:15 node2-compute neutron-openvswitch-agent[3471]: import psutil
    Jan 07 02:45:15 node2-compute neutron-openvswitch-agent[3471]: ImportError: No module named psutil

#### workaround

     $ yum install python-psutil -y
