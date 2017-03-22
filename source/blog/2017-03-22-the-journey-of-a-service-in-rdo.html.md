---
title: The journey of a new OpenStack service in RDO
author: amoralej
tags:
date: 2017-03-22 19:22:55 CET
---



When new contributors join RDO, they ask for recommendations about
how to add new services and help RDO users to adopt it. This post is
not a official policy document nor a detailed description about how to carry
out some activities but provides some high level recommendations to newcomers
based on what I have learned and observed in the last year working in RDO.

Note that you are not required to follow all these steps and even you can
have your own ideas about it. If you want to discuss it, let us know your thoughts, we are always open to improvements.

### 1. Adding the package to RDO

The first step is to add the package(s) to RDO repositories as shown
in [RDO documentation](https://www.rdoproject.org/documentation/rdo-packaging/#how-to-add-a-new-package-to-rdo-trunk).
This tipically includes the main service package, client library and maybe
a package with a plugin for horizon. In some cases you may need to add new
libraries to Fedora which are required for the new packages.

### 2. Create a puppet module

Although there are multiple deployment tools for OpenStack based on several
frameworks, the use of puppet is widely used by different tools or even directly
by operators so we recommend to create a puppet module to deploy your new service
following the [Puppet OpenStack Guide](https://docs.openstack.org/developer/puppet-openstack-guide/).
Once the puppet module is ready, remember to follow the [RDO new package
process](https://www.rdoproject.org/documentation/rdo-packaging/#how-to-add-a-new-puppet-module-to-rdo-trunk)
to get it packaged in the repos.

### 3. Make sure the new service is tested in RDO-CI

As explained in [a previous post](https://www.rdoproject.org/blog/2017/03/rdo-ci-in-a-nutshell/)
we run several jobs in RDO CI to validate the content of our repos. Most
of the times the first way to get it tested is by adding the new service
to one of the puppet-openstack-integration scenarios which is also
recommended to get the puppet module tested in upstream gates. An example
of how to add a new service into p-o-i is in [this review](https://review.openstack.org/#/c/429705/).

### 4. Adding deployment support in Packstack

If you want to make easier for RDO users to evaluate a new service, adding
it to [Packstack](https://wiki.openstack.org/wiki/Packstack) is a good idea.
Packstack is a puppet-based deployment tool used by RDO users to deploy small proof
of concept (PoC) environments to evaluate new services or configurations
before deploying it in their production clouds. If you are interested you can
take a look to [these two reviews](https://review.openstack.org/#/q/405010+OR+360388)
which added support for Panko and Magnum in Ocata cycle.

### 5. Add it to TripleO

[TripleO](https://docs.openstack.org/developer/tripleo-docs/) is a powerful
OpenStack management tool able to provision and manage cloud environments
with production-ready features, as high availability, extended security,
etc... Adding support for new services in TripleO will help the users to
adopt it for their cloud deployments. The [TripleO composable roles tutorial](https://docs.openstack.org/developer/tripleo-docs/developer/tht_walkthrough/tht_walkthrough.html)
can guide you about how to do it.


### 6. Build containers for new services

[Kolla](https://docs.openstack.org/developer/kolla/) is the upstream
project providing container images and deployment tools to operate OpenStack
clouds using container technologies. Kolla supports building images for
CentOS distro using binary method which uses packages from RDO. Operators using
containers will have it easier it if you add containers for new services.

### Other recomendations

#### Follow OpenStack governance policies

RDO methodology and tooling is conceived according to OpenStack upstream
release model, so following policies about [release management](https://github.com/openstack/releases/blob/master/README.rst)
and [requirements](https://github.com/openstack/requirements/blob/master/README.rst)
will help to make package maintenance easier in RDO.


#### Advertise your work to the RDO community

Making potential users aware of availability of new services or other
improvements is a good practice. RDO provides several ways to do this as
sending mails to [our mailing lists](https://www.rdoproject.org/community/mailing-lists/),
writing a post in [the blog](https://www.rdoproject.org/blog/), adding
references in our documentation, creating screencast demos, etc...


####  Join RDO Test Days

RDO organizes [test days](https://www.rdoproject.org/testday/) at several
milestones during each OpenStack release cycle. Although we do Continuous
Integration testing in RDO, it's good to test that it can be deployed
following the instructions in the documentation. You can propose new
services or configurations in the test matrix and add a link to the
documented instructions about how to do it.

#### Upstream documentation

RDO relies on upstream [OpenStack Installation Guide](https://docs.openstack.org/ocata/install-guide-rdo/) for
deployment instructions. Keeping it up to date is recommended.
