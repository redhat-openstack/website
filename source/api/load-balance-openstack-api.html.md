---
title: Load Balance OpenStack API
category: api
authors: djschaap, rohara
wiki_title: Load Balance OpenStack API
wiki_revision_count: 11
wiki_last_updated: 2013-09-13
---

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
# Load-Balancing OpenStack API Services

When running each of the OpenStack API services on a single controller node, there exists not only a single point of failure but also a potential bottleneck. This guide will show how to manually deploy additional OpenStack controller nodes and configure HAProxy to load-balance each OpenStack API service. In addition, keepalived will be used to provide high availability for the HAProxy load-balancer.

### Prerequisites

This guide assumes that OpenStack has been deployed on a single node via the packstack installer. See the RDO QuickStart guide for more information.

### Overview

The general approach is to install and configure the load-balancer nodes, followed by deploying the additional OpenStack controller nodes. This may seem backwards, but it is better to do configure our OpenStack controller nodes after our virtual IP address is active.

Note that in the example given in this guide the load-balancer is not co-located on the OpenStack controller nodes. While it may be possible to merge the load-balance and controller nodes, it requires extra care to ensure that HAProxy and the various OpenStack API services are not listening on the same ports.

### Configure Load-Balancer Nodes

The first step is select two or more nodes that will serve as load-balancer nodes. Each of these nodes will run both haproxy and keepalived. In our example there will be three load-balancer nodes.

Next, identify which nodes will serve as OpenStack controller nodes. This includes both the single-node OpenStack deployment and at least one additional controller node to be configured. Each of these nodes will run the OpenStack API services. In our example there will be three OpenStack controller nodes with the following IP addresses:

    10.15.85.141
    10.15.85.142
    10.15.85.143

Finally, select a virtual IP address. This can be any available IP address on the same subnet as our load-balancer and controller nodes. The example described in this guide will use the following virtual IP address:

    10.15.85.31

Login to each of the load-balancer nodes and install both keepalived and haproxy.

    # yum install keepalived haproxy

To configure the load-balancer, begin by editing the HAProxy configuration file /etc/haproxy/haproxy.cfg. In the example below shows a very simple haproxy.cfg file that defines a proxy for each OpenStack API service. Each proxy has a frontend and a backend. The frontend will define the IP address and port on which HAProxy will listen, as well that the default backend. A proxy's backend defines the pool of servers which traffic will be load-balanced across using a specific algorithm.

Note that HAProxy has many powerful options. The example shown below is intended to be a very basic configuration. Please refer to the official HAProxy documentation for an exhaustive list of options.

    global
        daemon

    defaults
        mode http
        maxconn 10000
        timeout connect 10s
        timeout client 10s
        timeout server 10s

    frontend keystone-admin-vip
        bind 10.15.85.31:35357
        default_backend keystone-admin-api

    frontend keystone-public-vip
        bind 10.15.85.31:5000
        default_backend keystone-public-api

    frontend quantum-vip
        bind 10.15.85.31:9696
        default_backend quantum-api

    frontend glance-vip
        bind 10.15.85.31:9191
        default_backend glance-api

    frontend glance-registry-vip
        bind 10.15.85.31:9292
        default_backend glance-registry-api

    frontend nova-ec2-vip
        bind 10.15.85.31:8773
        default_backend nova-ec2-api

    frontend nova-compute-vip
        bind 10.15.85.31:8774
        default_backend nova-compute-api

    frontend nova-metadata-vip
        bind 10.15.85.31:8775
        default_backend nova-metadata-api

    frontend cinder-vip
        bind 10.15.85.31:8776
        default_backend cinder-api

    backend keystone-admin-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:35357 check inter 10s
        server mesa-virt-02 10.15.85.142:35357 check inter 10s
        server mesa-virt-03 10.15.85.143:35357 check inter 10s

    backend keystone-public-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:5000 check inter 10s
        server mesa-virt-02 10.15.85.142:5000 check inter 10s
        server mesa-virt-03 10.15.85.143:5000 check inter 10s

    backend quantum-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:9696 check inter 10s
        server mesa-virt-02 10.15.85.142:9696 check inter 10s
        server mesa-virt-03 10.15.85.143:9696 check inter 10s

    backend glance-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:9191 check inter 10s
        server mesa-virt-02 10.15.85.142:9191 check inter 10s
        server mesa-virt-03 10.15.85.143:9191 check inter 10s

    backend glance-registry-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:9292 check inter 10s
        server mesa-virt-02 10.15.85.142:9292 check inter 10s
        server mesa-virt-03 10.15.85.143:9292 check inter 10s

    backend nova-ec2-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:8773 check inter 10s
        server mesa-virt-02 10.15.85.142:8773 check inter 10s
        server mesa-virt-03 10.15.85.143:8773 check inter 10s

    backend nova-compute-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:8774 check inter 10s
        server mesa-virt-02 10.15.85.142:8774 check inter 10s
        server mesa-virt-03 10.15.85.143:8774 check inter 10s

    backend nova-metadata-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:8775 check inter 10s
        server mesa-virt-02 10.15.85.142:8775 check inter 10s
        server mesa-virt-03 10.15.85.143:8775 check inter 10s

    backend cinder-api
        balance roundrobin
        server mesa-virt-01 10.15.85.141:8776 check inter 10s
        server mesa-virt-02 10.15.85.142:8776 check inter 10s
        server mesa-virt-03 10.15.85.143:8776 check inter 10s

