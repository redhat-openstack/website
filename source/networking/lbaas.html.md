---
title: LBaaS
authors: rohara
wiki_title: LBaaS
wiki_revision_count: 7
wiki_last_updated: 2014-02-20
---

# L Baa S

{:.no_toc}

## Configuring and Deploying LBaaS in OpenStack

This document was written for the Havana release so may well be out of date. Please help out!

The Neutron LBaaS (load-balancer-as-a-service) extension provides a means to load balance traffic for services running on virtual machines in the cloud. The LBaaS API provides an API to quickly and easily deploy a load balancer. This guide will show how to configure and deploy a load balancer using the LBaaS API with RDO.

### Prerequisites

In this guide, haproxy will be used as the load balancer. Be sure that you either have haproxy installed or have access to a yum repository that provides the haproxy package.

To avoid issues with networking, it is best to provide a static IP address and disabling NetworkManager

    # systemctl disable NetworkManager
    # systemctl enable network
    # systemctl stop NetworkManager.service
    # systemctl start network.service


### Installation

The Neutron LBaaS extension can be enabled and configured by packstack at install time. To do so, use the `--os-neutron-lbaas-install` option to indicate you want to install the LBaaS agent:

    # packstack --allinone --os-neutron-lbaas-install=y

In the above example, packstack will do an all-in-one install on the local host. In the future it may be possible to have packstack install and configure the LBaaS agent on multiple hosts.


### Deploy

After the install the LBaaS plugin is configured and the LBaaS agent is running, the next step is to boot the virtual machines and deploy a load balancer. In the example shown here, the "demo" tenant, which is provisioned by packstack, will be used.

This example also makes use of a custom image that has the httpd service enabled. This is the service that will be load-balanced. In addition, the image was built such that the virtual machine's host name is retrieved from the metadata service and placed in /var/www/html/index.html. This is done by using a simple curl command in rc.local:

    curl -s -o /var/www/html/index.html http://169.254.169.254/latest/meta-data/hostname

This is useful to show the load balancer working later in the example.

First, use the demo tenant:

    # source keystonerc_demo

Import the custom image that has httpd enabled and a modified rc.local script:

    # openstack image create --name rhel-http --public true --disk-format qcow2 --container-format bare --file rhel.qcow2

Check that the image was imported:

    # openstack image list
    +--------------------------------------+-----------+-------------+------------------+------------+--------+
    | ID                                   | Name      | Disk Format | Container Format | Size       | Status |
    +--------------------------------------+-----------+-------------+------------------+------------+--------+
    | 74f1b121-1531-4c48-b528-bdb22d327359 | cirros    | qcow2       | bare             | 13147648   | active |
    | 5d6bd846-e044-4a8f-99f0-5ca1d006f8ef | rhel-http | qcow2       | bare             | 1690042368 | active |
    +--------------------------------------+-----------+-------------+------------------+------------+--------+

Next, create a keypair to use when we boot the image:

    #  openstack keypair create --public-key ~/.ssh/rdo_key.pub rdo_key
+-------------+-------------------------------------------------+
| Field       | Value                                           |
+-------------+-------------------------------------------------+
| fingerprint | 4e:89:51:ff:90:9b:f8:2c:01:27:c2:7c:ac:8d:36:98 |
| name        | rdo_key                                         |
| user_id     | b32cd586eb3b4bfe925913a6b51da7f1                |
+-------------+-------------------------------------------------+

Create the virtual machines by booting the custom image. Each of the resulting instances will be running the httpd service, which we can then load balance. This example will use three httpd servers.

    # openstack server create rhel-01 --flavor 2 --image rhel-http --key-name rdo_key
    # openstack server create rhel-02 --flavor 2 --image rhel-http --key-name rdo_key
    # openstack server create rhel-03 --flavor 2 --image rhel-http --key-name rdo_key

