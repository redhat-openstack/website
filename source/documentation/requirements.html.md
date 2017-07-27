---
author: amoralej
title: General purpose requirements
---

# Requirements management in RDO 

1. toc
{:toc}

## Introduction

OpenStack services usually need some pieces of software which are not developed as
part of the project. They are are general purpose libraries (typically python
modules) or services used in some way to run or build OpenStack packages.

OpenStack [requirements project](https://docs.openstack.org/developer/requirements/) 
defines the policies and processes to manage requirements in upstream projects from
a global perspective.

## Managing OpenStack requirements in RDO

RDO provides all requirements for packaged services in RPM format from their own repos,
so that no software should be installed from external repositories. This packages can
be provided by:

- CentOS base repositories (base, updates and extras). This is the preferred source of
packages whenever possible.
- Other [CentOS SIG repositories](https://wiki.centos.org/SpecialInterestGroup) (Virtualization,
Storage, etc...). When a required package is being maintained by other CentOS SIG, it
will be reused for RDO repos.
- RDO CloudSIG repositories. When a package is not available from previous repos, it will
be provided by RDO repositores. Note that it's required that these packages exist previously
in Fedora so that they can be rebuilt with minimal changes (if any).

If you have questions or special requests, don't hesitate in contacting RDO using our
[mailing lists](/contribute/mailing-lists/) or #rdo channel in freenode.

### Adding a new requirement to RDO

When a new requirement is needed for an OpenStack project included in RDO, package maintainers
must follow this procedure:

![RDO dependencies](/images/cbs-requirements.png)


1. If the project follows global-requirements processes, make sure that the requirement has been
added to global-requirements.txt and upper-constraints.txt files as described in the [upstream
documentation](https://github.com/openstack/requirements/#proposing-changes)
    
    <br />
2. Check if the new requirement is present in CentOS base channels. The easiest way to do this
is using yum command from a system running CentOS 7:
    
        yum list "*<dependency>"
    
    If it's present, the desired package is already available to RDO users.
    
    <br />
3. If the package is not in CentOS base repos, you can check if it has been already built by
the CloudSIG using rdopkg:
    
        rdopkg info <package name>
    
    as, for example:
    
        $ rdopkg info python-eventlet
        1 packages found:

        name: python-eventlet
        project: python-eventlet
        conf: unmanaged-dependency
        patches: None
        distgit: https://github.com/rdo-common/python-eventlet.git
        buildsys-tags:
          cloud7-openstack-common-release: python-eventlet-0.17.4-4.el7
          cloud7-openstack-common-testing: python-eventlet-0.17.4-4.el7
          cloud7-openstack-newton-release: python-eventlet-0.18.4-2.el7
          cloud7-openstack-newton-testing: python-eventlet-0.18.4-2.el7
          cloud7-openstack-ocata-release: python-eventlet-0.18.4-2.el7
          cloud7-openstack-ocata-testing: python-eventlet-0.18.4-2.el7
          cloud7-openstack-pike-testing: python-eventlet-0.20.1-2.el7
        master-distgit: https://github.com/rdo-common/python-eventlet.git
        review-origin: null
        review-patches: null
        tags:
          dependency: null
        maintainers: 
        - apevec@redhat.com
        - hguemar@fedoraproject.org

    If the package is found, it's already in RDO repositories and no more actions are needed to add
    it to the repos.
    
    <br />
4. In case that the dependency is not in CentOS base or CloudSIG repo, you can check if it has been built
by other SIGs in [CBS web interface](http://cbs.centos.org/koji/). You can use wildcards in the packages
search expression. If you find the desired dependency, you can open a bug in [Red Hat Bugzilla for
RDO product](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=distribution) requesting
the inclussion of the package in RDO repos. RDO Core members will handle the request.
    
    <br />
5. If the new package is not in CBS, you must check if it's packaged in Fedora using the [package
browser](https://apps.fedoraproject.org/packages/). If the package exists you can open a bug in [Red Hat Bugzilla for
RDO product](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=distribution) requesting
the rebuild of the package in RDO repos. RDO Core members will rebuild the package using latest existing version
in Fedora.
    
    <br />
6. When the packages doesn't exist even in Fedora you need to add the package following the [New package
process](https://fedoraproject.org/wiki/New_package_process_for_existing_contributors). Note that a Fedora
packager needs to participate in this process. While RDO core members may maintain the new package for
common requirements used by different projects, dependencies for specific project must be maintained in
Fedora by the project team. Once the package is included in Fedora repos you can create a bugzilla as
explained in step 5.
    
    <br />
7. Once the package is available in the repos, you can add it to the list of *Requires* or *BuildRequires* in
your package spec file. Note that optional dependencies not used in default or common configurations should
not be added as Requires but installed only when needed.


### Updating a requirement in RDO CloudSIG repositories

There are some rules to follow when a requirement update is needed by a OpenStack project:

* If the dependency is included in upstream requirements project, the required version must be equal to
the version in [upper-constraints](https://github.com/openstack/requirements/blob/master/upper-constraints.txt) file.

* For packages installed from CentOS base repos, the package should be updated in CentOS/RHEL repos. This can
be requested opening a [bug in bugzilla for RHEL product](https://bugzilla.redhat.com/enter_bug.cgi?product=Red%20Hat%20Enterprise%20Linux%207).
This bug will be evaluated following the RHEL process.

* For packages installed from RDO CloudSIG repos, the package must be updated in Fedora first to the required
version. If it has not been updated first you can contact Fedora package maintainer or open a [bug for Fedora
product](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora). Once the package has been updated, yo can
send a [request to get it updated in RDO repos](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=distribution).

## Contact us

If you have questions or special requests about requirements, don't hesitate to contact RDO community members using our
[mailing lists](/contribute/mailing-lists/) or #rdo channel in freenode.
