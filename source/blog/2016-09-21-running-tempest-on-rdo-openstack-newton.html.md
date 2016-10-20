---
title: Running Tempest on RDO OpenStack Newton
author: chandankumar
tags: rdo,packstack,tempest,newton,packaging
date: 2016-09-26 11:23:29 IST
---


[Tempest](http://docs.openstack.org/developer/tempest/overview.html) is a set of integration tests to run against an OpenStack cluster.

**What does [RDO](https://www.rdoproject.org) provides for Tempest?**

RDO provides three packages for running tempest against any OpenStack installation.

* *python-tempest* : It can be used as a python library, consumed as a dependency for out of tree tempest plugins i.e. for horizon and designate tempest plugins.
* *openstack-tempest* : It provides python tempest library and required executables for running tempest.
* *openstack-tempest-all* : It will install openstack-tempest as well as all the tempest plugins on the system.

**Deploy [packstack](github.com/openstack/packstack) using latest RDO Newton packages**

Roll out a vm of [CentOS 7](https://www.centos.org/download/), Follow these steps:

1. Install rdo-release-newton rpm

        # yum -y install https://rdoproject.org/repos/openstack-newton/rdo-release-newton.rpm

2. Update your CentOS vm and perform reboot.

	    # yum -y update

3. Install openstack-packstack

	    # yum install -y openstack-packstack

4. Run packstack to deploy OpenStack Newton release:

	    # packstack --allinone

   Once packstack installation is done, we are good to go ahead.

**Install tempest and required tempest plugins**

 1. Install tempest

	    # yum install openstack-tempest

2. Install tempest plugins based on the openstack services installed and configured on deployment.

   Packstack installs by default horizon, nova, neutron, keystone, cinder, swift, glance, ceilometer, aodh and gnocchi.
   To find out what are the openstack components installed, just do a rpm query:

	    # rpm -qa | grep openstack-*

	OR you can use openstack-status command for the same.
	Just grab the tempest plugins of these services and install it.

	    # yum install python-glance-tests python-keystone-tests python-horizon-tests-tempest \
	      python-neutron-tests python-cinder-tests python-nova-tests python-swift-tests \
	      python-ceilometer-tests python-gnocchi-tests python-aodh-tests

	OR you can automatically install the required tempest plugins of the configured services on the environment.

	    # python /usr/share/openstack-tempest-*/tools/install_test_packages.py

3. To find what are tempest plugins installed:

	    # tempest list-plugins

   Once done, you are ready to run tempest.

   If you face any entry point issues while running tempest, you can debug using [entry_point_inspector](https://pypi.python.org/pypi/entry_point_inspector) tool
   Install entry_point_inspector from epel.repo.

            # yum install epel-release

            # yum install python-epi

   Run epi command to show the entry points of tempest plugins:

	    # epi group show tempest.test_plugins

**Configuring and Running tempest**

1. source admin credentials and switch to normal user

	    # source /root/keystonerc_admin

	    # su <user>

2. Create a directory from where you want to run tempest

	    $ mkdir /home/$USER/tempest; cd /home/$USER/tempest

3. Configure the tempest directory

	    $ /usr/share/openstack-tempest-*/tools/configure-tempest-directory

4.  Auto generate tempest configuration for your deployed openstack environment

	    $ python tools/config_tempest.py --debug identity.uri $OS_AUTH_URL \
          identity.admin_password  $OS_PASSWORD --create

	It will automatically create all the required configuration in etc/tempest.conf

5.  To list all the tests

	    $ testr list-tests

    OR

	    $ ostestr -l

6. To run tempest tests:

	    $ ostestr

7. For running api and scenario tests using ostestr and prints the slowest tests after test run

	    $ ostestr --regex '(?!.*\[.*\bslow\b.*\])(^tempest\.(api|scenario))'

8. To run specific tests:

	    $ python -m testtools.run tempest.api.volume.v2.test_volumes_list.VolumesV2ListTestJSON

	OR

	    $ ostestr --pdb tempest.api.volume.v2.test_volumes_list.VolumesV2ListTestJSON

	ostestr --pdb will call python -m testtools.run under the hood.


Thanks to [Luigi](https://twitter.com/tosky_eu), [Steve](https://github.com/eggmaster), [Daniel](https://github.com/danielmellado),
[Javier](https://twitter.com/fj_pena), [Alfredo](https://twitter.com/amoralej), [Alan](https://twitter.com/apevec_) for the review.

Happy Hacking!
