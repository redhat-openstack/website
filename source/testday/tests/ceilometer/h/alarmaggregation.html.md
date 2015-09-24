---
title: AlarmAggregation
authors: eglynn
wiki_title: HowToTest/Ceilometer/H/AlarmAggregation
wiki_revision_count: 1
wiki_last_updated: 2013-10-23
layout: pullheadings
---

# Alarm Aggregation

{:.no_toc}

## Aggregation over multiple alarm states

Upstream [blueprint](https://blueprints.launchpad.net/ceilometer/+spec/alarming-logical-combination) .

## Prerequisites

Install `packstack --allinone`, then spin up an instance in the usual way.

Ensure the compute agent is gathering metrics at a reasonable cadence (every 60s for example instead of every 10mins as per the default):

       sudo sed -i '/^ *name: cpu_pipeline$/ { n ; s/interval: 600$/interval: 60/ }' /etc/ceilometer/pipeline.yaml
       sudo service openstack-ceilometer-compute restart

Ensure the ceilometer alarm services are installed and running:

       sudo yum install -y openstack-ceilometer-alarm
       export CEILO_ALARM_SVCS='evaluator notifier'
       for svc in $CEILO_ALARM_SVCS; do sudo service openstack-ceilometer-alarm-$svc start; done

## Step 1.

Create multiple basic alarms with thresholds sufficiently low that they are guaranteed to go into alarm:

       for i in $(seq 5)
       do
         ceilometer alarm-threshold-create --name basic_cpu_low_threshold_${i} \
          --meter-name cpu_util  --threshold 0.01 --comparison-operator gt  --statistic avg \
          --period 60 --evaluation-periods 1 \
          --alarm-action 'log://' \
          --query resource_id=$INSTANCE_ID
       done

## Step 2.

Create a meta-alarm combining (with logical AND) the state of these basic alarms:

       ALARM_IDS=
      `  for a in `ceilometer alarm-list | awk -F\| '/basic_cpu_/ {print $2}'`; do ALARM_IDS="$ALARM_IDS --alarm_ids $a"; done `
       ceilometer --debug alarm-combination-create --name combination_cpu_low --description 'combination of high CPU util alarms' --alarm-action 'log://' $ALARM_IDS

Ensure that this combination alarm transitions into the alarm state within one evaluation period (60s by default):

       sleep 60 ; ceilometer alarm-list | grep combination_cpu_low

## Step 3.

Create another set of basic alarms with thresholds sufficiently high that they are guaranteed not to go into alarm:

       for i in $(seq 5)
       do
         ceilometer alarm-threshold-create --name basic_cpu_high_threshold_${i} \
          --meter-name cpu_util --threshold 99.99 --comparison-operator gt  --statistic max \
          --period 60 --evaluation-periods 1 \
          --alarm-action 'log://' \
          --query resource_id=$INSTANCE_ID
       done

## Step 4.

Create two further meta-alarms combining (with logical AND & OR respectively) the state of these basic alarms:

       ALARM_IDS=
      `  for a in `ceilometer alarm-list | awk -F\| '/basic_cpu_/ {print $2}'`; do   ALARM_IDS="$ALARM_IDS --alarm_ids $a"; done `
       ceilometer --debug alarm-combination-create --name combination_cpu_mixed_and --description 'combination (AND) of mixed CPU util alarms' --alarm-action 'log://' $ALARM_IDS --operator and
       ceilometer --debug alarm-combination-create --name combination_cpu_mixed_or --description 'combination (OR) of mixed CPU util alarms' --alarm-action 'log://' $ALARM_IDS --operator or

Ensure that this combination alarms transition into the alarm and ok state (for the combination_cpu_mixed_or and combination_cpu_mixed_and alarms respectively) within one evaluation period (60s by default):

       sleep 60 ; ceilometer alarm-list | grep combination_cpu_mixed

