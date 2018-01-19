---
title: Overview of a CI/CD workflow with Zuul
date: 2018-01-22
author: tristanC
tags: software-factory, zuul, ci, cd
---

The upcoming version of [Zuul](https://docs.openstack.org/infra/zuul/)
has many new features that allow one to create powerful continuous
integration and continuous deployment pipelines.

This article presents some mechanisms to create such pipelines.
As a practical example, I demonstrate the Software Factory project
development workflow we use to continously build, test and deliver
rpm packages through code review.


# Build job

The first stage of this workflow is to build a new package for each change.

## Build job definition

The build job is defined in a zuul.yaml
[file](https://softwarefactory-project.io/r/gitweb?p=software-factory/sfinfo.git;a=blob;f=zuul.d/jobs.yaml):

```yaml
- job:
    name: sf-rpm-build
    description: Build Software Factory rpm package
    run: playbooks/rpmbuild.yaml
    required-projects:
      - software-factory/sfinfo
    nodeset:
      nodes:
        - name: mock-host
          label: centos-7
```

The *required-projects* option declare projects that are needed to run the
job. In this case, the package metadata, such as the software collection
targets are defined in the sfinfo project.
This mean that everytime this job is executed, the sfinfo project will be
copied to the test instance.

Extra required-projects can be added per project, for example the cauth package
requires the cauth-distgit project to build a working package.
The cauth pipeline can be defined as:

```yaml
- project:
    name: software-factory/cauth
    check:
      jobs:
        - sf-rpm-build:
            required-projects:
              - software-factory/cauth-distgit
```
Most of the job parameters can be modified when added to a
project pipeline. In the case of the *required-projects* the list isn't replaced
but extended. This means a change on the cauth project results in the
sf-rpm-build job running with the sfinfo and cauth-distgit projects.


## Build job playbook

The build job is an Ansible
[playbook](https://softwarefactory-project.io/r/gitweb?p=software-factory/sfinfo.git;a=blob;f=playbooks/rpmbuild.yaml):

```yaml
- hosts: mock-host
  vars:
    # Get sfinfo location
    sfinfo_path_query: "[?name=='software-factory/sfinfo'].src_dir"
    sfinfo_path: >
      {{ (zuul.projects.values() | list | json_query(sfinfo_path_query))[0] }}
    # Get workspace path to run zuul_rpm_* commands
    sfnamespace_path: "{{ sfinfo_path | dirname | dirname }}"
  tasks:
    - name: Copy rpm-gpg keys
      become: yes
      command: "rsync -a {{ sfinfo_path }}/rpm-gpg/ /etc/pki/rpm-gpg/"

    - name: Run zuul_rpm_build.py
      command: >
        ./software-factory/sfinfo/zuul_rpm_build.py
            --distro-info ./software-factory/sfinfo/sf-{{ zuul.branch }}.yaml
            --zuulv3
            {% for item in zuul['items'] %}
              --project {{ item.project.name }}
            {% endfor %}
      args:
        chdir: "{{ sfnamespace_path }}"

    - name: Fetch zuul-rpm-build repository
      synchronize:
        src: "{{ sfnamespace_path }}/zuul-rpm-build/"
        dest: "{{ zuul.executor.log_root }}/buildset/"
        mode: pull
```

First, the variables use JMES query to discover the path of the sfinfo project
location on the test instance. Indeed the Zuul executor prepares the workspace
using relative paths constructed from the connection hostname. For reference,
the playbook starts with a *zuul.projects* variable like the one below:

```yaml
zuul:
  projects:
    managesf.softwarefactory-project.io/software-factory/sfinfo:
      name: software-factory/sfinfo
      src_dir: src/gerrit.softwarefactory-project.io/software-factory/sfinfo
    ...
```

Then the job runs the package building command using a loop on
Zuul items. This enables the cross repository dependencies feature of Zuul
where this job needs to build all the projects that are added as depends-on.
Note that this is automatically done by the "tox" job, see
the [install_sibling task](http://git.openstack.org/cgit/openstack-infra/zuul-jobs/tree/roles/tox/tasks/siblings.yaml).
For reference, the playbook starts with a *zuul.items* variable like the one
below:

```yaml
zuul:
  items:
    - branch: master
      change_url: https://softwarefactory-project.io/r/10736
      project:
        name: scl/zuul-jobs-distgit
    - branch: master
      change_url: https://softwarefactory-project.io/r/10599
      project:
        name: software-factory/sf-config
    - branch: master
      change_url: https://softwarefactory-project.io/r/10605
      project:
        name: software-factory/sf-ci
```

In this example, the depends-on list includes three changes:
* Pages roles added to zuul-jobs-distgit,
* Pages jobs configured in sf-config, and
* Functional tests added to sf-ci.

The sf-rpm-build job will build a new package for each of these changes.

The last task fetches the resulting rpm repository to the job logs.
Any jobs, playbooks or tasks can synchronize artifacts to the
*zuul.executor.log_root* directory.
Having the packages exported with the job logs is convenient for the end users
to easily install the packages built in the CI.
Moreover, this will also be used by the integration jobs below.


# Integration pipeline

The second stage of the workflow is to test the packages built by the
sf-rpm-build job.

## Share Zuul artifacts between jobs

Child jobs can inherit data produced by a parent job when using the
*zuul_return* Ansible module. The
[buildset-artifacts-location](https://review.openstack.org/530679) role
automatically set the artifacts job logs url using this task:

```yaml
- name: Define buildset artifacts location
  delegate_to: localhost
  zuul_return:
    data:
      buildset_artifacts_url: "{{ zuul_log_url }}/{{ zuul_log_path }}/buildset"
```

Software Factory configures this role along the upload-logs to transparently
define this *buildset_artifacts_url* variable when there is a *buildset*
directory in the logs.


## Integration pipeline definition

The integration pipeline is defined in a zuul.yaml
[file](https://softwarefactory-project.io/r/gitweb?p=software-factory/sfinfo.git;a=blob;f=zuul.d/templates.yaml):

```yaml
- project-template:
    name: sf-jobs
    check:
      jobs:
        - sf-rpm-build
        - sf-ci-functional-minimal:
            dependencies:
              - sf-rpm-build
        - sf-ci-upgrade-minimal:
            dependencies:
              - sf-rpm-build
        - sf-ci-functional-allinone:
            dependencies:
              - sf-rpm-build
        - sf-ci-upgrade-allinone:
            dependencies:
              - sf-rpm-build
```

The functional and upgrade jobs use the *dependencies* option to
declare that they only run after the rpm-build job is finished.
The functional and upgrade jobs use new packages using the task below:

```yaml
- name: Add CI packages repository
  yum_repository:
    name: "zuul-built"
    baseurl: "{{ buildset_artifacts_url }}"
    gpgcheck: "0"
  become: yes
```


## Projects definition

The sfinfo project is a *config-project* in Zuul configuration.
It enables the defining of all the projects' jobs without requiring the
addition of a zuul.yaml file in each project.
Config-projects are allowed to configure foreign projects' jobs, for example:

```yaml
- project:
    name: scl/zuul-jobs-distgit
    templates:
      - sf-jobs
```

A good design for this workflow defines common jobs in a dedicated repository
and the common pipeline definitions in a config-projects.
*Untrusted-projects* can still add local jobs if needed and can even
add dependencies to the common pipelines. For example, the cauth project
extends the required-projects for the sf-rpm-build.


# Deployment pipeline

When a change succeeds the integration tests the reviewer can approve it to
trigger the deployment pipeline. The first thing to understand is how to
use secrets in the deployment job.

## Using secrets in jobs

Zuul can securely manage secrets using public key cryptography. Zuul
manages a private key for each project and the user can encrypt secrets with
the public key to store them in the repository along with the job. That
means encryption is a one-way operation for the user and only the Zuul
scheduler can decrypt the secret.

To create a new secret the user runs the [encrypt_secret](http://git.openstack.org/cgit/openstack-infra/zuul/tree/tools/encrypt_secret.py) tool:

```yaml
# encrypt_secret.py --infile secret.data <zuul-web-url>/keys/<tenant-name> <project-name>
- secret:
    name: <secret-name>
    data:
      <variable-name>: !encrypted/pkcs1-oaep
        - ENCRYPTED-DATA-HERE
```

Once a secret is added to a job the playbook will have access to its
decrypted content. However, there are a few caveats:

* The secret and the playbook need to be defined in a **single job**
  stored in the **same project**. Note that this may change in the
  [future](http://lists.zuul-ci.org/pipermail/zuul-discuss/2018-January/000010.html).
* If the secret is defined in an *untrusted-project*,
  then the job is automatically converted to *post-review*.
  That means jobs using secrets can only run in post, periodic or release
  pipelines. This prevents speculative job modifications from leaking
  the secret content.
* Alternatively, if the secret is defined in a *config-project*, then the
  job can be used in any pipeline because config-projects don't allow
  speculative execution on new patchset.


## Deployment pipeline definition

In the Software Factory project, the deployment is a
[koji](https://fedoraproject.org/wiki/Koji) build and
is performed as part of the gate pipeline.
That means the change isn't merged if it is not deployed.
Another strategy is to deploy in the post pipeline after the change is
merged, or in the release pipeline after a tag is submitted.

The deployment pipeline is defined as below:

```yaml
- project-template:
    name: sf-jobs
    gate:
      queue: sf
      jobs:
        - sf-rpm-build
        - sf-ci-functional-minimal:
            dependencies:
              - sf-rpm-build
        - sf-ci-upgrade-minimal:
            dependencies:
              - sf-rpm-build
        - sf-ci-functional-allinone:
            dependencies:
              - sf-rpm-build
        - sf-ci-upgrade-allinone:
            dependencies:
              - sf-rpm-build
        - sf-rpm-publish:
            dependencies:
              - sf-ci-functional-minimal
              - sf-ci-upgrade-minimal
              - sf-ci-functional-allinone
              - sf-ci-upgrade-allinone
```

The deployment pipeline needs to use the *queue* option to group all the
approved changes in dependent order.
When multiple changes are approved in parallel, they will all be tested
together before being merged, as if they were submitted with a
depends-on relationship.

The deployment pipeline is similar to the integration pipeline, it just adds
a publish job that will only run if all the integration tests succeed.
This ensures that changes are consistently tested with the projects' current
state before being deployed.


## Deployment job definition

The job is declared in a zuul.yaml file as below:

```yaml
- job:
    name: sf-rpm-publish
    description: Publish Software Factory rpm to koji
    run: playbooks/rpmpublish.yaml
    hold-following-changes: true
    required-projects:
      - software-factory/sfinfo
    secrets:
      - sf_koji_configuration
```

This job is using the *hold-following-changes* setting to ensure that only
the top of the gate gets published. If the deployement is happening in the
post or release pipeline, then this setting can be replaced by a *semaphore*
instead, for example:

```yaml
- job:
    name: deployment
    semaphore: production-access

- semaphore:
    name: production-access
    max: 1
```

This prevents concurrency issues when multiple changes are approved in parallel.


# Zuul concepts summary

This article covered the following concepts:

* Project types:

  * *config-projects*: hold deployment secrets and set projects' pipelines.
  * *untrusted-projects*: the projects being tested and deployed.

* Playbook variables:

  * *zuul.projects*: the projects installed on the test instance,
  * *zuul.items*: the list of changes being tested with depends-on,
  * *zuul.executor.log_root*: the location of job artifacts, and
  * *zuul_return*: an Ansible module to share data between jobs.

* Job options:

  * *required-projects*: the list of projects to copy on the test instance,
  * *dependencies*: the list of jobs to wait for,
  * *secret*: the deployment job's secret,
  * *post-review*: prevents a job from running speculatively,
  * *hold-following-changes*: makes dependent pipelines run in serial, and
  * *semaphore*: prevents concurrent deployment of different changes.

* Pipeline options:

  * Job settings can be modified per project, and
  * *queue* makes all the projects depend on each other automatically.

# Conclusion

To experiment Zuul by yourself, follow this deployment guide written by Fabien
in this [previous article](https://www.rdoproject.org/blog/2017/11/getting-started-with-software-factory-and-zuul3/).

Zuul can be used to effectively manage complex continous integration and
deployment pipelines with powerfull cross repository dependencies management.

This article presented the Software Factory workflow where rpm packages are
being continously built, tested and delivered through code review.
A similar workflow can be created for other types of projects such as golang
or container based software.
