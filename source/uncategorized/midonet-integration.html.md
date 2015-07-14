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

#### Enabling RDO repositories

Enable the EDO repositories using the following command (as root):

      yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

To enable the EPEL repository use this command:

      su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'

To enable 'optional' and 'extras' from the RHEL subscription run these commands (as root):

      yum -y install yum-utils
      yum-config-manager --enable rhel-7-server-optional-rpms
      yum-config-manager --enable rhel-7-server-extras-rpms

#### Make sure your OS is up to date

Run yum update to make sure the system is running the latest packages. This is required:

      yum update -y

Once this is finished:

      reboot

#### Install Packstack Installer

Run the following command to install Packstack on your system

      yum install -y openstack-packstack

#### Install Openstack Packstack

      packstack --allinone

### Cleaning up Packstack OpenStack All-in-on Installation

The first steps to get MidoNet running on the All-in-one environment created by the Packstack installer is to clean up the network section in preparation of installing MidoNet.

Log in to your horizon dashboard as the Admin account and do the following:

1.  Add the admin user to the "demo" tenant ( under Admin>Identity>Project)
2.  Move to the demo tenant, as admin, and delete the router, the private subnet and clear the router gateway in this order: Clear Router Gateway, Delete Router Interface, Delete Router, Delete network.
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

The packages are tested against and supported on Red Hat Enterprise Linux (RHEL) 7. Add either the MidoNet Community repos or the Midokura Enterprise MidoNet repos.

#### Midonet Community

1. Enable the DataStax repository by creating the /etc/yum.repos.d/datastax.repo file with this entry for Midokura Enterprise Midonet (not the commnity version):

      [datastax]
      name= DataStax Repo for Apache Cassandra
      baseurl=http://rpm.datastax.com/community
      enabled=1
      gpgcheck=0
      gpgkey = https://rpm.datastax.com/rpm/repo_key

2. Enable the Midonet repositories by creating the /etc/yum.repos.d/midonet.repo file with these entries for Midonet Community:

      [midonet] 
      name=MidoNet
      baseurl=http://repo.midonet.org/midonet/v2014.11/RHEL/7/unstable/
      enabled=1
      gpgcheck=1
      gpgkey=http://repo.midonet.org/RPM-GPG-KEY-midokura

      [midonet-openstack-integration]
      name=MidoNet OpenStack Integration
      baseurl=http://repo.midonet.org/openstack-icehouse/RHEL/7/unstable/
      enabled=1
      gpgcheck=1
      gpgkey=http://repo.midonet.org/RPM-GPG-KEY-midokura

      [midonet-misc]
      name=MidoNet 3rd Party Tools and Libraries
      baseurl=http://repo.midonet.org/misc/RHEL/7/misc/
      enabled=1
      gpgcheck=1
      gpgkey=http://repo.midonet.org/RPM-GPG-KEY-midokura

#### Midokura Enterprise Midonet

1. Enable the DataStax repository by creating the /etc/yum.repos.d/datastax.repo file with this entry:

      [datastax]
      name= DataStax Repo for Apache Cassandra
      baseurl=http://rpm.datastax.com/community
      enabled=1
      gpgcheck=0

2. Enable the Midokura repositories by creating the /etc/yum.repos.d/midokura.repo file with these entries for Midokura Enterprise Midonet (not the commnity version):

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

1. Install OpenJDK 7 JRE (the 'headless' mode at the least):

   ```
   yum install java-1.7.0-openjdk-headless
   ```

2. Install the ZooKeeper packages:

   ```
   yum install zookeeper
   ```

3. Zookeeper expects the JRE to be found in the /usr/java/default/bin/ directory so if it is in a different location, you must create a symbolic link pointing to that location. To do so run the 2 following commands:

   ```
   mkdir -p /usr/java/default/bin/
   ln -s /usr/lib/jvm/jre-1.7.0-openjdk/bin/java /usr/java/default/bin/java
   ```

4. Next we need to create the zookeeper data directory and assign permissions:

   ```
   mkdir /var/lib/zookeeper/data
   chmod 777 /var/lib/zookeeper/data
   ```

5. Now we can edit the Zookeeper configuration file. We need to add the servers (in a prod installation you would have more than one zookeeper server in a cluster. For this example we are only using one. ). Edit the Zookeeper config file at /etc/zookeeper/zoo.cfg and add the following to the bottom of the file:

   ```
   server.1=`<host IP>`:2888:3888
   ```

   _**Note**: Please replace host IP with your IP on the server you are working with_

