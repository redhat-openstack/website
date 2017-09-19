---
title: Project Teams Gathering (PTG) report - Zuul
author: tristanC
date: 2017-09-18 15:00:00 UTC
tags: openstack, infra, zuul
---

The OpenStack infrastructure team gathered in Denver (September 2017).
This article reports some of Zuul's topics that were discussed at the PTG.

For your reference, I highlighted some of the new features comming in the Zuul version 3
in this [article](http://rdoproject.org/blog/2017/08/whats-new-in-zuulV3/).


# Cutover and jobs migration

The OpenStack community grew a complex set of CI jobs over the past several years,
that needs to be migrated.
A zuul-migrate script has been created to automate the migration from the
Jenkins-Jobs-Builder format to the new Ansible based job definition.
The migrated jobs are prefixed with "-legacy" to indicate they still need
to be manually refactored to fully benefit from the ZuulV3 features.

The team couldn't finish the migration and disable the current ZuulV2 services
at the PTG because the jobs migration took longer than expected.
However, a new cutover attemp will occur in the next few weeks.


# Ansible devstack job

The devstack job has been completely rewritten to a fully fledged Ansible job.
This is a good example of what a job looks like in the new Zuul:

* The [devstack job definition](http://git.openstack.org/cgit/openstack-infra/devstack-gate/tree/.zuul.yaml#n7)
* The [devstack pre playbook](http://git.openstack.org/cgit/openstack-infra/devstack-gate/tree/playbooks/pre.yaml)
* The [devstack's roles](http://git.openstack.org/cgit/openstack-infra/devstack-gate/tree/roles)
* A [devstack job added to shade](https://review.openstack.org/500365)

A project that needs a devstack CI job needs this new job definition:

```yaml
- job:
    name: shade-functional-devstack-base
    parent: devstack
    description: |
      Base job for devstack-based functional tests
    pre-run: playbooks/devstack/pre
    run: playbooks/devstack/run
    post-run: playbooks/devstack/post
    required-projects:
      # These jobs will DTRT when shade triggers them, but we want to make
      # sure stable branches of shade never get cloned by other people,
      # since stable branches of shade are, well, not actually things.
      - name: openstack-infra/shade
        override-branch: master
      - name: openstack/heat
      - name: openstack/swift
    roles:
      - zuul: openstack-infra/devstack-gate
    timeout: 9000
    vars:
      devstack_localrc:
        SWIFT_HASH: "1234123412341234"
      devstack_local_conf:
        post-config:
          "$CINDER_CONF":
            DEFAULT:
              osapi_max_limit: 6
      devstack_services:
        ceilometer-acentral: False
        ceilometer-acompute: False
        ceilometer-alarm-evaluator: False
        ceilometer-alarm-notifier: False
        ceilometer-anotification: False
        ceilometer-api: False
        ceilometer-collector: False
        horizon: False
        s-account: True
        s-container: True
        s-object: True
        s-proxy: True
      devstack_plugins:
        heat: https://git.openstack.org/openstack/heat
      shade_environment:
        # Do we really need to set this? It's cargo culted
        PYTHONUNBUFFERED: 'true'
        # Is there a way we can query the localconf variable to get these
        # rather than setting them explicitly?
        SHADE_HAS_DESIGNATE: 0
        SHADE_HAS_HEAT: 1
        SHADE_HAS_MAGNUM: 0
        SHADE_HAS_NEUTRON: 1
        SHADE_HAS_SWIFT: 1
      tox_install_siblings: False
      tox_envlist: functional
      zuul_work_dir: src/git.openstack.org/openstack-infra/shade
```

This new job definition simplifies a lot the devstack integration tests
and projects now have a much more fine grained control over their integration
with the other OpenStack projects.


# Dashboard

I have been working on the new zuul-web interfaces to replace the scheduler webapp
so that we can scale out the REST endpoints and prevent direct connections
to the scheduler. Here is a summary of the new interfaces:

* /tenants.json : return the list of tenants,
* /{tenant}/status.json : return the status of the pipelines,
* /{tenant}/jobs.json : return the list of jobs defined, and
* /{tenant}/builds.json : return the list of builds from the sql reporter.

Moreover, the new interfaces enable new use cases, for example, users can now:

* Get the list of available jobs and their description,
* Check the results of post and periodic jobs, and
* Dynamically list jobs' results using filters, for example,
  the last tripleo periodic jobs can be obtained using:

```
$ curl ${TENANT_URL}/builds.json?project=tripleo&pipeline=periodic | python -mjson.tool
[
    {
        "change": 0,
        "patchset": 0,
        "id": 16,
        "job_name": "periodic-tripleo-ci-centos-7-ovb-ha-oooq",
        "log_url": "https://logs.openstack.org/periodic-tripleo-ci-centos-7-ovb-ha-oooq/2cde3fd/",
        "pipeline": "periodic",
		...
    },
    ...
]
```

# OpenStack health

The [openstack-health](http://status.openstack.org/openstack-health) service is likely
to be modified to better interface with the new Zuul design.
It is currently connected to an internal gearman bus to receive job completion
events before running the subunit2sql process.

This processing could be rewritten as a post playbook to do the subunit processing
as part of the job. Then the data could be pushed to the SQL server with the credencials
stored in a Zuul's secret.


# Roadmap

The last day, even though most of us were exhausted, we spend some time discussing
the roadmap for the upcoming months. While the roadmap is still being defined,
here are some hilights:

* Based on new user's walkthrough, the documentation will be greatly improved,
  For example see this [nodepool contribution](https://review.openstack.org/#/c/498050/).
* Jobs will be able to return structured data to improve the reporting.
  For example a pypi publisher may return the published url.
  Similarly, a rpm-build job may return the repository url.
* Dashboard web interface and javascript tooling,
* Admin interface to manually trigger unique build or cancel a buildset,
* Nodepool quota to improve performances,
* Cross source dependencies, for example a github change in Ansible could depends-on a gerrit change in shade,
* More Nodepool drivers such as Kubernetes or AWS, and
* Fedmsg and mqtt zuul driver for message bus repporting and trigger source.


In conclusion, the ZuulV3 efforts were extremly fruitful and this article only covers
a few of the design sessions. Once again, we have made great progress and I'm looking forward to further
developments. Thanks you all for the great team gathering event!