Notice that each server declaration has "check inter 10s" appended. This instructs HAProxy to perform a health-check of the server every 10 seconds. When a server fails a health-check it is considered "down" and traffic will not be forwarded to that. However the health-check will still be performed at 10 second intervals. Should the server resume responding to health-checks, it will be considered "active" and once again be considered for load-balancing traffic.

The haproxy.cfg file should be identical on each of the load-balancer nodes, so copy that file to the all other load-balancer nodes.

Before we start the HAProxy service on our load-balancer nodes, configure keepalived. In our example, keepalived will be used to provide high-availability for our HAProxy load-balancer. Without keepalived, HAProxy would be a single point of failure.

In our example, the keepalived service is used for virtual IP failover. Keepalived uses Virtual Router Redundancy Protocol (VRRP) to handle virtual IP failover. VRRP is a priority-based protocol where at any time there can be multiple backup nodes and a single master node. The master node it responsible for sending out periodic advertisements that include the node's priority. Should the backup nodes stop receiving advertisements, a new master is selected based on priority.

Note that VRRP advertisements are sent via multicast, so all load-balancer nodes should be capable of sending and receiving multicast traffic. Be particularly cautious of iptables rules that may block multicast traffic.

On each load-balancer node, edit /etc/keepalived/keepalived.conf to configure keepalived. Below is the keepalived.conf file used in our example:

    vrrp_script haproxy-check {
        script "killall -0 haproxy"
        interval 2
        weight 10
    }

    vrrp_instance openstack-vip {
        state BACKUP
        priority 102
        interface eth0
        virtual_router_id 47
        advert_int 3

        virtual_ipaddress {
            10.15.85.31
        }

        track_script {
        haproxy-check
        }
    }

The keepalived.conf configuration file will not be the same on each load-balancer node. Specifically, each load-balancer node should have a unique priority. Also, one load-balancer node may be configured to default to MASTER state, but this is not required.

Notice that the keepalived configuration has a VRRP script. In our example the script is named "haproxy-check". This script is used to check that our HAProxy service is running. If this script succeeds, the node's effective priority is increased by 10. Since the example above has a base priority of 102, the effective priority for the node will be 112 as long as HAProxy is running. If HAProxy should stop running for any reason, the node's effective priority will return to 102.

As mentioned above, each load-balancer node should have a unique priority. It is important that the difference between each node's priority is not greater than the weight of our VRRP scipt. For example, if our three load-balancer nodes had base priorities of 102, 132, and 162 respectively, yet the weight of our VRRP script was only 10, a failed VRRP script may not reduce a node's effective priority enough to cause a failover.

Next, configure the load-balancer nodes to allow HAProxy to bind to a non-local IP address. This is needed since HAProxy will be running on each of our load-balancer nodes, yet keepalived will ensure that our virtual IP address exists on only one of our load-balancer nodes at any given time.

    # sysctl -w net.ipv4.ip_nonlocal_bind=1

To make this change permanent, add the following line to /etc/sysctl.conf:

    net.ipv4.ip_nonlocal_bind=1

With both keepalived and haproxy configured on each node, enable and start each service.

    # chkconfig haproxy on
    # chkconfig keepalived on
    # service haproxy start
    # service keepalived start

At this point both services should be running on each node. The node with the highest priority should own the virtual IP address and HAProxy should be ready to load-balance traffic for our OpenStack API services to our controller nodes once they are configured.

### Configure OpenStack Controller Nodes

The next step is to deploy additional OpenStack controller nodes and configure them to use our virtual IP address. The easiest way to do this is install the required packages on the additional controller nodes, edit the appropriate configuration files on the original single-node deployment, and finally copy the configuration files to the new controller nodes. When copying OpenStack configuration files between nodes, take care that the files have the correct owner, group and permissions.