Once the virtual machines are up and running, check that each is active and has an IP address on the private network.

    # nova list
    +--------------------------------------+---------+--------+------------+-------------+------------------+
    | ID                                   | Name    | Status | Task State | Power State | Networks         |
    +--------------------------------------+---------+--------+------------+-------------+------------------+
    | 1fffa4ec-2bd6-426d-89b0-ead561545de7 | rhel-01 | ACTIVE | None       | Running     | private=10.0.0.3 |
    | ae1f4f60-18c1-4001-8a55-7b7036ca6b3c | rhel-02 | ACTIVE | None       | Running     | private=10.0.0.4 |
    | 429be6ec-a069-4dcd-bfca-33cd42606d39 | rhel-03 | ACTIVE | None       | Running     | private=10.0.0.5 |
    +--------------------------------------+---------+--------+------------+-------------+------------------+

Before creating a load balancer, optionally test that each server is running the httpd service by creating three floating IP addresses and associating them with the virtual machines. Then, use a simple curl or wget command to send an HTTP request to each virtual machine. The HTTP response should be the virtual machine's host name. This step is not required since the servers will be accessible via the load balancer later on in our example.

Check to see what networks are available:

    # openstack network list
    +--------------------------------------+---------+--------------------------------------+
    | ID                                   | Name    | Subnets                              |
    +--------------------------------------+---------+--------------------------------------+
    | 63d4d6bf-24e6-4063-9f92-402d78ce3fc2 | private | 3b4be857-7705-4e47-80a2-5f15beb675c2 |
    | f33a8dc9-cee6-48c2-9f7d-6fef8bead932 | public  | 64377ee4-cb4d-4e91-98bd-c7f1aa4b2484 |
    +--------------------------------------+---------+--------------------------------------+

Create three floating IP addresses on the 'public' network by running the following command three times:

    # openstack floating ip create public

Check to see which floating IP addresses were created:

    # openstack floating ip list
    +--------------------------------------+---------------------+------------------+------+
    | ID                                   | Floating IP Address | Fixed IP Address | Port |
    +--------------------------------------+---------------------+------------------+------+
    | 01707a5a-d049-463a-9358-5f98d1c31e5e | 172.24.4.227        | None             | None |
    | eb6003f5-d50f-4cf3-9115-bdd0343f8571 | 172.24.4.228        | None             | None |
    | f9a20cdb-d31d-4f81-9a91-164a34d94443 | 172.24.4.229        | None             | None |
    +--------------------------------------+---------------------+------------------+------+

Now associate a floating IP address with each instance.

    # openstack server add floating ip rhel-01 172.24.4.227
    # openstack server add floating ip rhel-02 172.24.4.228
    # openstack server add floating ip rhel-03 172.24.4.229

Verify that the floating IP addresses were correctly associated with each virtual machine.

    # openstack floating ip list
    +--------------------------------------+---------------------+------------------+--------------------------------------+
    | ID                                   | Floating IP Address | Fixed IP Address | Port                                 |
    +--------------------------------------+---------------------+------------------+--------------------------------------+
    | 01707a5a-d049-463a-9358-5f98d1c31e5e | 172.24.4.227        | 10.0.0.7         | 8a6782e5-dbad-4b7d-86f2-7c5ac5c832a6 |
    | eb6003f5-d50f-4cf3-9115-bdd0343f8571 | 172.24.4.228        | 10.0.0.12        | 820c4722-4459-46d8-a799-2360c56d21bf |
    | f9a20cdb-d31d-4f81-9a91-164a34d94443 | 172.24.4.229        | 10.0.0.6         | e155ddb5-fbb8-408a-93c5-6dc02142a457 |
    +--------------------------------------+---------------------+------------------+--------------------------------------+

Before sending HTTP requests to each virtual machine, add a security group rule that will allow TCP traffic on port 80 to be passed to the virtual machines.

    # openstack security group rule create default --protocol tcp --dst-port 80:80 --src-ip 0.0.0.0/0

Use curl to send an HTTP request to each instance. Since each instance has its hostname in /var/www/html/index.html, each HTTP response should simply contain the hostname.

    # curl -w "\n" 172.24.4.227
    rhel-01

    # curl -w "\n" 172.24.4.228
    rhel-02

    # curl -w "\n" 172.24.4.229
    rhel-03

These results confirm that each virtual machine will respond to a simple HTTP request with its hostname. This will be useful later in the example when HTTP requests are sent via the load balancer.

