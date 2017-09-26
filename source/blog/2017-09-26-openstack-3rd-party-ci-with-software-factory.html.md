---
title: OpenStack 3rd Party CI with Software Factory
author: jpena
tags: 
date: 2017-09-26 11:34:30 CEST
---


# Introduction

When developing for an OpenStack project, one of the most important aspects to cover is to ensure
proper CI coverage of our code. Each OpenStack project runs a number of CI jobs on each commit to
test its validity, so thousands of jobs are run every day in the upstream infrastructure.

In some cases, we will want to set up an external CI system, and make it report as a 3rd Party CI
on certain OpenStack projects. This may be because we want to cover specific software/hardware
combinations that are not available in the upstream infrastructure, or want to extend test
coverage beyond what is feasible upstream, or any other reason you can think of.

While the process to set up a 3rd Party CI [is documented](https://docs.openstack.org/infra/system-config/third_party.html),
some implementation details are missing. In the RDO Community, we have been using [Software Factory](https://softwarefactory-project.io/docs)
to power our 3rd Party CI for OpenStack, and it has worked very reliably over some cycles.

The main advantage of Software Factory is that it integrates all the pieces of the OpenStack CI
infrastructure in an easy to consume package, so let's have a look at how to build a 3rd party CI
from the ground up.

# Requirements

You will need the following:

- An OpenStack-based cloud, which will be used by Nodepool to create temporary VMs where the CI jobs
  will run. It is important to make sure that the `default` security group in the tenant accepts SSH
  connections from the Software Factory instance.
- A CentOS 7 system for the Software Factory instance, with at least 8 GB of RAM and 80 GB of disk.
  It can run on the OpenStack cloud used for nodepool, just make sure it is running on a separate
  project.
- DNS resolution for the Software Factory system.
- A 3rd Party CI user on review.openstack.org. Follow [this guide](https://docs.openstack.org/infra/system-config/third_party.html#creating-a-service-account) to configure it.
- Some previous knowledge on how [Gerrit](https://www.gerritcodereview.com/) and [Zuul](https://github.com/openstack-infra/zuul)
  work is advisable, as it will help during the configuration process.

# Basic Software Factory installation

For a detailed installation walkthrough, refer to the [Software Factory documentation](https://softwarefactory-project.io/docs/deploy.html).
We will highlight here how we set it up on a test VM.

## Software installation

On the CentOS 7 instance, run the following commands to install the latest release of Software Factory (2.6 at the time of this article):

```shell
$ sudo yum install -y https://softwarefactory-project.io/repos/sf-release-2.6.rpm
$ sudo yum update -y
$ sudo yum install -y sf-config
```

## Define the architecture

Software Factory has several optional components, and can be set up to run them on more than one system.
In our setup, we will install the minimum required components for a 3rd party CI system, all in one.

```shell
$ sudo vi /etc/software-factory/arch.yaml
```

Make sure the `nodepool-builder` role is included. Our file will look like:

```yaml
---
description: "OpenStack 3rd Party CI deployment"
inventory:
  - name: managesf
    ip: 192.168.122.230
    roles:
      - install-server
      - mysql
      - gateway
      - cauth
      - managesf
      - gitweb
      - gerrit
      - logserver
      - zuul-server
      - zuul-launcher
      - zuul-merger
      - nodepool-launcher
      - nodepool-builder
      - jenkins
```

In this setup, we are using Jenkins to run our jobs, so we need to create an additional file:

```shell
$ sudo vi /etc/software-factory/custom-vars.yaml
```

And add the following content

```yaml
nodepool_zuul_launcher_target: False
```

**Note**: As an alternative, we could use zuul-launcher to run our jobs and drop Jenkins. In that case,
there is no need to create this file. However, [later when defining our jobs](#define-test-job) we will need to use the
`jobs-zuul` directory instead of `jobs` in the config repo.

## Edit Software Factory configuration

```shell
$ sudo vi /etc/software-factory/sfconfig.yaml
```

This file contains all the configuration data used by the `sfconfig` script. Make sure you set the
following values:

- Password for the default `admin` user.

```yaml
authentication:
  admin_password: supersecurepassword
```

- The fully qualified domain name for your system.

```yaml
fqdn: sftests.com
```

- The OpenStack cloud configuration required by Nodepool.

```yaml
nodepool:
  providers:
  - auth_url: http://192.168.1.223:5000/v2.0
    name: microservers
    password: cloudsecurepassword
    project_name: mytestci
    region_name: RegionOne
    regions: []
    username: ciuser
```

- The authentication options if you want other users to be able to log into your instance of
Software Factory using OAuth providers like GitHub. This is not mandatory for a 3rd party CI.
See [this part of the documentation](https://softwarefactory-project.io/docs/auths.html#oauth2-based-authentication) for details.

- If you want to use [LetsEncrypt](https://letsencrypt.org/) to get a proper SSL certificate, set:

```yaml
  use_letsencrypt: true
```

## Run the configuration script

You are now ready to complete the configuration and get your basic Software Factory installation running.

```shell
$ sudo sfconfig
```

After the script finishes, just point your browser to https://<your-fqdn> and you can see the
Software Factory interface.

![SF interface](/images/SF_basic_gui.png "Software Factory interface")

# Configure SF to connect to the OpenStack Gerrit

Once we have a basic Software Factory environment running, and our service account set up in
review.openstack.org, we just need to connect both together. The process is quite simple:

- First, make sure the local Zuul user SSH key, found at `/var/lib/zuul/.ssh/id_rsa.pub`, is added
to the service account at [review.openstack.org](https://review.openstack.org/#/settings/ssh-keys).

- Then, edit `/etc/software-factory/sfconfig.yaml` again, and edit the `zuul` section
to look like:

```yaml
zuul:
  default_log_site: sflogs
  external_logservers: []
  gerrit_connections:
  - name: openstack
    hostname: review.openstack.org
    port: 29418
    puburl: https://review.openstack.org/r/
    username: mythirdpartyciuser
```

- Finally, run `sfconfig` again. Log information will start flowing in `/var/log/zuul/server.log`,
and you will see a connection to `review.openstack.org` port 29418.

# Create a test job

In Software Factory 2.6, a special project named `config` is automatically created on the internal
Gerrit instance. This project holds the user-defined configuration, and changes to the project must
go through Gerrit.

## Configure images for nodepool

All CI jobs will use a predefined image, created by Nodepool. Before creating any CI job, we need to
prepare this image.

- As a first step, add your SSH public key to the admin user in your Software Factory Gerrit instance.

![Add SSH Key](/images/ssh-keys.png "Adding an SSH key")

- Then, clone the config repo on your computer and edit the nodepool configuration file:

```shell
$ git clone ssh://admin@sftests.com:29418/config sf-config
$ cd sf-config
$ vi nodepool/nodepool.yaml
```

- Define the disk image and assign it to the OpenStack cloud defined previously:

```yaml
---
diskimages:
  - name: dib-centos-7
    elements:
      - centos-minimal
      - nodepool-minimal
      - simple-init
      - sf-jenkins-worker
      - sf-zuul-worker
    env-vars:
      DIB_CHECKSUM: '1'
      QEMU_IMG_OPTIONS: compat=0.10
      DIB_GRUB_TIMEOUT: '0'

labels:
  - name: dib-centos-7
    image: dib-centos-7
    min-ready: 1
    providers:
      - name: microservers

providers:
  - name: microservers
    cloud: microservers
    clean-floating-ips: true
    image-type: raw
    max-servers: 10
    boot-timeout: 120
    pool: public
    rate: 2.0
    networks:
      - name: private
    images:
      - name: dib-centos-7
        diskimage: dib-centos-7
        username: jenkins
        min-ram: 1024
        name-filter: m1.medium
```

First, we are defining the [diskimage-builder](http://github.com/openstack/diskimage-builder) elements
that will create our image, named `dib-centos-7`.

Then, we are assigning that image to our `microservers` cloud provider, and specifying that we want
to have at least 1 VM ready to use.

Finally we define some specific parameters about how Nodepool will use our cloud provider: the
internal (`private`) and external (`public`) networks, the flavor for the virtual machines to create
(`m1.medium`), how many seconds to wait between operations (`2.0` seconds), etc.

- Now we can submit the change for review:

```shell
$ git add nodepool/nodepool.yaml
$ git commit -m "Nodepool configuration"
$ git review
```

- In the Software Factory Gerrit interface, we can then check the open change. The `config` repo has
some predefined CI jobs, so you can check if your syntax was correct. Once the CI jobs show a
`Verified +1` vote, you can approve it (Code Review +2, Workflow +1), and the change will be merged in
the repository.

- After the change is merged in the repository, you can check the logs at `/var/log/nodepool` and see
the image being created, then uploaded to your OpenStack cloud.

## Define test job

There is a special project in OpenStack meant to be used to test 3rd Party CIs,
`openstack-dev/ci-sandbox`. We will now define a CI job to "check" any new commit being reviewed there.

- Assign the nodepool image to the test job

```shell
$ vi jobs/projects.yaml
```

We are going to use a pre-installed job named `demo-job`. All we have to do is to ensure it uses the
image we just created in Nodepool.

```yaml
- job:
    name: 'demo-job'
    defaults: global
    builders:
      - prepare-workspace
      - shell: |
          cd $ZUUL_PROJECT
          echo "This is a demo job"
    triggers:
      - zuul
    node: dib-centos-7
```

- Define a Zuul pipeline and a job for the ci-sandbox project

```shell
$ vi zuul/upstream.yaml
```

We are creating a specific [Zuul pipeline](https://docs.openstack.org/infra/zuul/zuul.html#pipelines)
for changes coming from the OpenStack Gerrit, and specifying that we want to run a CI job for commits
to the ci-sandbox project:

```yaml
pipelines:
  - name: openstack-check
    description: Newly uploaded patchsets enter this pipeline to receive an initial +/-1 Verified vote from Jenkins.
    manager: IndependentPipelineManager
    source: openstack
    precedence: normal
    require:
      open: True
      current-patchset: True
    trigger:
      openstack:
        - event: patchset-created
        - event: change-restored
        - event: comment-added
          comment: (?i)^(Patch Set [0-9]+:)?( [\w\\+-]*)*(\n\n)?\s*(recheck|reverify)
    success:
      openstack:
        verified: 0
    failure:
      openstack:
        verified: 0

projects:
  - name: openstack-dev/ci-sandbox
    openstack-check:
      - demo-job
```

Note that we are telling our job not to send a vote for now (`verified: 0`). We can change that later
if we want to make our job voting.

- Apply configuration change

```shell
$ git add zuul/upstream.yaml jobs/projects.yaml
$ git commit -m "Zuul configuration for 3rd Party CI"
$ git review
```

Once the change is merged, Software Factory's Zuul process will be listening for changes to the
[ci-sandbox project](https://github.com/openstack-dev/ci-sandbox). Just try creating a change and see
if everything works as expected!

# Troubleshooting

If something does not work as expected, here are some troubleshooting tips:

## Log files

You can find the Zuul log files in `/var/log/zuul`. Zuul has several components, so start with checking `server.log`
and `launcher.log`, the log files for the main server and the process that launches CI jobs.

The Nodepool log files are located in `/var/log/nodepool`. `builder.log` contains the log from image
builds, while `nodepool.log` has the log for the main process.

## Nodepool commands

You can check the status of the virtual machines created by nodepool with:

```shell
$ sudo nodepool list
```

Also, you can check the status of the disk images with:

```shell
$ sudo nodepool image-list
```

## Jenkins status

You can see the Jenkins status from the GUI, at https://<your fqdn>/jenkins/, if logged on with the admin
user. If no machines show up at the 'Build Executor Status' pane, that means that either Nodepool could
not launch a VM, or there was some issue in the connection between Zuul and Jenkins. In that case,
check the jenkins logs at `/var/log/jenkins`, or restart the service if there are errors.

# Next steps

For now, we have only ran a test job against a test project. The real power comes when you create
a proper CI job on a project you are interested in. You should now:

- Create a file under `jobs/` with the [JJB](https://docs.openstack.org/infra/jenkins-job-builder/)
definition for your new job.

- Edit `zuul/upstream.yaml` to add the project(s) you want your 3rd Party CI system to watch.