#### Keystone

On the new controller nodes, install the OpenStack Keystone service:

    # yum install openstack-keystone

Copy the configuration files in the /etc/keystone/ directory on the original controller node to the additional controller nodes.

    /etc/keystone
    /etc/keystone/default_catalog.templates
    /etc/keystone/keystone.conf
    /etc/keystone/logging.conf
    /etc/keystone/policy.json
    /etc/keystone/ssl
    /etc/keystone/ssl/certs
    /etc/keystone/ssl/certs/01.pem
    /etc/keystone/ssl/certs/cakey.pem
    /etc/keystone/ssl/certs/ca.pem
    /etc/keystone/ssl/certs/index.txt
    /etc/keystone/ssl/certs/index.txt.attr
    /etc/keystone/ssl/certs/index.txt.old
    /etc/keystone/ssl/certs/openssl.conf
    /etc/keystone/ssl/certs/req.pem
    /etc/keystone/ssl/certs/serial
    /etc/keystone/ssl/certs/serial.old
    /etc/keystone/ssl/certs/signing_cert.pem
    /etc/keystone/ssl/private
    /etc/keystone/ssl/private/signing_key.pem

On the new controller nodes, enable and start the OpenStack Keystone service:

    # chkconfig openstack-keystone on
    # service openstack-keystone start

#### Quantum

On the new controller nodes, install the OpenStack Quantum service and the appropriate L2 plugin:

    # yum install openstack-quantum
    # yum install openstack-quantum-openvswitch

Since the Keystone and Nova services will also be load-balanced, make the following changes to our configuration files:

/etc/quantum/quantum.conf

    auth_host = 10.15.85.31

/etc/quantum/api-paste.ini

    auth_host = 10.15.85.31

/etc/quantum/metadata_agent.ini

    auth_url = http://10.15.85.31:35357/v2.0
    nova_metadata_ip = 10.15.85.31

Copy the configuration files in the /etc/quantum/ directory on the original controller node to the additional controller nodes:

    /etc/quantum
    /etc/quantum/api-paste.ini
    /etc/quantum/dhcp_agent.ini
    /etc/quantum/l3_agent.ini
    /etc/quantum/lbaas_agent.ini
    /etc/quantum/metadata_agent.ini
    /etc/quantum/plugin.ini -> /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
    /etc/quantum/plugins
    /etc/quantum/plugins/openvswitch
    /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
    /etc/quantum/policy.json
    /etc/quantum/quantum.conf
    /etc/quantum/release
    /etc/quantum/rootwrap.conf

On the new controller nodes, enable and start the OpenStack Quantum service:

    # chkconfig quantum-server on
    # service quantum-server start

#### Glance

On the new controller nodes, install the OpenStack Glance service:

    # yum install openstack-glance

Make the following modifications to the configuration files:

/etc/glance/glance-api.conf

    registry_host = 10.15.85.31
    auth_host = 10.15.85.31

/etc/glance/glance-registry.conf

    auth_host = 10.15.85.31

Copy the configuration files in the /etc/glance/ directory on the original controller node to the additional controller nodes:

    /etc/glance
    /etc/glance/glance-api.conf
    /etc/glance/glance-api-paste.ini
    /etc/glance/glance-cache.conf
    /etc/glance/glance-registry.conf
    /etc/glance/glance-registry-paste.ini
    /etc/glance/glance-scrubber.conf
    /etc/glance/policy.json
    /etc/glance/schema-image.json

On the new controller nodes, enable and start the OpenStack Glance API and registry services:

    # chkconfig openstack-glance-registry  on
    # chkconfig openstack-glance-api on
    # service openstack-glance-registry start
    # service openstack-glance-api start

#### Nova

On the new controller nodes, install the OpenStack Nova service and the Cinder client:

    # yum install openstack-nova-api
    # yum install python-cinderclient

Make the following modifications to the configuration files:

/etc/nova/nova.conf

    metadata_host = 10.15.85.31
    quantum_admin_auth_url = http://10.15.85.31:35357/v2.0
    quantum_url = http://10.15.85.31:9696
    glance_api_servers = 10.15.85.31:9292

/etc/nova/api-paste.ini

    auth_host = 10.15.85.31

Copy the configuration files in the /etc/nova/ directory on the original controller node to the additional controller nodes:

    /etc/nova
    /etc/nova/api-paste.ini
    /etc/nova/nova.conf
    /etc/nova/policy.json
    /etc/nova/release
    /etc/nova/rootwrap.conf

On the new controller nodes, enable and start the OpenStack Nova API service:

    # chkconfig openstack-nova-api on
    # service openstack-nova-api start
