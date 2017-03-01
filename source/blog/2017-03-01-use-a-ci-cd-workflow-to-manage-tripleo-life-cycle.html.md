---
title: Use a CI/CD workflow to manage TripleO life cycle
author: Nicolas Hicher
tags: openstack, rdo, tripleo, software-factory
date: 2017-03-01 15:18:31 EST
---

In this post, I will present how to use a CI/CD workflow to manage TripleO deployment life cycle within an OpenStack tenant.

The goal is to use Software-Factory to submit reviews to create or update a TripleO deployment. The review process ensure peers validation before executing the deployment or update command. The deployment will be done within Openstack tenants. We will split each roles in a different tenant to ensure network isolation between services.

![](/images/sf-project.png)

## Tools

### Software Factory

[Software Factory](https://github.com/redhat-cip/software-factory) (also called SF) is a collection of services that provides a powerful platform to build software.

The main advantages of using Software Factory to manage the deployment are:

* Cross-project gating system (through user defined jobs).
* Code-review system to ensure peer validation before changes are merged.
* Reproducible test environment with ephemeral slave

### Python-tripleo-helper

[Python-tripleo-helper](https://github.com/redhat-openstack/python-tripleo-helper) is a library provides a complete Python API to drive an OpenStack deployment (TripleO). It allow to:

* Deploy OpenStack with TripleO within an OpenStack tenant
* Can deploy a virtual OpenStack using the baremetal workflow with IPMI commands.

### TripleO

[Tripleo](https://wiki.openstack.org/wiki/TripleO) is a program aimed at installing, upgrading and operating OpenStack clouds using OpenStack's own cloud facilities as the foundations.

[full article](/resources/use-a-ci-cd-workflow-to-manage-tripleo-life-cycle-full)