The floating IP addresses that were associated with each virtual machine are no longer needed, so it is safe is disassociate them.


    # openstack floating ip list
    +--------------------------------------+---------------------+------------------+--------------------------------------+
    | ID                                   | Floating IP Address | Fixed IP Address | Port                                 |
    +--------------------------------------+---------------------+------------------+--------------------------------------+
    | 01707a5a-d049-463a-9358-5f98d1c31e5e | 172.24.4.227        | 10.0.0.7         | 8a6782e5-dbad-4b7d-86f2-7c5ac5c832a6 |
    | eb6003f5-d50f-4cf3-9115-bdd0343f8571 | 172.24.4.228        | 10.0.0.12        | 820c4722-4459-46d8-a799-2360c56d21bf |
    | f9a20cdb-d31d-4f81-9a91-164a34d94443 | 172.24.4.229        | 10.0.0.6         | e155ddb5-fbb8-408a-93c5-6dc02142a457 |
    +--------------------------------------+---------------------+------------------+--------------------------------------+

    # openstack server remove floating ip rhel-01 172.24.4.227
    # openstack server remove floating ip rhel-02 172.24.4.228
    # openstack server remove floating ip rhel-03 172.24.4.229

Confirm that the floating IP addresses still exist but are no longer associated with the virtual machines.

    # openstack floating ip list
    +--------------------------------------+---------------------+------------------+------+
    | ID                                   | Floating IP Address | Fixed IP Address | Port |
    +--------------------------------------+---------------------+------------------+------+
    | 01707a5a-d049-463a-9358-5f98d1c31e5e | 172.24.4.227        | None             | None |
    | eb6003f5-d50f-4cf3-9115-bdd0343f8571 | 172.24.4.228        | None             | None |
    | f9a20cdb-d31d-4f81-9a91-164a34d94443 | 172.24.4.229        | None             | None |
    +--------------------------------------+---------------------+------------------+------+

### Create the load balancer

The first step when creating a load balancer is to create a pool. A pool is a group of virtual machines, known as members, that will provide the actual service. In this example there will be three members, each capable of providing the httpd service. In addition, the pool also defines the protocol, the load balancing algorithm, and the subnet with which to associate the load balancer. Note that the subnet must be the same as the subnet of the members that belong to the pool.

First, get the subnet ID from neutron.

    # openstack subnet list
    +--------------------------------------+----------------+-------------+--------------------------------------------+
    | id                                   | name           | cidr        | allocation_pools                           |
    +--------------------------------------+----------------+-------------+--------------------------------------------+
    | a4f17073-298e-4d92-8c19-8f3333145fd0 | private_subnet | 10.0.0.0/24 | {"start": "10.0.0.2", "end": "10.0.0.254"} |
    +--------------------------------------+----------------+-------------+--------------------------------------------+

Next, create the pool.

    # neutron lbaas-pool-create --name http-pool --lb-method ROUND_ROBIN --protocol HTTP --subnet-id a4f17073-298e-4d92-8c19-8f3333145fd0
    Created a new pool:
    +------------------------+--------------------------------------+
    | Field                  | Value                                |
    +------------------------+--------------------------------------+
    | admin_state_up         | True                                 |
    | description            |                                      |
    | health_monitors        |                                      |
    | health_monitors_status |                                      |
    | id                     | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | lb_method              | ROUND_ROBIN                          |
    | members                |                                      |
    | name                   | http-pool                            |
    | protocol               | HTTP                                 |
    | provider               | haproxy                              |
    | status                 | PENDING_CREATE                       |
    | status_description     |                                      |
    | subnet_id              | a4f17073-298e-4d92-8c19-8f3333145fd0 |
    | tenant_id              | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    | vip_id                 |                                      |
    +------------------------+--------------------------------------+

