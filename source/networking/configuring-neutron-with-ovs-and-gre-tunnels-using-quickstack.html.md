---
title: Configuring Neutron with OVS and GRE Tunnels using quickstack
authors: gdubreui
---

# Configuring Neutron with OVS and GRE Tunnels using quickstack

For now, quickstack neutron-controller is doing only GRE, it will therefore manage all the tunnels between the controller and the networker automatically.

*   1. Assuming two NICs
*   2. The physical interface (public/external network) IP will be moved to the br-ex OVS bridge
*   3. The br-ex should be activated as well

Besides other needed parameters, make sure you have the values required, for example:

    # params.pp excerpt but could be via foreman variables
    $private_interface             = 'eth1'
    $public_interface              = 'eth0'
    $metadata_proxy_shared_secret  = 'CHANGEME'

    # Floating IPs (external network br-ex)
    $public_network_name = 'public'
    $public_cidr = '10.0.0.0/22'
    $public_gateway_ip = '10.1.1.254'
    $public_allocation_pools_start = '10.0.3.1'
    $public_allocation_pools_end  = '10.0.3.254'

## Notes

*   The public_cidr should correspond to the existing physical network the host is attached to.
*   The public_gateway_ip is usually the default gateway
*   The allocation pools, will provide a range of foating IPs

The external/public bridge setup (br-ex) must be configured at the end of the deployment process.
If not then run this command as openstack admin, with your values:

    neutron net-create external --provider:network_type local --router:external true --shared  
    neutron subnet-create external 10.0.0.0/22 --disable-dhcp --allocation-pool start=10.0.3.1,end=10.0.3.254 --gateway=10.1.1.254

## What else?

Workflow for a Per Tenant networks/routers environment

*   For each tenant
    -   Create a network/subnet/router (admin user)
    -   Add Security Groups rules for the tenant (tenant user)

<!-- -->

    neutron security-group-rule-create --protocol icmp --direction ingress default
    neutron security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
