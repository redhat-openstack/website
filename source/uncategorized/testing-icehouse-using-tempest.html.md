---
title: Testing IceHouse using Tempest
authors: afazekas, rbowen, thaha, whayutin
wiki_title: Testing IceHouse using Tempest
wiki_revision_count: 18
wiki_last_updated: 2015-04-01
---

# Testing IceHouse using Tempest

This page documents how to run tempest on an All-In-Once installation of RDO - IceHouse on Fedora 19/20.

*   **Assumption:** packstack is already installed

## Enable tempest and demo provision

### Generate Answer file

        packstack --gen-answer-file=answers.txt

### Enable tempest and demo

Edit answers.txt and set

        CONFIG_PROVISION_DEMO=y
        CONFIG_PROVISION_TEMPEST=y
        CONFIG_PROVISION_TEMPEST_REPO_REVISION=stable/havana

### Workaround the openstack-puppet-module bug ( fedora only )

         sed -e 's/mysql/mariadb/g' -i  /usr/lib/python2.7/site-packages/packstack/puppet/modules/tempest/manifests/params.pp

### Run packstack

         packstack --answer-file=answers.txt

## configure testr

### Install virtualenv and junitxml

        cd /var/lib/tempest
        python tools/install_venv.py
        source .venv/bin/activate
        pip install junitxml

### configure testr

        testr init

### Run testr and capture test-result

        test run --subunit | 
            tee >(subunit2junitxml --output-to=results.xml) |
            subunit-2to1 | tools/colorizer.py