The example above creates a pool named "http-pool", which uses the HTTP protocol and a round-robin load balancing algorithm. This pool is associated with the private subnet. The lb-pool-list and lb-pool-show commands may be used to get information about existing pools.

    # neutron lbaas-pool-list
    +--------------------------------------+-----------+----------+-------------+----------+----------------+----------------+
    | id                                   | name      | provider | lb_method   | protocol | admin_state_up | status         |
    +--------------------------------------+-----------+----------+-------------+----------+----------------+----------------+
    | 01745519-f910-4393-b237-a24a4f9c2a7d | http-pool | haproxy  | ROUND_ROBIN | HTTP     | True           | PENDING_CREATE |
    +--------------------------------------+-----------+----------+-------------+----------+----------------+----------------+

    # neutron lbaas-pool-show http-pool
    +------------------------+--------------------------------------+
    | Field                  | Value                                |
    +------------------------+--------------------------------------+
    | admin_state_up         | True                                 |
    | description            |                                      |
    | health_monitors        |                                      |
    | health_monitors_status |                                      |
    | id                     | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | lb_method              | ROUND_ROBIN                          |
    | members                |                                      |
    | name                   | http-pool                            |
    | protocol               | HTTP                                 |
    | provider               | haproxy                              |
    | status                 | PENDING_CREATE                       |
    | status_description     |                                      |
    | subnet_id              | a4f17073-298e-4d92-8c19-8f3333145fd0 |
    | tenant_id              | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    | vip_id                 |                                      |
    +------------------------+--------------------------------------+

The next step is to create members and add them to the pool. A member is nothing more than the IP address and port of a virtual machine that can provide the service being load-balanced. In this example there are three virtual machines listening on port 80. Create a member for each of these servers and add them to the pool.

    # neutron lbaas-member-create --address 10.0.0.3 --protocol-port 80 http-pool
    # neutron lbaas-member-create --address 10.0.0.4 --protocol-port 80 http-pool
    # neutron lbaas-member-create --address 10.0.0.5 --protocol-port 80 http-pool

The lb-member-list and lb-member-show commands may be used to get information about existing members.

    # neutron lb-member-list --sort-key address --sort-dir asc
    +--------------------------------------+----------+---------------+----------------+----------------+
    | id                                   | address  | protocol_port | admin_state_up | status         |
    +--------------------------------------+----------+---------------+----------------+----------------+
    | 5750769c-3131-41bd-b0f1-be6c41aa15c9 | 10.0.0.3 |            80 | True           | PENDING_CREATE |
    | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 | 10.0.0.4 |            80 | True           | PENDING_CREATE |
    | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 | 10.0.0.5 |            80 | True           | PENDING_CREATE |
    +--------------------------------------+----------+---------------+----------------+----------------+

    # neutron lbaas-member-show 5750769c-3131-41bd-b0f1-be6c41aa15c9
    +--------------------+--------------------------------------+
    | Field              | Value                                |
    +--------------------+--------------------------------------+
    | address            | 10.0.0.3                             |
    | admin_state_up     | True                                 |
    | id                 | 5750769c-3131-41bd-b0f1-be6c41aa15c9 |
    | pool_id            | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | protocol_port      | 80                                   |
    | status             | ACTIVE                               |
    | status_description |                                      |
    | tenant_id          | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    | weight             | 1                                    |
    +--------------------+--------------------------------------+

Note that the member shown above has a pool ID that corresponds to the 'http-pool'. The lb-pool-show command may also be used to see the members of a given pool.

    # neutron lbaas-pool-show http-pool
    +------------------------+--------------------------------------+
    | Field                  | Value                                |
    +------------------------+--------------------------------------+
    | admin_state_up         | True                                 |
    | description            |                                      |
    | health_monitors        |                                      |
    | health_monitors_status |                                      |
    | id                     | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | lb_method              | ROUND_ROBIN                          |
    | members                | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 |
    |                        | 5750769c-3131-41bd-b0f1-be6c41aa15c9 |
    |                        | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 |
    | name                   | http-pool                            |
    | protocol               | HTTP                                 |
    | provider               | haproxy                              |
    | status                 | PENDING_CREATE                       |
    | status_description     |                                      |
    | subnet_id              | a4f17073-298e-4d92-8c19-8f3333145fd0 |
    | tenant_id              | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    | vip_id                 |                                      |
    +------------------------+--------------------------------------+

