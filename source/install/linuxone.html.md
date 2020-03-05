---
title: LinuxONE How-to
category: documentation
authors: shilinh@cn.ibm.com, fulong.wang@cn.ibm.com
---
The instructions provided below specify the steps to deploy OpenStack Train version on Linux on IBM Z or IBM LinuxONE for

* RHEL (8.0)

# General Notes:

* Please make sure the system hardware model you will deploy on is at least IBM z13 or above, lower than this model is not supported. 
* If no explicit state, the steps need to be performed on all relevant nodes.
* To simplify this doc, we use root user to create this demo, but a normal user to perform the deploy may be required in certain case and it’s ok, in that case you will need create a new OS account and configure sudo for the system.

# Prerequisites

Using Packstack, you can perform single-node/multi-node deployment by customizing the answer file for installation. In this guide, we will demonstrate how to perform a single-node deployment (that is one node to provide the controller service + compute service + network service, etc).

## Software
Red Hat Enterprise Linux (RHEL) 8 is the only verified version at the creation time of this how-to, we will update this guide if we verify other releases and Linux distributions. 

## Hardware 
Here is the minimum recommended configuration for an LPAR of IBM Z or IBM LinuxONE system. It should have at least 16GB RAM, 2 logical IFLs configured with hardware virtualization extensions, and two network adapters.

| Server | CPU | Memory | Storage | Network Adapter |
| ------ | --- | ------ | ------- | --------------- |
| Physical Servers| 2 logical IFLs | >= 16GB | 50 GB | 1 x Admin NIC (can be shared OSA port) 1 x Data NIC (dedicate OSA port) | 

*If you perform a single-node deployment, please allocate more memory on the host to gain a stable deployment. 

## Install Operating System on an LPAR

Install a base operating system on the LPAR, minimum installation is OK.
 
Follow below RHEL8 official installation guide, if you are not familiar with the installation process. 
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/performing_a_standard_rhel_installation/installing_red_hat_enterprise_linux_on_ibm_z

## Disable NetworkManager

For a working and stable deployment, below services are recommended to be disabled and stopped, but with the traditional network service enabled and up.

Follow this guide for the details:
* https://access.redhat.com/solutions/4365931 

Issue below commands on the terminal of every participated node.

```Shell
systemctl disable firewalld.service
systemctl stop firewalld.service
systemctl disable NetworkManager.service
systemctl stop NetworkManager.service
systemctl enable network.service
systemctl start network.service
```

## Make sure your IP and hostname were listed in /etc/hosts.
```Shell
cat /etc/hosts

172.16.36.194   	lpar94
```
# Software repositories
## Enable YUM repos
You need enable Redhat subscription to get update packages from Red Hat, and add following repos to get OpenStack packages and OpenStack dependency packages.

```Shell
[rdo-train-upstream]
name=rdo-train-upstream
baseurl=https://trunk.rdoproject.org/centos8-train/puppet-passed-ci/
enabled=1
gpgcheck=0
[rdo-train-linuxone-deps]
name=rdo-train-linuxone-deps
baseurl=http://linuxone.cloud.marist.edu:8080/repos/rdo/rhel8.0/deps/
enabled=1
gpgcheck=0
```

## Make sure to use latest yum repo
```Shell
yum clean all
```

## Disable virt module by issuing following command
```Shell
dnf module disable virt
```

#  Installing Packstack Installer

## Prepare the answer file

Now OVN is not supported in OpenStack on LinuxONE, we need use Openvswitch for network support, make sure your packstack answer file has following lines:

```Shell
CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch,l2population
CONFIG_NEUTRON_L2_AGENT=openvswitch
```

For a single-node deployment, you can configure the parameter “CONFIG_CONTROLLER_HOST” and the parameter “CONFIG_COMPUTE_HOSTS” with the same IP address. 

For a multi-node deployment (like in this guide), you should configure the parameter “CONFIG_CONTROLLER_HOST” and the parameter “CONFIG_COMPUTE_HOSTS” with different IP address. The parameter “CONFIG_COMPUTE_HOSTS” can be configured with multiple IP addresses separated with comma, thus you can configure multiple compute nodes in one config file.

##  Installing packstack installer on your controller node
On your controller node install packstack by issuing below command on a terminal window.
```Shell
yum -y install openstack-packstack
```
## Make sure your IP and hostname is lised in /etc/hosts
```Shell
cat /etc/hosts
```


# Running Packstack to install OpenStack
## Single-node/Multi-node deployment

Whether you perform single-node deployment or multi-node deployment, the packstack command to run is the same. The difference is in the answer file, you will need to assign different IP addresses for different roles as descripted above.
On your controller node, run below command to start the OpenStack deployment. 

