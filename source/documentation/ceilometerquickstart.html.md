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

The general prerequsites are identical to the [Havana QuickStart](QuickStartLatest), and in fact if you follow that guide right now you will end up with Ceilometer installed by default once your packstack run completes .

However, if you are installing on a resource-constrained VM, some prior setup can make your life easier. The default & most feature-complete storage driver used by Ceilometer is mongodb, which on installation eagerly pre-allocates large journal files *etc*. This is normally not an issue, but the default service timeout of 90 seconds imposed by systemd *may* not suffice for this preallocation to complete on resource-starved VMs. However this can be easily worked around in that scenarion by preinstalling mongo with a modified startup timeout, as follows:

         sudo yum install -y mongodb-server mongodb
         sudo sed -i '/^`\[Service\]`$/ a\
           TimeoutStartSec=360' /usr/lib/systemd/system/mongod.service
         sudo service mongod start
         sudo service mongod status
         sudo service mongod stop

### Step 1. Verification

Once your packstack run is complete, you're probably eager to verify that Ceilometer is properly installed and working it should.

Before we do that, a few words on how Ceilometer is realized as a set of agents and services. It comprises at least four separate daemons, each with a specific function in the metering pipeline:

*   **compute** agent: polls the local libvirt daemon to acquire performance data for the local instances, massages and emits these data as AMQP notifications
*   **central** agent: polls the public RESTful APIs of other openstack services such as nova and glance, in order to keep tabs on resource existence
*   **collector** service: consumes AMQP notifications from the agents and other openstack services, then dispatch these data to the metering store
*   **API** service: presents aggregated metering data to consumers (such as billing engines, analytics tools *etc*.)

</div>
</div>
<Category:Documentation>