The next step is to create a health monitor and associate it with othe pool. The health monitor is responsible for periodically checking the health of each member of the pool.

    # neutron lbaas-healthmonitor-create --delay 5 --type HTTP --max-retries 3 --timeout 2
    Created a new health_monitor:
    +----------------+--------------------------------------+
    | Field          | Value                                |
    +----------------+--------------------------------------+
    | admin_state_up | True                                 |
    | delay          | 5                                    |
    | expected_codes | 200                                  |
    | http_method    | GET                                  |
    | id             | 1de041b8-37bd-4b9a-aac6-a4669110eb46 |
    | max_retries    | 3                                    |
    | pools          |                                      |
    | tenant_id      | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    | timeout        | 2                                    |
    | type           | HTTP                                 |
    | url_path       | /                                    |
    +----------------+--------------------------------------+

In this example, the health monitor will perform an HTTP GET of the "/" path. This health check expects an HTTP status of 200 in the response, and the connection must be established within 2 seconds. This check will be retried a maximum of 3 times before a member is determined to be failed.

At this point the health monitor has not yet been associated with a pool, so it is not actually performing any health checks. Associating the health monitor with the 'http-pool' will cause each of the members of the pool to be checked in the manner described above.

    # neutron lbaas-healthmonitor-associate 1de041b8-37bd-4b9a-aac6-a4669110eb46 http-pool

The lb-healthmonitor-list and lb-healthmonitor-show may be used to get information about existing health monitors.

    # neutron lb-healthmonitor-list
    +--------------------------------------+------+----------------+
    | id                                   | type | admin_state_up |
    +--------------------------------------+------+----------------+
    | 1de041b8-37bd-4b9a-aac6-a4669110eb46 | HTTP | True           |
    +--------------------------------------+------+----------------+

    # neutron lbaas-healthmonitor-show 1de041b8-37bd-4b9a-aac6-a4669110eb46
    +----------------+-------------------------------------------------------------------------------------------------------------+
    | Field          | Value                                                                                                       |
    +----------------+-------------------------------------------------------------------------------------------------------------+
    | admin_state_up | True                                                                                                        |
    | delay          | 5                                                                                                           |
    | expected_codes | 200                                                                                                         |
    | http_method    | GET                                                                                                         |
    | id             | 1de041b8-37bd-4b9a-aac6-a4669110eb46                                                                        |
    | max_retries    | 3                                                                                                           |
    | pools          | {"status": "PENDING_CREATE", "status_description": null, "pool_id": "01745519-f910-4393-b237-a24a4f9c2a7d"} |
    | tenant_id      | 47e1f8f3b8dc4ab2a5f931cdd502afae                                                                            |
    | timeout        | 2                                                                                                           |
    | type           | HTTP                                                                                                        |
    | url_path       | /                                                                                                           |
    +----------------+-------------------------------------------------------------------------------------------------------------+

The final step in creating the load balancer is to create the virtual IP address, or VIP. This will create a VIP for the load balancer on the private subnet and associate the virtual IP address with the pool. The VIP must be created on the same subnet as the pool, which in this example is the 'private' subnet. A floating IP address on the 'public' network can then be associated with the virtual IP address on the 'private_subnet' such that the load balancer will be externally accessible. First, create the VIP.

    # neutron lbaas-vip-create --name http-vip --protocol-port 80 --protocol HTTP --subnet-id a4f17073-298e-4d92-8c19-8f3333145fd0 http-pool
    Created a new vip:
    +--------------------+--------------------------------------+
    | Field              | Value                                |
    +--------------------+--------------------------------------+
    | address            | 10.0.0.6                             |
    | admin_state_up     | True                                 |
    | connection_limit   | -1                                   |
    | description        |                                      |
    | id                 | 72848e0a-bb58-406d-aa9b-dcb6ca93a69f |
    | name               | http-vip                             |
    | pool_id            | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | port_id            | d2319cc8-6bc7-4a04-b3a6-4906ecc5d6b3 |
    | protocol           | HTTP                                 |
    | protocol_port      | 80                                   |
    | status             | PENDING_CREATE                       |
    | status_description |                                      |
    | subnet_id          | a4f17073-298e-4d92-8c19-8f3333145fd0 |
    | tenant_id          | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    +--------------------+--------------------------------------+

