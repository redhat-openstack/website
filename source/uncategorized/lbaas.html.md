---
title: LBaaS
authors: rohara
wiki_title: LBaaS
wiki_revision_count: 7
wiki_last_updated: 2014-02-20
---

# L Baa S

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
## Configuring and Deploying LBaaS in OpenStack Havana

The Neutron LBaaS (load-balancer-as-a-service) extension provides a means to load balance traffic for services running on virtual machines in the cloud. The LBaaS API provides an API to quickly and easily deploy a load balancer. This guide will show how to configure and deploy a load balancer using the LBaaS API with RDO.

### Prerequisites

In this guide, haproxy will be used as the load balancer. Be sure that you either have haproxy installed or have access to a yum repository that provides the haproxy package.

### Installation

The Neutron LBaaS extension can be enabled and configured by packstack at install time. To do so, use the --neutron-lbaas-hosts option to specify the IP address of that host that will run the LBaaS agent:

    # packstack --allinone --neutron-lbaas-hosts=192.168.1.10

In the above example, packstack will do an all-in-one install on the local host, which has an IP address of 192.168.1.10. In the future it may be possible to have packstack install and configure the LBaaS agent on multiple hosts. For now, using the local host's IP address for the --neutron-lbaas-hosts option will configure LBaaS on our all-one-one deployment

### Configuration

For LBaaS to be configure properly, various configuration files must have the following changes:

The service_provider parameter should be set in /usr/share/neutron/neutron-dist.conf:

    service_provider = LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default

The service_plugin should be set in /etc/neutron/neutron.conf:

    service_plugins = neutron.services.loadbalancer.plugin.LoadBalancerPlugin

The interface_driver and device_driver should be set in /etc/neutron/lbaas_agent.ini. Since the load balancer will be haproxy, set the device_driver accordingly:

    device_driver = neutron.services.loadbalancer.drivers.haproxy.namespace_driver.HaproxyNSDriver

The interface_driver will depend on the core L2 plugin being used.

For OpenVSwitch:

    interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver

For linuxbridge:

    interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver

If the above configuration files were changed manually, restart the neutron-server service and neutron-lbaas-agent service.
