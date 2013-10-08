---
title: CeilometerQuickStart
category: documentation
authors: eglynn, jpichon
wiki_category: Documentation
wiki_title: CeilometerQuickStart
wiki_revision_count: 43
wiki_last_updated: 2014-11-26
---

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8">
# Ceilometer Quickstart

This guide is intended to get you up and running quickly with Ceilometer:

*   metering cloud resource usage
*   understanding the foundational Ceilometer concepts and terminology
*   interacting with the aggregation API via the command line interface
*   understanding how the metering store is structured
*   alarming on resource performance

*This guide is predicated on at least the Havana RC1 version of the packages being used (the service start-up instructions for older versions of the packages from the H cycle would differ somewhat).*

### Step 0. Prerequites

The general prerequsites are identical to the [Havana QuickStart](QuickStartLatest), and in fact if you follow that guide right now you will end up with Ceilometer installed by default once your `packstack` run completes .

However, if you are installing on a resource-constrained VM, some prior setup can make your life easier. The default & most feature-complete storage driver used by Ceilometer is `mongodb`, which on installation eagerly pre-allocates large journal files *etc*. This is normally not an issue, but the default service timeout of 90 seconds imposed by systemd *may* not suffice for this preallocation to complete on resource-starved VMs. However this can be easily worked around in that scenarion by preinstalling mongo with a modified startup timeout, as follows:

         sudo yum install -y mongodb-server mongodb
         sudo sed -i '/^`\[Service\]`$/ a\
           TimeoutStartSec=360' /usr/lib/systemd/system/mongod.service
         sudo service mongod start
         sudo service mongod status
         sudo service mongod stop

### Step 1. Verification

Once your `packstack` run is complete, you're probably eager to verify that Ceilometer is properly installed and working it should.

Before we do that, a few words on how Ceilometer is realized as a set of agents and services. It comprises at least four separate daemons, each with a specific function in the metering pipeline:

*   **compute** agent: polls the local libvirt daemon to acquire performance data for the local instances, massages and emits these data as AMQP notifications
*   **central** agent: polls the public RESTful APIs of other openstack services such as nova and glance, in order to keep tabs on resource existence
*   **collector** service: consumes AMQP notifications from the agents and other openstack services, then dispatch these data to the metering store
*   **API** service: presents aggregated metering data to consumers (such as billing engines, analytics tools *etc*.)

 In a `packstack` "all in one" installation, all of these services will be running on your single node. In a wider deployment, the main location constraint is that the compute agent is required to run on all nova compute nodes. Assuming "all in one" for now, check that all services are running smoothly:

       export CEILO_SVCS='compute central collector api'
       for svc in $CEILO_SVCS ; do sudo service openstack-ceilometer-$svc status ; done

For your peace of mind, ensure that there are no errors in the Ceilometer logs at this time:

       for svc in $CEILO_SVCS ; do sudo grep ERROR /var/log/ceilometer/${svc}.log ; done

### Step 2. Basic Concepts

Getting up to speed with Ceilometer involves getting to grips a few basic concepts and terms.

#### Meters

Meters simply measure a particular aspect of resource usage (e.g. the existence of a running instance) or of ongoing performance (e.g. the current CPU utilization % for that instance). As such meters exist per-resource, in that there is a separate `cpu_util` meter for example for each instance. The lifecycle of meters is also decoupled from the existence of the related resources, in the sense that the meter continues to exist *after* the resource has been terminated. While that may seem strange initially, think about how otherwise you could avoid being billed simply by shutting down all your instances the day before your cloud provider kicks off their monthly billing run!

All meters have a string name, a unit of measurement, and a type indicating whether values are monotonically increasing (`cumulative`), interpreted as a change from the previous value (`delta`), or a standalone value relating only to the current duration (`gauge`).

In earlier iterations of Ceilometer, we often used 'counter' as a synonym for 'meter', and this usage though now deprecated persists in some older documentation and deprecated aspects of the command line interpreter.

#### Samples

Sample are simply individual datapoints associated with a particular meter. As such, all samples encompass the same attributes as the meter itself, but with the addition of a timestamp and and a value (otherwise known as the sample 'volume').

#### Statistics

If a sample is a single datapoint, then a statistic is a set of such datapoints aggregates over a time duration. Ceilometer currently employs 5 different aggregation functions:

*   **count**: the number of samples in each period
*   **max**: the maxima of the sample volumes in each period
*   **min**: the maxima of the sample volumes in each period
*   **avg**: the maxima of the sample volumes over each period
*   **sum**: the sum of the sample volumes over each period

 Note that *all* of these aggregation functions are applied for every statistic calculated. This may seem wasteful if you're only interested in one of the values, but it practice hardly any extra computation cost is incurred due to the map-reduce scheme used to calculate these values.

