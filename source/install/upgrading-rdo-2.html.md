# Scenario 2: One service at a time

In this scenario, you upgrade one service at a time in a non-HA environment.

## Pre-upgrade

Perform the necessary [pre-upgrade][] steps.

[pre-upgrade]: upgrading-rdo-pre-upgrade

## Service upgrades

Upgrade each of your services, following the process described above.
The following is a reasonable order in which to perform the upgrade:

1. Keystone
1. Cinder
1. Glance
1. Cinder
1. Heat
1. Ceilometer
1. Nova
1. Neutron
1. Horizon

The procedure for upgrading an individual OpenStack service looks like
this:

1. [Stop the service][stop]:

         # openstack-service stop <service>

1. Upgrade the packages that provide that service:

         # yum upgrade \*<service>\*

1. Perform any necessary [configuration updates][config] for that service.

1. Perform [database schema upgrades][dbsync] for that service.

1. [Restart the service][start]:

         # openstack-service start <service>

[config]: upgrading-rdo-config-upgrade
[dbsync]: upgrading-rdo-database-upgrade
[stop]: upgrading-rdo-service#stop
[start]: upgrading-rdo-service#start

# Post-upgrade

Perform the necessary [post-upgrade][] steps.

[post-upgrade]: upgrading-rdo-post-upgrade

