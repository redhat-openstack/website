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

### configure testr

#### Install virtualenv and junitxml

        cd /var/lib/tempest
        python tools/install_venv.py
        source .venv/bin/activate
        pip install junitxml

#### configure and run testr ( Fedora )

        testr init
        test run --subunit | 
           tee >(subunit2junitxml --output-to=results.xml) |
           subunit-2to1 | tools/colorizer.py

#### configure and run nosetest ( RHEL/CentOS )

        export NOSE_WITH_OPENSTACK=1
        export NOSE_OPENSTACK_COLOR=1
        export NOSE_OPENSTACK_RED=15.00
        export NOSE_OPENSTACK_YELLOW=3.00
        export NOSE_OPENSTACK_SHOW_ELAPSED=1
        export NOSE_OPENSTACK_STDOUT=1
        export TEMPEST_PY26_NOSE_COMPAT=1

         nosetests --verbose --attr=type=smoke  --with-xunit

         or a larger set of tests w/
         nosetests --verbose   --with-xunit

## Multi Node Setup ( coming soon )
