---
title: MidoNet integration
authors: adjohn, fernando, fiveohmike, red trela, techcet, yantarou, zbigniewficner
wiki_title: MidoNet integration
wiki_revision_count: 172
wiki_last_updated: 2015-08-07
---

# MidoNet integration

## Prerequisites

### Installing OpenStack

Please verify that this is working before proceeding. Most installation issues come when a Packstack error has occurred but was ignored.

NOTE: Make sure Selinux is disabled (or set to permissive) and both FirewallD and/or IPTables are disabled!

#### Make sure your OS is up to date

Run yum update to make sure the system is running the latest packages. This is required:

      yum update -y

Once this is finished:

      reboot

#### Enabling RDO repositories

Enable the EDO repositories using the following command (as root):

      yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

To enable the EPEL repository use this command:

      su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm'

To enable 'optional' and 'extras' from the RHEL subscription run these commands (as root):

      yum -y install yum-utils
      yum-config-manager --enable rhel-7-server-optional-rpms
      yum-config-manager --enable rhel-7-server-extras-rpms

#### Install Packstack Installer

Run the following command to install Packstack on your system

      yum install -y openstack-packstack

#### Install Openstack Packstack

      packstack --allinone

### Cleaning up Packstack OpenStack All-in-on Installation

The first steps to get MidoNet running on the All-in-one environment created by the Packstack installer is to clean up the network section in preparation of installing MidoNet.

Log in to your horizon dashboard as the Admin account and do the following:

1.  Add the admin user to the "demo" tenant.
2.  Move to the demo tenant, as admin, and delete the router, the private subnet and clear the router gateway.
3.  Move back to the admin tenant and remove the public subnet (external network).

Next, we need to SSH into the Packstack system (in this case I am using RHEL 7). We need to remove services that will interfere with MidoNet and/or are no longer needed. This will break the networking of your PackStack until the MidoNet integration is complete. Please be aware of this before starting to make sure you have sufficient time.

*   1. Remove the OpenVswitch agent packages:

      yum remove openstack-neutron-openvswitch

*   2. Stop and disable the Neutron L3 Agent package:

      systemctl stop neutron-l3-agent
      systemctl disable neutron-l3-agent

*   3. Disable Network Manager

      systemctl stop networkmanager.service
      systemctl disable networkmanager.service
      systemctl enable network.service
      systemctl start network.service

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
      gpgkey=http://username:password@yum.midokura.com/repo/RPM-GPG-KEY-midokura
      enabled=1
      [Midokura-Neutron-Plugin]
      name=Midokura-Neutron-Plugin Repository
      baseurl=http://username:password@yum.midokura.com/repo/openstack-icehouse/stable/RHEL/7/
      gpgcheck=1
      gpgkey=http://username:password@yum.midokura.com/repo/RPM-GPG-KEY-midokura
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

The Midolman agent must be installed on all network and compute nodes (in this case we are running All-in-one).

*   1. Install Midolman package:

      yum install midolman

*   2. If you run ZooKeeper and Cassandra in a cluster the Midolman configuration file must reflect this.
    -   a) For the ZooKeeper cluster the /etc/midolman/midolman.conf file must contain the following entries:

      [zookeeper]
      zookeeper_hosts =`<host_IP>`:2181

*   -   b) For the Cassandra cluster the /etc/midolman/midolman.conf file must contain the following entries:

      [cassandra]
`servers = `<host_IP>
      replication_factor = 1
      cluster = midonet

3. Restart Midolman:

      systemctl restart midolman.service

### Midonet API

*   1. Install the MidoNet API package:

      yum install midonet-api

*   2. Configure MidoNet API by editing the /usr/share/midonet-api/WEB-INF/web.xml file to contain the following entries:

<context-param>
<param-name>`rest_api-base_uri`</param-name>
<param-value>`http://<host_IP>:8080/midonet-api</param-value>`
</context-param>
<context-param>
<param-name>`keystone-service_host`</param-name>
<param-value>`host_IP`</param-value>
</context-param>
<context-param>
<param-name>`keystone-admin_token`</param-name>
<param-value>`ADMIN_TOKEN`</param-value>
</context-param>
<context-param>
<param-name>`zookeeper-zookeeper_hosts`</param-name>
<param-value>`host_IP:2181`</paramvalue>
</context-param>

Make sure to change the all of the <host_ID> fields and the admin_token field to the correct values. The admin_token can be found in your packstack keystonerc_admin.sh file

*   3. Install the Tomcat package:

      yum install tomcat

*   4. Configure Tomcat's Entropy Source by editing the /usr/share/tomcat7/bin/catalina.sh file to contain this entry:

      JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=`[`file:/dev/./urandom`](file:/dev/./urandom)`"

*   5. Configure MidoNet API context by editing the /etc/tomcat7/Catalina/localhost/midonet-api.xml file to contain these entries:

<Context
     path="/midonet-api"
     docBase="/usr/share/midonet-api"
     antiResourceLocking="false"
     privileged="true"
 />
