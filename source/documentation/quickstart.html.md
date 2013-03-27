---
title: Quickstart
category: documentation
authors: apevec, dneary, garrett, jasonbrooks, jlibosva, mmagr, pixelbeat, pmyers,
  rbowen
wiki_category: Documentation
wiki_title: Quickstart
wiki_revision_count: 141
wiki_last_updated: 2015-06-30
---

__NOTOC__

<div class="bg-boxes">
<div class="row hero-unit">
<div class="offset4 span7 pull-l">
# RDO Quickstart

Deploying RDO is a quick and easy process. Setting up an OpenStack cloud takes approximately 12 minutes, and can be as short as 4 steps.

First, we'll explain how to set up OpenStack on one server, and afterward, we will show you how to set up additional OpenStack nodes and get them working with each other.

</div>
</div>
<div class="row">
<div class="offset4 span7 pull-s">
### Step 0: Prerequisites

**Software:** Install Fedora, Red Hat Enterprise Linux (RHEL), or one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, etc. Just as a traditional OS relies on the hardware beneath it, so too does the OpenStack cloud operating system rely on the foundation of a hypervisor and OS platform.

**Hardware:** Ideally, you should install RDO on a machine with a healthy amount of RAM (at least 2GB) and processors with hardware virtualization extensions, although you may run OpenStack in a less-capable machine or a virtual machine with reduced performance. You'll need one network adapter for the single-host OpenStack install.

**Network:** Every VM instance you launch with OpenStack is issued a private IP address, which connects the instance to its host and to other instances. To make your instances accessible to other machines on your network, you'll need to issue the instance a floating IP address. Identify a range of addresses on your network that OpenStack use for floating IP addresses. For tips on identifying a floating IP range, see WHERE.

### Step 1: Software repositories

As root, run the following command:

**For Fedora:**

*working command:*

    sudo curl -sO /etc/yum.repos.d/fedora-openstack-grizzly.repo http://repos.fedorapeople.org/repos/openstack/openstack-grizzly/fedora-openstack-grizzly.repo

*aspirational command:*

    sudo yum localinstall http://openstack.redhat.com/releases/rdo-grizzly-fedora-release.rpm

**For RHEL and derivatives:**

*working command:*

    sudo curl -sO /etc/yum.repos.d/epel-openstack-grizzly.repo http://repos.fedorapeople.org/repos/openstack/openstack-grizzly/epel-openstack-grizzly.repo

*aspirational command:*

    sudo yum localinstall -y http://openstack.redhat.com/releases/rdo-grizzly-epel-release.rpm