The lb-vip-list and lb-vip-show commands may be used to get information about existing virtual IP addresses:

    # neutron lbaas-vip-list
    +--------------------------------------+----------+----------+----------+----------------+--------+
    | id                                   | name     | address  | protocol | admin_state_up | status |
    +--------------------------------------+----------+----------+----------+----------------+--------+
    | 72848e0a-bb58-406d-aa9b-dcb6ca93a69f | http-vip | 10.0.0.6 | HTTP     | True           | ACTIVE |
    +--------------------------------------+----------+----------+----------+----------------+--------+

    # neutron lbaas-vip-show 72848e0a-bb58-406d-aa9b-dcb6ca93a69f
    +--------------------+--------------------------------------+
    | Field              | Value                                |
    +--------------------+--------------------------------------+
    | address            | 10.0.0.6                             |
    | admin_state_up     | True                                 |
    | connection_limit   | -1                                   |
    | description        |                                      |
    | id                 | 72848e0a-bb58-406d-aa9b-dcb6ca93a69f |
    | name               | http-vip                             |
    | pool_id            | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | port_id            | d2319cc8-6bc7-4a04-b3a6-4906ecc5d6b3 |
    | protocol           | HTTP                                 |
    | protocol_port      | 80                                   |
    | status             | ACTIVE                               |
    | status_description |                                      |
    | subnet_id          | a4f17073-298e-4d92-8c19-8f3333145fd0 |
    | tenant_id          | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    +--------------------+--------------------------------------+

At this point the load-balancer has been successfully created and should be functional. Traffic sent to address 10.0.0.6 on port 80 will be load-balanced across all active members of our pool. To make the load balancer externally accessible, create a floating IP address and associate it with the virtual IP address.

    # openstack floating ip create public
    Created a new floatingip:
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | fixed_ip_address    |                                      |
    | floating_ip_address | 172.24.4.230                         |
    | floating_network_id | 3f006c95-f46e-4d93-87e5-4107cff5cd8f |
    | id                  | 6becaba6-b3fe-4e54-8bd6-f5d8364a363f |
    | port_id             |                                      |
    | router_id           |                                      |
    | tenant_id           | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    +---------------------+--------------------------------------+

    # neutron floatingip-associate 6becaba6-b3fe-4e54-8bd6-f5d8364a363f d2319cc8-6bc7-4a04-b3a6-4906ecc5d6b3

Use the floatingip-list command to see that the floating IP address (172.24.4.230) is associated with the virtual IP address (10.0.0.6).

    # openstack  floating ip list
    +--------------------------------------+------------------+---------------------+--------------------------------------+
    | id                                   | fixed_ip_address | floating_ip_address | port_id                              |
    +--------------------------------------+------------------+---------------------+--------------------------------------+
    | 5064e824-d4a2-4c8d-9c91-e8d864df0b94 |                  | 172.24.4.227        |                                      |
    | 85905522-6354-4728-a6fa-ff76a3e79e50 |                  | 172.24.4.228        |                                      |
    | 96943920-105e-4017-9393-873ef4607b5f |                  | 172.24.4.229        |                                      |
    | 6becaba6-b3fe-4e54-8bd6-f5d8364a363f | 10.0.0.6         | 172.24.4.230        | d2319cc8-6bc7-4a04-b3a6-4906ecc5d6b3 |
    +--------------------------------------+------------------+---------------------+--------------------------------------+

### Testing

Now that the load balancer is running and externally accessible, test that traffic is properly load-balanced and the health checker works correctly. First, check what members are active.

    # neutron lbaas-member-list --sort-key address --sort-dir asc
    +--------------------------------------+----------+---------------+----------------+--------+
    | id                                   | address  | protocol_port | admin_state_up | status |
    +--------------------------------------+----------+---------------+----------------+--------+
    | 5750769c-3131-41bd-b0f1-be6c41aa15c9 | 10.0.0.3 |            80 | True           | ACTIVE |
    | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 | 10.0.0.4 |            80 | True           | ACTIVE |
    | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 | 10.0.0.5 |            80 | True           | ACTIVE |
    +--------------------------------------+----------+---------------+----------------+--------+

Since this example has a single pool and all members are marked 'active', successive HTTP requests to the virtual IP address should be balanced round-robin across all three members. Recall that each virtual machine will respond to an HTTP request with its hostname.

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-03
    rhel-02
    rhel-01
    rhel-03
    rhel-02
    rhel-01

