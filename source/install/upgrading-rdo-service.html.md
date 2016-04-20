# Managing OpenStack services

## <a name="stop">Stopping all OpenStack services</a>

This applies to a non-HA environment.

Run the following command on all of your OpenStack hosts:

    # openstack-service stop

## <a name="start">Starting all OpenStack services</a>

This applies to a non-HA environment.

On all of the systems in your OpenStack environment, run:

    # openstack-service start

## A note regarding the openstack-service command

These instructions make use of the `openstack-service` command,
available from the `openstack-utils` package.  After configuring the
appropriate repositories, you can upgrade to the latest version by
running:

    # yum install openstack-utils

## References

* [Upgrade scenario 1](/install/upgrading-rdo-1/)
* [Upgrade scenario 2](/install/upgrading-rdo-2/)

