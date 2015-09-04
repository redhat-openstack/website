---
title: Setting-up-HA-of-RabbitMQ
authors: kashyap
wiki_title: Setting-up-HA-of-RabbitMQ
wiki_revision_count: 1
wiki_last_updated: 2014-04-28
---

## Setting up HA of RabbitMQ

This document outlines setting up HA of RabbitMQ on four nodes (rdo-rabbitmq1|rdo-rabbitmq2|rdo-rabbitmq3|rdo-rabbitmq4):

These notes are based on this [reference](http://openstack.redhat.com/RabbitMQ).

Setup EPEL repositories:

    cat &gt; /etc/yum.repos.d/epel6.repo &lt;&lt; EOF
    [epel]
    name=Extra Packages for Enterprise Linux 6 - $basearch
    mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&amp;arch=$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0
    EOF

Install RabbitMQ server:

    yum clean all
    yum -y update
    yum -y install rabbitmq-server

    service rabbitmq-server start &amp;&amp; service rabbitmq-server stop

    chkconfig rabbitmq-server off

On the first node of RabbitMQ (rdo-rabbitmq1):

    cp /var/lib/rabbitmq/.erlang.cookie /srv/rhos/configs/rabbitmq_erlang_cookie

On rest of the RabbitMQ nodes (rdo-rabbitmq2|rdo-rabbitmq3|rdo-rabbitmq4):

    cat /srv/rhos/configs/rabbitmq_erlang_cookie &gt; /var/lib/rabbitmq/.erlang.cookie

Enable and configure `pacemaker` on all the four nodes of RabbitMQ (rdo-rabbitmq1|rdo-rabbitmq2|rdo-rabbitmq3|rdo-rabbitmq4):

    chkconfig pacemaker on
    pcs cluster setup --name rdo-rabbitmq rdo-rabbitmq1 rdo-rabbitmq2 rdo-rabbitmq3 rdo-rabbitmq4
    pcs cluster start

    sleep 30

    pcs stonith create rabbitmq1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo-rabbitmq1

    pcs stonith create rabbitmq2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo-rabbitmq2

    pcs stonith create rabbitmq3-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo-rabbitmq3

    pcs stonith create rabbitmq4-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo-rabbitmq4

    pcs resource create rabbitmq-server lsb:rabbitmq-server --clone

    rdo-rabbitmq2|rdo-rabbitmq3|rdo-rabbitmq4

All 3 RabbitMQ nodes must be stopped first:

    rabbitmqctl stop_app

Make them join *one* at a time:

    rabbitmqctl join_cluster rabbit@rdo-rabbitmq1

Start *one* at a time, only after they are part of the rabbitmq cluster:

    rabbitmqctl start_app

On the first node of RabbitMQ (rdo-rabbitmq1):

    rabbitmqctl set_policy HA '^(?!amq\.).*' '{&quot;ha-mode&quot;: &quot;all&quot;}'

Do a simple test on all four nodes of RabbitMQ (rdo-rabbitmq1|rdo-rabbitmq2|rdo-rabbitmq3|rdo-rabbitmq4):

    rabbitmqctl cluster_status
    rabbitmqctl list_policies
