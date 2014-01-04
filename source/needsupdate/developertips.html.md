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

### Using koji and bodhi tools to find packages

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
