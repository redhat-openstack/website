---
title: Setting-up-HAProxy-Load-Balancer
authors: kashyap
wiki_title: Setting-up-HAProxy-Load-Balancer
wiki_revision_count: 2
wiki_last_updated: 2014-04-23
---

## Setting up HAProxy load balancer

This document outlines configuration details for setting up HAProxy load balancer:

On both nodes of the load balancer, first, install the relevant packages (rdo-lb1|rdo-lb2):

    yum install -y haproxy

Enable binding to a non-local address (for transparent proxying):

    echo net.ipv4.ip_nonlocal_bind=1 &gt;&gt; /etc/sysctl.conf
    echo 1 &gt; /proc/sys/net/ipv4/ip_nonlocal_bind

Setup `haproxy.cfg`:

    cat &gt; /etc/haproxy/haproxy.cfg &lt;&lt; EOF
    global
        daemon
    defaults
        mode tcp
        maxconn 10000
        timeout connect 2s
        timeout client 10s
        timeout server 10s
    frontend vip-mysql
        bind 192.168.16.200:3306
        timeout client 90s
        default_backend mysql-vms
    backend mysql-vms
        balance roundrobin
        timeout server 90s
        server rdo-mysql1 192.168.16.13:3306 check inter 1s
        server rdo-mysql2 192.168.16.14:3306 check inter 1s
    frontend vip-qpid
        bind 192.168.16.201:5672
        default_backend qpid-vms
    backend qpid-vms
    # comment stick-table out
    # and add balance roundrobin for A/A cluster mode in qpid
        stick-table type ip size 2
        stick on dst
        server rdo-qpid1 192.168.16.15:5672 check inter 1s
        server rdo-qpid2 192.168.16.16:5672 check inter 1s
    frontend vip-keystone-admin
        bind 192.168.16.202:35357
        default_backend keystone-admin-vms
    backend keystone-admin-vms
        balance roundrobin
        server rdo-keystone1 192.168.16.17:35357 check inter 1s
        server rdo-keystone2 192.168.16.18:35357 check inter 1s
    frontend vip-keystone-public
        bind 192.168.16.202:5000
        default_backend keystone-public-vms
    backend keystone-public-vms
        balance roundrobin
        server rdo-keystone1 192.168.16.17:5000 check inter 1s
        server rdo-keystone2 192.168.16.18:5000 check inter 1s
    # skip 2 ip for memcached
    frontend vip-glance-api
        bind 192.168.16.203:9191
        default_backend glance-api-vms
    backend glance-api-vms
        balance roundrobin
        server rdo-glance1 192.168.16.21:9191 check inter 1s
        server rdo-glance2 192.168.16.22:9191 check inter 1s
    frontend vip-glance-registry
        bind 192.168.16.203:9292
        default_backend glance-registry-vms
    backend glance-registry-vms
        balance roundrobin
        server rdo-glance1 192.168.16.21:9292 check inter 1s
        server rdo-glance2 192.168.16.22:9292 check inter 1s
    frontend vip-cinder
        bind 192.168.16.204:8776
        default_backend cinder-vms
    backend cinder-vms
        balance roundrobin
        server rdo-cinder1 192.168.16.23:8776 check inter 1s
        server rdo-cinder2 192.168.16.24:8776 check inter 1s
    frontend vip-swift
        bind 192.168.16.205:8080
        default_backend swift-vms
    backend swift-vms
        balance roundrobin
        server rdo-swift1 192.168.16.25:8080 check inter 1s
        server rdo-swift2 192.168.16.26:8080 check inter 1s
    # skip 2 ip for swift containers (no LB)
    frontend vip-neutron
        bind 192.168.16.206:9696
        default_backend neutron-vms
    backend neutron-vms
        balance roundrobin
        server rdo-neutron1 192.168.16.29:9696 check inter 1s
        server rdo-neutron2 192.168.16.30:9696 check inter 1s
    # skip 2 for neutron network nodes
    frontend vip-nova-vnc-novncproxy
        bind 192.168.16.207:6080
        default_backend nova-vnc-novncproxy-vms
    backend nova-vnc-novncproxy-vms
        balance roundrobin
        server rdo-nova1 192.168.16.33:6080 check inter 1s
        server rdo-nova2 192.168.16.34:6080 check inter 1s
    frontend vip-nova-vnc-xvpvncproxy
        bind 192.168.16.207:6081
        default_backend nova-vnc-xvpvncproxy-vms
    backend nova-vnc-xvpvncproxy-vms
        balance roundrobin
        server rdo-nova1 192.168.16.33:6081 check inter 1s
        server rdo-nova2 192.168.16.34:6081 check inter 1s
    frontend vip-nova-metadata
        bind 192.168.16.207:8775
        default_backend nova-metadata-vms
    backend nova-metadata-vms
        balance roundrobin
        server rdo-nova1 192.168.16.33:8775 check inter 1s
        server rdo-nova2 192.168.16.34:8775 check inter 1s
    frontend vip-nova-api
        bind 192.168.16.207:8774
        default_backend nova-api-vms
    backend nova-api-vms
        balance roundrobin
        server rdo-nova1 192.168.16.33:8774 check inter 1s
        server rdo-nova2 192.168.16.34:8774 check inter 1s
    frontend vip-horizon
        bind 192.168.16.208:80
        default_backend horizon-vms
    backend horizon-vms
        balance roundrobin
        server rdo-horizon1 192.168.16.35:80 check inter 1s
        server rdo-horizon2 192.168.16.36:80 check inter 1s
    frontend vip-heat-cfn
        bind 192.168.16.209:8000
        default_backend heat-cfn-vms
    backend heat-cfn-vms
        balance roundrobin
        server rdo-heat1 192.168.16.37:8000 check inter 1s
        server rdo-heat2 192.168.16.38:8000 check inter 1s
    frontend vip-heat-cloudw
        bind 192.168.16.209:8003
        default_backend heat-cloudw-vms
    backend heat-cloudw-vms
        balance roundrobin
        server rdo-heat1 192.168.16.37:8003 check inter 1s
        server rdo-heat2 192.168.16.38:8003 check inter 1s
    frontend vip-heat-srv
        bind 192.168.16.209:8004
        default_backend heat-srv-vms
    backend heat-srv-vms
        balance roundrobin
        server rdo-heat1 192.168.16.37:8004 check inter 1s
        server rdo-heat2 192.168.16.38:8004 check inter 1s
    frontend vip-mongo
        bind 192.168.16.210:27017
        default_backend mongo-vms
    backend mongo-vms
        balance roundrobin
        server rdo-mongodb1 192.168.16.39:27017 check inter 1s
        server rdo-mongodb2 192.168.16.40:27017 check inter 1s
        server rdo-mongodb3 192.168.16.41:27017 check inter 1s
        server rdo-mongodb4 192.168.16.42:27017 check inter 1s
    # CEILOMETER TIMEOUTS OF DEATH!!!
    frontend vip-ceilometer
        bind 192.168.16.211:8777
        timeout client 90s
        default_backend ceilometer-vms
    backend ceilometer-vms
        balance roundrobin
        timeout server 90s
        server rdo-ceilometer1 192.168.16.43:8777 check inter 1s
        server rdo-ceilometer2 192.168.16.44:8777 check inter 1s
    # add nagios here
    frontend vip-rabbitmq
        bind 192.168.16.213:5672
        timeout client 90s
        default_backend rabbitmq-vms
    backend rabbitmq-vms
        balance roundrobin
        timeout server 90s
        server rdo-rabbitmq1 192.168.16.49:5672 check inter 1s
        server rdo-rabbitmq2 192.168.16.50:5672 check inter 1s
        server rdo-rabbitmq3 192.168.16.51:5672 check inter 1s
        server rdo-rabbitmq4 192.168.16.52:5672 check inter 1s
    EOF

