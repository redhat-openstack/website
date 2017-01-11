---
title: Writing rpm-macros for OpenStack
author: chandankumar
date: 2017-01-11 14:00:00 IST
tags: blogs,openstack,rdo,rpm-macros
---

rpm-macros is a short string, always prefixed by % and generally surrounded by curly brackets ({}) which RPM will convert to a different and usually longer string.
Some macros can take arguments and some can be quite complex.
In RHEL, Centos and Fedora, Macros are provided by rpm package and from [redhat-rpm-config](https://apps.fedoraproject.org/packages/redhat-rpm-config).
In RDO, openstack macros are provided by [openstack-macros](http://cbs.centos.org/koji/packageinfo?packageID=3792) which comes from upstream [rpm-packaging](http://git.openstack.org/cgit/openstack/rpm-packaging/) project.
You can find list of all macros under /usr/lib/rpm/macros.d/ directory.

To see the list of all available macros on your system:

    $ rpm --showrc

For example: %{_bindir} is a rpm-macro which points to binary directory where executables are usually stored.

To evaluate a rpm macro:

    $ rpm --eval %{_bindir}

%py_build is the commonly used rpm-macro in RDO OpenStack packages which points to *python setup.py build* process.

    $ rpm --eval %py_build

**Motivation behind writing rpm-macro for OpenStack**
Currently, Tempest provides a external test plugin interface which enables anyone to integrate an external test suite as a part of tempest run and each service tempest plugin has a entrypoint
defined in setup.cfg through which tempest discovers it and list the tempest plugins.
For example:

    tempest.test_plugins =
        heat_tests = heat_integrationtests.plugin:HeatTempestPlugin

In RDO OpenStack services Packages, In tree tempest plugins packages are provided by openstack-{service}-tests subpackage but the tempest plugin entrypoint is provided by the main package openstack-%{service}.
So once you have a working OpenStack environment with tempest installed having no test subpackage installed. Then we tried to run tempest commands you would have encountered "No module heat_integrationtests.plugin found"
and you endup installing a hell lot of packages to fix this. The basic reason for the above error is tempest plugin entry point is installed by main openstack package but files pointing to entrypoint are not found.

To fix the above issue we have decided to seperate out the tempest plugin entrypoint from main package and move it to openstack-{service}-tests subpackage during rpmbuild process by creating a fake tempest plugin entry point
for all RDO services packages. Since it is a massive and similar change affecting all openstack services packages.
So i have created %py2_entrypoint macro which is available in OpenStack Ocata release.
Here is the macro definition of [%py2_entrypoint](https://github.com/openstack/rpm-packaging/blob/master/openstack/openstack-macros/macros.openstack-rdo#L23):

   # Create a fake tempest plugin entry point which will
   # resides under %{python2_sitelib}/%{service}_tests.egg-info.
   # The prefix is %py2_entrypoint %{modulename} %{service}
   # where service is the name of the openstack-service or the modulename
   # It should used under %install section
   # the generated %{python2_sitelib}/%{service}_tests.egg-info
   # will go under %files section of tempest plugin subpackage
   # Example: %py2_entrypoint %{modulename} %{service}
   # In most of the cases %{service} is same as %{modulename}
   # but in case of neutron plugins it is different
   # like servicename is neutron-lbaas and modulename is neutron_lbass
   %py2_entrypoint() \
   egg_path=%{buildroot}%{python2_sitelib}/%{1}-*.egg-info \
   tempest_egg_path=%{buildroot}%{python2_sitelib}/%{1}_tests.egg-info \
   mkdir $tempest_egg_path \
   grep "tempest\\|Tempest" %{1}.egg-info/entry_points.txt >$tempest_egg_path/entry_points.txt \
   sed -i "/tempest\\|Tempest/d" $egg_path/entry_points.txt \
   cp -r $egg_path/PKG-INFO $tempest_egg_path \
   sed -i "s/%{2}/%{1}_tests/g" $tempest_egg_path/PKG-INFO \
   %nil

Here is the list of [tempest-plugin-entrypoint reviews](https://review.rdoproject.org/r/#/q/topic:tempest-plugin-entrypoint).

Some learning from above macro:

[1.] You can use shell script or lua language to write macros.

[2.] %define <macroname> is used to define a macro in spec file or you can directly place the macro in /usr/lib/rpm/macros.d/macros.openstack-rdo to consume it using rpmbuild process.

[3.] use %nil to showcase the end of macro.

[4.] use %{1} to %{6} to pass variables in macros.

Above is a temprory solution. We are working upstream to seperate out tempest plugins from openstack project to a new repo for easier management and packaging
in Pike release:[https://review.openstack.org/#/c/405416/](https://review.openstack.org/#/c/405416/).

Thanks to [Daniel](https://github.com/danielmellado), [Alan](https://twitter.com/apevec_) [Haikel](https://twitter.com/hguemar) and many others on #rdo channel for getting the work done.
It was a great learning experience.
