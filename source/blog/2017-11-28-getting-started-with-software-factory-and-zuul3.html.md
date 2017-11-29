---
title: Getting started with Software Factory and Zuul3
author: fboucher
tags:
date: 2017-11-28 15:10:00 CEST
---

# Introduction

Software Factory 2.7 has been recently [released](https://www.redhat.com/archives/softwarefactory-dev/2017-November/msg00014.html).
Software Factory is an easy to deploy software development forge that is deployed at
[review.rdoproject.org](https://review.rdoproject.org) and [softwarefactory-project.io](https://softwarefactory-project.io).
Software Factory provides, among other features, code review and continuous integration (CI).
This new release features [Zuul V3](https://docs.openstack.org/infra/zuul/) that is, now, the default CI
component of Software Factory.

In this blog post I will explain how to deploy a Software Factory
instance for testing purposes in less than 30 minutes and initialize
two demo repositories to be tested via Zuul.

Note that Zuul V3 is not yet released upstream however
it is already in production, acting as the CI system of OpenStack.

# Prerequisites

Software Factory requires CentOS 7 as its base Operating System so
the commands listed below should be executed on a fresh deployment of CentOS 7.

The default FQDN of a Software Factory deployment is *sftests.com*. In order to
be accessible in your browser, `sftests.com` must be added to your */etc/hosts*
with the IP address of your deployment.

# Installation

First, let's install the repository of the last version then
install *sf-config*, the configuration management tool.

```shell
sudo yum install -y https://softwarefactory-project.io/repos/sf-release-2.7.rpm
sudo yum install -y sf-config
```

# Activating extra components

Software Factory has a modular architecture that can be easily defined through
a YAML configuration file, located in */etc/software-factory/arch.yaml*. By default,
only a limited set of components are activated to set up a minimal CI with Zuul V3.

We will now add the *hypervisor-oci* component to configure a container provider,
so that [OCI containers](https://www.opencontainers.org/) can be consumed by Zuul
when running CI jobs. In others words it means you won't need an OpenStack cloud
account for running your first Zuul V3 jobs with this Software Factory instance.

Note that the OCI driver, on which *hypervisor-oci* relies, while totally functional,
is still under review and not yet merged upstream.

```shell
echo "      - hypervisor-oci" | sudo tee -a /etc/software-factory/arch.yaml
```

# Starting the services

Finally run *sf-config*:

```shell
sudo sfconfig --enable-insecure-slaves --provision-demo
```

When the *sf-config* command finishes you should be able to access
the Software Factory web UI by connecting your browser to https://sftests.com.
You should then be able to login using the login *admin* and password *userpass*
(Click on "Toggle login form" to display the built-in authentication).

# Triggering a first job on Zuul

The *--provision-demo* option is a special command to provision two demo Git
repositories on Gerrit with two demo jobs.

Let's propose a first change on it:

```shell
sudo -i
cd demo-project
touch f1 && git add f1 && git commit -m"Add a test change" && git review
```

Then you should see the jobs being executed on the ZuulV3 status page.

![Zuul buildset](images/zuul.png)

And get the jobs' results on the corresponding Gerrit review page.

![Gerrit change](images/gerrit.png)

Finally, you should find the links to the generated artifacts and the [ARA](https://github.com/openstack/ara) reports.

![ARA report](images/ara.png)

# Next steps to go further

To learn more about Software Factory please refer to [the user documentation](https://softwarefactory-project.io/docs/).
You can reach the Software Factory team on IRC freenode channel #softwarefactory
or by email at the softwarefactory-dev@redhat.com mailing list.