Next, mark one of the member's 'admin_state_up' flag to False. A member with 'admin_state_up' set to False should not be considered for load-balancing.

    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 --admin_state_up False
    Updated member: 5750769c-3131-41bd-b0f1-be6c41aa15c9

    # neutron lb-member-list --sort-key address --sort-dir asc
    +--------------------------------------+----------+---------------+----------------+--------+
    | id                                   | address  | protocol_port | admin_state_up | status |
    +--------------------------------------+----------+---------------+----------------+--------+
    | 5750769c-3131-41bd-b0f1-be6c41aa15c9 | 10.0.0.3 |            80 | False          | ACTIVE |
    | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 | 10.0.0.4 |            80 | True           | ACTIVE |
    | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 | 10.0.0.5 |            80 | True           | ACTIVE |
    +--------------------------------------+----------+---------------+----------------+--------+

The member with IP address 10.0.0.3 (rhel-01) should no longer receive traffic from the load balancer. Note that the virtual machine itself is still running. This is effectively the same as removing the member from the pool. Repeat the test that sends multiple HTTP requests to the load balancer.

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-02
    rhel-03
    rhel-02
    rhel-03
    rhel-02
    rhel-03

As expected, virtual machine 'rhel-01' is not considered for load-balancing. Set the admin_state_up flag back to True and rerun the test.

    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 --admin_state_up True
    Updated member: 5750769c-3131-41bd-b0f1-be6c41aa15c9

    # neutron lbaas-member-list --sort-key address --sort-dir asc
    +--------------------------------------+----------+---------------+----------------+--------+
    | id                                   | address  | protocol_port | admin_state_up | status |
    +--------------------------------------+----------+---------------+----------------+--------+
    | 5750769c-3131-41bd-b0f1-be6c41aa15c9 | 10.0.0.3 |            80 | True           | ACTIVE |
    | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 | 10.0.0.4 |            80 | True           | ACTIVE |
    | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 | 10.0.0.5 |            80 | True           | ACTIVE |
    +--------------------------------------+----------+---------------+----------------+--------+

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-03
    rhel-02
    rhel-01
    rhel-03
    rhel-02
    rhel-01

As expected, 'rhel-01' is again eligible to receive HTTP requests via the load balancer.

A member can also be disabled by setting its weight to 0.

    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 --weight 0
    Updated member: 5750769c-3131-41bd-b0f1-be6c41aa15c9

    # neutron lbaas-member-show 5750769c-3131-41bd-b0f1-be6c41aa15c9
    +--------------------+--------------------------------------+
    | Field              | Value                                |
    +--------------------+--------------------------------------+
    | address            | 10.0.0.3                             |
    | admin_state_up     | True                                 |
    | id                 | 5750769c-3131-41bd-b0f1-be6c41aa15c9 |
    | pool_id            | 01745519-f910-4393-b237-a24a4f9c2a7d |
    | protocol_port      | 80                                   |
    | status             | ACTIVE                               |
    | status_description |                                      |
    | tenant_id          | 47e1f8f3b8dc4ab2a5f931cdd502afae     |
    | weight             | 0                                    |
    +--------------------+--------------------------------------+

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-02
    rhel-03
    rhel-02
    rhel-03
    rhel-02
    rhel-03

Notice that the member is still marked active and the admin_state_up flag is True, but the member's weight has been changed to 0. Regardless of the algorithm being used, a member with a weight of 0 will not receive any new connections from the load balancer. Set the member's weight back to 1 for it to once again be considered for load balancing.

    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 --weight 1
    Updated member: 5750769c-3131-41bd-b0f1-be6c41aa15c9

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-03
    rhel-02
    rhel-01
    rhel-03
    rhel-02
    rhel-01

As expected, 'rhel-01' is again eligible to receive HTTP requests via the load balancer.

