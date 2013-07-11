---
title: Networking
category: troubleshooting
authors: dneary, forrest, palmtown, rbowen
wiki_category: Troubleshooting
wiki_title: Networking
wiki_revision_count: 27
wiki_last_updated: 2013-12-19
---

# Networking

__NOTOC__

## Troubleshooting network issues

### Toolchain

A number of tools come in handy when troubleshooting Neutron/Quantum networking issues.

*   [Open vSwitch](//openvswitch.org/) ([documentation](http://openvswitch.org/support/))
    -   [ovs-vsctl](//openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-vsctl.8) - tool for querying and configuring ovs-vswitchd
    -   [ovs-ofctl](//openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-ofctl.8) - OpenFlow configuration tool
    -   [ovs-dpctl](//openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-vsctl.8) - query and configure Open vSwitch datapaths
*   [iproute tools](//www.linuxfoundation.org/collaborate/workgroups/networking/iproute2)
    -   [iproute2 HOWTO](//www.policyrouting.org/iproute2.doc.html)
    -   [iproute2 examples](//www.linuxfoundation.org/collaborate/workgroups/networking/iproute2_examples)

#### Useful commands

...

### Common issues

*   I can create an instance, but cannot SSH or ping it
*   I cannot associate a floating IP with an instance

...

### Useful resources

*   [Quantum L3 workflow](//docs.openstack.org/trunk/openstack-network/admin/content/l3_workflow.html)
*   [Network troubleshooting](//docs.openstack.org/trunk/openstack-ops/content/network_troubleshooting.html)

...

<Category:Troubleshooting> <Category:Documentation> [Category:In progress](Category:In progress)
