---
author: jruzicka
title: RDO OpenStack Packaging
---

# RDO OpenStack Packaging

1. toc
{:toc}

## Introduction

This document attempts to be the definitive source of information about
*RDO* OpenStack packaging for developers and packagers.


### Packaging overview

RDO produces two set of packages repositories:

* **RDO CloudSIG** repositories provide packages of upstream point
releases created through a controlled process using CentOS Community Build
System. This is kind of "stable RDO".

* **RDO Trunk** repositories provide packages of latest upstream code without any
additional patches. New packages are created on each commit merged on upstream
OpenStack projects.

Following diagram shows the global packaging process in RDO.

![RDO packaging workflow](../images/rdo-full-workflow-high-level-no-buildlogs.png)


<a id="distgit"></a>

### distgit - where the .spec file lives

*distgit* is a git repository which contains `.spec` file used for building
a RPM package. It also contains other files needed for building source RPM
such as patches to apply, init scripts etc.

RDO packages' distgit repos are hosted on
[review.rdoproject.org](https://review.rdoproject.org/r/gitweb?p=openstack/nova-distgit.git;a=summary)
and follow `$PROJECT-distgit` naming. You can navigate the full list of distgit repos using this
[link](https://review.rdoproject.org/r/#/admin/projects/?filter=distgit).

You can use [rdopkg](#rdopkg) to clone a RDO package `distgit` and also setup related
remotes:

```bash
$> rdopkg clone openstack-nova
Cloning distgit into ./openstack-nova/
git clone http://review.rdoproject.org/r/p/openstack/nova-distgit.git openstack-nova
...
```

Inspect package history using `git`:

```bash
$> cd openstack-nova
$> git checkout mitaka-rdo
$> git log --oneline
ded74f2 Add privsep-helper to nova sudoers file
55981cf Add python-microversion-parse dependency
39d576a Update .gitreview
4e53ad0 Add missing python-cryptography BuildRequires
```

See what `rdopkg` thinks about current distgit:

```bash
$> rdopkg pkgenv

Package:   openstack-nova
Version:   13.0.0
Upstream:  13.0.0
Tag style: X.Y.Z

Patches style:          review
Dist-git branch:        mitaka-rdo
Local patches branch:   mitaka-patches
Remote patches branch:  patches/mitaka-patches
Remote upstream branch: upstream/master
Patches chain:          http://review.rdoproject.org/r/631
```

Submit distgit changes for review:

```bash
$> rdopkg review-spec
```
<a id="branches in distgits"></a>

#### Branches in distgits

Because of the different build tools used for RDO CloudSIG and Trunk repos and
the differences in dependencies and content in packages for each OpenStack
release, RDO maintains several branches in distgits:

- **rpm-&lt;release>:** is used to package RDO trunk (version can be master,
  mitaka or liberty )
- **&lt;release>-rdo:** is used for RDO CloudSIG.

There are a number of expected differences between the spec files in
rpm-&lt;release> and &lt;release>-rdo branches:

* For RDO trunk, packaging has had `Version:` and `Release:` fields
  both set to `XXX` as `dlrn` takes both of
  these from the tags set on the git repositories. For &lt;release>-rdo branches
  they must be manually set to the right version and release.

* %changelog section is empty in rpm-&lt;release>.

* Because we are packaging vanilla upstream code, patches aren't backported into the RDO Trunk repositories.

* All of the specs in rpm-&lt;release> branches contain a reference to `%{upstream_version}`
  in the `%setup macro`, this is because the subdirectory contained in
  the source tarball contains both the version and release, this is
  being passed into `rpmbuild`. In the Fedora packaging, spec can
  include compatibility macro e.g. [Nova](https://review.rdoproject.org/r/gitweb?p=openstack/nova-distgit.git;a=blob;f=openstack-nova.spec;h=1dc49d1f8aacbaef235f1decc2319ce42fa68156;hb=refs/heads/liberty-rdo#l12)
  to avoid conflicts when backporting change from master packaging.

* The files `sources` and `.gitignore` have been truncated in the
  master packaging

* In `%files` avoid using `%{version}` and use instead wildcard `*`



### Patches branch

Because we rebase often in RDO CloudSIG repos, manual management of patch files in
distgit would be _unbearable_. That's why each distgit branch
has an associated **patches branch** which contains upstream git tree with
extra downstream patches on top.

A distgit can be automatically updated by `rdopkg` to include patches from
associated **patches branch** and thus RPM patches are managed with `git`.

Individual RDO patches are maintained in form of gerrit reviews on
[review.rdoproject.org](https://review.rdoproject.org/r/#/q/status%3Aopen+project%3Aopenstack/nova).

<a id="rdopkg"></a>

### rdopkg

[rdopkg](https://github.com/redhat-openstack/rdopkg) is a command line tool
that automates many operations on RDO packages including:

 * cloning package distgit and setting up remotes
 * introducing patches
 * rebases to new versions
 * sending changes for review
 * querying `rdoinfo` metadata
 * modifying .spec file: bumping versions, managing patches, writing
   changelog, producing meaningful commit messages, ...

`rdopkg` is a Swiss army knife of RDO packaging and it automates a number of
repetitive and error prone processes involving several underlying tools, each
with its own quirks.

Install `rdopkg` from [`jruzicka/rdopkg` copr](https://copr.fedorainfracloud.org/coprs/jruzicka/rdopkg/):

```bash
$> dnf copr enable jruzicka/rdopkg
$> dnf install rdopkg
```

`rdopkg` source lives at
[review.rdoproject.org](https://review.rdoproject.org/r/gitweb?p=rdopkg.git;a=summary)
but it's also mirrored to
[github](https://github.com/redhat-openstack/rdopkg).

Bugs are tracked as
[github issues](https://github.com/redhat-openstack/rdopkg/issues).

Poke `jruzicka` on `#rdo` for help/hate/suggestions about `rdopkg`.

See also [man rdopkg](https://www.rdoproject.org/packaging/rdopkg/rdopkg.1.html).


<a id="rdoinfo"></a>

### rdoinfo metadata

`rdoinfo` is a git repository containing RDO packaging metadata such as
releases, packages, maintainers and more, currently in a single `rdo.yml` YAML
file.

`rdoinfo` lives at
[review.rdoproject.org](https://review.rdoproject.org/r/gitweb?p=rdoinfo.git;a=summary)
but it's also mirrored to
[github](https://github.com/redhat-openstack/rdoinfo).

To query `rdoinfo`, use `rdopkg info`:

```bash
$> rdopkg info
$> rdopkg info openstack-nova
$> rdopkg info maintainers:jruzicka@redhat.com
```

To integrate `rdoinfo` in your software, use `rdopkg.actionmods.rdoinfo`
module.

### DLRN

[DLRN](https://github.com/openstack-packages/DLRN) is a tool used to build RPM
packages on each commit merged in a set of configurable git repositories. DLRN
uses rdoinfo to retrieve the metadata and repositories associated with each
project in RDO (code and distgit) and mock to carry out the actual build in an
isolated environment.

DLRN is used to build the packages in RDO Trunk repositories that are available
from [http://trunk.rdoproject.org](http://trunk.rdoproject.org).

NVR for packages generated by DLRN follows some rules:

* Version is set to MAJOR.MINOR.PATCH of the next upstream version.
* Release is 0.&lt;timestamp>.&lt;short commit hash>

For example `openstack-neutron-8.1.1-0.20160531171125.ddfe09c.el7.centos.noarch.rpm`.


### Prerequisites for packagers

 * You need a [github](https://github.com) account which is used to log into
[review.rdoproject.org](https://review.rdoproject.org/auth/login).
 * You need to install [rdopkg](#rdopkg) tool.


## RDO Trunk Packaging Guide

In RDO Trunk packages are built automatically by [DLRN](#DLRN) from
`.spec` templates residing in `rpm-master` and `rpm-$RELEASE` [distgits](#distgit).

In order to build an `RPM` with the master packaging you'll need to
install [DLRN](https://github.com/openstack-packages/DLRN),
following the instructions described in this
[README](https://github.com/openstack-packages/DLRN/blob/master/README.rst).

### Run DLRN

Once DLRN is installed, run `dlrn` for the package you are trying to build.

```bash
$> dlrn --config-file projects.ini --local --package-name openstack-cinder
```

This will clone the distgit for the project you're interested in into
`data/openstack-cinder_distro`, you can now change this packaging and
rerun the `dlrn` command in test your changes.

If you have locally changed the packaging make sure to include `--dev`
in the command line. This switches `dlrn` into "dev mode" which
causes it to preserve local changes to your packaging between runs so
you can iterate on spec changes. It will also cause the most current
public master repository to be installed in your build image(as some
of its contents will be needed for dependencies) so that the packager
doesn't have to build the entire set of packages.

The output from `dlrn` is a repository containing the packages you
just built along with the most recent successfully built version of
each package. To find the most recent repository follow the symbolic
link `./data/repos/current`

### Submitting distgit changes to gerrit

When modifying spec files for RDO Trunk keep in mind the considerations shown
in [Branches in distgits](#branches-in-distgits) and follow the recommendations
in the [RDO Packaging Guidelines](https://www.rdoproject.org/documentation/rdo-packaging-guidelines/).
Once you are happy that you have your changes in distgit ready to be reviewed,
create a `git commit` with an appropriate comment, add a `git remote`
pointing to gerrit and then submit your patch

```bash
$> git review -s
$> git commit -p
$> git review rpm-master
```

### Browsing gerrit for reviews

To look at all open patches for the upstream packaging simply use the this
[link](https://review.rdoproject.org/r/#/q/status:open) and look for your
desired project, for example `openstack/cinder-distgit`.

### How to add a new package to RDO Trunk

When a new package is required in RDO, it must be added to RDO Trunk packaging.
To include new packages, following steps are required:

1. Create a "Package Review" bug in [Red Hat bugzilla](https://bugzilla.redhat.com/)
following the best practices described in [RDO OpenStack Packaging Guidelines](/documentation/rdo-packaging-guidelines/).

2. Send a review adding the new project in rdo.yml to the [rdoinfo project in
review.rdoproject.org](https://review.rdoproject.org/r/#/q/project:rdoinfo). In
this change you must provide the project information and Package Review bugzilla
ticket in the commit message (see [this example](https://review.rdoproject.org/r/#/c/1408/)).
In the project definition in **rdo.yml** file, only `under-review` must be uncommented as project tags
and comment all releases where package should be built, as for example:
    
        - project: murano-dashboard
          name: openstack-murano-ui
          tags:
            under-review:
            #newton-uc:
            #newton:
            #mitaka:
          conf: rpmfactory-core
          maintainers:
          - atsamutali@mirantis.com
          - iyozhikov@mirantis.com
     
    **Note:** Maintainers must be registered in review.rdoproject.org and use the registered email in the rdoinfo review.
    This is required to set your permissions on your project.

    As part of the review process, some tasks will be carried out by the RDO team:

    * The required projects will be created in [https://review.rdoproject.org](https://review.rdoproject.org).
    * Users included in maintainers list will received required permissions to manage the project.
    * The new projects will be added to zuul configuration in review.rdoproject.org
    (as in [this example](https://review.rdoproject.org/r/#/c/1418/)).
    * Once the projects are created, the change will be merged in rdoinfo project.

3. Create a new review to the new distgit project with the needed content (spec
file, etc...) for the initial import as in [this example](https://review.rdoproject.org/r/#/c/1417/).
This will trigger a CI job to test the package build.

4. Once the initial import in the distgit is merged, send a new review to rdoinfo
project to remove the `under-review` tag and uncomment the required versions where the
package must be built ([example](https://review.rdoproject.org/r/#/c/1422/)).
This change can be sent before merging review in step 3 if a `Depends-On: <gerrit-change-id step 3>` is added.

Once the change is merged in rdoinfo, a new package should be automatically built
and published in the [RDO Trunk repos](http://trunk.rdoproject.org/centos7-master/report.html).

In order to track all review requests related to a new package process, it's recommended
to use the same topic (as `add-osc-lib` in the above examples) for all these reviews.

RDO project is working to automate as much as possible this process. If you need
help to add new packages, you can ask on `#rdo` or `rdo-list` mailing list.

<a id="#rdo-pkg-guide"></a>

## RDO CloudSIG Packaging Guide

Packaging files for CloudSIG repos live in `$RELEASE-rdo` branches of
[distgit](#distgit). Patches can be introduced as needed through associated
[patches branch](#patches-branch).


### Initial repository setup

`rdopkg clone` takes care of getting the package [distgit](#distgit) and
also setting up all relevant git remotes defined in [rdoinfo](#rdoinfo).
Use `-u`/`--review-user` option to specify your github username if it differs
from `$USER`.

```bash
$> rdopkg clone openstack-nova -u github-username
Cloning distgit into ./openstack-nova/
git clone http://review.rdoproject.org/r/p/openstack/nova-distgit.git openstack-nova
Adding patches remote...
git remote add patches http://review.rdoproject.org/r/p/openstack/nova.git
Adding upstream remote...
git remote add upstream git://git.openstack.org/openstack/nova
...
```

Check output of `rdopkg pkgenv` to see what `rdopkg` thinks about your
package:

```bash
$> cd openstack-nova
$> git checkout mitaka-rdo
$> rdopkg pkgenv
```


### Simple `.spec` fix

The simplest kind of change that doesn't introduce/remove patches or
different source tarball.

* Make required changes.
* Bump `Release`.
* Provide useful `%changelog` entry describing your change.
* Commit the [distgit](#distgit) changes with meaningful commit message.
* Send the change for review.

Although this change is simple, `rdopkg fix` can still make some string
manipulation for you. In following example, I add a new dependency to `nova`
package:

```bash
$> cd openstack-nova
$> git checkout mitaka-rdo
$> rdopkg fix

Action required: Edit .spec file as needed and describe changes in changelog.

Once done, run `rdopkg -c` to continue.

$> vim openstack-nova.spec
# Add Requires line and describe the change in %changelog
$> rdopkg -c
```

After this, `rdopkg` generates new commit from the %changelog entry you
provided and displays the diff:

```diff
    Epoch:            1
    Version:          13.0.0
   -Release:          1%{?dist}
   +Release:          2%{?dist}
    Summary:          OpenStack Compute (nova)

    ...

    Requires:         bridge-utils
    Requires:         sg3_utils
    Requires:         sysfsutils
   +Requires:         banana

    %description compute
    OpenStack Compute (codename Nova) is open source software designed to

    ...

    %changelog
   +* Mon May 09 2016 Jakub Ruzicka <jruzicka@redhat.com> 1:13.0.0-2
   +- Require banana package for the lulz
   +
    * Thu Apr  7 2016 Haïkel Guémar <hguemar@fedoraproject.org> - 1:13.0.0-1
    - Upstream 13.0.0
```

Finally, send the changes for review:

```bash
$> rdopkg review-spec
```


### Introducing/removing patches

See [patches branch](#patches-branch) for introduction.

Following schema shows the workflow to maintain patches applied in the packaging process.

```
     +------------------------+
     |        upstream        |
     |  github.com/openstack  |
     +------------------------+
                 |
 git cherry-pick | rdopkg review-patch
                 V
     +-------------------------+
     |      patches branch     |
     |  review.rdoproject.org  |
     +-------------------------+
                 |
    rdopkg patch | rdopkg review-spec
                 V
     +-------------------------+
     |        distgit          |
     |  review.rdoproject.org  |
     +-------------------------+
```

First, use `rdopkg get-patches` to get a [patches branch](#patches-branch)
associated with current [distgit](#distgit), cherry pick your patch(es) on
top, and send them for review with `rdopkg review-patch`:

```bash
$> git checkout mitaka-rdo
$> rdopkg get-patches
$> git cherry-pick YOUR_PATCH
$> rdopkg review-patch
```

Once the patch gets approved (not merged), you can tell `rdopkg` to update the
distgit and send the `.spec` change for review:

```bash
$> git checkout mitaka-rdo
$> rdopkg patch
$> rdopkg review-spec
```

For **more specific example**, please see
[Introducing patches to RDO CloudSIG packages RDO blog post](
https://www.rdoproject.org/blog/2016/09/introducing-patches-to-rdo-cloudsig-packages/).


### Rebasing on new version

tl;dr `rdopkg new-verison` should take care of that:

```bash
$> git checkout mitaka-rdo
$> rdopkg new-version
```

or `rdopkg new-version 1.2.3` to select specific version.

Inspect resulting distgit commit and if you need to adjust anything, use
`rdopkg amend` to amend and regenerate commit message from changelog.

Finally, once happy with your change submit it for review with

```bash
$> rdopkg review-spec
```