A simple way to demonstrate the health checker is to shutdown one of the virtual machines. This will cause the health check to fail and the member should be marked inactive. Stop one of the virtual machines that is an active member of the pool and check that it is marked inactive.

    # openstack server list
    +--------------------------------------+---------+--------+------------+-------------+------------------+
    | ID                                   | Name    | Status | Task State | Power State | Networks         |
    +--------------------------------------+---------+--------+------------+-------------+------------------+
    | 1fffa4ec-2bd6-426d-89b0-ead561545de7 | rhel-01 | ACTIVE | None       | Running     | private=10.0.0.3 |
    | ae1f4f60-18c1-4001-8a55-7b7036ca6b3c | rhel-02 | ACTIVE | None       | Running     | private=10.0.0.4 |
    | 429be6ec-a069-4dcd-bfca-33cd42606d39 | rhel-03 | ACTIVE | None       | Running     | private=10.0.0.5 |
    +--------------------------------------+---------+--------+------------+-------------+------------------+

    # openstack server stop rhel-03
    # openstack server list
    +--------------------------------------+---------+---------+------------+-------------+------------------+
    | ID                                   | Name    | Status  | Task State | Power State | Networks         |
    +--------------------------------------+---------+---------+------------+-------------+------------------+
    | 1fffa4ec-2bd6-426d-89b0-ead561545de7 | rhel-01 | ACTIVE  | None       | Running     | private=10.0.0.3 |
    | ae1f4f60-18c1-4001-8a55-7b7036ca6b3c | rhel-02 | ACTIVE  | None       | Running     | private=10.0.0.4 |
    | 429be6ec-a069-4dcd-bfca-33cd42606d39 | rhel-03 | SHUTOFF | None       | Shutdown    | private=10.0.0.5 |
    +--------------------------------------+---------+---------+------------+-------------+------------------+

    # neutron lbaas-member-list
    +--------------------------------------+----------+---------------+----------------+----------+
    | id                                   | address  | protocol_port | admin_state_up | status   |
    +--------------------------------------+----------+---------------+----------------+----------+
    | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 | 10.0.0.4 |            80 | True           | ACTIVE   |
    | 5750769c-3131-41bd-b0f1-be6c41aa15c9 | 10.0.0.3 |            80 | True           | ACTIVE   |
    | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 | 10.0.0.5 |            80 | True           | INACTIVE |
    +--------------------------------------+----------+---------------+----------------+----------+

Notice that 'rhel-03' (which has address 10.0.0.5) is now marked as an inactive member. This was caused by repeated failed health checks because that member is not responding to HTTP requests. Run our simple test of sending multiple HTTP requests to the load balancer.

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-01
    rhel-02
    rhel-01
    rhel-02
    rhel-01
    rhel-02

As expected, 'rhel-03' does not receive any traffic from the load balancer. Although this virtual machine is down, it is still a member of the pool and therefore is still being health checked every 5 seconds. If the virtual machine is restarted, health checks of this member will once again be successful when httpd is responsive. The member should then be marked active and again be eligible to receive HTTP requests via the load-balancer.

    # openstack server start rhel-03
    # openstack server list
    +--------------------------------------+---------+--------+------------+-------------+------------------+
    | ID                                   | Name    | Status | Task State | Power State | Networks         |
    +--------------------------------------+---------+--------+------------+-------------+------------------+
    | 1fffa4ec-2bd6-426d-89b0-ead561545de7 | rhel-01 | ACTIVE | None       | Running     | private=10.0.0.3 |
    | ae1f4f60-18c1-4001-8a55-7b7036ca6b3c | rhel-02 | ACTIVE | None       | Running     | private=10.0.0.4 |
    | 429be6ec-a069-4dcd-bfca-33cd42606d39 | rhel-03 | ACTIVE | None       | Running     | private=10.0.0.5 |
    +--------------------------------------+---------+--------+------------+-------------+------------------+

    # neutron lbaas-member-list
    +--------------------------------------+----------+---------------+----------------+--------+
    | id                                   | address  | protocol_port | admin_state_up | status |
    +--------------------------------------+----------+---------------+----------------+--------+
    | 135846f5-e1b0-4ad0-83fd-de4dd1dbde58 | 10.0.0.4 |            80 | True           | ACTIVE |
    | 5750769c-3131-41bd-b0f1-be6c41aa15c9 | 10.0.0.3 |            80 | True           | ACTIVE |
    | 63f009cf-f6bc-4274-8e5d-f9c2613d7912 | 10.0.0.5 |            80 | True           | ACTIVE |
    +--------------------------------------+----------+---------------+----------------+--------+

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-01
    rhel-02
    rhel-03
    rhel-01
    rhel-02
    rhel-03
