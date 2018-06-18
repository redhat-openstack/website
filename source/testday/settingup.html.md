# Setting up a cloud for the Test Days

The following instructions will set up a single baremetal node, which will then be used to create an all-in-one test cloud for the RDO Test Days. You can also use them to set up your own environment.

## Cloud provider and credentials

We are using Internap to provide a cloud with bare metal capabilities. As a first step, make sure you have the required environment variables for use with openstackclient:

 ```
  $ export OS_AUTH_URL=https://identity.api.cloud.iweb.com/v2.0
  $ export OS_PROJECT_NAME="myproject"
  $ export OS_USERNAME="user"
  $ export OS_PASSWORD="password"
  $ export OS_REGION_NAME="nyj01"
  $ export OS_IDENTITY_API_VERSION=2
 ```
 
Make sure your SSH public key is loaded.

## Required data

We need to select the right flavor for our cloud. You can check the available node types in the [pricing page](https://www.inap.com/cloud/bare-metal/bare-metal-pricing/), then match it with the available flavors returned by:

 ```
  $ openstack flavor list
  +----------------------------------------+----------------------------------------+-------+------+-----------+-------+-----------+
  | ID                                     | Name                                   |   RAM | Disk | Ephemeral | VCPUs | Is Public |
  +----------------------------------------+----------------------------------------+-------+------+-----------+-------+-----------+
  | A1.1                                   | A1.1                                   |  1024 |   20 |         0 |     1 | True      |
  | A1.16                                  | A1.16                                  | 16384 |  320 |         0 |    16 | True      |
  ...
  | AS2.2xE5-2630v3.64GB.1x2TB.HDD.10GbE   | AS2.2xE5-2630v3.64GB.1x2TB.HDD.10GbE   | 65536 | 2000 |         0 |    32 | True      |
  | AS2.2xE5-2630v3.64GB.1x480GB.SSD.10GbE | AS2.2xE5-2630v3.64GB.1x480GB.SSD.10GbE | 65536 |  480 |         0 |    32 | True      |
  ...
  | B1.8                                   | B1.8                                   | 30720 |  160 |         0 |     8 | True      |
  +----------------------------------------+----------------------------------------+-------+------+-----------+-------+-----------+
 ```
 
Let's assume we want to use a node with flavor AS2.2xE5-2630v3.64GB.1x2TB.HDD.10GbE.

In this provider, we have two available networks:

* LAN, used for inter-machine communications
* WAN, used for communications with the outside world (i.e. Internet)

We can get the ids for those networks using:
  ```
  $ openstack network list

  +---------+--------------------+----------------------+
  | ID      | Name               | Subnets              |
  +---------+--------------------+----------------------+
  | <uuid1> | inap-20986-LAN3085 | <subnet1>, <subnet2> |
  | <uuid2> | inap-20986-WAN2091 | <subnet1>, <subnet2> |
  +---------+--------------------+----------------------+
  ```
Finally, we need to know the image to use. There is an image named "CentOS 7", so we can just use it.

## Creating the node

Now that we have all the required data, we can create the node:
  ```
  $ openstack server create --flavor AS2.2xE5-2630v3.64GB.1x2TB.HDD.10GbE \
    --image "CentOS 7" \
    --key-name my-key \
    --nic net-id=<uuid2> \ 
    --nic net-id=<uuid1> \ 
    testday.rdoproject.org
  ```
Note that we are specifying the uid for the WAN network first.

The node will take several minutes to create. Once it is done, you should be able to log in to it:
  ```
  $ ssh root@<IP>
  ```
## Configuring the network port to allow floating IPs

The node we just created is part of a Neutron network, so it has certain protections such as anti-spoofing. We want to run an
RDO cloud on that node, so we need to configure its WAN network port to allow multiple IPs to be bound to it.

First, we will find the port associated to the WAN nic in the newly created server:
  ```
  $ openstack port list
  ```
Just find the port with the same IP address as the server. Let's assume it has id aaa-bbb-ccc. Then, we do:
  ```
  $ openstack port set --allowed-address ip-address=74.217.28.48/28 aaa-bbb-ccc
  ```
Replace the `74.217.28.48/28` subnet with the appropriate one. This command will allow any IP in that subnet
to be bound to the port used by our server. To prevent any other machine in our project from taking the floating
IP addresses, we will create the ports as well:
  ```
  $ for i in 51 52 53 54 55 56 57 58 59
  > do
  > openstack port create --network <uuid2> --fixed-ip subnet=<subnet id>,ip-address=74.217.28.$i 74.217.28.$i
  > done
  ```
We need to find the uid for the subnet associated to our server.

## Create your test cloud

Once this is done, the sky is the limit! You can follow the [TripleO](http://tripleo.org/), [Kolla](https://docs.openstack.org/kolla-ansible/latest/user/index.html) or [Packstack](/install/packstack) installation instructions to set up your test day cloud.
