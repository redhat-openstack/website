---
title: 'Testing RDO with Tempest: new features in Ocata'
author: ltoscano
tags: tempest,install,configure,rpm,ocata
date: 2017-02-01 14:15:19 CET
---

The release of Ocata, with its shorter release cycle, is close and
it is time to start a broader testing (even if one could argue that
it is always time for testing!).

One of the core pieces for testing the cloud is the
[Tempest](http://docs.openstack.org/developer/tempest/overview.html).

# Tempest in RDO

## Current status

The status up to the Newton is well described in few blog posts,
either from [packages](/blog/2016/09/running-tempest-on-rdo-openstack-newton/)
or from [git](/blog/2016/11/how-to-install-and-run-tempest/).
In short, RDO used a [forked repository](https://github.com/redhat-openstack/tempest),
which regularly received all the changes from the official Tempest.
The main reason for this was a configuration script which auto-discovers
the features of the cloud (with some hints based on the version) and creates
a valid `tempest.conf`.

## Changes in Ocata

The auto-configuration script was decoupled from the internal Tempest and
moved to the new [python-tempestconf](https://github.com/redhat-openstack/python-tempestconf) repository,
thanks to the work of Martin Kopec, Chandan Kumar and Daniel Mellado.

This means less burden work required (no need to keep the fork) but also
simplifies a bit the steps required to initialize and run Tempest tests,
close to the process documented by Tempest upstream.

## New configuration steps

Configure the RDO repositories, then install the required packages:

    $ yum -y install openstack-tempest

`python-tempestconf` will be installed as well, as new dependency of
`openstack-tempest`.

Now source the admin credentials, initialize tempest and run the discovery tool:

    $ source </path/to/>keystonerc_admin
    $ tempest init testingdir
    $ cd testingdir
    $ discover-tempest-config --debug identity.uri $OS_AUTH_URL \
          identity.admin_password  $OS_PASSWORD --create

`discover-tempest-config` is the new name of the old `config_tempest.py`
script and it accepts the same parameters.

And that's it! Now it is possible to lists and run the tests a usual:

    $ tempest run

For more details, see the the
[upstream documentation of `tempest run`](http://docs.openstack.org/developer/tempest/run.html).
As this is a wrapper to `testr`, `ostestr` (and direct calls to `testr`)
works as before, even if the usage of `tempest run` and its filtering
features is highly recommended.


# Tempest plugins

## Current status

Tempest is really composed by two big parts: a library (with an increasing
number of stable APIs) and a set of tests.
With the introduction of [Tempest Plugins](http://docs.openstack.org/developer/tempest/plugin.html)
the scope of the tests included in tempest.git was limited to the core
components (right now Keystone, Nova, Neutron, Cinder, Glance and Swift).

The tests for other projects, as well as the advanced tests for the core
components, have been moved to separate repositories.
In most of the cases they have been added to the same repository of the
main project. This introduces a complication when the tests are split
in a separate RPM subpackage, as it is the case in RDO: the entry point
for the tests for a component `foo` is always installed as part of the
base subpackage for foo (usually `python-foo`), but the corresponding
code is not (the `python-foo-tests` is not required). Running any
`tempest` command, the entry points are found but the code could not
be there, leading to errors.

The script `install_test_packages.py` provided in the openstack-tempest
RPM could discover the missing entry points and install the required
package, but that was clearly a workaround with a maintainance burden.

## Changes in Ocata

Thanks again to the work by Chandan Kumar, the packaging was fixed
to prevent this problem by automagically tuning the entry points
in the generated packages. The interesting technical details are
described in a [past blog post](/blog/2017/01/writing-rpm-macros-for-openstack/).

So no more obscure errors due to missing packages while using Tempest,
but you may want to check which packages containing tests are really
installed if you really want to maximize the testing against your cloud.