Configure `pacemaker` (Note: that fence xvm is specifically for VMs, not for baremetal)::

    chkconfig pacemaker on
    pcs cluster setup --name rdo-lb rdo-lb1 rdo-lb2
    pcs cluster start

    sleep 30

    pcs stonith create lb1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo-lb1
    pcs stonith create lb2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo-lb2

    pcs resource create lb-haproxy lsb:haproxy --clone

    pcs resource create vip-mysql IPaddr2 ip=192.168.16.200
    pcs resource create vip-qpid IPaddr2 ip=192.168.16.201
    pcs resource create vip-keystone IPaddr2 ip=192.168.16.202
    pcs resource create vip-glance IPaddr2 ip=192.168.16.203
    pcs resource create vip-cinder IPaddr2 ip=192.168.16.204
    pcs resource create vip-swift IPaddr2 ip=192.168.16.205
    pcs resource create vip-neutron IPaddr2 ip=192.168.16.206
    pcs resource create vip-nova IPaddr2 ip=192.168.16.207
    pcs resource create vip-horizon IPaddr2 ip=192.168.16.208
    pcs resource create vip-heat IPaddr2 ip=192.168.16.209
    pcs resource create vip-mongo IPaddr2 ip=192.168.16.210
    pcs resource create vip-ceilometer IPaddr2 ip=192.168.16.211
    pcs resource create vip-nagios IPaddr2 ip=192.168.16.212
    pcs resource create vip-rabbitmq IPaddr2 ip=192.168.16.213
