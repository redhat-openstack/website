---
title: UnitsRateOfChangeConversion
authors: eglynn
wiki_title: HowToTest/Ceilometer/H/UnitsRateOfChangeConversion
wiki_revision_count: 2
wiki_last_updated: 2013-10-23
layout: pullheadings
---

# Units Rate Of Change Conversion

{:.no_toc}

## Transformer for unit scaling and rate-of-change conversion

Upstream [blueprint](https://blueprints.launchpad.net/ceilometer/+spec/transformer-unit).

## Prerequisites

Install `packstack --allinone`, then spin up an instance in the usual way.

## Step 1.

Ensure the old cpu_util pollster is no longer loaded:

       sudo grep cpu_util /usr/lib/python2.?/site-packages/ceilometer-2013*.egg-info/entry_points.txt
       # (no output expected)

whereas the primary cpu pollster is still loaded:

       sudo grep '\`<cpu>` /usr/lib/python2.?/site-packages/ceilometer-2013*.egg-info/entry_points.txt

## Step 2.

Ensure that the cpu and cpu_util meters can be configured with independent cadences:

       sudo sed -i '/^ *name: cpu_pipeline$/ { n ; s/interval: 600$/interval: 60/ }' /etc/ceilometer/pipeline.yaml
       sudo service openstack-ceilometer-compute restart

       sleep 300

       ceilometer sample-list -m cpu
       ceilometer sample-list -m cpu_util

Confirm that the over the most recent time period, the cpu_util is being reported approximately at a ratio of 10:1 in frequency as compared to the cpu meter.

