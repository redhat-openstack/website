---
title: RabbitMQ
authors: ichavero, jeckersb, rohara
wiki_title: RabbitMQ
wiki_revision_count: 7
wiki_last_updated: 2014-03-13
---

# Rabbit MQ

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
## Using RabbitMQ with RDO Havana

OpenStack requires a messaging service for internal communications between various components. Currently, this is done by using an AMQP broker. OpenStack can be configured to use either the Qpid broker or the RabbitMQ broker. In RDO, the default broker is Qpid. This guide will show how to replace Qpid with RabbitMQ, as well as how to deploy highly available RabbitMQ.

This guide will assume that RDO has been installed on a single node via packstack:

    % packstack --allinone

This will deploy OpenStack on a single node, including the Qpid messaging service. In order to replace Qpid with RabbitMQ, all OpenStack services should first be stopped.

    % openstack-service stop

Once all the OpenStack services are stopped, stop and disable the Qpid service.

    % service qpidd stop
    % chkconfig qpidd off

Next, install the RabbitMQ service.

    % yum install rabbitmq-server

After installation completes, enable and start the RabbitMQ service.

    % chkconfig rabbitmq-server start
    % service rabbitmq-server start

At this point the RabbitMQ service is running on the localhost, listening on port 5672. The next step is to configure the relevant OpenStack services to use the RabbitMQ messaging driver.

Neutron:

    openstack-config --set /etc/neutron/neutron.conf DEFAULT rpc_backend neutron.openstack.common.rpc.impl_kombu

Cinder:

    openstack-config --set /etc/cinder/cinder.conf DEFAULT rpc_backend cinder.openstack.common.rpc.impl_kombu

Nova:

    openstack-config --set /etc/nova/nova.conf DEFAULT rpc_backend nova.openstack.common.rpc.impl_kombu

Glance:

    openstack-config --set /etc/glance/glance-api.conf DEFAULT notifier_strategy rabbit

Ceilometer:

    openstack-config --set /etc/ceilometer/ceilometer.conf DEFAULT rpc_backend ceilometer.openstack.common.rpc.impl_kombu

By default, OpenStack assumes that the RabbitMQ broker is listening on port 5672 of the localhost. In this example, the OpenStack services could now be restarted with no additional configuration. For completeness, set the host and port where the RabbitMQ broker is listening. This must be done for each OpenStack service.

Neutron:

    openstack-config --set /etc/neutron/neutron.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/neutron/neutron.conf DEFAULT rabbit_port 5672

Nova:

    openstack-config --set /etc/nova/nova.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/nova/nova.conf DEFAULT rabbit_port 5672
    </pre?

    Glance:
    <pre style="white-space: pre; overflow-x: auto; word-wrap: normal">
    openstack-config --set /etc/glance/glance-api.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/glance/glance-api.conf DEFAULT rabbit_port 5672

Cinder:

    openstack-config --set /etc/cinder/cinder.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/cinder/cinder.conf DEFAULT rabbit_port 5672

Ceilometer:

    openstack-config --set /etc/ceilometer/ceilometer.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/ceilometer/ceilometer.conf DEFAULT rabbit_port 5672

With the RabbitMQ broker running listening on port 5672 at host 10.15.85.141, the last step is to start all of the OpenStack services.

    % openstack-service start

