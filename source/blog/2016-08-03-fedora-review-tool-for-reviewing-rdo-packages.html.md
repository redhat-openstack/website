---
title: fedora-review tool for reviewing RDO packages
author: chandankumar
tags: dlrn,rdo,openstack,packaging,centos,fedora,fedora-review
date: 2016-08-03 16:05:19 IST
---

This tool makes reviews of rpm packages for Fedora easier. It tries to automate most of the process.
Through a bash API the checks can be extended in any programming language and for any programming language.

We can also use it for also reviewing RDO packages on Centos 7/Fedora-24.

## Install fedora-review and DLRN

[1.] Install fedora-review and Mock

**For Centos 7**

Enable epel repos on centos

	$ sudo yum -y install epel-release

Download fedora-review el7 build from Fedora Koji

	$ sudo yum -y install https://kojipkgs.fedoraproject.org//packages/fedora-review/0.5.3/2.el7/noarch/fedora-review-0.5.3-2.el7.noarch.rpm
    $ sudo yum -y install mock

**On Fedora 24**

	$ sudo dnf -y install fedora-review mock

[2.] Add the user you intend to run as to the mock group:

	$ sudo usermod -a -G mock $USER
	$ newgrp mock
	$ newgrp $USER

[3.] Install DLRN:

**On Centos 7**

	$ sudo yum -y install mock rpm-build git createrepo python-virtualenv python-pip openssl-devel gcc libffi-devel

**On Fedora 24**

	$ sudo dnf -y install mock rpm-build git createrepo python-virtualenv python-pip openssl-devel gcc libffi-devel

The below steps works on both distros.

	$ virtualenv rdo
	$ source .rdo/bin/activate
	$ git clone https://github.com/openstack-packages/DLRN.git
	$ cd DLRN
	$ pip install -r requirements.txt
	$ python setup.py develop

[4.] Generate dlrn.cfg (RDO trunk mock config)

	$ dlrn --config-file projects.ini --package-name python-keystoneclient
	$ ls <path to cloned DLRN repo>/data/dlrn.cfg

[5.] Add dlrn.cfg to mock config.

Add mock config is in /etc/mock directory.

	$ sudo cp <path to cloned DLRN repo>/data/dlrn.cfg /etc/mock
	$ ls /etc/mock/dlrn.cfg

Now, everything is set, we are now ready to review any RDO package reviews using fedora-review.

## Run Fedora-review tool

	$ fedora-review -b <RH bug number for RDO Package Review> -m <mock config to use>

Let's review 'python-osc-lib' using dlrn.cfg.

	$ fedora-review -b 1346412 -m dlrn

Happy Reviewing!
