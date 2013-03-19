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

# Quickstart

RDO Quick Start Set up a single machine or several servers Using RDO on Fedora, RHEL, or derivatives is a quick and easy process. The estimated time for setting up an OpenStack server is approximately 15 minutes and can be as short as 4 steps. First, we’ll explain how to set up OpenStack on one server, and afterward, we will detail what you have to do to set up additional OpenStack nodes and get them working with each other.

         Step 0: Install Linux 

If you have not done so already, install Fedora, Red Hat Enterprise Linux, CentOS, Scientific Linux, or another Fedora or Enterprise Linux derivative. Just as a traditional OS relies on the hardware beneath it, so too does the an OpenStack cloud operating system rely relies rests on the foundation of an Operating System and hypervisor and OS platform. <-- changed "OS" to "Operating System" here, as "OS" in this context could be confused as "OpenStack".

         Step 1: Add the repository 

`   sudo yum localinstall `[`http://openstack.redhat.com/releases/rdo-el6.noarch.rpm`](http://openstack.redhat.com/releases/rdo-el6.noarch.rpm)

         Step 2: Install packages

Install PackStack using the ‘yum’ command. This will takes a few minutes to install, depending on your network connection and disk speed.

         $ sudo yum install -y openstack-packstack 

If you need commercial support for OpenStack, please consider Red Hat's product offering Red Hat OpenStack [link], an enterprise-hardened OpenStack with support and certification.

         Step 3: Set up OpenStack with ‘packstack’ 

PackStack provides two helpful "basic configuration" options possibilities: a single machine running all of the core OpenStack services, and or a single control node with several computer nodes on the same network. a) To install a single host as both a control and compute node machine running all of the core OpenStack services: <-- mirrored the wording of this option from above, to be super clear.

         $ sudo packstack --install-hosts=`<Host IP address>` --novacompute-privif=lo

--novanetwork-privif=lo b) To install a single controller control node and multiple compute nodes: <-- mirrored the wording of this option from above, to be super clear.

         $ sudo packstack --install-hosts=CONTROL_HOSTNODE,COMPUTE_NODE1,COMPUTE_NODE2,...

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet. All , and all other configuration options will use default values. This process can take a few minutes per host. Once the process is complete, you can log in to the OpenStack web interface "Horizon" by going to <http://CONTROL_NODE/dashboard>. The username is "admin". The password can be found in the file keystonerc_admin in the /root/ directory of the control node. For additional flexibility during installation, consult the advanced installation guide [link].