If the OpenStack services are properly configured and using RabbitMQ, several queues should exist. Use the rabbitmqctl utility to get a list of queues.

    # rabbitmqctl list_queues name
    Listing queues ...
    ceilometer.agent.central
    ceilometer.agent.central.node-01
    ceilometer.agent.central_fanout_691f5ec697b44ac59f1d6502b1416098
    ceilometer.agent.compute
    ceilometer.agent.compute.node-01
    ceilometer.agent.compute_fanout_7b9dc502d91448928eb2e9cf8484a002
    ceilometer.alarm
    ceilometer.alarm.alarm_notifier
    ceilometer.alarm.node-01
    ceilometer.alarm_fanout_3ecad8cb2fd74faf875ec806a76d8d3c
    ceilometer.collector
    ceilometer.collector.node-01
    ceilometer.collector.metering
    ceilometer.collector_fanout_0d82ff676f554feca7ba0094eeac37d9
    ceilometer.collector_fanout_aac2e75d971348eabdbd620004a8304d
    cert
    cert.node-01
    cert_fanout_ae8623777cfb4a8cb7d5caca4613d230
    cinder-backup
    cinder-backup:node-01
    cinder-backup_fanout_9a9350ea037c43609044fe764a725825
    cinder-scheduler
    cinder-scheduler:node-01
    cinder-scheduler_fanout_3431689e0f13454eb256cacfaf486b1f
    cinder-volume
    cinder-volume:node-01
    cinder-volume_fanout_1f3b5f700c9b49aeb89e63e4028f7355
    compute
    compute.node-01
    compute_fanout_da934d2e469c423780134c7dede23cf2
    conductor
    conductor.node-01
    conductor_fanout_a83b91a499a74a49a53430d1c457d311
    consoleauth
    consoleauth.node-01
    consoleauth_fanout_0e7ad3a49caa45ed8a11e4ae966f33f0
    dhcp_agent
    dhcp_agent.node-01
    dhcp_agent_fanout_0f8e1a1e15df46f4907a763efc01da9a
    dhcp_agent_fanout_26792e5100c84c5c83fd9d38270ca008
    glance_notifications.info
    l3_agent
    l3_agent.node-01
    l3_agent_fanout_2c9aee1c6ed7436fad08394e7892e862
    notifications.error
    notifications.info
    notifications.warn
    q-agent-notifier-network-delete_fanout_bbda4ea39b3d429bbdb775098b5a5d1c
    q-agent-notifier-network-delete_fanout_cc1956e54fe7426791223654b64d607a
    q-agent-notifier-network-delete_fanout_d45046ba0d1c4fc29258cc7a2dfea55e
    q-agent-notifier-port-update_fanout_4f99b23047ad46c8bcd29be4bbe73088
    q-agent-notifier-port-update_fanout_5de0f2fff1214b5db7734a1ac1834914
    q-agent-notifier-port-update_fanout_b24021a711674ea29a30fd441296bca0
    q-l3-plugin
    q-plugin
    reply_01cf9c9a5aff45dd99bd445d1c7c0548
    reply_08726de3da75449eb7122d57c2e65f21
    reply_69371f8be5b24a78a48d60251f991657
    reply_82f2a6704e2c48a4a73f6b9721f11b1e
    reply_884d5a9bc92644c79cb8e9d65ca49483
    reply_9dfc307e1984498888cb1b54cb4b5a3e
    reply_f5477d2019ca4dc2ad79f782f0c48199
    scheduler
    scheduler.node-01
    scheduler_fanout_e774adbbfb784b6c8edff8d9e579b2e0
    ...done.

### High Availability

To setup RabbitMQ for high availability, create a cluster of RabbitMQ brokers and enable mirrored queues. The example given here will use three RabbitMQ brokers in a single cluster. The RabbitMQ service will run on the OpenStack node (10.15.85.141) as well as two additional nodes (10.15.85.142 and 10.15.85.143). These nodes will form the RabbitMQ cluster.

Note: The example given here is not a complete solution for high availability. This example is is only intended to show how to configure RabbitMQ such that it is not a single point of failure.

First, stop all of the OpenStack services on node-01.

    % openstack-service stop

Install the RabbitMQ service on the additional RabbitMQ brokers (node-02 and node-03).

    % yum install rabbitmq-server

Before starting the RabbitMQ service on the two additional nodes, copy the erlang cookie from first node to the two additional RabbitMQ brokers. This cookie must be equivalent on each node in the RabbitMQ cluster.

    % scp /var/lib/rabbitmq/.erlang.cookie root@node-02:/var/lib/rabbitmq/.erlang.cookie
    % scp /var/lib/rabbitmq/.erlang.cookie root@node-03:/var/lib/rabbitmq/.erlang.cookie

Make sure that this cookie is owned by user 'rabbitmq', group 'rabbitmq' and has mode 400 on both node.

    % chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
    % chmod 400 /var/lib/rabbitmq/.erlang.cookie

Now enable and start the RabbitMQ service on node-02 and node-03.

    % chkconfig rabbitmq-server on
    % service rabbitmq-server start

At this point there are three independent RabbitMQ brokers. The next step is to form a cluster and enable mirrored queues. To create the cluster, login to each of the additional RabbitMQ nodes and instruct them to join the first node to form a cluster.

