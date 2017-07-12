---
title: LBaaS
authors: rohara, trilliams
wiki_title: LBaaS
wiki_revision_count: 8
wiki_last_updated: 2017-07-11
---

# Neutron LBaaS v2

{:.no_toc}

## Configuring and Deploying LBaaS in OpenStack

This document has been updated to use Neutron LBaaS v2 and OpenStack CLI where available. At this time, OpenStack CLI does not have integration with Neutron LBaaS v2 unless native Octavia v2 API is used. This document will be updated in the future if this changes.

The Neutron LBaaS (load-balancer-as-a-service) extension provides a means to load balance traffic for services running on virtual machines in the cloud. The LBaaS API provides an API to quickly and easily deploy a load balancer. This guide will demonstrate how to configure and deploy a load balancer using the LBaaS v2 API with RDO.

### Prerequisites

In this guide, haproxy will be used as the load balancer. Be sure that you either have haproxy installed or have access to a yum repository that provides the haproxy package.

To avoid issues with networking, it is best to provide a static IP address and disable NetworkManager.

    # systemctl disable NetworkManager
    # systemctl enable network
    # systemctl stop NetworkManager.service
    # systemctl start network.service


### Installation

The Neutron LBaaS extension can be enabled and configured by packstack at install time. To do so, use the `--os-neutron-lbaas-install` option to indicate you want to install the LBaaS agent:

    # packstack --allinone --os-neutron-lbaas-install=y

In the above example, packstack will do an all-in-one install on the local host. Those using an answer file can install Neutron LBaaS by updating the `CONFIG_LBAAS_INSTALL` variable, as demonstrated below.

	CONFIG_LBAAS_INSTALL=y

### Deploy

After the install the LBaaS plugin is configured and the LBaaS agent is running, the next step is to boot the virtual machines and deploy a load balancer. In the example shown here, the "demo" tenant, which is provisioned by packstack, will be used.

This example also makes use of a custom server image that has the httpd service enabled. This is the service that will be load-balanced. In addition, the image was built such that the virtual machine's host name is retrieved from the metadata service and placed in /var/www/html/index.html. This is done by using a simple curl command in rc.local:

    curl -s -o /var/www/html/index.html http://169.254.169.254/latest/meta-data/hostname

This is useful to show the load balancer working later in the example.

First, use the demo tenant:

    # source keystonerc_demo

Import the custom image that has httpd enabled and a modified rc.local script:


=======
    # openstack image create rhel-http --public --disk-format qcow2 --container-format bare --file rhel.qcow2


Check that the image was imported:

    # openstack image list
    +--------------------------------------+-----------+-------------+------------------+------------+--------+
    | ID                                   | Name      | Disk Format | Container Format | Size       | Status |
    +--------------------------------------+-----------+-------------+------------------+------------+--------+
    | 74f1b121-1531-4c48-b528-bdb22d327359 | cirros    | qcow2       | bare             | 13147648   | active |
    | 5d6bd846-e044-4a8f-99f0-5ca1d006f8ef | rhel-http | qcow2       | bare             | 1690042368 | active |
    +--------------------------------------+-----------+-------------+------------------+------------+--------+

Next, create a keypair to use when we boot the image:


    # openstack keypair create --public-key ~/.ssh/rdo-key.pub  rdo-key.pem
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

    # openstack server list
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

    | 63d4d6bf-24e6-4063-9f92-402d78ce3fc2 | private |3b4be857-7705-4e47-80a2-5f15beb675c2  |
    | f33a8dc9-cee6-48c2-9f7d-6fef8bead932 | public  |64377ee4-cb4d-4e91-98bd-c7f1aa4b2484  |
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

Our first step will be to create a new load balancer using NeutronCLI, tied to a network. For my example, I will create a load balancer on the Private network subnet.

First, get the subnet ID from neutron.

    # openstack subnet list
    +--------------------------------------+----------------+-------------+--------------------------------------------+
    | id                                   | name           | cidr        | allocation_pools                           |
    +--------------------------------------+----------------+-------------+--------------------------------------------+
    | a4f17073-298e-4d92-8c19-8f3333145fd0 | private_subnet | 10.0.0.0/24 | {"start": "10.0.0.2", "end": "10.0.0.254"} |
    +--------------------------------------+----------------+-------------+--------------------------------------------+

