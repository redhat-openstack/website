---
title: Testing IceHouse using Tempest
authors: afazekas, rbowen, thaha, whayutin
wiki_title: Testing IceHouse using Tempest
wiki_revision_count: 18
wiki_last_updated: 2015-04-01
---

# Testing IceHouse using Tempest

This page documents how to run tempest on an All-In-One installation of RDO - IceHouse on RHEL, CentOS and Fedora 19/20.

*   **Assumption:** packstack is already installed

## All-In-One

#### Generate Answer file

        packstack --gen-answer-file=answers.txt

#### Enable tempest and demo

Edit answers.txt and set

        CONFIG_PROVISION_DEMO=y
        CONFIG_PROVISION_TEMPEST=y
        CONFIG_PROVISION_TEMPEST_REPO_REVISION=master

#### Workaround the openstack-puppet-module bug ( fedora only )

         sed -e 's/mysql/mariadb/g' -i  /usr/lib/python2.7/site-packages/packstack/puppet/modules/tempest/manifests/params.pp

#### Run packstack

         packstack --answer-file=answers.txt

### Running tempest with tox

       pip install tox==1.6.1
       tox -efull -- --concurrency=3

Note: The default concurrency is the number of CPU threads on the test runner machine.

Run all network related test

       tox -eall network

libxslt-devel and libffi-devel might be required for creating the venv.

#### Using tempest with python 2.6

       yum install -y python-unittest2 patch
       pip install  discover

Download the attached patch from <https://code.google.com/p/unittest-ext/issues/detail?id=79>

      (cd /usr/lib/python2.6/site-packages/; sudo patch  <"/tmp/unittest2-discover.patch")
      sudo rm /usr/lib/python2.6/site-packages/discover.pyc
      sudo python -c 'import discover'

#### generating junit file from an existing testropistory

       pip install junitxml python-subunit
        <./.testrepository/0  subunit-1to2  | subunit2junitxml >results.junit.xml

./.testrepository/0 is the resouts from the first test run, you can convert any results to an another supported format

#### 

### configure testr

#### Install virtualenv and junitxml

        cd /var/lib/tempest
        python tools/install_venv.py
        source .venv/bin/activate
        pip install junitxml

#### configure and run testr ( Fedora )

        testr init
        testr run --subunit | 
           tee >(subunit2junitxml --output-to=results.xml) |
           subunit-2to1 | tools/colorizer.py
