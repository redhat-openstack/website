# Database upgrades

You can use the `openstack-db` command to perform database schema upgrades:

    openstack-db --service <service> --update

For example:

    openstack-db --service keystone --update

This will run the database upgrade command appropriate for that
service.  The `openstack-db` command is part of the `openstack-utils`
package.

Some services may require additional database maintenance as part of the
upgrade that is not covered by the `openstack-db` command. For more
information, see the
[OpenStack Projects Release Notes for Mitaka](http://releases.openstack.org/mitaka/index.html).

## References

* [Upgrade scenario 1](/install/upgrading-rdo-1/)
* [Upgrade scenario 2](/install/upgrading-rdo-2/)