6. We need to set the Zookeeper ID on this server:

   ```
   echo 1 > /var/lib/zookeeper/data/myid
   ```

7. Lastly we start the zookeeper service:

   ```
   systemctl start zookeeper.service
   ```

8. Now test to see if Zookeeper is running:

   ```
   echo ruok | nc 127.0.0.1 2181
   ```

   _If it is running correctly you will see an "imok" response._

#### Installing Cassandra

Use this procedure to install Cassandra on Red Hat Enterprise Linux 7.

1. Install the Cassandra packages:

   ```
   yum install dsc20
   ```

2. Configure the cluster.

   1. Configure the cluster name by editing the /etc/cassandra/conf/cassandra.yaml file so that it contains this entry:

      ```
      cluster_name: 'midonet'
      ```

   2. Configure a listen address by editing the /etc/cassandra/conf/cassandra.yaml file so that it contains the IP of the host that you are configuring:

      ```
      listen_address: <host_IP>
      ```

   3. Configure the cluster nodes by editing the /etc/cassandra/conf/cassandra.yaml file so that it contains the following line:

      ```
      seeds: "<host_IP>"
      ```

   4. Configure the RPC Listen address:

      ```
      rpc_address: <host_IP>
      ```

3. Clean existing system data and restart Cassandra:

   ```
   rm -rf /var/lib/cassandra/data/system/
   systemctl restart cassandra.service
   ```

4. Test for connectivity by running the following:

   ```
   cassandra-cli -h `<host_IP>` -p 9160
   ```

If everything is ok you should see something similar:

```
Connected to: "midonet" on 10.0.0.5/9160
Welcome to Cassandra CLI version 2.0.6
Type 'help;' or '?' for help.
Type 'quit;' or 'exit;' to quit.
[default@unknown]:
```

### Installing MidolMan

The Midolman agent must be installed on all network and compute nodes (in this case we are running All-in-one).

1. Install Midolman package:

   ```
   yum install midolman
   ```

2. If you run ZooKeeper and Cassandra in a cluster the Midolman configuration file must reflect this.

    1. For the ZooKeeper cluster the /etc/midolman/midolman.conf file must contain the following entries:

       ```
       [zookeeper]
       zookeeper_hosts =`<host_IP>`:2181
       ```

    2. For the Cassandra cluster the /etc/midolman/midolman.conf file must contain the following entries:

       ```
       [cassandra]
 `servers = `<host_IP>
       replication_factor = 1
       cluster = midonet
       ```

3. Restart Midolman:

   ```
   systemctl restart midolman.service
   ```

4. Check to see if Midolman is running:

   ```
   ps -ef | grep mido
   ```

You should see the process running.

### Midonet API

*   1. Install the MidoNet API package:

      yum install midonet-api

*   2. Configure MidoNet API by editing the /usr/share/midonet-api/WEB-INF/web.xml file to contain the following entries:

```xml
<context-param>
<param-name>`rest_api-base_uri`</param-name>
<param-value>`http://<host_IP>:8081/midonet-api</param-value>`
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
```

Make sure to change the all of the <host_ID> fields and the admin_token field to the correct values. The admin_token can be found in your packstack /etc/keystone/keystone.conf file

*   3. Install the Tomcat package:

      yum install tomcat

*   4. Configure MidoNet API context by editing the /etc/tomcat/Catalina/localhost/midonet-api.xml file to contain these entries:

```
<Context
     path="/midonet-api"
     docBase="/usr/share/midonet-api"
     antiResourceLocking="false"
     privileged="true"
 />
