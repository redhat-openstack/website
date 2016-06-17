---
title: CeilometerQuickStart
category: documentation
authors: eglynn, jpichon
wiki_category: Documentation
wiki_title: CeilometerQuickStart
wiki_revision_count: 43
wiki_last_updated: 2014-11-26
---

{:.no_toc}

# Ceilometer Quickstart

This guide is intended to get you up and running quickly with Ceilometer:

*   metering cloud resource usage
*   understanding the foundational Ceilometer concepts and terminology
*   interacting with the aggregation API via the command line interface
*   understanding how the metering store is structured
*   alarming on resource performance

*This guide is predicated on at least the Havana final version of the packages being used, i.e. openstack-ceilometer-2013.2-1 or later (as the service start-up instructions for older versions of the packages from the H cycle would differ somewhat).*

## Prerequisites

The general prerequisites are identical to the [Havana QuickStart](QuickStartLatest), and in fact if you follow that guide right now you will end up with Ceilometer installed by default once your `packstack` run completes .

However, if you are installing on a resource-constrained VM, some prior setup can make your life easier. The default & most feature-complete storage driver used by Ceilometer is `mongodb`, which on installation eagerly pre-allocates large journal files *etc*. This is not normally an issue, but the default service timeout of 90 seconds imposed by systemd *may* not suffice for the pre-allocation to complete on resource-starved VMs. However this can be easily worked around in that scenarion by pre-installing mongo with a modified startup timeout, as follows:

         sudo yum install -y mongodb-server mongodb
         sudo sed -i '/^`\[Service\]`$/ a\
           TimeoutStartSec=360' /usr/lib/systemd/system/mongod.service
         sudo service mongod start
         sudo service mongod status
         sudo service mongod stop

## Verification

Once your `packstack` run is complete, you're probably eager to verify that Ceilometer is properly installed and working as it should.

Before we do that, a few words on how Ceilometer is realized as a set of agents and services. It comprises at least four separate daemons, each with a specific function in the metering pipeline:

*   **compute** agent: polls the local libvirt daemon to acquire performance data for the local instances, messages and emits these data as AMQP notifications
*   **central** agent: polls the public RESTful APIs of other openstack services such as nova and glance, in order to keep tabs on resource existence
*   **collector** service: consumes AMQP notifications from the agents and other openstack services, then dispatch these data to the metering store
*   **API** service: presents aggregated metering data to consumers (such as billing engines, analytics tools *etc*.)
*   **alarm-evaluator** service: determines when alarms fire due to the associated statistic trend crossing a threshold over a sliding time window
*   **alarm-notifier** service: initiates alarm actions, for example calling out to a webhook with a description of the alarm state transition

 In a `packstack` "all in one" installation, all of these services will be running on your single node. In a wider deployment, the main location constraint is that the compute agent is required to run on all nova compute nodes. Assuming "all in one" for now, check that all services are running smoothly:

       export CEILO_SVCS='compute central collector api alarm-evaluator alarm-notifier'
       for svc in $CEILO_SVCS ; do sudo service openstack-ceilometer-$svc status ; done

For your peace of mind, ensure that there are no errors in the Ceilometer logs at this time:

       for svc in $CEILO_SVCS ; do sudo grep ERROR /var/log/ceilometer/${svc}.log ; done

## Basic Concepts

Getting up to speed with Ceilometer involves getting to grips a few basic concepts and terms.

### Meters

Meters simply measure a particular aspect of resource usage (e.g. the existence of a running instance) or of ongoing performance (e.g. the current CPU utilization % for that instance). As such meters exist per-resource, in that there is a separate `cpu_util` meter for example for each instance. The lifecycle of meters is also decoupled from the existence of the related resources, in the sense that the meter continues to exist *after* the resource has been terminated. While that may seem strange initially, think about how otherwise you could avoid being billed simply by shutting down all your instances the day before your cloud provider kicks off their monthly billing run!

