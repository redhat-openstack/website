# Scenario 1: All-at-once upgrade

In this scenario, you will take down all of your OpenStack
services at the same time, and will not bring them back up until the
upgrade process is complete.

On all of your hosts:

1. Install the Mitaka yum repository:

        # yum install https://www.rdoproject.org/repos/rdo-release.rpm

1. [Stop all your OpenStack services](/install/upgrading-rdo-service/#stop).

1. Perform a complete upgrade of all packages:

        # yum upgrade

1. Perform any necessary [configuration updates](/install/upgrading-rdo-config-upgrade/)
   for each of your services.

1. Perform [database schema upgrades](/install/upgrading-rdo-database-upgrade/) for each
   of your services:

    - Keystone
    - Cinder
    - Glance
    - Neutron
    - Nova
    - Heat
    - Ceilometer (only if you are using the MySQL backend)

1. Review newly installed configuration files.

     The upgraded packages will have installed `.rpmnew` files
     appropriate to the Mitaka version of the service.  In general,
     the Mitaka services will run using the configuration files from
     your Liberty deployment, but you will want to review the
     `.rpmnew` files for any required changes.

     New versions of OpenStack services may deprecate certain
     configuration options. You should also review your OpenStack
     logs for any deprecation warnings, because these may cause
     problems during a future upgrade.

1. [Start all your OpenStack services](/install/upgrading-rdo-service/#start).

## References

* [Upgrading from Liberty to Mitaka: Overview](/install/upgrading-rdo/)

