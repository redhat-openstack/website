---
title: MidoNet integration
authors: adjohn, fernando, fiveohmike, red trela, techcet, yantarou, zbigniewficner
wiki_title: MidoNet integration
wiki_revision_count: 172
wiki_last_updated: 2015-08-07
---

# MidoNet integration

To install MidoNet on RDO follow the [Redhat Enterprise Linux 7 Quick Start Guide](http://docs.midonet.org/docs/v1.8/quick-start-guide/rhel-7_icehouse/content/index.html), with the exception of the repository configuration, and OpenStack installation, as outlined below.

## Prerequisites

### Installing OpenStack

Install OpenStack using the procedure provided in the [RDO Quickstart](https://openstack.redhat.com/Quickstart).

Please verify that this is working before proceeding. Most installation issues come when a Packstack error has occurred but was ignored.

NOTE: Make sure Selinux is disable (or set to permissive) and both FirewallD and/or IPTables are disabled!

### Enabling RDO repositories

Enable the EDO repositories using the following command (as root):

      yum install -y https://rdo.fedorapeople.org/rdo-release.rpm

To enable the EPEL repository use this command:

      su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm'

To enable 'optional' and 'extras' from the RHEL subscription run these commands (as root):

      yum -y install yum-utils
      yum-config-manager --enable rhel-7-server-optional-rpms
      yum-config-manager --enable rhel-7-server-extras-rpms

### Cleaning up Packstack OpenStack All-in-on Installation

The first steps to get MidoNet running on the All-in-one environment created by the Packstack installer is to clean up the network section in preparation of installing MidoNet.

Log in to your horizon dashboard as the Admin account and do the following:

1.  Add the admin user to the "demo" tenant.
2.  Move to the demo tenant, as admin, and delete the router, the private subnet and clear the router gateway.
3.  Move back to the admin tenant and remove the public subnet (external network).

Next, we need to SSH into the Packstack system (in this case I am using RHEL 7). We need to remove services that will interfere with MidoNet and/or are no longer needed. This will break the networking of your PackStack until the MidoNet integration is complete. Please be aware of this before starting to make sure you have sufficient time.

1.  Remove the OpenVswitch agent packages:

      yum remove openstack-neutron-openvswitch

1.  Stop and disable the Neutron L3 Agent package:

      systemctl stop neutron-l3-agent
      systemctl disable neutron-l3-agent

## Installing MidoNet Components

### Adding the MidoNet Repositories

The packages are tested against and supported on Red Hat Enterprise Linux (RHEL) 7. 1. Enable the DataStax repository by creating the /etc/yum.repos.d/datastax.repo file with this entry:

      [datastax]
      name= DataStax Repo for Apache Cassandra
      baseurl=http://rpm.datastax.com/community
      enabled=1
      gpgcheck=0

2. Enable the Midokura repositories by creating the /etc/yum.repos.d/midokura.repo file with these entries:

      [Midokura]
      name=Midokura Repository
      baseurl=http://username:password@yum.midokura.com/repo/v1.7/stable/RHEL/7/
      gpgcheck=1
      gpgkey=http://username:password@yum.midokura.com/repo/RPM-GPG-KEYmidokura
      enabled=1
      [Midokura-Neutron-Plugin]
      name=Midokura-Neutron-Plugin Repository
      baseurl=http://username:password@yum.midokura.com/repo/openstack-icehouse/stable/RHEL/7/
      gpgcheck=1
      gpgkey=http://username:password@yum.midokura.com/repo/RPM-GPG-KEYmidokura
      enabled=1

Where username:password are repository login credentials provided by Midokura, and version is the OpenStack version you're installing with MidoNet, its accepted values being openstack-havana and openstack-icehouse. Alternatively you can follow the instructions using the MidoNet community repos as well.

### MidoNet Network State Database

#### Installing ZooKeeper

*   1. Install OpenJDK 7 JRE (the 'headless' mode at the least):

      yum install java-1.7.0-openjdk-headless

*   2. Install the ZooKeeper packages:

      yum install zookeeper

*   3. Zookeeper expects the JRE to be found in the /usr/java/default/bin/ directory so if it is in a different location, you must create a symbolic link pointing to that location. To do so run the 2 following commands:

      mkdir -p /usr/java/default/bin/
      ln -s /usr/lib/jvm/jre-1.7.0-openjdk/bin/java /usr/java/default/bin/java

*   4. Next we need to create the zookeeper data directory and assign permissions:

      mkdir /var/lib/zookeeper/data
      chmod 777 /var/lib/zookeeper/data

*   5. Now we can edit the Zookeeper configuration file. We need to add the servers (in a prod installation you would have more than one zookeeper server in a cluster. For this example we are only using one. ). Edit the Zookeeper config file at /etc/zookeeper/zoo.cfg and add the following to the bottom of the file:

      server.1=`<host IP>`:2888:3888

Note: Please replace host IP with your IP on the server you are working with

*   6. We need to set the Zookeeper ID on this server:

      echo 1 > /var/lib/zookeeper/data/myid

*   7. Lastly we start the zookeeper service:

      systemctl start zookeeper.service

*   8. Now test to see if Zookeeper is running:

      echo ruok | nc 127.0.0.1 2181

If it is running correctly you will see an "imok" response.

#### Installing Cassandra

Use this procedure to install Cassandra on Red Hat Enterprise Linux 7.

*   1. Install the Cassandra packages:

      yum install dsc20

*   2. Configure the cluster.
    -   a) Configure the cluster name by editing the /etc/cassandra/conf/cassandra.yaml file so that it contains this entry:

      cluster_name: 'midonet'

*   -   b) Configure a listen address by editing the /etc/cassandra/conf/cassandra.yaml file so that it contains the IP of the host that you are configuring:

`listen_address: `<host_IP>

*   -   c) Configure the cluster nodes by editing the /etc/cassandra/conf/cassandra.yaml file so that it contains the following line:

      - seeds: "`<host_IP>`"

*   -   d) Configure the RPC Listen address:

`rpc_listen: `<host_IP>

*   3. Clean existing system data and restart Cassandra:

      rm -rf /var/lib/cassandra/data/system/
      systemctl restart cassandra.service

*   4. Test for connectivity by running the following:

      cassandra-cli -h 192.168.100.8 -p 9160

If everything is ok you should see something similar:

      Connected to: "midonet" on 10.0.0.5/9160
      Welcome to Cassandra CLI version 2.0.6
      Type 'help;' or '?' for help.
      Type 'quit;' or 'exit;' to quit.
      [default@unknown]:

### Installing MidolMan
