# Pre-upgrade steps

On all of your hosts:

1. If you are running Puppet as configured by Staypuft, you must
   disable it:

        # systemctl stop puppet
        # systemctl disable puppet

   This ensures that the Staypuft-configured puppet will not revert
   changes made as part of the upgrade process.

1. Install the Mitaka yum repository:

        # yum install https://www.rdoproject.org/repos/rdo-release.rpm

1. Upgrade the `openstack-selinux` package, if available:

        yum upgrade openstack-selinux

   This is necessary to ensure that the upgraded services will run
   correctly on a system with [SELinux](http://selinuxproject.org/page/Main_Page)
   enabled.

1. Go back to [Upgrade scenario 2](/install/upgrading-rdo-2/).

