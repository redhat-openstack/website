---
title: AlarmPartitioning
authors: eglynn
wiki_title: HowToTest/Ceilometer/H/AlarmPartitioning
wiki_revision_count: 2
wiki_last_updated: 2013-10-23
---

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
# Alarm partitioning over multiple threshold evaluators

Upstream [blueprint](https://blueprints.launchpad.net/ceilometer/+spec/alarm-service-partitioner).

### Prerequisites

Install packstack allinone, and also on an additional compute node.

Ensure the compute agent is gathering metrics at a reasonable cadence (every 60s for example instead of every 10mins as per the default):

       sudo sed -i '/^ *name: cpu_pipeline$/ { n ; s/interval: 600$/interval: 60/ }' /etc/ceilometer/pipeline.yaml
       sudo service openstack-ceilometer-compute restart

### Step 1.

Ensure the ceilometer-alarm-evaluator and ceilometer-alarm-notifier services are running on the controller node, with the partitioned evaluation service configured:

       sudo yum install -y openstack-ceilometer-alarm
       sudo openstack-config --set /etc/ceilometer/ceilometer.conf alarm evaluation_service ceilometer.alarm.service.PartitionedAlarmService
       export CEILO_ALARM_SVCS='evaluator notifier'
       for svc in $CEILO_ALARM_SVCS; do sudo service openstack-ceilometer-alarm-$svc start; done

### Step 2.

Ensure a second ceilometer-alarm-evaluator service is running on the compute node:

       sudo yum install -y openstack-ceilometer-alarm
       sudo openstack-config --set /etc/ceilometer/ceilometer.conf alarm evaluation_service ceilometer.alarm.service.PartitionedAlarmService
       export CEILO_ALARM_SVCS='evaluator'
       for svc in $CEILO_ALARM_SVCS; do sudo service openstack-ceilometer-alarm-$svc start; done

### Step 3.

Spin up an instance in the usual way:

       nova boot --image $IMAGE_ID --flavor 1 test_instance

### Step 4.

Create multiple alarms with thresholds sufficiently low that they are guaranteed to go into alarm:

       for i in $(seq 10)
       do
         ceilometer alarm-threshold-create --name high_cpu_alarm_${i} --description 'instance running hot'  \
          --meter-name cpu_util  --threshold 0.01 --comparison-operator gt  --statistic avg \
          --period 60 --evaluation-periods 1 \
          --alarm-action 'log://' \
          --query resource_id=$INSTANCE_ID
       done

### Step 5.

Ensure that the alarms are partitioned over the multiple evaluators:

       tail -f /var/log/alarm-evaluator.log | grep 'initiating evaluation cycle'
       

On each host, expect approximately half the alarms to be evaluated, i.e.

       '... initiating evaluation cycle on 5 alarms'

### Step 6.

Ensure all alarms have transitioned to the 'alarm' state:

       ceilometer alarm-list

### Step 7.

Create some more alarms:

       for i in $(seq 10)
       do
         ceilometer alarm-threshold-create --name low_cpu_alarm_${i} --description 'instance running cold'  \
          --meter-name cpu_util  --threshold 99.9 --comparison-operator le  --statistic avg \
          --period 60 --evaluation-periods 1 \
          --alarm-action 'log://' \
          --query resource_id=$INSTANCE_ID
       done

and also delete a few alarms:

       ceilometer delete-alarm -a $ALARM_ID

and ensure that the alarm allocation is still roughly even between the evaluation services:

       tail -f /var/log/alarm-evaluator.log | grep 'initiating evaluation cycle'

</div>
</div>
