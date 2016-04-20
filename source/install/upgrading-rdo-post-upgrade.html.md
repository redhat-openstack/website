# Post-upgrade steps

## Final package upgrade

After completing all of your individual service upgrades, you should
perform a complete package upgrade on all of your systems:

    # yum upgrade

This will ensure that all packages are up-to-date.  You may want to
schedule a restart of your OpenStack hosts at a future date in order
to ensure that all running processes are using updated versions of the
underlying binaries.

## Configuration review

After you have upgraded each service, you should test to make sure
that the service is functioning properly.  You will also want to
review any new (`*.rpmnew`) configuration files installed by the
upgraded package.

New versions of OpenStack services may deprecate certain
configuration options. For information on upgrading OpenStack services,
see the
[OpenStack Projects Release Notes for Mitaka](http://releases.openstack.org/mitaka/index.html).

You should also review your OpenStack logs for any deprecation warnings,
because these may cause problems during a future upgrade.

## References

* [Upgrade scenario 1](/install/upgrading-rdo-1/)
* [Upgrade scenario 2](/install/upgrading-rdo-2/)

