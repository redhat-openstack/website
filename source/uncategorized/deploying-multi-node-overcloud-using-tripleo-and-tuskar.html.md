---
title: Deploying Multi Node Overcloud Using TripleO And Tuskar
authors: rlandy
wiki_title: Deploying Multi Node Overcloud Using TripleO And Tuskar
wiki_revision_count: 20
wiki_last_updated: 2014-03-18
---

# Deploying Multi Node Overcloud Using TripleO And Tuskar

## Background

This task follows the steps to install RDO using the [Tuskar](//wiki.openstack.org/wiki/TripleO/Tuskar) and [TripleO](//wiki.openstack.org/wiki/TripleO) projects. The install is done via packages. Note that any pages linked and any information in the linked pages are part of a rapidly changing project and are likely to be modified.

The goal of the task is to:

      - install the Undercloud
      - download images needed for the Overcloud
      - deploy an Overcloud with one Control node, Two Compute nodes and Two Block Storage nodes using Heat
      - test that this Overcloud is functional by deploying a test instance within it
      - tear down the Overcloud
      - re-deploy the same Overcloud using Tuskar
      - test that Overcloud

## Undercloud Setup

The steps to install the undercloud and configure Tuskar are listed in: <https://github.com/agroup/instack-undercloud/blob/master/README-packages.md>. These steps should be executed on Fedora 20.

Note that this task's install uses the instack-baremetal.answers.sample answers file.

## Setup for Overcloud

<https://github.com/agroup/instack-undercloud/blob/master/scripts/instack-prepare-for-overcloud>

## Deploying an Overcloud

## Overcloud Steps

## Future