Once we have identified the name of our private subnet, we can then create a
new load balancer using Neutron CLI.


    # neutron lbaas-loadbalancer-create --name http-lb private_subnet

    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | admin_state_up      | True                                 |
    | description         |                                      |
    | id                  | 1fc0b51e-a45b-4ae3-9618-453f28db6bc8 |
    | listeners           |                                      |
    | name                | http-lb                              |
    | operating_status    | OFFLINE                              |
    | pools               |                                      |
    | provider            | haproxy                              |
    | provisioning_status | PENDING_CREATE                       |
    | tenant_id           | c33d136a60e04e1fabf733acffa43058     |
    | vip_address         | 10.0.0.13                         |
    | vip_port_id         | 49faec3d-ce16-4bba-bd03-5d4a06fc2aec |
    | vip_subnet_id       | 4ec385da-a94d-42a5-8375-4fa6425f2e97 |
    +---------------------+--------------------------------------+

Once the load balancer is online, you will then need to create a listener. For this example, I am going to create an HTTP listener on port 80. The listener is automatically associated with the http-lb load balancer with the `--loadbalancer` flag.

    # neutron lbaas-listener-create --name http-listener --loadbalancer http-lb --protocol HTTP --protocol-port 80

    Created a new listener:
    +---------------------------+------------------------------------------------+
    | Field                     | Value                                          |
    +---------------------------+------------------------------------------------+
    | admin_state_up            | True                                           |
    | connection_limit          | -1                                             |
    | default_pool_id           |                                                |
    | default_tls_container_ref |                                                |
    | description               |                                                |
    | id                        | 54c30e75-f62b-4b40-9bc1-a2032f1ea042           |
    | loadbalancers             | {"id": "1fc0b51e-a45b-4ae3-9618-453f28db6bc8"} |
    | name                      | http-listener                                  |
    | protocol                  | HTTP                                           |
    | protocol_port             | 80                                             |
    | sni_container_refs        |                                                |
    | tenant_id                 | c33d136a60e04e1fabf733acffa43058               |
    +---------------------------+------------------------------------------------+

Next, we will create an LBaaS pool. A pool is a group of virtual machines, known as members, that will provide the actual service. In this example there will be three members, each capable of providing the httpd service. In addition, the pool also defines the protocol, the load balancing algorithm, and the subnet with which to associate the load balancer. Note that the subnet must be the same as the subnet of the members that belong to the pool.

    # neutron lbaas-pool-create --name http-pool --lb-algorithm ROUND_ROBIN --listener http-listener --protocol HTTP
    Created a new pool:
    +---------------------+------------------------------------------------+
    | Field               | Value                                          |
    +---------------------+------------------------------------------------+
    | admin_state_up      | True                                           |
    | description         |                                                |
    | healthmonitor_id    |                                                |
    | id                  | 11b75bf9-3349-43eb-be26-ecdf284d62a0           |
    | lb_algorithm        | ROUND_ROBIN                                    |
    | listeners           | {"id": "54c30e75-f62b-4b40-9bc1-a2032f1ea042"} |
    | loadbalancers       | {"id": "1fc0b51e-a45b-4ae3-9618-453f28db6bc8"} |
    | members             |                                                |
    | name                | http-pool                                      |
    | protocol            | HTTP                                           |
    | session_persistence |                                                |
    | tenant_id           | c33d136a60e04e1fabf733acffa43058               |
    +---------------------+------------------------------------------------+

The example above creates a pool named "http-pool", which uses the HTTP protocol and a round-robin load balancing algorithm. This pool is associated with the http-pool load balancer created in a previous step. To get more information on existing LBaaS pools, we can run the commands `neutron lbaas-pool-list` and `neutron lbaas-pool-show`. The `lbaas-pool-list` command will list out all active load balancers, while `lbaas-pool-show` will display details on a specific load balancer.

    # neutron lbaas-pool-list
    +--------------------------------------+------------+----------+----------------+
    | id                                   | name       | protocol | admin_state_up |
    +--------------------------------------+------------+----------+----------------+
    | 11b75bf9-3349-43eb-be26-ecdf284d62a0 | http-pool  | HTTP     | True           |
    +--------------------------------------+------------+----------+----------------+

    # neutron lbaas-pool-show http-pool
    +---------------------+------------------------------------------------+
    | Field               | Value                                          |
    +---------------------+------------------------------------------------+
    | admin_state_up      | True                                           |
    | description         |                                                |
    | healthmonitor_id    |                                                |
    | id                  | 11b75bf9-3349-43eb-be26-ecdf284d62a0           |
    | lb_algorithm        | ROUND_ROBIN                                    |
    | listeners           | {"id": "54c30e75-f62b-4b40-9bc1-a2032f1ea042"} |
    | loadbalancers       | {"id": "1fc0b51e-a45b-4ae3-9618-453f28db6bc8"} |
    | members             |                                                |
    | name                | http-pool                                      |
    | protocol            | HTTP                                           |
    | session_persistence |                                                |
    | tenant_id           | c33d136a60e04e1fabf733acffa43058               |
    +---------------------+------------------------------------------------+

