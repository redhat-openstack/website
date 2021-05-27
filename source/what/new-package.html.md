---
title: I want a new package in RDO, now what?
---

# I want a new package in RDO. Now what?
First of all, thanks for contributing! The process to have a new package in RDO can be intimidating at first, but if you are familiar with the creation of RPM packages it should not be too complicated, and there is always someone willing to help at #rdo on the OFTC IRC network.

## Getting started
The first step to have a new package in RDO is to follow the process to [add it to RDO Trunk](https://www.rdoproject.org/documentation/add-packages/). Once a package is in RDO Trunk, it will be built for every new commit of the project, and it will end up in the next GA version.

## Working with rdoinfo
One of the first steps in the process is to edit the rdo.yml file from [rdoinfo](https://www.rdoproject.org/what/new-package/). This file contains the metadata we use in RDO. An example section for a new package is:

```yaml
- project: tempestconf
  conf: rpmfactory-lib
  upstream: git://github.com/redhat-openstack/python-tempestconf.git
  tags:
    pike-uc:
    pike:
    ocata:
  maintainers:
  - chkumar@redhat.com
  - ltoscano@redhat.com
  - dmellado@redhat.com
```

Some of these tags have special meanings, so we will discuss them in detail.

### Configurations
The rdo.yml file has some pre-defined configurations at the top. These configurations define a template for certain fields that follow a common pattern, such as upstream Git repo or package name. These configurations include:

- rpmfactory-core, for service projects (e.g. Nova, Neutron)
- rpmfactory-client, for Python clients (e.g. python-glanceclient, python-cinderclient)
- rpmfactory-lib, for generic Python libraries (e.g. oslo-sphinx, oslo-messaging)
- rpmfactory-puppet, for Puppet modules

So once you have defined a configuration in your new project section, most of the options are defined for you.

### Tags
Tags are used by the RDO Trunk builders to determine which releases we need to build a package for, and if we need to use some release-specific information for a project. In the above example, we are building the `python-tempestconf` package for the Ocata and Pike releases.

You can set some special information for a specific release, for example:

```yaml  
    pike-uc:
      source-branch: 0.7.0
    pike:
    ocata:
      source-branch: 0.7.0
```

The above snippet tells DLRN to use a specific tagged release (0.7.0) when building the package for the pike-uc and ocata releases.

In addition to the release names, we can use some special tags:

- `under-review` is used during the review phase for a new package. Having this tag allows our CI jobs to build the package while being reviewed, but prevents our RDO Trunk builders from adding it to the repos.

- `version-locked` is used to prevent our periodic jobs from proposing updates to the source-branch tag in projects managed by the [upper-constraints file](https://github.com/openstack/requirements/blob/master/upper-constraints.txt). Check [this blog post](https://www.rdoproject.org/blog/2016/11/chasing-the-trunk-but-not-too-fast/) for details on the upper-constraints usage by RDO Trunk packages.

### Maintainers
The list of package maintainers is used as a reference of who takes ownership of the package. It does not mean that nobody else can do modifications to the spec, but it will be used to notify the owners when a package fails to build, what we usually call [FTBFS](https://fedoraproject.org/wiki/Fails_to_build_from_source).

## Testing your spec locally
You can use [DLRN](/what/dlrn) to test all your changes locally before sending any review. You will need:

- A local copy of rdoinfo with your modifications.
- A local DLRN installation.

Let's use a fictional project `test123` as an example. This is a shiny, new project for an OpenStack service, so we create the following new section in our local rdo.yml copy:

```yaml
- project: test123
  conf: rpmfactory-core
  tags:
    under-review:
  maintainers:
  - jpena@redhat.com
```

Since we are using the `rpmfactory-core` configuration, the package name will be `openstack-test123` once built.

Now, we create the spec file for the new package in ``<path to DLRN>/data/openstack-test123_distro/openstack-test123.spec``. To test the package build, we use the following command-line:

```bash
    $ dlrn --config-file projects.ini --package-name openstack-test123 --info-repo <path to rdoinfo> --dev
```

----

[← Promption pipeline](/what/promotion-pipeline) |
[↑ TOC](/what) 

