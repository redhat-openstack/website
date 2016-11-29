---
title: How to Install and Run Tempest
author: mkopec
tags: tempest,install,configure,virtualenv
date: 2016-11-22 11:10:15 UTC
---

[Tempest](http://docs.openstack.org/developer/tempest/overview.html) is a set of integration tests to run against an OpenStack cluster. In this blog I'm going to show you, how to install tempest from git repository, how to install all requirements and run tests against an OpenStack cluster.

I'm going to use a fresh installation of [Centos7](https://www.centos.org/download/) and OpenStack cluster provided by [packstack](https://www.rdoproject.org/install/quickstart/). If you've done that, follow the instructions below.

# Tempest Installation
You have two options how to install tempest. You can install it through RPM or you can clone tempest from GitHub repository. If you choose installation through RPM, follow [this link](https://www.rdoproject.org/blog/2016/09/running-tempest-on-rdo-openstack-newton/).

# Installation from GitHub repository
Now you can clone [upstream tempest](https://github.com/openstack/tempest) or you can clone [RedHat's fork](https://github.com/redhat-openstack/tempest/) of upstream tempest. The RedHat's fork provides `config_tempest.py`, which is a configuration tool. It will generate `tempest.conf` for you, what can be handy.

[1.] Install dependencies:

    $ sudo yum install -y gcc python-devel libffi-devel openssl-devel

[2.] Clone tempest:

    $ git clone https://github.com/openstack/tempest.git

Or (RedHat's fork):

    $ git clone https://github.com/redhat-openstack/tempest.git

[3.] Install pip, for example:

    $ curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    $ sudo python get-pip.py

[4.] Install tempest globally in the system. If you **don't** want to do that, **skip** this step and continue reading.

    $ sudo pip install tempest/

## Install tempest in a virtual environment
Sometimes you don't want to install things globally in the system. For this reason you may want to use a virtual environment. I'm going to explain installation through [virtualenv](https://virtualenv.pypa.io/en/stable/) and [tox](https://tox.readthedocs.io/en/latest/).

### Setting up Tempest using virtualenv
[1.] Install virtualenv:

    $ easy_install virtualenv

Or through pip:

    $ pip install virtualenv

[2.] Enter tempest directory you've cloned before:

    $ cd tempest/

[3.] Create a virtual environment and let's name it `.venv`:

    $ virtualenv .venv
    $ source ./venv/bin/activate

[4.] Install requirements:

    (.venv) $ pip install -r requirements.txt
    (.venv) $ pip install -r test-requirements.txt

*NOTE*: If problems occur during requirements installation, it may be due to an old version of pip, upgrade may help:

    (.venv) $ pip install pip --upgrade

[5.] After dependencies are installed, run following commands, which install tempest within the virtual environment:

    (.venv) $ cd ../
    (.venv) $ pip install tempest/

Or this command does the same without using pip:

    $ python setup.py install
If you need to trigger installation to developer mode run:

    (.venv) $ python setup.py develop
`setup.py develop` comes from limitations on [pbr](http://docs.openstack.org/developer/pbr/). If you are interested, [here is](https://setuptools.readthedocs.io/en/latest/setuptools.html#development-mode) an explanation of difference between `install` and `develop`.

### Setting up Tempest using TOX
[1.] Install tox:

    $ easy_install tox

Or if you want to use pip:

    $ pip install tox

[2.] Install tempest:

    $ tox -epy27 --notest
    $ source .tox/py27/bin/activate
This will create a virtual environment named `.tox`, install all dependencies (*requirements.txt* and *test-requirements.txt*) and tempest within it. If you check `tox.ini` file, you'll see tox actually run tempest installation in develop mode you could run manually as it was explained above.

**Optional:**

[3.] If you want to expose system-site packages, tox will do it for you. Deactivate environment, you are currently in (if you followed the step before) and create another environment:

    (py27) $ deactivate
    $ tox -eall-plugin --notest
    $ source .tox/all-plugin/bin/activate

[4.] Then if you want to install plugins test packages based on the OpenStack Components installed, let this script to do it:

    (all-plugin) $ sudo python tools/install_test_packages.py
    (all-plugin) $ python setup.py develop

## Generate tempest.conf
About `tempest.conf` and what it is used for you can read in [this documentation](http://docs.openstack.org/developer/tempest/configuration.html).
If you want to create `tempest.conf` let `config_tempest.py` do it for you. The tool is part of RPM tempest ([check this documentation](https://www.rdoproject.org/blog/2016/09/running-tempest-on-rdo-openstack-newton/)) or if you don’t want to install tempest globally, you can clone [RedHat's tempest fork](https://github.com/redhat-openstack/tempest/) and install it within a virtual environment as it was explained above.

### RedHat's tempest fork
Create a virtual environment as I already mentioned and `source` credentials (if you installed OpenStack cluster by [packstack](https://www.rdoproject.org/install/quickstart/) credentials are saved in `/root/`):

    (.venv) $ source /root/keystone_admin

And run config tool:

    (.venv) $ python tools/config_tempest.py --debug identity.uri $OS_AUTH_URL \
             identity.admin_password  $OS_PASSWORD --create
 After this, `./etc/tempest.conf` is generated.

**NOTE**:
If you running [OSP](https://access.redhat.com/documentation/en/red-hat-openstack-platform/), it’s needed to add a new argument to *config_tempest* tool:

    (.venv) $ ./tools/config_tempest.py object-storage.operator_role swiftoperator

It's because OSP uses lowercase operator for the swift operator_role, however, tempest default value is "SwiftOperator".
To override the default value run `config_tool` like this:

    $ python tools/config_tempest.py --debug identity.uri $OS_AUTH_URL \
      identity.admin_password  $OS_PASSWORD \
      object-storage.operator_role swiftoperator --create

## Running tests
If you've installed tempest and have `tempest.conf`, you cant start testing.
To run tests you can use [testr](https://wiki.openstack.org/wiki/Testr) or [ostestr](http://docs.openstack.org/developer/os-testr/). If you want to run tempest unit tests, [check this out](https://github.com/openstack/tempest#unit-tests).

*Note: following commands run withing the virtual environment you've created before.*
To run specific tests run for example:

    $ python -m testtools.run tempest.api.volume.v2.test_volumes_list
OR

    $ ostestr --regex tempest.api.volume.v2.test_volumes_list

Alternatively you can use tox, for example:

    $ tox -efull
Run only tests tagged as smoke:

    $ tox -esmoke


