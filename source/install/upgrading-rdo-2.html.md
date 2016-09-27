# Scenario 2: One service at a time

In this scenario, you upgrade one service at a time in a non-HA environment.

## Pre-upgrade

Perform the necessary [pre-upgrade](/install/upgrading-rdo-pre-upgrade/) steps.

## Service upgrades

Upgrade each of your services, following the process described above.
The following is a reasonable order in which to perform the upgrade:

1. Keystone
1. Glance
1. Cinder
1. Heat
1. Ceilometer
1. Nova
1. Neutron
1. Horizon

The procedure for upgrading an individual OpenStack service looks like
this:

1. [Stop the service](/install/upgrading-rdo-service/#stop):

         # openstack-service stop <service>

1. Upgrade the packages that provide that service:

         # yum upgrade \*<service>\*

1. Perform any necessary [configuration updates](/install/upgrading-rdo-config-upgrade/)
   for that service.

1. Perform [database schema upgrades](/install/upgrading-rdo-database-upgrade/) for that
   service.

1. [Restart the service](/install/upgrading-rdo-service/#start):

         # openstack-service start <service>

## Post-upgrade

Perform the necessary [post-upgrade](/install/upgrading-rdo-post-upgrade/) steps.

## References

* [Upgrading from Liberty to Mitaka: Overview](/install/upgrading-rdo/)

