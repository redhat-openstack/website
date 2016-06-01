---
title: "Newbie in RDO: one size doesn't fit all"
author: amoralej
tags: openstack, rdo, repos
date: 2016-05-30 17:18:23 CEST
published: true
---

As a new contributor to the RDO project, one of my first tasks was to understand what is actually being produced by the project. According to [RDO faq](https://www.rdoproject.org/rdo/faq/), the main goal is to maintain a freely-available, community-supported distribution of OpenStack based on RPM packages able to run Red Hat Enterprise Linux, CentOS, Fedora, and their derivatives. But the RDO community is diverse and different use patterns have been found over the time with different requirements:

- Organizations running production OpenStack clouds with community support require a stable distribution.
- Organizations running production environments with community or enterprise-grade distributions require sometimes an up-to-date distribution to test recent functionalities and plan the future of their cloud deployments.
- Developers require up-to-date distribution to test their changes and run their CI jobs.
- Packagers need to have full control over the packaging process.

Providing a suitable distribution for all these scenarios is not an easy task and the RDO community ended up with two different distribution set of repos targetting different purposes:

### RDO CloudSIG repos
Provide a set of stable OpenStack packages through CentOS CloudSIG repos based on CBS, [CentOS Community Build System](https://wiki.centos.org/HowTos/CommunityBuildSystem):

- The RDO CloudSIG repos are only published after GA of a upstream release (only stable branches are used, not master).
- New packages are created only when a new point release is published (release tag created) on upstream stable repositories. The RDO community is currently working to automate as much as possible the process to build these packages in rpmfactory.
- In addition to the vanilla upstream code, some patches may be applied during packaging:
  - Fixes for security issues or critical bugs not backported upstream. Note that an upstream-first policy is applied so these patches will be applied only after merged in upstream master.
  - Patches required for the packaging process.
- Packages are created through a controlled workflow. This is accomplished by koji (the technology behind CBS) which ensures reproducibility of the building process by:
  - Creating a self-contained build environment (buildroot) that provides all the dependencies by a controlled package. No network access exist int this build environment.
  - Recording both the spec file defining the package to be built and the packages included in the buildroot. This information allows to recreate exactly the same build environment to create the package at a later point in time.
- The criteria for pubishing any new release includes both thechnical (a set of CI jobs must pass as aggreed in [RDO community meeting](https://meetbot.fedoraproject.org/rdo/2016-04-06/rdo_meeting_%282016-04-06%29.2016-04-06-15.00.html)) and non-technical requirements (documentation, etc...).

This is probably what you want to use for your stable cloud with a community-supported OpenStack distribution and what you will use following the [official upstream install guide](http://docs.openstack.org/mitaka/install-guide-rdo/environment-packages.html) or [RDO docummentation](https://www.rdoproject.org/install/) to deploy and manage OpenStack.


### RDO Trunk repos
Provide RPM package repositories for OpenStack projects as close as possible to the vanilla upstream code in order to test any change and catch any bug or impact on packaging as soon as possible. These packages are built when a commit is merged in upstream master or any of the supported stable branches. This means that new packages are provided even during the development phase of a new release (before GA). Once a build is done, a set of CI jobs is passed to validate installation and basic functionalities. As part of RDO Trunk we provide different repos for CentOS 7 under http://trunk.rdoproject.org/centos7-&lt;release>/ :

- **consistent:** provides the latest snapshot of packages successfully built (i.e. https://trunk.rdoproject.org/centos7-master/consistent/).
- **current-passed-ci:** provides the latest snapshot of packages built and with CI jobs successfully passed (i.e. https://trunk.rdoproject.org/centos7-master/current-passed-ci/).
- **current-tripleo:** provides the latest snapshot of packages tested by specific TripleO CI jobs on master branch (https://trunk.rdoproject.org/centos7-master/current-tripleo/)

Currently (may '16'), &lt;release> can be master, mitaka or liberty.

As operators, these repos may not be the best option to run a stable OpenStack cloud but it can be a good choice in some cases:

- You are interested in deploying an environment to test latest changes in OpenStack code
- You need to quickly apply a patch that has been merged upstream and can't wait until it's included in a point release and is properly packaged in RDO CloudSIG repos. Note that "current-passed-ci" repos are recommended in this case.

If you are a OpenStack developer, using RDO trunk may be a good option to build your environments with latest vanilla upstream code.

Finally, if you are a packager, you probably want to know how the build process went for a specific commit or even to perform an installation based on it. RDO also provides both build reports and RPM repos based on each commit for both CentOS and Fedora from [http://trunk.rdoproject.org](http://trunk.rdoproject.org).

[Fred](http://blogs.rdoproject.org/author/fred) wrote an excelent [post](http://blogs.rdoproject.org/7834/delorean-openstack-packages-from-the-future) describing how DLRN (f.k.a. delorean) builds packages for RDO trunk repos.

If you are interested in the details about how to build RDO packages, you'll find a lot of interesting information in [RDO documentation](https://www.rdoproject.org/documentation/packaging/).

And remember that if you are looking for enterprise-level support, or information on partner certification, Red Hat also offers [Red Hat Enterprise Linux OpenStack Platform](https://redhat.com/openstack).
