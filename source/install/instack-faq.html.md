---
title: Instack FAQ
authors: bcrochet, bnemec, ccrouch, rbowen, rbrady, rlandy, slagle, sradvan
wiki_title: Instack FAQ
wiki_revision_count: 62
wiki_last_updated: 2015-02-13
---

# Instack FAQ

[← Deploying RDO using Instack](/install/deploying-rdo-using-instack/)

This page includes tips, fixes and debugging steps for Instack installs:

## I got a "disk is in use" error when deploying the Overcloud

If the undercloud machine was installed using LVM, when deploying overcloud nodes, you may see an error related to the disk being "in use". The workaround for this error is to:

    # Modify /etc/lvm/lvm.conf to set use_lvmetad to be 0
    vi /etc/lvm/lvm.conf
    use_lvmetad=0
    # Disable and stop relevant services
    systemctl stop lvm2-lvmetad
    systemctl stop lvm2-lvmetad.socket
    systemctl disable lvm2-lvmetad.socket
    systemctl stop lvm2-lvmetad

## Are there any example rc files for Overcloud deployment?

Example rc files to source before deploying the overcloud are included as part of the instack-undercloud package. Descriptions of the variables are below

Example deploy-overcloudrc file for deploying the overcloud on a virtual machine setup:

    /usr/share/instack-undercloud/deploy-virt-overcloudrc

Example deploy-overcloudrc file for deploying the overcloud on a bare metal machine setup:

    /usr/share/instack-undercloud/deploy-baremetal-overcloudrc

Descriptions of the variables in the rc files

*   NODES_JSON: path to a file of the JSON representation of the baremetal nodes. Documented in the next section
*   NeutronPublicInterface: Overcloud management interface name
*   OVERCLOUD_LIBVIRT_TYPE: Overcloud libvirt type: qemu or kvm
*   NETWORK_CIDR: neutron network cidr
*   FLOATING_IP_START: floating ip allocation start
*   FLOATING_IP_END: floating ip allocation end
*   FLOATING_IP_CIDR: floating ip network cidr
*   NEUTRON_NETWORK_TYPE: tenant network type: gre or vxlan
*   NEUTRON_TUNNEL_TYPES: supported tenant network tunnel types: gre or vxlan or gre,vxlan
*   COMPUTESCALE: # of overcloud compute nodes
*   BLOCKSTORAGESCALE: # of overcloud block storage nodes
*   SWIFTSTORAGESCALE: # of overcloud object storage nodes

## What is the NODES_JSON file format?

NODES_JSON in the deploy-overcloudrc file specifies a path to a JSON file and contains the data used to register nodes for baremetal provisioning. The JSON file should be in the following format.

For virt (note that if you used `instack-virt-setup` the file has already been created for you automatically):

            {
              "nodes":
                [
                  {
                    "memory": "4072",
                    "disk": "30",
                    "arch": "x86_64",
                    "pm_user": "stack",
                    "pm_addr": "192.168.122.1",
                    "pm_password": "contents of ssh private key go here",
                    "pm_type": "pxe_ssh",
                    "mac": [
                      "00:76:31:1f:f2:a0"
                    ],
                    "cpu": "1"
                  },
                  {
                    "memory": "4072",
                    "disk": "30",
                    "arch": "x86_64",
                    "pm_user": "stack",
                    "pm_addr": "192.168.122.1",
                    "pm_password": "contents of ssh private key go here",
                    "pm_type": "pxe_ssh",
                    "mac": [
                      "00:76:31:1f:f2:a0"
                    ],
                    "cpu": "1"
                  }
                ]
            }

For baremetal:

            {
              "nodes": [
                {
                  "pm_password": "ipmi password goes here",
                  "pm_type": "pxe_ipmitool",
                  "mac": [
                    "mac address of nic that will handle pxe boot goes here"
                  ],
                  "cpu": "4",
                  "memory": "32768",
                  "disk": "900",
                  "arch": "x86_64",
                  "pm_user": "ipmi username goes here",
                  "pm_addr": "ipmi ip address goes here"
                },
                {
                  "pm_password": "ipmi password goes here",
                  "pm_type": "pxe_ipmitool",
                  "mac": [
                    "mac address of nic that will handle pxe boot goes here"
                  ],
                  "cpu": "4",
                  "memory": "32768",
                  "disk": "900",
                  "arch": "x86_64",
                  "pm_user": "ipmi username goes here",
                  "pm_addr": "ipmi ip address goes here"
                }
              ]
            }

