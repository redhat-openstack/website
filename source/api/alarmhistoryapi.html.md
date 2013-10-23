---
title: AlarmHistoryAPI
category: api
authors: eglynn
wiki_title: HowToTest/Ceilometer/H/AlarmHistoryAPI
wiki_revision_count: 2
wiki_last_updated: 2013-10-23
---

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
# Alarm audit/history API

Upstream [blueprint](https://blueprints.launchpad.net/ceilometer/+spec/alarm-audit-api).

### Prerequistes

      Install packstack allinone, then spin up an instance in the usual way. 

Ensure the compute agent is gathering metrics at a reasonable cadence (every 60s for example instead of every 10mins as per the default):

       sudo sed -i '/^ *name: cpu_pipeline$/ { n ; s/interval: 600$/interval: 60/ }' /etc/ceilometer/pipeline.yaml
       sudo service openstack-ceilometer-compute restart

### Step 1.

Create an alarm with a threshold sufficiently low that it's guaranteed to go into alarm:

       ceilometer alarm-threshold-create --name cpu_high --description 'instance running hot'  \
          --meter-name cpu_util  --threshold 0.01 --comparison-operator gt  --statistic avg \
          --period 60 --evaluation-periods 1 \
          --alarm-action 'log://' \
          --query resource_id=$INSTANCE_ID

### Step 2.

Update the alarm:

       ceilometer alarm-update --threshold 75.0 -a $ALARM_ID

### Step 3.

Wait a while, then delete the alarm:

       sleep 120 ; ceilometer alarm-delete -a $ALARM_ID

### Step 3.

Ensure that the alarm-history reports the following events:

*   creation
*   rule change
*   state transition
*   deletion

 For example:

       ceilometer alarm-history -a ALARM_ID
       +------------------+----------------------------+---------------------------------------+
       | Type             | Timestamp                  | Detail                                |
       +------------------+----------------------------+---------------------------------------+
       | creation         | 2013-10-01T16:20:29.238000 | name: cpu_high                        |
       |                  |                            | description: instance running hot     |
       |                  |                            | type: threshold                       |
       |                  |                            | rule: cpu_util > 0.01 during 1 x 60s  |
       | state transition | 2013-10-01T16:20:40.626000 | state: alam                           |
       | rule change      | 2013-10-01T16:22:40.718000 | rule: cpu_util > 75.0 during 3 x 600s |
       | creation         | 2013-10-01T16:20:29.238000 | name: cpu_high                        |
       |                  |                            | description: instance running hot     |
       |                  |                            | type: threshold                       |
       |                  |                            | rule: cpu_util > 75. during 1 x 60sc  |
       +------------------+----------------------------+---------------------------------------+

</div>
</div>