On node-02:

    # rabbitmqctl stop_app
    Stopping node 'rabbit@node-02' ...
    ...done.

    # rabbitmqctl join_cluster rabbit@node-01
    Clustering node 'rabbit@node-02' with 'rabbit@node-01' ...
    ...done.

    # rabbitmqctl start_app
    Starting node 'rabbit@node-02' ...
    ...done.

On node-03:

    # rabbitmqctl stop_app
    Stopping node 'rabbit@node-03' ...
    ...done.

    # rabbitmqctl join_cluster rabbit@node-01
    Clustering node 'rabbit@node-03' with 'rabbit@node-01' ...
    ...done.

    # rabbitmqctl start_app
    Starting node 'rabbit@node-03' ...
    ...done.

At this point there should be a three node RabbitMQ cluster. The status of the cluster can be obtained from any of the three members.

    Cluster status of node 'rabbit@node-01' ...
    [{nodes,[{disc,['rabbit@node-01','rabbit@node-02',
            'rabbit@node-03']}]},
     {running_nodes,['rabbit@node-03','rabbit@node-02',
                     'rabbit@node-01']},
     {partitions,[]}]
    ...done.

The final step for setting up the cluster is to create a policy that instructs RabbitMQ to use mirrored queues. In normal operation, queues are not mirrored across cluster nodes. Enabling mirrored queues allows producers and consumers to connect to any of the RabbitMQ brokers and access the same message queues.

    % rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'

Finally, since the message queues are accessible via any of the three RabbitMQ brokers, setup a load balancer for RabbitMQ. The example below show how to configure HAProxy on the OpenStack node (node-01) to serve as a load balancer for RabbitMQ.

Install haproxy on node-01.

    % yum install haproxy

Edit /etc/haproxy/haproxy.cfg and create a simple TCP proxy for RabbitMQ.

    global
        daemon

    defaults
        mode tcp
        maxconn 10000
        timeout connect 5s
        timeout client 100s
        timeout server 100s

    listen rabbitmq 10.15.85.141:5670
        mode tcp
        balance roundrobin
        server node-01 10.15.85.141:5672 check inter 5s rise 2 fall 3
        server node-02 10.15.85.142:5672 check inter 5s rise 2 fall 3
        server node-03 10.15.85.143:5672 check inter 5s rise 2 fall 3

The example shown above creates a TCP proxy listening on port 5670 of the OpenStack node (node-01) with IP address 10.15.85.141.. The OpenStack node is also a RabbitMQ broker, so it is also listed as a backend server along with the other two brokers. Connections to this proxy will be distributed in a round-robin manner to the three RabbitMQ brokers, each which is listening on port 5672. Note that the client and server timeouts are set relatively high (100 seconds). This prevents haproxy from closing idle connections too aggressively.

Note: The proxy create for RabbitMQ could have just as easily been created to listen on a virtual IP address. As long as HAProxy can bind to the address/port and the OpenStack services are configured with the correct address/port, the RabbitMQ proxy will work as intended.

Start haproxy on the OpenStack node.

    % service haproxy start

With haproxy serving as a proxy for RabbitMQ, configure each OpenStack service to use address 10.15.85.141, port 5670 for RabbitMQ. The 'rabbit_host' and 'rabbit_port' should match the address and port of the RabbitMQ proxy.

Neutron:

    openstack-config --set /etc/neutron/neutron.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/neutron/neutron.conf DEFAULT rabbit_port 5670

Nova:

    openstack-config --set /etc/nova/nova.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/nova/nova.conf DEFAULT rabbit_port 5670

Glance:

    openstack-config --set /etc/glance/glance-api.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/glance/glance-api.conf DEFAULT rabbit_port 5670

Cinder:

    openstack-config --set /etc/cinder/cinder.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/cinder/cinder.conf DEFAULT rabbit_port 5670

Ceilometer:

    openstack-config --set /etc/ceilometer/ceilometer.conf DEFAULT rabbit_host 10.15.85.141
    openstack-config --set /etc/ceilometer/ceilometer.conf DEFAULT rabbit_port 5670

Finally, define the RabbitMQ cluster nodes in the configuration file such that the node will join the cluster on restart. Edit /etc/rabbitmq/rabbitmq.config on each of the RabbitMQ cluster ndoes.

    [{rabbit,
      [{cluster_nodes, {['rabbit@node-01', 'rabbit@node-02', 'rabbit@node-03'], ram}}]}].

</pre>