The next step is to create members and add them to the pool. A member is nothing more than the IP address and port of a virtual machine that can provide the service being load-balanced. In this example there are three virtual machines listening on port 80. Create a member for each of these servers and add them to the pool.

    # neutron lbaas-member-create --subnet private_subnet --address 10.0.0.3 --protocol-port 80 http-pool
    # neutron lbaas-member-create --subnet private_subnet --address 10.0.0.4 --protocol-port 80 http-pool
    # neutron lbaas-member-create --subnet private_subnet --address 10.0.0.5 --protocol-port 80 http-pool

The `lbaas-member-list` and `lbaas-member-show` commands may be used to get information about existing members.


    # neutron lbaas-member-list --sort-key address --sort-dir asc http-pool
    +--------------------------------------+------+--------------+---------------+--------+--------------------------------------+----------------+
    | id                                   | name | address      | protocol_port |weight  | subnet_id                            | admin_state_up |
    +--------------------------------------+------+--------------+---------------+--------+--------------------------------------+----------------+
    | 8aab1324-6500-427b-92a6-6415beae2f8f |      | 10.0.0.3     |            80 |      1 | 4ec385da-a94d-42a5-8375-4fa6425f2e97 | True           |
    | 419dc5ba-1421-4dad-a1fb-565b6dd9a71d |      | 10.0.0.4     |            80 |      1 | 4ec385da-a94d-42a5-8375-4fa6425f2e97 | True           |
    | a35f3365-2445-4a01-b6ba-995bd1313817 |      | 10.0.0.5     |            80 |      1 | 4ec385da-a94d-42a5-8375-4fa6425f2e97 | True           |
    +--------------------------------------+------+--------------+---------------+--------+--------------------------------------+----------------+

    # neutron lbaas-member-show a35f3365-2445-4a01-b6ba-995bd1313817 http-pool

    +----------------+--------------------------------------+
    | Field          | Value                                |
    +----------------+--------------------------------------+
    | address        | 10.0.0.3                             |
    | admin_state_up | True                                 |
    | id             | a35f3365-2445-4a01-b6ba-995bd1313817 |
    | name           |                                      |
    | protocol_port  | 80                                   |
    | subnet_id      | 4ec385da-a94d-42a5-8375-4fa6425f2e97 |
    | tenant_id      | c33d136a60e04e1fabf733acffa43058     |
    | weight         | 1                                    |
    +----------------+--------------------------------------+

Note that the member shown above has a pool ID that corresponds to the `http-pool`. The command `neutron lbaas-pool-show` may also be used to see the members of a given pool.

    # neutron lbaas-pool-show http-pool
    +---------------------+------------------------------------------------+
    | Field               | Value                                          |
    +---------------------+------------------------------------------------+
    | admin_state_up      | True                                           |
    | description         |                                                |
    | healthmonitor_id    |                                                |
    | id                  | 11b75bf9-3349-43eb-be26-ecdf284d62a0           |
    | lb_algorithm        | ROUND_ROBIN                                    |
    | listeners           | {"id": "54c30e75-f62b-4b40-9bc1-a2032f1ea042"} |
    | loadbalancers       | {"id": "1fc0b51e-a45b-4ae3-9618-453f28db6bc8"} |
    | members             | 419dc5ba-1421-4dad-a1fb-565b6dd9a71d           |
    |                     | 8aab1324-6500-427b-92a6-6415beae2f8f           |
    |                     | a35f3365-2445-4a01-b6ba-995bd1313817           |
    | name                | http-pool                                      |
    | protocol            | HTTP                                           |
    | session_persistence |                                                |
    | tenant_id           | c33d136a60e04e1fabf733acffa43058               |
    +---------------------+------------------------------------------------+

The next step is to create a health monitor and associate it with the pool. The health monitor is responsible for periodically checking the health of each member of the pool.

    # neutron lbaas-healthmonitor-create --delay 5 --type HTTP --max-retries 3 --timeout 2 --pool http-pool
    Created a new healthmonitor:
    +------------------+------------------------------------------------+
    | Field            | Value                                          |
    +------------------+------------------------------------------------+
    | admin_state_up   | True                                           |
    | delay            | 5                                              |
    | expected_codes   | 200                                            |
    | http_method      | GET                                            |
    | id               | ec8ff90c-7c5e-4883-a1a4-10cc22072bb0           |
    | max_retries      | 3                                              |
    | max_retries_down | 3                                              |
    | name             |                                                |
    | pools            | {"id": "11b75bf9-3349-43eb-be26-ecdf284d62a0"} |
    | tenant_id        | c33d136a60e04e1fabf733acffa43058               |
    | timeout          | 2                                              |
    | type             | HTTP                                           |
    | url_path         | /                                              |
    +------------------+------------------------------------------------+


