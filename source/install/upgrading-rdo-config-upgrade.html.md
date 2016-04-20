# Configuration upgrades

You may need to modify the configuration of the following OpenStack
services before the upgraded versions will run correctly:

## Keystone

Consult the Upgrade Notes for Keystone at
[http://docs.openstack.org/releasenotes/keystone/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/keystone/mitaka.html#upgrade-notes).

## Cinder

Consult the Upgrade Notes for Cinder at
[http://docs.openstack.org/releasenotes/cinder/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/cinder/mitaka.html#upgrade-notes).

## Glance

Consult the Upgrade Notes for Glance at
[http://docs.openstack.org/releasenotes/glance/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/glance/mitaka.html#upgrade-notes).

## Neutron

If using the ML2 plugin with the OVS driver and enabling security groups, you
need to set a parameter `firewall_driver` in `/etc/neutron/plugin.ini`:

        # openstack-config --set /etc/neutron/plugin.ini securitygroup \
          firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

For other upgrade notes on Neutron, consult the upstream document at
[http://docs.openstack.org/releasenotes/neutron/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/neutron/mitaka.html#upgrade-notes).

## Nova

Consult the Upgrade Notes for Nova at
[http://docs.openstack.org/releasenotes/nova/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/nova/mitaka.html#upgrade-notes).

## Heat

Consult the Upgrade Notes for Heat at
[http://docs.openstack.org/releasenotes/heat/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/heat/mitaka.html#upgrade-notes).

## Horizon

Consult the Upgrade Notes for Horizon at
[http://docs.openstack.org/releasenotes/horizon/mitaka.html#upgrade-notes](http://docs.openstack.org/releasenotes/horizon/mitaka.html#upgrade-notes).

## Other services

For information on upgrading other OpenStack services, see the
[OpenStack Projects Release Notes for Mitaka](http://releases.openstack.org/mitaka/index.html).

## References

* [Upgrade scenario 1](/install/upgrading-rdo-1/)
* [Upgrade scenario 2](/install/upgrading-rdo-2/)