Also there is some potential confusion in there being both a duration *and* a period associated with these statistics. The duration is simply the overall time-span over which a single query applies, where the period is the time-slice length into which this duration is divided for aggregation purposes. So for example, if I was interested in the hourly average CPU utilization over a day, I would provide midnight-to-midnight start and end timestamps on my query giving a duration of 24 hours, while also specifying a period of 3600 seconds to indicate that the finegrained samples should be aggregated over each hour within that day.

#### Pipelines

Pipelines are composed of a metering data source that produces certain enumerated or wildcarded meters at a certain cadence, which are fed through a chain of zero or more transformers to massage the data in various ways, before being emitted to the collector via a publisher.

Example of transformers shipped with Ceilometer include:

*   **unit_conversion**: apply a scaling conversion to allow a different to be unit that originally supplied with the observed data, for example converting a temperature from °F to °C (the scaling rule is configurable, so that any reasonable unit conversion expessable in python may be implemented)
*   **rate_of_change**: derives a secondary meter from directly observed data based on the calculated rate of change by sampling the sequence of datapoint, with an associated scaling rule
*   **accumulator**: gather several datapoints before emitting in a batch

 Multiple publishers are also supported, including:

*   **rpc://**: emit metering data for collector over AMQP
*   **<udp://>**: emit metering data for collector over lossy UDP (useful for metric data collected for alarming purposes, but not suitable for metering data to feed into a billing system due to the obviously retention requirements)
*   **<file://>**: emit metering data into a file

These pipelines are configured via a YAML file which is explained in detail below.

### Step 3. Configuration of Ceilometer

The shipped Ceilometer configuration is intended to be usable out-of-the-box. However, there are a few tweaks you may want to make while exploring Ceilometer functionality.

#### Pipeline configuration

The pipeline definitions are read by default from `/etc/ceilometer/pipeline.yaml` though this location may be overridden via the `pipeline_cfg_file` config option (for example to allow different ceilometer services use different pipelines.

The most likely pipeline config elements you might want to experiment initially initially would be:

*   **`interval`**: defines the cadence of data acquisition by controlling the polling period, which default to 600 seconds (10 minutes).
*   **`meters`**: a list of meters that the current pipeline applies to, either explicitly enumerated with negation via `!` or wildcarded.
*   **`transformers`**: a list of named transformers and their parameters, to be loaded as `stevedore` extensions.

To become more familiar with the possibilities offered by this configuration file, let's examine the shipped `pipeline.yaml`:

       ---
       -
           name: meter_pipeline
           interval: 600
           meters:
               - "*"
           transformers:
           publishers:
               - rpc://
       -
           name: cpu_pipeline
           interval: 600
           meters:
               - "cpu"
           transformers:
               - name: "rate_of_change"
                 parameters:
                     target:
                         name: "cpu_util"
                         unit: "%"
                         type: "gauge"
                         scale: "100.0 / (10**9 * (resource_metadata.cpu_number or 1))"
           publishers:
               - rpc://

This file defines two separate pipeline, named `meter_pipeline` and `cpu_pipeline`,

The first is very straight-forward, running at the default cadence of 600s and applying to all primary meters (`meters: - "*"`) which are emitted unchanged over AMQP.

The second is more interesting, applying to only the `cpu` meter, transforming this via the `rate_of_change` transformer into the derived `cpu_util` meter. The effect here is to transformer the primary observation of cumulative CPU time in nanosecond into a gauge value as a percentage of the notional maximum total CPU time over that preceding duration scaled by the number of vCPUs allocated to the instance. The scaling rule is expressed as a fragment of python which handles the percentage conversion, nanosecond scaling and taking the number of CPUs into account, all defined very concisely in configuration.

An example modification would be something like increasing the cadence of `cpu_util` from once per 10 minutes to once a minute:

       sudo sed -i '/^ *name: cpu_pipeline$/ { n ; s/interval: 600$/interval: 60/ }' /etc/ceilometer/pipeline.yaml
       sudo service openstack-ceilometer-compute restart

Note that we only need to restart the `compute` and not the `central` even though both share the same pipeline config by default, because the particular meter impacted by the change is only gathered by the former agent.

#### Ceilometer service configuration

The service configuration is read by default from two sources, via the same pattern as you've encountered with the other openstack services in RDO:

*   **distribution config**: `/usr/share/ceilometer/ceilometer-dist.conf` containing the distro-specific overrides over upstream defaults
*   **user-editable config**: `/etc/ceilometer/ceilometer.conf` containing commented-out setting for the all configuration options with help strings and default values

</div>
</div>
<Category:Documentation>