## How do I delete the Overcloud?

There are delete scripts included with the instack-undercloud package If you want to delete an overcloud and reset the environment to a state where you can deploy another overcloud. These steps only work if you used `instack-deploy-overcloud` to deploy the overcloud.

1. While logged into the undercloud node export the required variables into your shell in order to use the CLI tools for the undercloud and overcloud. If you copied the stackrc file into your home directory at the end of the undercloud installation, simply source that file. Alternatively, you can use the following command directly to set the needed environment variables.

      command $(sudo cat /root/stackrc | xargs)

2. Run one of the following examples that matches how you deployed the overcloud.

       instack-delete-overcloud

## How do I load new Overcloud images?

If new images are made available for download, or you build new images, you will need to load them into glance on the Undercloud. You can follow these steps to do so.

1. While logged into the undercloud node export the required variables into your shell in order to use the CLI tools for the undercloud and overcloud. If you copied the stackrc file into your home directory at the end of the undercloud installation, simply source that file. Alternatively, you can use the following command directly to set the needed environment variables.

      command $(sudo cat /root/stackrc | xargs)

2. Use the following command to load new images. Pass the command whatever new image file you want loaded into glance.

      tripleo load-image -d overcloud-control.qcow2

## How do I view the Undercloud Dashboard when using a remote virt host?

If your virt host is a remote system, and not the same system that you're running your web browser from, you can create an ssh tunnel from the virt host to the instack virtual machine for connectivity. On the virt host enter the following:

       sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
      `  ssh -g -N -L 8080:192.168.122.55:80 `hostname` `

where 192.168.122.55 is the IP address of the instack virtual machine. Update appropriately for your environment. With the ssh tunnel created you can launch a browser on a system with connectivity to the virt host and go to <http://><virt-host>:8080/dashboard and the dashboard should appear. If you need to connect remotely through the virt host, you can chain ssh tunnels as needed.

When logging into the dashboard the default user and password are found in the /root/stackrc file on the instack virtual machine, OS_USERNAME and OS_PASSWORD. You can read more about using the dashboard in the User Guide.

## What configuration changes does `instack-virt-setup` make to the virt host?

`instack-virt-setup` makes configuration changes to the virt host to allow for using a full virtual environment for testing an Overcloud deployment.

These changes include:

*   Installs various packages such as openvswitch, libvirt, qemu, etc.
*   Adds a new openvswitch bridge called `brbm`
*   Adds a new libvirt network also called `brbm`, which is configured to use the above bridge.
*   Reconfigures libvirtd to set the domain socket group ownership to the `libvirtd` group. This allows for easier interaction with libvirtd on the host
*   Adds the user running `instack-virt-setup` to the `libvirtd` group.

## How do I build RHEL 7 Overcloud images?

*   Download the fedora-user.qcow2 image found here: <https://repos.fedorapeople.org/repos/openstack-m/tripleo-images-rdo-juno/fedora-user.qcow2> This is the image that will be booted to test that your overcloud is working properly. **Important Note:** If you are deploying to a virtual environment, it is necessary that you use this specific image and not a generic cloud image from Fedora. As of this writing the stock Fedora cloud image has problems running in nested virt on RHEL 7.
*   Install `instack-undercloud` on the system to be used for the image builds.
*   Set the following environment variables in your shell, substituting appropriate values where necessary. In particular, any value wrapped in [] needs to be replaced with the appropriate value for your environment. The REG_USER and REG_PASSWORD can optionally be replaced by obtaining an activation key from your subscription administrator and setting REG_ACTIVATION_KEY.

<!-- -->

    export NODE_DIST="rhel7"
    export DIB_CLOUD_IMAGES="[http://server/path/containing/image]"
    # A cloud guest image downloaded from the Red Hat Customer Portal
    export BASE_IMAGE_FILE="rhel-guest-image-7.0-20140930.0.x86_64.qcow2"
    export REG_METHOD=portal
    # Find this with `subscription-manager list --available`
    export REG_POOL_ID="[pool id]"
    export REG_PASSWORD="[your password]"
    export REG_USER="[your username]"
    export REG_REPOS="rhel-7-server-extras-rpms,rhel-ha-for-rhel-7-server-rpms,rhel-7-server-optional-rpms"

*   Run `instack-build-images`.