In this example, the health monitor will perform an HTTP GET of the "/" path. This health check expects an HTTP status of 200 in the response, and the connection must be established within 2 seconds. This check will be retried a maximum of 3 times before a member is determined to be failed.



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

Once the floating IP has been created, we will need to assign it to the load balancer port. We can locate the neutron port for our load balancer with the following command.

    # openstack port list
    +--------------------------------------+---------------------------------------------------+-------------------+--------------------------------------------------------+
    | ID                                   | Name                                              | MAC Address       | Fixed IP Addresses                                     |
    +--------------------------------------+---------------------------------------------------+-------------------+--------------------------------------------------------+
    | b9b86e52-25c3-4277-afc6-9214197827d3 |loadbalancer-ed3efc09-7284-4edb-9a70-f730ef9595c1 | fa:16:3e:9f:4c:cb  |ip_address='10.0.0.6', subnet_id='4ec385da-a94d-        ||                                      |                                                   |                   | 42a5-8375-4fa6425f2e97'                                |
    +--------------------------------------+---------------------------------------------------+-------------------+--------------------------------------------------------+

Once the port UUID has been located, assign the floating IP to the load balancer with the command `neutron floatingip-associate`, specifying both the UUID for the floating IP address and the UUID for the load balancer port. 

    # neutron floatingip-associate 6becaba6-b3fe-4e54-8bd6-f5d8364a363f b9b86e52-25c3-4277-afc6-9214197827d3
    Associated floating IP 6becaba6-b3fe-4e54-8bd6-f5d8364a363f

Use the `floatingip-list` command to verify that the floating IP address (172.24.4.230) is associated with the virtual IP address (10.0.0.6).

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

Now that the load balancer is running and externally accessible, test that traffic is properly load-balanced and the health checker works correctly. First, check what members are active in the LB pool, `http-pool`.


    # neutron lbaas-member-list http-pool --sort-key address --sort-dir asc


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


    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 http-pool --admin_state_up False


    Updated member: 5750769c-3131-41bd-b0f1-be6c41aa15c9

    # neutron lbaas-member-list --sort-key address --sort-dir asc
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

    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 http-pool --admin_state_up True

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


    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 http-pool --weight 0

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


    # neutron lbaas-member-update 5750769c-3131-41bd-b0f1-be6c41aa15c9 http-pool --weight 1

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

Notice that `rhel-03` (which has address 10.0.0.5) is now marked as an inactive member. This was caused by repeated failed health checks because that member is not responding to HTTP requests. Run our simple test of sending multiple HTTP requests to the load balancer.

    # for i in {1..6} ; do curl -w "\n" 172.24.4.230 ; done
    rhel-01
    rhel-02
    rhel-01
    rhel-02
    rhel-01
    rhel-02

As expected, `rhel-03` does not receive any traffic from the load balancer. Although this virtual machine is down, it is still a member of the pool and therefore is still being health checked every 5 seconds. If the virtual machine is restarted, health checks of this member will once again be successful when httpd is responsive. The member should then be marked active and again be eligible to receive HTTP requests via the load-balancer.

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

### Dashboard Integration

Optionally, Neutron LBaaS v2 integration can be added to the Horizon dasboard by installing the `openstack-neutron-lbaas` and `openstack-neutron-lbaas-ui` plugins with yum.

	# yum -y install openstack-neutron-lbaas openstack-neutron-lbaas-ui
	
Once the packages have been installed, enable LBaaS in Horizon by changing the `enable_lb` value in `/etc/openstack-dashboard/local_settings` from `False` to `True`:

	OPENSTACK_NEUTRON_NETWORK = {
    'enable_distributed_router': False,
    'enable_firewall': False,
    'enable_ha_router': False,
    'enable_lb': True,
    'enable_quotas': True,
    'enable_security_group': True,
    'enable_vpn': False,
    'profile_support': None,
  
	
After saving and closing the file, restart Apache and memcached.

	# systemctl restart httpd memcached
	
Now you should be able to view, create, and manage Neutron LBaaS under Projects --> Networking -- Load Balancers in the Horizon web dashboard.