All meters have a string name, an unit of measurement, and a type indicating whether values are monotonically increasing (`cumulative`), interpreted as a change from the previous value (`delta`), or a standalone value relating only to the current duration (`gauge`).

In earlier iterations of Ceilometer, we often used 'counter' as a synonym for 'meter', and this usage though now deprecated persists in some older documentation and deprecated aspects of the command line interpreter.

### Samples

Sample are simply individual datapoints associated with a particular meter. As such, all samples encompass the same attributes as the meter itself, but with the addition of a timestamp and and a value (otherwise known as the sample 'volume').

### Statistics

If a sample is a single datapoint, then a statistic is a set of such datapoints aggregates over a time duration. Ceilometer currently employs 5 different aggregation functions:

*   **count**: the number of samples in each period
*   **max**: the maxima of the sample volumes in each period
*   **min**: the minima of the sample volumes in each period
*   **avg**: the average of the sample volumes over each period
*   **sum**: the sum of the sample volumes over each period

 Note that *all* of these aggregation functions are applied for every statistic calculated. This may seem wasteful if you're only interested in one of the values, but in practice hardly any extra computation cost is incurred due to the map-reduce scheme used to calculate these values.

Also there is some potential confusion in there being both a duration *and* a period associated with these statistics. The duration is simply the overall time-span over which a single query applies, whereas the period is the time-slice length into which this duration is divided for aggregation purposes. So for example, if I was interested in the hourly average CPU utilization over a day, I would provide midnight-to-midnight start and end timestamps on my query giving a duration of 24 hours, while also specifying a period of 3600 seconds to indicate that the finegrained samples should be aggregated over each hour within that day.

### Pipelines

Pipelines are composed of a metering data source that produces certain enumerated or wildcarded meters at a certain cadence, which are fed through a chain of zero or more transformers to massage the data in various ways, before being emitted to the collector via a publisher.

Example of transformers shipped with Ceilometer include:

*   **unit_conversion**: apply a scaling conversion to use a different unit than originally supplied with the observed data, for example converting a temperature from °F to °C (the scaling rule is configurable, so that any reasonable unit conversion expressible in python may be implemented)
*   **rate_of_change**: derives a secondary meter from directly observed data based on the calculated rate of change by sampling the sequence of datapoint, with an associated scaling rule
*   **accumulator**: gather several datapoints before emitting in a batch

 Multiple publishers are also supported, including:

*   **rpc://**: emit metering data for collector over AMQP
*   **<udp://>**: emit metering data for collector over lossy UDP (useful for metric data collected for alarming purposes, but not suitable for metering data to feed into a billing system due to the obvious retention requirements)
*   **<file://>**: emit metering data into a file

These pipelines are configured via a YAML file which is explained in detail below.

### Alarms

Alarms are a new feature in Ceilometer for Havana intended to provide user-oriented Monitoring-as-a-Service for Openstack, with Heat autoscaling being the main motivating use-case, but also having general purpose utility. Essentially an alarm is just a set of rules defining a monitor, plus a current state, with edge-triggered actions associated with target states. These alarms follow a tri-state model of `ok`, `alarm`, and `insufficient data`.

For conventional threshold-oriented alarms, state transitions are governed by:

*   a *static* threshold value & comparison operator
*   against which a selected meter statistic is compared
*   over an evaluation window of configurable length into the recent past.

We also support the concept of a meta-alarm, which aggregates over the current state of a set of other basic alarms combined via a logical operator (AND/OR).

A key associated concept is the notion of *dimensioning* which defines the set of matching meters that feed into an alarm evaluation. Recall that meters are per-resource-instance, so in the simplest case an alarm might be defined over a particular meter applied to *all* resources visible to a particular user. More useful however would the option to explicitly select which specific resources we're interested in alarming on. On one extreme we would have narrowly dimensioned alarms where this selection would have only a single target (identified by resource ID). On the other extreme, we'd have widely dimensioned alarms where this selection identifies many resources over which the statistic is aggregated, for example all instances booted from a particular image or all instances with matching user metadata (the latter is how Heat identifies autoscaling groups).