[Given an rdo-release package (which, for EL, configured RDO & EPEL repos), this command could become "yum localinstall URL-TO-RDO-RELEASEPACKAGE" -- echo, separate EPEL install wouldn't be needed.]

### Step 2: Install Packstack Installer

*working command:*

    sudo yum install -y net-tools &amp;&amp; sudo yum install -y openstack-packstack --enablerepo=updates-testing

[trim the --enablerepo=updates-testing for EL]

*aspirational command:*

    sudo yum install -y openstack-packstack

[Openstack-packstack should be made to depend on net-tools, which would remove installing net-tools from this step (required for Fedora). Openstack-packstack isn't in the standard Fedora repos right now, but in updates-testing. If packstack were in the RDO repo, the --enablerepo argument wouldn't be required.]

### Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command, including your test machine's IP address.

    packstack --install-hosts=$YOURIP --novacompute-privif=lo --novanetwork-privif=lo --novanetwork-floating-range=XX.XX.XX.XX/XX

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface "Horizon" by going to <http://CONTROL_NODE/dashboard>. The username is "admin". The password can be found in the file keystonerc_admin in the /root/ directory of the control node.

[on F18, no auth would work until [chown -R keystone:keystone /etc/keystone/ssl/\*] [also need to "firewall-cmd --permanent --add-service=http" to keep dash accessible between reboots] [had to "service openstack-nova-conductor start" at least following reboot] [As of last Fedora and EL tests, setenforce 0 was required]

------------------------------------------------------------------------

# Running an Instance

### Step 1: Visit the Dashboard

Log in to the Openstack dashboard at <http://CONTROL_NODE/dashboard>. The username is "admin". The password can be found in the file keystonerc_admin in the /root/ directory of the control node.

### Step 2. Enable SSH on your default security group.

Once logged in to the OpenStack dashboard, click the "Project" tab in the left-side navigation menu, and then click "Access & Security" under the heading "Manage Compute." Under the "Security Groups" heading, click the "Edit Rules" button for the "default" security group. Click the "Add Rule" button, and in the resulting dialog, enter "22" in the "Port" field, and then click the "Add" button.

### Step 3: Create or import a key pair.

In the left-side navigation menu, click "Access & Security" under the heading "Manage Compute." In the main poriton of the screen, click the tab labeled "Keypairs," and choose either to "Create Keypair" or "Import Keypair." The "Create Keypair" dialog will prompt you to supply a keypair name before downloading a private key to your client. The "Import Keypair" option will prompt you to provide a name and a public key to use with an existing private key on your client.

### Step 4: Add an image.

In the left-side navigation menu, click "Images & Snapshots" under the heading "Manage Compute." Click the "Create Image" button, located in the upper-right portion of the screen. In the resulting dialog box, enter "Cirros" in the "Name" field, "[https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"](https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img") in the "Image Location" field, choose "QCOW2" from the "Format" drop-down menu, leave the "Minimum Disk" and "Minimum Ram" fields blank, check the "Public" box, and click the "Create Image" button.

### Step 5: Launch the instance.

In the main portion of the screen, under the "Images" heading, click the "Launch" button for the "Cirros" image. In the resulting dialog, provide a name in the "Instance Name" field, and click the "Launch" button.

### Step 6: Associate Floating IP

In the main portion of the screen, under the "Instances" heading, click the "More" button, followed by the "Associate Floating IP" link for the instance you just launched. You should see both public and private IP addresses listed in the "IP Address" column for your instance.

### Step 6: SSH to Your Instance

[Hmm, also, the user data injection bit seems not to be working for this cirros image:

"wget: server returned error: HTTP/1.1 404 Not Found clouduserdata: failed to read user data url: <http://169.254.169.254/20090404/userdata> WARN: /etc/rc3.d/S99clouduserdata failed"

This one does work: <http://mattdm.fedorapeople.org/cloud-images/Fedora18-Cloud-x86_64-latest.qcow2>]

[All right, it's running, but you can't ssh to it from the machine w/ your web browser: aka, the one w/ your private key from step 3 unless you've set up your floating IP pool correctly and then associated one of the addresses with your instance, neither of which we've discussed yet. Discussion TK. I mean, yes, you can have a VM running, but if you can't reach it from a client on your network... big deal. The floating IP stuff absolutely has to be part of this part two of the quickstart, IMO.]

------------------------------------------------------------------------

### Adding a second compute node

Expanding your single-node OpenStack cloud to include a second compute node requires a second network adapter: in order for our pair of nodes to share the same private network, we must replace the "lo" interface we used for the private network with a real nic.

1.  Edit the answer file generated during the initial packstack setup. You'll find it in the directory from which you ran packstack.
    vi $youranswerfile

Change the values for "CONFIG_NOVA_COMPUTE_PRIVIF" and "CONFIG_NOVA_NETWORK_PRIVIF" from "lo" to "eth1" (substitute the correct name for your second nic, if needed)

Change the value for "CONFIG_NOVA_COMPUTE_HOSTS" from "\(YOUR_1st_HOST_IP" to "\)YOUR_1st_HOST_IP,$YOUR_2nd_HOST_IP"

1.  Run packstack again, specifiying your modified answer file:
    sudo packstack --answer-file=$youranswerfile

Packstack will prompt you for the root password for each of your nodes.

### Setting your floating IP range

OpenStack instances receive a private IP address through which they can reach each other and through which hosts can reach them. In order to access these instances from other machines in your network, such as your workstation, the instances will need to be allocated a "floating IP." Packstack automatically configures this with a default that may well be wrong for your network. [CK it's wrong in our network, at least, maybe a better guess is made on other networks -- I must test this].

Should be able to provide the range on as a packstack argument, but addresses aren't validating. I filed a bug: <https://bugzilla.redhat.com/show_bug.cgi?id=924010>.

1.  Identify an open chunk of addresses on your network.
2.  If you don't know (best), and can't ask someone who does know (next best), you can make an intelligent guess by steering well clear of the range you typically get DHCP addresses in, by picking a fairly small range (/29 gives an 8 address range, 6 of which will be usable, so, like 192.168.1.56/29 is a range of 192.168.1.56-63, with 57-62 usable) and by using nmap to check if hosts are up in the range you're guessing at (nmap 192.168.1.56/29).
3.  Either supply packstack with this initially, or do it afterward. Before will be simpler.

</div>
</div>
<div class="row">
<div class="offset2 span8">

------------------------------------------------------------------------

Notes: An F18 cloud image in qcow format is available here: <http://mattdm.fedorapeople.org/cloud-images/Fedora18-Cloud-x86_64-latest.qcow2>

</div>
</div>