## Use the answer file to run packstack
```Shell
packstack --answer-file=train_linuxone.txt
```

## Command output
Below is a normal setup log for reference. During a multi-node deploy, the script will ask for root password for all relevant nodes in your configuration.
```Shell
[root@lpar94 ~]# packstack --answer-file=train_linuxone.txt
Welcome to the Packstack setup utility
The installation log file is available at: /var/tmp/packstack/20200212-182922-yfne4u4r/openstack-setup.log
Installing:
Clean Up                       [ DONE ]
Discovering IP protocol version           [ DONE ]
Setting up ssh keys                 [ DONE ]
Preparing servers                  [ DONE ]
Pre installing Puppet and discovering hosts’ details [ DONE ]
Preparing pre-install entries            [ DONE ]
Setting up CACERT                  [ DONE ]
Preparing AMQP entries                [ DONE ]
Preparing MariaDB entries              [ DONE ]
Fixing Keystone LDAP config parameters to be undef if empty[ DONE ]
Preparing Keystone entries              [ DONE ]
Preparing Glance entries               [ DONE ]
Checking if the Cinder server has a cinder-volumes vg[ DONE ]
Preparing Cinder entries               [ DONE ]
Preparing Nova API entries              [ DONE ]
Creating ssh keys for Nova migration         [ DONE ]
Gathering ssh host keys for Nova migration      [ DONE ]
Preparing Nova Compute entries            [ DONE ]
Preparing Nova Scheduler entries           [ DONE ]
Preparing Nova VNC Proxy entries           [ DONE ]
Preparing OpenStack Network-related Nova entries   [ DONE ]
Preparing Nova Common entries            [ DONE ]
Preparing Neutron API entries            [ DONE ]
Preparing Neutron L3 entries             [ DONE ]
Preparing Neutron L2 Agent entries          [ DONE ]
Preparing Neutron DHCP Agent entries         [ DONE ]
Preparing Neutron Metering Agent entries       [ DONE ]
Checking if NetworkManager is enabled and running  [ DONE ]
Preparing OpenStack Client entries          [ DONE ]
Preparing Horizon entries              [ DONE ]
Preparing Swift builder entries           [ DONE ]
Preparing Swift proxy entries            [ DONE ]
Preparing Swift storage entries           [ DONE ]
Preparing Gnocchi entries              [ DONE ]
Preparing Redis entries               [ DONE ]
Preparing Ceilometer entries             [ DONE ]
Preparing Aodh entries                [ DONE ]
Preparing Puppet manifests              [ DONE ]
Copying Puppet modules and manifests         [ DONE ]
Applying 172.16.36.194_controller.pp
172.16.36.194_controller.pp:             [ DONE ]      
Applying 172.16.36.194_network.pp
172.16.36.194_network.pp:              [ DONE ]    
Applying 172.16.36.194_compute.pp
172.16.36.194_compute.pp:              [ DONE ]    
Applying Puppet manifests              [ DONE ]
Finalizing                      [ DONE ]
 **** Installation completed successfully ******
Additional information:
 * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
 * File /root/keystonerc_admin has been created on OpenStack client host 172.16.36.194. To use the command line tools you need to source the file.
 * To access the OpenStack Dashboard browse to http://172.16.36.194/dashboard .
Please, find your login credentials stored in the keystonerc_admin in your home directory.
 * The installation log file is available at: /var/tmp/packstack/20200212-182922-yfne4u4r/openstack-setup.log
 * The generated manifests are available at: /var/tmp/packstack/20200212-182922-yfne4u4r/manifests
 * Note temporary directory /var/tmp/packstack/81e7946e76234028b827e67e2b46b5a8 on host 172.16.36.194 was not deleted for debugging purposes.
```
# Post deployment actions for a working installation.

## Make sure following options in /etc/nova/nova.conf are same as below.
Make sure to change `my_ip` option

[DEFAULT] Section
```Shell
compute_driver = libvirt.LibvirtDriver
my_ip = CHANGE_TO_YOUR_SYSTEM_IP_ADDRESS
config_drive_format = iso9660
force_config_drive = True
```
[libvirt] Section
```Shell
virt_type = kvm
cpu_mode = none
use_usb_tablet = False
inject_partition = -2
```
[vnc] Section
```Shell
enabled = False
```

# Cloud images for testing

You can get a cloud image for s390x architect for testing purpose from below location. 
* https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-s390x.img

# Next steps
Now that your single node OpenStack instance is up and running, you can read on about configuring a floating IP range, configuring RDO to work with your existing network, or about expanding your installation by adding a compute node. 
