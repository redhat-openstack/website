---
title: A tale of Tempest rpm with Installers
author: chandankumar
tags: openstack,rdo,tempest,python-tempestconf
date: 2017-03-14 18:27:02 IST
---

[Tempest](https://docs.openstack.org/developer/tempest/overview.html) is a set of integration tests to run against OpenStack Cloud.
Delivering robust and working OpenStack cloud is always challenging. To make sure what we deliver in RDO is rock-solid, we use Tempest
to perform a set of API and scenario tests against a running cloud using different installers like [puppet-openstack-integration](http://git.openstack.org/cgit/openstack/puppet-openstack-integration/),
[packstack](http://git.openstack.org/cgit/openstack/packstack), and [tripleo-quickstart](http://git.openstack.org/cgit/openstack/tripleo-quickstart).
And, it is the story of how we integrated RDO Tempest RPM package with installers so it can be consumed by various CI rather than using raw upstream sources.

And the story begins from here:

In RDO, we deliver Tempest as an rpm to be consumed by anyone to test their cloud. Till Newton release,
we maintained a fork of [Tempest](https://github.com/redhat-openstack/tempest) which contains the config_tempest.py script to auto generate tempest.conf
for your cloud and a set of helper scripts to run Tempest tests as well as with some backports for each release. From Ocata, we have changed the source of Tempest rpm from forked Tempest to upstream Tempest by keeping
the old source till Newton in RDO through [rdoinfo](https://review.rdoproject.org/r/#/q/topic:switch-upstream-tempest). We are using rdo-patches branch
to maintain patches backports starting from Ocata release.

With this change, we have moved the config_tempest.py script from the forked Tempest repository to a separate project [python-tempestconf](https://github.com/redhat-openstack/python-tempestconf)
so that it can be used with vanilla Tempest to generate Tempest config automatically.

What have we done to make a happy integration between Tempest rpm and the installers?

Currently, puppet-openstack-integration, packstack, and tripleo-quickstart heavily use RDO packages. So using Tempest rpm with these installers will be the best match.
Before starting the integration, we need to make the initial ground ready. Till Newton release, all these installers are using Tempest from source in their respective CI.
We have started the match making of Tempest rpm with installers.
puppet-openstack-integration and packstack consume puppet-modules. So in order to consume Tempest rpm, first I need to fix the [puppet-tempest](http://git.openstack.org/cgit/openstack/puppet-tempest).

## [puppet-tempest](http://git.openstack.org/cgit/openstack/puppet-tempest)

It is a puppet-module to install and configure Tempest and openstack-services Tempest plugins based on the services available from source as well as packages.
So we have fixed puppet-tempest to install Tempest rpm from the package and created a Tempest workspace. In order to use that feature through puppet-tempest module [https://review.openstack.org/#/c/425085/].
you need to add *install_from_source => 'false'* and *tempest_workspace => 'path to tempest workspace'* to tempest.pp and it will do the job for you.
Now we are using the same feature in puppet-openstack-integration and packstack.

## [puppet-openstack-integration](http://git.openstack.org/cgit/openstack/puppet-openstack-integration/)

It is a collection of scripts and manifests for puppet module testing (which powers the openstack-puppet CI).
From Ocata release, we have added a flag TEMPEST_FROM_SOURCE flag in [run_tests.sh script](http://git.openstack.org/cgit/openstack/puppet-openstack-integration/tree/run_tests.sh).
Just change TEMPEST_FROM_SOURCE to false in the [run_test.sh](https://review.openstack.org/#/c/427578/), Tempest is then installed and configured from packages using puppet-tempest.

## [packstack](http://git.openstack.org/cgit/openstack/packstack)

It is a utility to install OpenStack on CentOS, Red Hat Enterprise Linux or other derivatives in proof of concept (PoC) environments. Till Newton, Tempest is installed and ran by packstack from the upstream source and behind the scenes, puppet-tempest does the job for us. From Ocata, we have replaced this feature by using [Tempest RDO package](https://review.openstack.org/#/c/428102/). You can use this feature by running the following command:

	$ sudo packstack --allinone --config-provision-tempest=y --run-tempest=y

It will perform packstack all in one installation and after that, it will install and configure Tempest and run smoke tests on deployed cloud.
We are using the same in RDO CI.

## [tripleo-quickstart](https://docs.openstack.org/developer/tripleo-quickstart/)

It is an ansible based project for setting up TripleO virtual environments.
It uses [triple-quickstart-extras](http://git.openstack.org/cgit/openstack/tripleo-quickstart-extras/tree/roles/validate-tempest) where validate-tempest roles exist which is used to install, configure and run Tempest on a tripleo deployment after installation. We have improved the validate-tempest role to use Tempest rpm package for all releases (supported by OpenStack upstream) by keeping the old workflow and as well as using Ocata Tempest rpm and using ostestr for running Tempest tests for all releases and using python-tempestconf to generate tempest.conf through [this patch](https://review.openstack.org/#/c/431916/).

To see in action, Run the following command:

	$ wget https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh
	$ bash quickstart.sh --install-deps
	$ bash quickstart.sh -R master --tags all $VIRTHOST

So finally the integration of Tempest rpm with installers is finally done and they are happily consumed in different CI and this will help to test and produce more robust OpenStack cloud in RDO as well as catch issues of Tempest with Tempest plugins early.

Thanks to apevec, jpena, amoralej, Haikel, dmsimard, dmellado, tosky, mkopec, arxcruz, sshnaidm, mwhahaha, EmilienM
and many more on #rdo channel for getting this work done in last 2 and half months. It was a great learning experience.



