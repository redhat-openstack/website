---
title: What's new in ZuulV3
author: tristanC
date: 2017-08-01 15:00:00 UTC
tags: openstack, infra, zuul, software-factory
comments: true
published: true
---

[Zuul](https://docs.openstack.org/infra/zuul/) is a program used to
gate a project's source code repository so that changes are only
merged if they pass integration tests. This article presents some
of the new features in the next version:
[ZuulV3](https://docs.openstack.org/infra/zuul/feature/zuulv3/)


## Distributed configuration

The configuration is distributed accross projects' repositories,
for example, here is what the new zuul main.yaml configuration will
look like:

```yaml
- tenant:
    name: downstream
    source:
      gerrit:
        config-projects:
          - config
        untrusted-projects:
          - restfuzz
      openstack.org:
        untrusted-projects:
          - openstack-infra/zuul-jobs:
              include: job
              shadow: config
```

This configuration describes a *downstream* tenant with two sources. Gerrit
is a local gerrit instance and openstack.org is the review.openstack.org
service. For each sources, there are 2 types of projects:

* config-projects hold configuration information such as logserver access.
  Jobs defined in config-projects run with elevated privileges.
* untrusted-projects are projects being tested or deployed.

The openstack-infra/zuul-jobs has special settings discussed below.


## Default jobs with openstack-infra/zuul-jobs

The openstack-infra/zuul-jobs repository contains common job definitions and
Zuul only imports jobs that are not already defined (shadow) in the local
config.

This is great news for Third Party CIs that will easily be able to re-use
upstream jobs such as tox-docs or tox-py35 with their convenient
post-processing of unittest results.


## In-repository configuration

The new distributed configuration enables a more streamlined workflow.
Indeed, pipelines and projects are now defined in the project's repository
which allows changes to be tested before merging.

Traditionaly, projects' CI needed to be configured in two steps: first, the jobs
were defined, then a test change was rechecked until the job was working.
This is no longer needed because the jobs and configurations are directly set in
the repository and CI change undergoes the CI workflow.

After being registered in the main.yaml file, a project author can submit a
.zuul.yaml file (along with any other changes needed to make the test succeed).
Here is a minimal zuul.yaml setting:

```yaml
- project:
    name: restfuzz
    check:
      jobs:
        - tox-py35
```

Zuul will look for a zuul.yaml file or a zuul.d directory as well as hidden
versions prefixed by a '.'. The project can also define its own jobs.


## Ansible job definition

Jobs are now created in Ansible, which brings many advantages over
the Jenkins Jobs Builder format:

* Multi-node architecture where tasks are easily distributed,
* Ansible module ecosystem simplify complex task, and
* Manual execution of jobs.

Here is an example:

```yaml
- job:
    name: restfuzz-rdo
    parent: base
    run: playbooks/rdo
    nodes:
      - name: cloud
        label: centos
      - name: fuzzer
        label: fedora
```

Then the playbook can be written like this:

```yaml
- hosts: cloud
  tasks:
    - name: "Deploy rdo"
      command: packstack --allinone
      become: yes
      become_user: root

    - name: "Store openstackrc"
      command: "cat /root/keystonerc_admin
      register: openstackrc
      become: yes
      become_user: root

- hosts: fuzzer
  tasks:
    - name: "Setup openstackrc"
      copy:
        content: "{{ hostvars['cloud']['openstackrc'].stdout }}"
        dest: "{{ zuul_work_dir }}/.openstackrc"

    - name: "Deploy restfuzz"
      command: python setup.py install
      args:
        chdir: "{{ zuul_work_dir }}"
      become: yes
      become_user: root

    - name: "Run restfuzz"
      command: "restfuzz --target {{ hostvars['cloud']['ansible_eth0']['ipv4']['address'] }}"
```

The base parent from the config project manages the pre phase to copy
the sources to the instances and the post phase to publish the job logs.


## Nodepool drivers

This is still a work in [progress](https://review.openstack.org/#/q/topic:nodepool-drivers)
but it's worth noting that Nodepool is growing a driver based design to
support non-openstack providers. The primary goal is to support static node
assignements, and the interface can be used to implement new providers.
A driver needs to implement a Provider class to manage access to a new API,
and a RequestHandler to manage resource creation.

As a Proof Of Concept, I wrote an
[OpenContainer driver](https://review.openstack.org/468753) that can spawn
thin instances using RunC:

```yaml
providers:
  - name: container-host-01
    driver: oci
    hypervisor: fedora.example.com
    pools:
      - name: main
        max-servers: 42
        labels:
          - name: fedora-26-oci
            path: /
          - name: centos-6-oci
            path: /srv/centos6
          - name: centos-7-oci
            path: /srv/centos7
          - name: rhel-7.4-oci
            path: /srv/rhel7.4
```

This is good news for operators and users who don't have access to an
OpenStack cloud since Zuul/Nodepool may be able to use new providers
such as OpenShift for example.


In conclusion, ZuulV3 brings a lot of new cool features to the table,
and this article only covers a few of them. Check the
[documentation](https://docs.openstack.org/infra/zuul/feature/zuulv3/)
for more information and stay tuned for the upcoming release.
