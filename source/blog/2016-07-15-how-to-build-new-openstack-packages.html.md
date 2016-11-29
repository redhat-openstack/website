---
title: How to build new OpenStack packages
author: chandankumar
tags: dlrn,rdo,openstack,packaging,centos
date: 2016-07-15 17:37:12 UTC
---

Building new OpenStack packages for RDO is always tough. Let's use DLRN to make our life simpler.

DLRN is the RDO Continuous Delivery platform that pulls upstream git, rebuild them as RPM using template spec files, and ships them in
repositories consumable by CI (e.g upstream puppet/Tripleo/packstack CI).

We can use DLRN to build a new RDO python package before sending them for package review.

## Install DLRN

[1.] Install required dependencies for DLRN on Fedora/CentOS system:

    $ sudo yum install git createrepo python-virtualenv mock gcc \
                  redhat-rpm-config rpmdevtools libffi-devel \
                  openssl-devel


[2.] Create a virtualenv and activate it

    $ virtualenv dlrn-venv
    $ source dlrn-venv/bin/activate

[3.] Clone DLRN git respository from github

    $ git clone https://github.com/openstack-packages/DLRN.git

[4.] Install the required python dependencies for DLRN

    $ cd DLRN
    $ pip install -r requirements.txt

[5.] Install DLRN

    $ python setup.py develop

Now your system is ready to use DLRN.

## Add the user you intend to run as to the mock group:

    $ sudo usermod -a -G mock $USER
    $ newgrp mock
    $ newgrp $USER

## Let us package "congress" OpenStack project for RDO

[1.] create a project "congress-distgit" and initialize the project using git init

    $ mkdir congress-distgit
    $ cd congress-distgit
    $ git init

[2.] create a branch "rpm-master"

    $ git checkout -b rpm-master

[3.] Create openstack-congress.spec file using [RDO spec template](https://github.com/openstack-packages/openstack-example-spec) and commit it into rpm-master branch.

    $ git add openstack-congress.spec
    $ git commit -m "<your commit message>"

## Add a package entry in rdoinfo

[1.] Copy rdoinfo directory somewhere locally and make changes there.

    $ rdopkg info && cp -r ~/.rdopkg/rdoinfo $SOMEWHERE_LOCAL
    $ cd $SOMEWHERE_LOCAL/.rdopkg/rdoinfo

[2.] Edit the rdo.yml file and add package entry in the last

    $ vim rdo.yml
    - project: congress # project name
      name: openstack-congress # RDO package name
      upstream: git://github.com/openstack/%(project)s # Congress project source code git repository
      master-distgit: <path to project spec file git repo>.git # path to congress-distgit git directory
      maintainers:
      - < maintainer email > # your email address

[3.] save the rdo.yml and run

    $ ./verify.py

This will check rdo.yml sanity.

## Run DLRN to build openstack-congress package

[1.] Go to DLRN project directory.

[2.] Run the following command to build the package

    $ dlrn --config-file projects.ini \
            --info-repo $SOMEWHERE_LOCAL/.rdopkg/rdoinfo \ # --info-repo flag for pointing local rdoinfo repo
            --package-name openstack-congress \ --package flag to build openstack-congress
            --head-only \ To build the package using latest commit

It will clone the project code "openstack-congress" and spec under "openstack-congress_distro" folder.

[3.] Once done, you can rebuilding the package by passing the --dev flag.

    $ dlrn --config-file projects.ini \
            --info-repo ~/.rdopkg/rdoinfo \ # --info-repo flag for pointing local rdoinfo repo
            --package-name <openstack-congress> \ # --package flag to build openstack-congress
            --head-only \ # To build the package using latest commit
            --dev \ # to build the package locally

[4.] Once build is completed, you can find the rpms and srpms in this folder

    $ # path to packaged rpms and srpms
    $ <path to DLRN>/data/repos/current/

Now grab the rpms and feel free to test it.