```

*   5. Configure the port for MidoNet-API. Swift proxy is running by default on port 8080, we need to configure Midonet API to run on a different port (8081). In /etc/tomcat/tomcat.conf edit the following:

      CONNECTOR_PORT="8081"

in /etc/tomcat/server.xml edit:

`   `<Connector port="8081" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />

*   6. Then restart tomcat:

      systemctl restart tomcat.service

### Install Midonet CLI

We next need to install the Midonet CLI pacakge:

*   1. Install the MidoNet CLI package:

      yum install python-midonetclient

*   2. Create the following file for authentication (this has to be exact):

      vi ~/.midonetrc

*   3. Edit ~/.midonetrc and add the following:

       [cli]
      api_url = http://<host_ip>:8081/midonet-api
      username = admin
      password = ADMIN_PASS
      project_id = admin

NOTE: The admin_pass is the same pass from your /root/keystonerc_admin file and also edit the <host_ip>

### Create Midonet Tunnel Zone and Register Midolman

We first need to create a Tunnel Zone in the Midonet CLI and then register the Midolman agent to it. This will allow the Midolman agent to send packets and communicate to the Midonet API.

*   1. Launch the MidoNet CLI:

      midonet-cli

You will see a prompt:

      midonet>

*   2. Create a tunnel zone:

      midonet> tunnel-zone create name vxlan type vxlan
      tzone0
      midonet> list tunnel-zone

If successful you will see:

      tzone tzone0 name vxlan type vxlan

*   3. Add hosts to the tunnel zone:

      midonet> list host
      host host0 name network alive true host host1 name compute alive true
`midonet> tunnel-zone tzone0 add member host host0 address `<host_IP>
      zone tzone0 host host0 address ip_address_host0

Remember to change <host_IP> to the IP of you box.

You can now leave the CLI again by typing `exit` or `ctrl-d`.

## Integrating Midonet with Packstack

### Keystone Integration

*   1. Create MidoNet API Service. As Keystone admin, execute the following command:

      source /root/keystonerc_admin
      keystone service-create --name midonet --type midonet --description "MidoNet API Service"

2. Create MidoNet Administrative User. As Keystone admin, execute the following commands:

      keystone user-create --name midonet --pass midonet --tenant services
      keystone user-role-add --user midonet --role admin --tenant services

NOTE: The "--pass midonet" can be "--pass <whateveryouwanthere>" just remember this password.

### Neutron Integration

#### Neutron Server and Packages

*   1. Install the following packets:

      yum install openstack-neutron python-neutron-plugin-midonet

*   2. Edit the /etc/neutron/neutron.conf file and edit this parameter in the [DEFAULT] section:

      core_plugin = midonet.neutron.plugin.MidonetPluginV2

*   3. Create the directory for the MidoNet plugin:

      mkdir /etc/neutron/plugins/midonet

*   4. Create the /etc/neutron/plugins/midonet/midonet.ini file and edit it to contain the following:

      [DATABASE]
      sql_connection = mysql://neutron:NEUTRON_DBPASS@<host_ip>/neutron
      [MIDONET]
      # MidoNet API URL
      midonet_uri = http://<host_IP>:8081/midonet-api
      # MidoNet administrative user in Keystone
      username = midonet
      password = midonet
      # MidoNet administrative user's tenant
      project_id = services

NOTE: The NEUTRON_DBPASS can be found in your packstack "answers" file in your /root/ directory. You can "cat /root/<packstackAnswersFileName> | grep NEUTRON_DB_PW" to find the password. ALSO NOTE: If you changed your midonet keystone password, please change the password = midonet parameter.

*   5. Create a symbolic link to direct Neutron to the MidoNet configuration:

      rm -f /etc/neutron/plugin.ini
      ln -s /etc/neutron/plugins/midonet/midonet.ini /etc/neutron/plugin.ini

*   6. In /etc/neutron/neutron.conf you need to comment out the following line:

      #service_plugins =

#### Neutron DHCP Agent

*   1. Edit the /etc/neutron/dhcp_agent.ini file to contain the following:

      [DEFAULT]
      interface_driver = neutron.agent.linux.interface.MidonetInterfaceDriver
      dhcp_driver = midonet.neutron.agent.midonet_driver.DhcpNoOpDriver
      use_namespaces = True
      enable_isolated_metadata = True

*   2. Add the following at the end of the file.

      [MIDONET]
      # MidoNet API URL
      midonet_uri = http://<host_IP>:8081/midonet-api
      # MidoNet administrative user in Keystone
      username = midonet
      password = midonet
      # MidoNet administrative user's tenant
      project_id = services

#### Finish Neutron Integration

Rebuild Neutron database:

      systemctl stop neutron-server
      mysql -e 'drop database neutron'
      mysql -e 'create database neutron'
      su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/midonet/midonet.ini upgrade kilo" neutron
      systemctl restart openstack-nova-api openstack-nova-scheduler openstack-nova-conductor
      systemctl start neutron-server

Restart neutron services:

      systemctl restart neutron-server
      systemctl restart neutron-dhcp-agent
      systemctl restart neutron-metadata-agent

### Nova Integration

#### Libvirt Configuration

*   1. We need to enable Cgroup in Libvirt for Midonet to work properly. To do this edit your /etc/libvirt/qemu.conf uncomment the following:

      user = "root"
      group = "root"

*   2. In the same file uncomment this seciont and add "/dev/net/tun" to it.. It should look like:

      cgroup_device_acl = [
         "/dev/null", "/dev/full", "/dev/zero",
         "/dev/random", "/dev/urandom",
         "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
         "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
         "/dev/net/tun"
      ]

*   3. Restart Libvirt:

      systemctl restart libvirtd.service

#### Nova Configuration

*   1. Please edit your /etc/nova/nova.conf and add/edit the following lines at the END of the file:

      [MIDONET]
      # MidoNet API server URI 
      midonet_uri = http://<host_IP>:8081/midonet-api
      # MidoNet username with admin role in keystone 
      username=midonet
      password=midonet
      # MidoNet provider tenant name
      project_id=services

NOTE: If you have changed your midonet keystone user password please put the new one in here

*   2. Restart Nova

      systemctl restart openstack-nova-api.service
      systemctl restart openstack-nova-cert.service
      systemctl restart openstack-nova-compute.service
      systemctl restart openstack-nova-consoleauth.service
      systemctl restart openstack-nova-scheduler.service
      systemctl restart openstack-nova-conductor.service
      systemctl restart openstack-nova-novncproxy.service

## Creating Initial Networks and Static Uplink

Use this section to create external connectivity on your all-in-one system. Please follow this exactly.

### Create External Network

We first need to create the External Network (fake) to be used for connectivity using the following two commands:

      neutron net-create ext-net --shared --router:external=True
      neutron subnet-create ext-net --name ext-subnet --allocation-pool start=200.200.200.2,end=200.200.200.254 --disable-dhcp --gateway 200.200.200.1 200.200.200.0/24

### Create Fake Uplink

      # We are going to create the following topology to allow the VMs reach external networks
      #
      #             +---------------+
      #                             |
      #                             | 172.19.0.1/30
      #          +------------------+---------------+
      #          |                                  |
      #          |     Fakeuplink linux bridge      |
      #          |                                  |
      #          +------------------+---------------+        UNDERLAY
      #                             | veth0
      #                             |
      #                             |
      #                             |
      # +------+  +-------+  +-------------+  +-----+  +-----+
      #                             |
      #                             |
      #                             |
      #               172.19.0.2/30 | veth1
      #          +------------------+----------------+        OVERLAY
      #          |                                   |
      #          |    MidonetProviderRouter          |
      #          |                                   |
      #          +------------------+----------------+
      #                             |  200.200.200.0/24
      #             +               |
      #             +---------------+----------------+

Create veth pair:

      ip link add type veth
      ip link set dev veth0 up
      ip link set dev veth1 up

Create a linux brige, set an IP address and attach veth0

      brctl addbr uplinkbridge
      brctl addif uplinkbridge veth0
      ip addr add 172.19.0.1/30 dev uplinkbridge
      ip link set dev uplinkbridge up

Enable IP forwarding:

      sysctl -w net.ipv4.ip_forward=1

Route packets to 'external' network to the bridge

      ip route add 200.200.200.0/24 via 172.19.0.2

In midonet-cli create a port in the provider router and bind it to the veth:

      # midonet-cli
      midonet> router list
      router router0 name MidoNet Provider Router state up 
      midonet> router router0 add port address 172.19.0.2 net 172.19.0.0/30
      router0:port0
      midonet> router router0 add route src 0.0.0.0/0 dst 0.0.0.0/0 type normal port router router0 port port0 gw 172.19.0.1
      midonet> host list
      host host0 name controller alive true
      midonet> host host0 add binding port router router0 port port0 interface veth1
      host host0 interface veth1 port router0:port0

Add masquerading to your external interface so connections coming from the overlay with addresses that belong to the external network are NATed. Also make sure these packets can be forwarded:

      iptables -t nat -I POSTROUTING -o eth0 -s 200.200.200.0/24 -j MASQUERADE
      iptables -I FORWARD -s 200.200.200.0/24 -j ACCEPT
      iptables -I FORWARD -d 200.200.200.0/24 -j ACCEPT

Now we can reach VMs from the underlay host with their floating IPs, and VMs can reach external networks as well (as long as the host has external connectivity).
