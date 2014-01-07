---
title: RDO test day January 2014
authors: adarazs, admiyo, amuller, cgirda, dbaxps, derez, dneary, dron, edu, eglynn,
  eharney, eyepv6, flaper87, gfidente, gparisse, gszasz, ihrachys, jary, jbernard,
  jistr, jpichon, jruzicka, kashyap, krwhitney, larsks, mbourvin, mjs, mpavlase, mrhodes,
  mrunge, ndipanov, nmagnezi, oblaut, ohochman, panda, pixelbeat, rbowen, rlandy,
  shardy, tkammer, verdurin, vladan, whayutin, yeylon, yrabl, zaitcev
wiki_title: RDO test day January 2014
wiki_revision_count: 80
wiki_last_updated: 2014-02-19
---

# RDO test day January 2014

We plan to hold a RDO test day on January 7th and 8th, 2014. This will be coordinated through the #rdo channel on Freenode, and through this wiki and the [rdo-list mailing list](http://www.redhat.com/mailman/listinfo/rdo-list).

We'll be testing the first Icehouse milestone release, and we'd like to test the scenarios enumerated below. If you can do any testing on your own ahead of time, that will help ensure that everyone isn't encountering the same problems.

## Who's Participating

*Add your name, and how you're able to help out*

*   adarazs (Attila Darazs) - Testing deployment, automated testing readiness
*   ajeain (Ami Jeain) - Testing Core components, IRC
*   amuller (Assaf Muller) - Testing network components, IRC
*   Dafna (Dafna Ron) - Testing semi distributed system with gluster backend for cinder and glance, IRC
*   dkorn (Daniel Korn ) - Testing Core components, IRC
*   dneary (Dave Neary) - Testing install of all in one and 2 node set-up in virt-manager instances
*   eharney (Eric Harney) - Testing cinder, IRC
*   flaper87 (Flavio Percoco) - Testing glance All-in-One: different glance drivers only, IRC
*   giulivo (Giulio Fidente) - Testing fully distributed system with EMC backend for cinder, IRC
*   gszasz (Gabriel Szasz) - Testing Core components, IRC
*   ihrachys (Ihar Hrachyshka) - Testing All-in-One w/ Neutron OVS (no tunnels, real provider net) Networking
*   jhenner (Jaroslav Henner) Testing core, IRC
*   larsks (Lars Kellogg-Stedman) - Testing, IRC, Documentation
*   mrunge (Matthias Runge) - Testing Core components, IRC,
*   nmagnezi (Nir Magnezi) - Testing Network and Core components, IRC
*   mpavlase (Martin Pavlasek) - Testing, IRC
*   oblaut(Ofer Blaut) - Testing Network components, IRC
*   ohochman (Omri Hochman) - Testing foreman and Core components, IRC
*   panda (Gabriele Cerami) - Testing All-in-One RHEL, ML2 plugin, CI, IRC
*   pbrady (Pádraig Brady) - Testing Core components, IRC
*   rbowen (Rich Bowen) - Testing, IRC, Documentation
*   tshefi (Tzach Shefi) - Testin fully distributed system with local swift backend for glance, IRC
*   ukalifon (Udi Kalifon ) - Testing Core components, IRC
*   weshay ( Wes Hayutin ) - Testing various config, CI, IRC
*   yeylon (Yaniv Eylon) - Testing foreman and Core components, IRC
*   yfried (Yair Fried) - Testing Network components, IRC
*   yrabl (Yogev Rabl) - Testin fully distributed system with guster backend for cinder, IRC
*   jbernard (Jon Bernard) - Testing cinder All-in-One: LVM and Gluster drivers, IRC
*   kashyap (Kashyap Chamarthy) - Testing, IRC, Documentation -- minimal, 2 node set-up, hand-configured, Neutron w/ GRE+OVS, on F20.
*   zaitcev (Pete Zaitcev) - Testing, Swift
*   rlandy (Ronelle Landy) - (newbie) Testing all-in-one install, Documentation
*   mrhodes (Marco Rhodes) - Testing all-in-one install, Documentation
*   tkammer (Tal Kammer) - Testing deployment, automated testing readiness
*   ewarszaw (edu) - [Cinder] All-in-One - RHEL 6.5
*   eglynn (Eoghan Glynn) - Testing Ceilometer
*   mbourvin (Meital Bourvine) - Testing all-in-one
*   jpichon (Julie Pichon) - Testing all-in-one
*   shardy (Steven Hardy) - Testing Heat
*   ndipanov - Testing all-in-one nova, IRC
*   verdurin - Testing all-in-one, IRC
*   jistr (Jiri Stransky) - Testing Foreman (2 node) on VMs, IRC

## Prerequisite for Test Day

We'll have packages for the following platforms:

*   Fedora 20
*   RHEL 6.5
*   CentOS 6
*   CentOS 6.5

You'll want a fresh install with latest updates installed. (Fresh so that there's no hard-to-reproduce interactions with other things.)

## How To Test

    sudo yum install http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

*   Check for any [ Workarounds](Workarounds_2014_01) required for your platform before the main installation
*   For Packstack based deployment start at step 2 of -- <http://openstack.redhat.com/Quickstart#Step_2:_Install_Packstack_Installer>
*   For Foreman based deployment on RHEL & its derivatives, -- <http://openstack.redhat.com/Virtualized_Foreman_Dev_Setup>

### Test cases and results

The things that should be tested are listed on the [Tested Setups](TestedSetups_2014_01) page.

*   Pick an item from the list
*   Go through the scenario as though you were a beginner, just following the instructions. (Check the [ Workarounds](Workarounds_2014_01) page for problems that others may have encountered and resolved.)
*   KEEP GOOD NOTES. You can use <https://etherpad.openstack.org/p/rdo_test_day_jan_2014> for these notes. Reviewing other peoples' notes may help you avoid problems that they've already encountered.
*   Compare your results to the CI results @ <https://prod-rdojenkins.rhcloud.com/>

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-packstack](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-packstack), [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder), [openstack-neutron](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-neutron),[openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift) or [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC (#rdo, freenode.net) and we will help you.

Once you have completed the tests, add your results to the table on the [TestedSetups](TestedSetups_2014_01) page, following the examples already there. Be sure to check the [ Workarounds](Workarounds_2014_01) page for things that may have already have fixes or workarounds.

"Setting up Multi-Node OpenStack RDO Havana + Gluster Backend + Neutron VLAN" on CentOS 6.5 with both Controller and Compute nodes each one having just two Ethernet adapters per Andrew Lau

Setup

* Controller node: Nova, Keystone, Cinder, Glance, Neutron (hv02)
* Compute node: Nova (nova-compute), Neutron (openvswitch-agent) (hv01)

<http://bderzhavets.blogspot.com/2013/12/attempt-to-reproduce-getting-started.html>
