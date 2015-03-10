---
title: RDO-Manager
authors: athomas, hewbrocca, jcoufal, jistr
wiki_title: RDO-Manager
wiki_revision_count: 49
wiki_last_updated: 2015-07-23
---

# RDO-Manager

## About

RDO-Manager is an OpenStack Deployment & Management tool for RDO. It combines the best from the [OpenStack TripleO](https://wiki.openstack.org/wiki/TripleO) and [SpinalStack](http://spinal-stack.readthedocs.org/en/latest/) projects.

RDO-Manager Repositories: <https://github.com/rdo-management>

## Instack

Instack is a tool which installs RDO Manager, also known as the "Deployment Cloud" or the "Undercloud".

Instack also includes scripts to use CLI commands to deploy a Workload Cloud or "Overcloud" layer (the OpenStack cloud you want to actually run instances on).

GitHub: <https://github.com/rdo-management/instack-undercloud>

Usage Guide: <https://repos.fedorapeople.org/repos/openstack-m/instack-undercloud/html/index.html>

## Inlunch

Inlunch is a tool which runs Instack while you are having lunch. In other words, it automates Instack scripts. Maybe more importantly, it prepares a virtual environment so that you can run Instack and it will find the virtual machines it needs to set up RDO Manager and the Workload Cloud.

GitHub: <https://github.com/rdo-management/inlunch>

## How to Guides

Demo 3 (March 9, 2015)

*   [RDO-Manager Deployment Flow, Recording on YouTube](https://www.youtube.com/watch?v=gskpEJ2QvpQ)
