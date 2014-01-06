---
title: DeveloperTips
category: needsupdate
authors: kashyap, pmyers, rbowen
wiki_category: NeedsUpdate
wiki_title: DeveloperTips
wiki_revision_count: 12
wiki_last_updated: 2015-07-16
---

# Developer Tips

This page has a few handy tips for new developers to use. Developers should continually add to this page, as they find things that would be useful to others.

## Using virt-builder to quickly build a Fedora VM

Ensure you have new enough ( Fedora 19 and above) libguestfs package.

Build it:

    $ virt-builder fedora-20

Import the guest:

    $ virt-install --name f20vm1 --ram 2048 \
      --disk path=/home/foo/fedora-20.img --import

## Using koji and bodhi tools to find packages

[Koji](https://fedoraproject.org/wiki/Koji) is the build system that Fedora uses, and is also used for EPEL and RDO builds. [Bodhi](https://fedoraproject.org/wiki/Bodhi) is the tool that is used to review new builds for inclusion into official repositories. There are handy command line tools that you can install in Fedora to query both Koji and Bodhi. Here's how to use them for some simple things:

    $ sudo yum install -y koji bodhi-client

To find a list of the latest builds for a specific package across all releases:

    $ bodhi -L openstack-neutron
    dist-6E-epel-testing-candidate  openstack-neutron-2014.1-0.1.b1.el6
         f19-updates-candidate  openstack-neutron-2013.2-5.fc19
           f20-updates-testing  openstack-neutron-2013.2.1-1.fc20
         f20-updates-candidate  openstack-neutron-2013.2-6.fc20
                   f20-updates  openstack-neutron-2013.2.1-1.fc20

To find the latest build available in Koji for a specific package:

    $ koji latest-build f21 openstack-neutron
    Build                                     Tag                   Built by
    ----------------------------------------  --------------------  ----------------
    openstack-neutron-2014.1-0.1.b1.fc21      f21                   pbrady

A few handy tags that can be to be used with koji build system: `f20`,`epel7`, `dist-6E-epel-testing-candidate`

You can obtain all list of tags available by running:

    $ koji list-tags

And, query for builds:

    $  koji latest-build dist-6E-epel-testing-candidate openstack-neutron
    Build                                     Tag                   Built by
    ----------------------------------------  --------------------  ----------------
    openstack-neutron-2014.1-0.1.b1.el6       dist-6E-epel-testing-candidate  pbrady

Some packages (like *openstack-neutron*) have sub-packages, you can list all sub-packages of a parent package by running:

    $ koji buildinfo openstack-neutron-2014.1-0.1.b1.fc21
    BUILD: openstack-neutron-2014.1-0.1.b1.fc21 [486743]
    State: COMPLETE
    Built by: pbrady
    Volume: DEFAULT
    Task: 6331159 build (rawhide, /openstack-neutron:be96ca650ad6c02310875491d68bb64f139da543)
    Finished: Tue, 24 Dec 2013 12:56:17 CET
    Tags: f21
    RPMs:
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-nec-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/python-neutron-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-metering-agent-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-vpn-agent-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-midonet-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-nicira-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-brocade-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-hyperv-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-ml2-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-linuxbridge-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-openvswitch-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-ryu-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-bigswitch-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-metaplugin-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-plumgrid-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-mellanox-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/noarch/openstack-neutron-cisco-2014.1-0.1.b1.fc21.noarch.rpm
    /mnt/koji/packages/openstack-neutron/2014.1/0.1.b1.fc21/src/openstack-neutron-2014.1-0.1.b1.fc21.src.rpm
