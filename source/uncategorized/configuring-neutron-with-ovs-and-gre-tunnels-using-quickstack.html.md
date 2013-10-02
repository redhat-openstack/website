---
title: Configuring Neutron with OVS and GRE Tunnels using quickstack
authors: gdubreui
wiki_title: Configuring Neutron with OVS and GRE Tunnels using quickstack
wiki_revision_count: 22
wiki_last_updated: 2013-10-02
---

# Configuring Neutron with OVS and GRE Tunnels using quickstack

For now, quickstack neutron-controller is doing only GRE, it will therefore manage all the tunnels between the controller and the networker automatically.

*   1. Assuming two NICs
*   2. The physical interface (public/external network) IP will be moved to the br-ex OVS bridge
*   3. The br-ex should be activated as well

Besides the other parameters, the values required via params.pp or foreman variables that must be added are similar to this example:

    $private_interface             = 'eth1'
    $public_interface              = 'eth2'
    $metadata_proxy_shared_secret  = 'CHANGEME'

    # Floating IPs (external network br-ex)
    $public_network_name = 'public'
    $public_cidr = '10.16.16.0/22'
    $public_gateway_ip = '10.16.19.254'
    $public_allocation_pools_start = '10.16.18.1'
    $public_allocation_pools_end  = '10.16.18.254'

## Notes

*   The public_cidr should correspond to the existing physical network the host is attached to.
*   The public_gateway_ip is usually the default gateway
*   The allocation pools, will provide a range of foating IPs

The external/public bridge setup (br-ex) must be configured at the end of the deployment process.
If not then run this command with your values:

    neutron net-create external --provider:network_type local --router:external true --shared  
    neutron subnet-create external 10.16.16.0/22 --disable-dhcp --allocation-pool start=10.16.18.1,end=10.16.18.254 --gateway=10.16.19.254

## What else?

Workflow for a Per Tenant networks/routers environment

*   Create external network and subnet (admin)
*   For each tenant
    -   Create a network/subnet/router (admin)
    -   Add Security Groups rules for the tenant (tenant)
