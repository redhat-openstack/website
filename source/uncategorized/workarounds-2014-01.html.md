---
title: Workarounds 2014 01
authors: afazekas, flaper87, larsks, pixelbeat, radez, rbowen, syspimp, thaha, whayutin
wiki_title: Workarounds 2014 01
wiki_revision_count: 28
wiki_last_updated: 2014-05-23
---

# Workarounds 2014 01

This page documents workarounds that may be required for installing RDO Icehouse Milestone 1. This page is associated with the [RDO_test_day_January_2014](RDO_test_day_January_2014). Please see [Workarounds](Workarounds) for a recommended format for writing up these workarounds.

## Failed to parse /etc/nova/nova.conf (RHEL)

*   **Bug:** [1047156](https://bugzilla.redhat.com/show_bug.cgi?id=1047156), [1048315](https://bugzilla.redhat.com/show_bug.cgi?id=1048315), [1048319](https://bugzilla.redhat.com/show_bug.cgi?id=1048319)
*   **Affects:** RHEL

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