## Configuration

The shipped Ceilometer configuration is intended to be usable out-of-the-box. However, there are a few tweaks you may want to make while exploring Ceilometer functionality.

### Pipeline configuration

The pipeline definitions are read by default from `/etc/ceilometer/pipeline.yaml` though this location may be overridden via the `pipeline_cfg_file` config option (for example to allow different ceilometer services use different pipelines.

The most likely pipeline config elements you might want to experiment initially initially would be:

*   **`interval`**: defines the cadence of data acquisition by controlling the polling period, which default to 600 seconds (10 minutes).
*   **`meters`**: a list of meters that the current pipeline applies to, either explicitly enumerated with negation via `!` or wildcarded.
*   **`transformers`**: a list of named transformers and their parameters, to be loaded as `stevedore` extensions.

 To become more familiar with the possibilities offered by this configuration file, let's examine the shipped `pipeline.yaml`:

       ---
       -
           name: meter_pipeline
           interval: 600
           meters:
               - "*"
           transformers:
           publishers:
               - rpc://
       -
           name: cpu_pipeline
           interval: 600
           meters:
               - "cpu"
           transformers:
               - name: "rate_of_change"
                 parameters:
                     target:
                         name: "cpu_util"
                         unit: "%"
                         type: "gauge"
                         scale: "100.0 / (10**9 * (resource_metadata.cpu_number or 1))"
           publishers:
               - rpc://

This file defines two separate pipeline, named `meter_pipeline` and `cpu_pipeline`,

The first is very straight-forward, running at the default cadence of 600s and applying to all primary meters (`meters: - "*"`) which are emitted unchanged over AMQP.

The second is more interesting, applying to only the `cpu` meter, transforming this via the `rate_of_change` transformer into the derived `cpu_util` meter. The effect here is to transformer the primary observation of cumulative CPU time in nanosecond into a gauge value as a percentage of the notional maximum total CPU time over that preceding duration scaled by the number of vCPUs allocated to the instance. The scaling rule is expressed as a fragment of python which handles the percentage conversion, nanosecond scaling and taking the number of CPUs into account, all defined very concisely in configuration.

An example modification would be something like increasing the cadence of `cpu_util` from once per 10 minutes to once a minute:

       sudo sed -i '/^ *name: cpu_pipeline$/ { n ; s/interval: 600$/interval: 60/ }' /etc/ceilometer/pipeline.yaml
       sudo service openstack-ceilometer-compute restart

Note that we only need to restart the `compute` and not the `central` even though both share the same pipeline config by default, because the particular meter impacted by the change is only gathered by the former agent.

### Service configuration

The service configuration is read by default from two sources, via the same pattern as you've encountered with the other openstack services in RDO:

*   **distribution config**: `/usr/share/ceilometer/ceilometer-dist.conf` containing the distro-specific overrides over upstream defaults
*   **user-editable config**: `/etc/ceilometer/ceilometer.conf` containing commented-out setting for the all configuration options with help strings and default values

 If you wish to change some configuration option, the latter file is one to edit. This is laid out in the familiar sectioned format as provided by the Olso config library, with configuration options under `[DEFAULT]`, `[database]`, `[api]`, `[alarm]` *etc*.

As always, you can choose to manually edit this file or else use the convenient `openstack-config` utility from the `openstack-utils` package, for example:

       sudo openstack-config --set /etc/ceilometer/ceilometer.conf DEFAULT debug true

to set the logging level to debug as opposed to the default warning. As always, services must be restarted for config changes to take effect.

## Exploring with the CLI

First ensure that the latest version of CLI package is installed:

       sudo rpm -qa | awk -F- '/python-ceilometerclient/ {print $3}'
       1.0.8

which will allow you to access the latest API additions, for example alarm history and the separation of alarm representation from the encapsulated rules.

We will proceed to explore each of the basic concepts described earlier in this guide. But before we do so, it's worth mentioning a common conceptual banana skin that often confuses new Ceilometer users at this early stage. Recall that metering is all about measuring user-visible cloud resource usage - if there ain't any user-visible resources in your cloud, no metering data will be generated. So let's start by ensuring some resources are actually present, firstly the basic building blocks, some VM images in `glance`:

       glance image-list

If this list empty, let's quickly grab a small basic `cirros` image that we'll later use to spin up some instances:

       sudo yum install -y wget
` wget `[`http://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-uec.tar.gz`](http://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-uec.tar.gz)
       tar zxvf cirros-0.3.0-x86_64-uec.tar.gz 
       glance image-create --name cirros-aki --is-public True --container-format aki --disk-format aki \
         --file cirros-0.3.0-x86_64-vmlinuz
       glance image-create --name cirros-ari --is-public True --container-format ari --disk-format ari \
         --file cirros-0.3.0-x86_64-initrd
       glance image-create --name cirros-ami --is-public True --container-format ami --disk-format ami \
         --property kernel_id=$(glance image-list | awk '/cirros-aki/ {print $2}') \
         --property ramdisk_id=$(glance image-list | awk '/cirros-ari/ {print $2}') --file cirros-0.3.0-x86_64-blank.img

Then spin up an instance booted from that image:

       IMAGE_ID=$(glance image-list | awk '/cirros-ami/ {print $2}')
       nova boot --image $IMAGE_ID --flavor 1 test_instance

Wait for that instance to become active and we're good to go!

       watch 'nova show test_instance'

### Displaying meters

Individual meters are displayed via the CLI `meter-list` command:

       $ ceilometer meter-list
       +----------------------------+------------+-----------+---------------+-----------+--------------+
       | Name                       | Type       | Unit      | Resource ID   | User ID   | Project ID   |
       +----------------------------+------------+-----------+---------------+-----------+--------------+
       | cpu                        | cumulative | ns        | INSTANCE_ID_1 | USER_ID_A | PROJECT_ID_X |
       | cpu                        | cumulative | ns        | INSTANCE_ID_2 | USER_ID_B | PROJECT_ID_Y |
       | cpu                        | cumulative | ns        | INSTANCE_ID_3 | USER_ID_C | PROJECT_ID_Z |
       | cpu_util                   | gauge      | %         | INSTANCE_ID_1 | USER_ID_A | PROJECT_ID_X |
       | cpu_util                   | gauge      | %         | INSTANCE_ID_3 | USER_ID_C | PROJECT_ID_Z |
       | disk.ephemeral.size        | gauge      | GB        | INSTANCE_ID_1 | USER_ID_A | PROJECT_ID_X |
       | disk.ephemeral.size        | gauge      | GB        | INSTANCE_ID_2 | USER_ID_B | PROJECT_ID_Y |
       | disk.ephemeral.size        | gauge      | GB        | INSTANCE_ID_3 | USER_ID_C | PROJECT_ID_Z |
       | ... [snip]                                                                                     |
       +----------------------------+------------+-----------+---------------+-----------+--------------+

As you can see in the example output above, all meters are listed for all resources that existed since metering began (modulo data expiry if configured). We can use the `--query` option to limit the output to a specific resource, project or user for example.

       $ ceilometer meter-list --query project=PROJECT_ID_Y;user=USER_ID_B
       +----------------------------+------------+-----------+---------------+-----------+--------------+
       | Name                       | Type       | Unit      | Resource ID   | User ID   | Project ID   |
       +----------------------------+------------+-----------+---------------+-----------+--------------+
       | cpu                        | cumulative | ns        | INSTANCE_ID_2 | USER_ID_B | PROJECT_ID_Y |
       | disk.ephemeral.size        | gauge      | GB        | INSTANCE_ID_2 | USER_ID_B | PROJECT_ID_Y |
       | ... [snip]                                                                                     |
       +----------------------------+------------+-----------+---------------+-----------+--------------+

The syntax of that `--query` (or `-q`) option is common across several CLI commands target'ing the v2 API, the syntax being:

` -q `<field1><operator1><value1>`;`<field2><operator2><value2>`;...;`<field_n><operator_n><value_n>

which are translated by the CLI to a sequence of [WSME](//pypi.python.org/pypi/WSME) query parameters.

### Displaying datapoints

Individual datapoints for a particular meter name are displayed via the CLI `samples-list` command:

       $ ceilometer sample-list --meter cpu
       +---------------+------+------------+---------------+------+---------------------+
       | Resource ID   | Name | Type       | Volume        | Unit | Timestamp           |
       +---------------+------+------------+---------------+------+---------------------+
       | INSTANCE_ID_1 | cpu  | cumulative | 1.6844e+11    | ns   | 2013-10-01T08:48:29 |
       | INSTANCE_ID_1 | cpu  | cumulative | 1.7039e+11    | ns   | 2013-10-01T08:58:28 |
       | INSTANCE_ID_1 | cpu  | cumulative | 1.7234e+11    | ns   | 2013-10-01T09:08:28 |
       | INSTANCE_ID_1 | cpu  | cumulative | 1.743e+11     | ns   | 2013-10-01T09:18:28 |
       | INSTANCE_ID_1 | cpu  | cumulative | 1.7626e+11    | ns   | 2013-10-01T09:28:28 |
       | ... [snip]                                                                     |
       | INSTANCE_ID_2 | cpu  | cumulative | 2.9833e+11    | ns   | 2013-10-01T08:48:29 |
       | INSTANCE_ID_2 | cpu  | cumulative | 2.6028e+11    | ns   | 2013-10-01T08:58:28 |
       | INSTANCE_ID_2 | cpu  | cumulative | 3.7156e+11    | ns   | 2013-10-01T09:08:28 |
       | INSTANCE_ID_2 | cpu  | cumulative | 3.7987e+11    | ns   | 2013-10-01T09:18:28 |
       | INSTANCE_ID_2 | cpu  | cumulative | 2.6555e+11    | ns   | 2013-10-01T09:28:28 |
       | ... [snip]                                                                     |
       +---------------+------+------------+---------------+------+---------------------+

Note that the samples relate to multiple resources (assuming more than one instances was spun up in this case) and are grouped by resource ID, and sorted by timestamp. Since the query applies to this meter name as it pertains to *all* resources, if metering has been running for any reasonable duration, this command unadorned can turn into a bit of a firehose in terms the sheer volume of data returned. As before, we can rely on the `-q` option to constrain the query, for example by resource id and timestamp:

       $ ceilometer sample-list --meter cpu -q 'resource_id=INSTANCE_ID_1;timestamp>2013-10-01T09:00:00;timestamp<=2013-10-01T09:30:00'
       +---------------+------+------------+---------------+------+---------------------+
       | Resource ID   | Name | Type       | Volume        | Unit | Timestamp           |
       +---------------+------+------------+---------------+------+---------------------+
       | INSTANCE_ID_1 | cpu  | cumulative | 1.7234e+11    | ns   | 2013-10-01T09:08:28 |
       | INSTANCE_ID_1 | cpu  | cumulative | 1.743e+11     | ns   | 2013-10-01T09:18:28 |
       | INSTANCE_ID_1 | cpu  | cumulative | 1.7626e+11    | ns   | 2013-10-01T09:28:28 |
       +---------------+------+------------+---------------+------+---------------------+

to restrict the query to samples for a particular instance that occurred within the specified half hour time window,

### Aggregating statistics

Individual datapoints for a particular meter may be aggregated into consolidated statistics via the CLI `statistics` command:

       $ ceilometer statistics --meter cpu_util
       +--------+--------------+------------+-------+------+-----+-----+-----+----------+----------------+----
       | Period | Period Start | Period End | Count | Min  | Max | Sum | Avg | Duration | Duration Start | ...
       +--------+--------------+------------+-------+------+-----+-----+-----+----------+----------------+----
       | 0      | PERIOD_START | PERIOD_END | 2024  | 0.25 | 6.2 | 550 | 2.9 | 85196.0  | DURATION_START | ...
       +--------+--------------+------------+-------+------+-----+-----+-----+----------+----------------+----

(output is narrowed for brevity here). The thing to notice here is that by default *all* samples for *all* meters matching the given name are aggregated for *all* time. It would be more normal to require that:

1.  the samples feeding into the statistics are constrained by resource or some other attribute
2.  the overall duration is bounded by start and end timestamp
3.  this bounded duration is further subdivided into timeslices

 These extra constraints may all be expressed on the command line:

       $ ceilometer --debug statistics -m cpu_util -q 'timestamp>START;timestamp<=END' --period 60
       +--------+--------------+------------+-------+-----+-----+-----+-----+----------+----------------+----
       | Period | Period Start | Period End | Count | Min | Max | Sum | Avg | Duration | Duration Start | ...
       +--------+--------------+------------+-------+-----+-----+-----+-----+----------+----------------+----
       | 60     | START        | START+60   | 2     | 1.5 | 2.5 | 4.0 | 2.0 | 0.0      | DURATION_START | ...
       | 60     | START+60     | START+120  | 2     | 2.5 | 3.5 | 6.0 | 3.0 | 0.0      | DURATION_START | ...
       | ...[snip]
       +--------+--------------+------------+-------+-----+-----+-----+-----+----------+----------------+----

### Using alarms

Before creating any alarms, ensure that the relevant Ceilometer alarming services are running:

       export CEILO_ALARM_SVCS='evaluator notifier'
       for svc in $CEILO_ALARM_SVCS; do sudo service openstack-ceilometer-alarm-$svc status; done

An example of creating a threshold-oriented alarm, based on a upper bound on the CPU utilization for a particular instance:

       $ ceilometer alarm-threshold-create --name cpu_high --description 'instance running hot'  \
         --meter-name cpu_util  --threshold 70.0 --comparison-operator gt  --statistic avg \
         --period 600 --evaluation-periods 3 \
         --alarm-action 'log://' \
         --query resource_id=INSTANCE_ID
       +---------------------------+-----------------------------------------------------+
       | Property                  | Value                                               |
       +---------------------------+-----------------------------------------------------+
       | meter_name                | cpu_util                                            |
       | alarm_actions             | [u'log://']                                         |
       | user_id                   | USER_ID                                             |
       | name                      | cpu_high                                            |
       | evaluation_periods        | 3                                                   |
       | statistic                 | avg                                                 |
       | enabled                   | True                                                |
       | period                    | 600                                                 |
       | alarm_id                  | ALARM_ID                                            |
       | state                     | insufficient data                                   |
       | query                     | resource_id == INSTANCE_ID                          |
       | insufficient_data_actions | []                                                  |
       | repeat_actions            | False                                               |
       | threshold                 | 70.0                                                |
       | ok_actions                | []                                                  |
       | project_id                | PROJECT_ID                                          |
       | type                      | threshold                                           |
       | comparison_operator       | gt                                                  |
       | description               | instance running hot                                |
       +---------------------------+-----------------------------------------------------+

This creates an alarm that will fire when the average CPU utilization for an individual instance exceeds 70% for three consecutive 10 minute periods. The notification is this case is simply a log message, though it could alternatively be a webhook URL.

You can display all your alarms via:

       $ ceilometer alarm-list 
       +----------+----------+-------------------+---------+------------+---------------------------------+
       | Alarm ID | Name     | State             | Enabled | Continuous | Alarm condition                 |
       +----------+----------+-------------------+---------+------------+---------------------------------+
       | ALARM_ID | cpu_high | insufficient data | True    | False      | cpu_util > 70.0 during 3 x 600s |
       +----------+----------+-------------------+---------+------------+---------------------------------+

In this case, the state is reported as `insufficient data` which could indicate that:

*   metrics have not yet been gathered about this instance over the evaluation window into the recent past (e.g. a brand-new instance)
*   or, that the identified instance is not visible to the user/tenant owning the alarm
*   or, simply that an alarm evaluation cycle hasn't kicked off since the alarm was created (by default, alarms are evaluated once per minute).

 Once the state of the alarm has settled down, we might decide that we set that bar too low with 70%, in which case the threshold (or most any other alarm attribute) can be updated as follows:

       $ ceilometer alarm-update --threshold 75 -a ALARM_ID
       +---------------------------+-----------------------------------------------------+
       | Property                  | Value                                               |
       +---------------------------+-----------------------------------------------------+
       | meter_name                | cpu_util                                            |
       | alarm_actions             | [u'log://']                                         |
       | user_id                   | USER_ID                                             |
       | name                      | cpu_high                                            |
       | evaluation_periods        | 3                                                   |
       | statistic                 | avg                                                 |
       | enabled                   | True                                                |
       | period                    | 600                                                 |
       | alarm_id                  | ALARM_ID                                            |
       | state                     | insufficient data                                   |
       | query                     | resource_id == INSTANCE_ID                          |
       | insufficient_data_actions | []                                                  |
       | repeat_actions            | False                                               |
       | threshold                 | 75.0                                                |
       | ok_actions                | []                                                  |
       | project_id                | PROJECT_ID                                          |
       | type                      | threshold                                           |
       | comparison_operator       | gt                                                  |
       | description               | instance running hot                                |
       +---------------------------+-----------------------------------------------------+

The change will take effect from the next evaluation cycle, which by default occurs every minute.

Over time the state of the alarm may change often, especially if the threshold is chosen to be close to the trending value of the statistic. We can follow the history of an alarm over its lifecycle via the audit API:

       $ ceilometer alarm-history -a ALARM_ID
       +------------------+----------------------------+---------------------------------------+
       | Type             | Timestamp                  | Detail                                |
       +------------------+----------------------------+---------------------------------------+
       | creation         | 2013-10-01T16:20:29.238000 | name: cpu_high                        |
       |                  |                            | description: instance running hot     |
       |                  |                            | type: threshold                       |
       |                  |                            | rule: cpu_util > 70.0 during 3 x 600s |
       | state transition | 2013-10-01T16:20:40.626000 | state: ok                             |
       | rule change      | 2013-10-01T16:22:40.718000 | rule: cpu_util > 75.0 during 3 x 600s |
       +------------------+----------------------------+---------------------------------------+

Finally, an alarm that's no longer required can be disabled:

      $ ceilometer alarm-update --enabled False -a ALARM_ID

or deleted permanently:

      $ ceilometer alarm-delete -a ALARM_ID

## Exploring the metering store

Ceilometer uses `mongodb` by default to store metering data, though alternative pluggable storage drivers are also provided for sqlalchemy, db2 and HBase. Only the `mongodb` storage driver is considered feature-complete at this time, so this is the recommended choice for production.

Before we begin to explore the datastore, ensure that the `mongo` client is installed locally:

       sudo yum install -y mongodb

The top-level structure can be seen by showing the available collections:

       $ mongo ceilometer
       MongoDB shell version: 2.4.6
       connecting to: ceilometer
       > show collections
       alarm
       alarm_history
       meter
       project
       resource
       system.indexes
       user

At the heart of the datastore is the `meter` collection containing the actual metering datapoints, and from which queries on meters, samples and statistics are satisfied. The `alarm` and `alarm_history` collections contain alarm rules & state and audit trails respectively. The `project` and `user` collections concern identity, referring to the known tenants and users respectively. Whereas the `resource` collection contains an entry per unique metered resource (instance, image, volume etc.), storing the metadata thereof and linking back to the related meters.

Note also the explicitly established system indices, which are created on demand by the storage driver:

       > query = {'name': {$ne: '_id_'}}             // only include explicitly named indices
       > projection = {'key': 1, 'ns': 1, 'name': 1} // project onto key, namespace, name
       > db.system.indexes.find(query, projection)
       { "key" : { "user_id" : 1, "source" : 1 }, "ns" : "ceilometer.resource", "name" : "resource_idx" }
       { "key" : { "resource_id" : 1, "user_id" : 1, "counter_name" : 1, "timestamp" : 1, "source" : 1 }, "ns" : "ceilometer.meter", "name" : "meter_idx" }
       { "key" : { "timestamp" : -1 }, "ns" : "ceilometer.meter", "name" : "timestamp_idx" }

The keys over which each index extends, in addition to the sort order (1 indicating ascending, -1 indicating decending) is revealed in the query result above. So for example, we see there's an index over the meter collection based on the timestamp attribute, ordered from most to least recent.

Unlike relational databases which have static schemata requiring careful management as they evolve, `mongo` is much more flexible and allows the structure of documents in a collection to change over time. Hence for this storage layer we do not have an analogue of the familiar `sqlalchemy-migrate` and/or `alembic` schema upgrade/downgrade scripts that are widely used across the OpenStack services. However there are several [tools available](http://skratchdot.com/projects/mongodb-schema) that allow a schema to be inferred from the observed document structure, if that would enhance your understanding of the store structure.

Now you could of course continue your exploration by looking at the raw documents stored in each of the Ceilometer collections, but these data are usually more conveniently retrieved via the API layer. However, there are cases were these data can be usefully processed directly, generally to aggregate in ways not currently supported by the Ceilometer API.

Say for example you wanted to see how much variance in CPU utilization there has been across the instances owned by a certain tenant. Casting your mind back to stats 101, you recall that such a question can be answered with the familiar concept of standard deviation. Now since standard deviation is not currently included in the set of statistical aggregates exposed in the v2 Ceilometer API, you could proceed to calculate it directly in `mongo` via map-reduce with some simple javascript:

       > function map() {
             emit(this.resource_id, {sum: this.counter_volume, count: 1, weighted_distances: 0});
         }
       > function reduce(key, mapped) { 
             var merge = mapped[0];
             for (var i = 1 ; i < mapped.length ; i++) {
                 var deviance = (merge.sum / merge.count) - mapped[i].sum;
                 var weight = merge.count / ++merge.count;
                 merge.weighted_distances += (Math.pow(deviance, 2) * weight);
                 merge.sum += mapped[i].sum;
             }      
             return merge; 
         }
       > function complete(key, reduced) {
             reduced.stddev = Math.sqrt(reduced.weighted_distances / reduced.count);
             return reduced;
        }
       > db.meter.mapReduce(map,
                            reduce,
                            {finalize: complete,
                             out: {merge: 'cpu_util_deviation'},
                             query: {'counter_name': 'cpu_util',
                                     'project_id': PROJECT_ID}})
        ...
       > projection = { 'value.stddev': 1 }  // ignore partial results 
       > db.cpu_util_deviation.find({}, projection)
       { "_id" : "INSTANCE_ID_1", "value" : { "stddev" : 0.030034533016630435 } }
       { "_id" : "INSTANCE_ID_2", "value" : { "stddev" : 0.3418399151135359 } }
       ...

We leave it as an exercise for the reader to compare the aggregate values directly calculated above in the partial results (sum, count) with those reported via the statistics API.

<Category:Documentation>
