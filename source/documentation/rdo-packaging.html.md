---
author: jruzicka
title: RDO OpenStack Packaging
---

# RDO Openstack Packaging

1. toc
{:toc}

## Introduction

This document attempts to be the definitive source of information about
*RDO* OpenStack packaging for developers and packagers.


### Packaging workflow

![RDO packaging workflow](../images/rdo-workflow.jpg)


#### Before RDO Liberty

All *RDO* packaging resources are maintained in the Fedora
[dist-git](#dist-git) repositories. This includes support for all
Fedora distros of course, but currently also caters for EL6 and EL7
distros and derivatives. In future the EL resources may be separated
out under the CentOS OpenStack SIG umbrella, but for now Fedora is the
primary `git` source.

Currently there is a 1:1 mapping between Fedora and OpenStack releases.
I.E. the OpenStack package versions that are provided through the
official Fedora repositories are:

 * f23 = Kilo
 * f22 = Juno
 * f21 = Icehouse

RDO also provides one release ahead for Fedora. There are
separate [RDO repositories](http://rdo.fedorapeople.org/) that provide more recent
OpenStack packages on the current stable version of Fedora.

 * [Juno for f21](https://repos.fedorapeople.org/repos/openstack/openstack-juno/fedora-21/)
 * [Icehouse for f20](https://repos.fedorapeople.org/repos/openstack/openstack-icehouse/fedora-20/)

The EL6 and EL7 packages are only provided through the [**RDO**](http://rdoproject.org)
repositories.

Historically, there were separate `el6-icehouse`, `el6-havana`, etc.
branches in Fedora [dist-git](#dist-git) but Fedora and EL converged
over time thanks to the release of EL7 and also due to the extra
flexibility that the separate RDO repos provide by allowing to carry
updated packages that may not be compatible with all of EPEL,
leveraging the fact that EL deployers almost universally dedicate
systems to OpenStack services. So going forward builds for all
platforms should work from the same `.spec` file. I.E. we only use the
Fedora branches corresponding to each OpenStack release (`master`,
`f21`, `f20`, ...) and EL6 and EL7 builds are done from those branches
in [copr](https://copr.fedoraproject.org/coprs/jruzicka/), as detailed
below in [RDO Packaging Guide](#rdo-pkg-guide).


#### RDO Liberty and later releases

Packaging resources for OpenStack services are now hosted in the
{openstack-packages-org}[openstack-packages] github organization.

The layout used for branches is:

 * `rpm-<master>` = tracks upstream master branch (Delorean)
 * `rpm-<release>` = tracks upstream stable/<release> branch (Delorean)
 * `rdo-<release>` = based upon rpm-<release> and used to build RDO stable packages

Clients and general-purpose libraries are still **included** in Fedora.


<a id="dist-git"></a>

### dist-git - where the .spec file lives

*dist-git* is a git repository which contains `.spec` file used for building
a RPM package. It also contains other files needed for building source RPM
such as patches to apply, init scripts etc.

RDO packages currently use [Fedora dist-git](http://pkgs.fedoraproject.org/cgit/openstack-nova.git/)
and `fedpkg` is used to obtain it, for example:

```bash
$> fedpkg clone openstack-nova
$> cd openstack-nova
$> git remote -v
origin    ssh://jruzicka@pkgs.fedoraproject.org/openstack-nova (fetch)
origin    ssh://jruzicka@pkgs.fedoraproject.org/openstack-nova (push)
```

You can inspect the package history using `git`:

```bash
$> git log --oneline
e70e895 Update to upstream 2014.2.b2
6d4b2ae Updated patches from master-patches
4113b4f maint: modernize the systemd build deps
9bec9a7 Update to latest stable/icehouse 2014.1.1
5963f2d - Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild
d398372 Increase release number
e203465 Remove qpid settings from dist conf
```

<a id="patches-branch"></a>

### Patches branch

Because we rebase and backport often, manual management of patch files in
dist-git would be _unbearable_. That's why each dist-git branch
has an associated **patches branch** which contains upstream git tree with
extra downstream patches on top. A dist-git can be updated by `rdopkg` to
include patches from **patches branch** so maintaining RPM patches is a matter
of `git` magic on patches branch - rebase on upstream tag, cherry-pick
patches, etc.

*RDO* patches branches live at [redhat-openstack github org](https://github.com/redhat-openstack/)
and follow few conventions:

Each patches branch:

* ends with `-patches` suffix by convention
* contains upstream project `git` tree up to a certain commit called
  _patches base_, usually a version tag like `2014.2`
* has downstream patches rebased on top _patches base_


#### patches branch workflow

```
     +------------------------+
     |        upstream        |
     |  github.com/openstack  |
     +------------------------+
                 |
      git rebase | git cherry-pick
                 V
  +-------------------------------+
  |       patches branch          |
  |  github.com/redhat-openstack  |
  +-------------------------------+
                 |
                 | rdopkg update-patches
                 V
     +--------------------------+
     |        dist-git          |
     |  pkgs.fedoraproject.org  |
     +--------------------------+
```


<a id="release-overview"></a>

### Releases & dists overview


<div class="alert alert-info">
Use `rdopkg info` to get up-to-date release & dists overview.
</div>  

* **Juno** (latest release)
  + `fedora-22`
    - available from official Fedora repos
    - built through `koji` (currently `master` branch)
  + `fedora-21`
    - RDO repo
    - Fedora 22 (`master`) builds from `koji` reused
  + `fedora-20`
    - RDO repo
    - symlink to `fedora-21`
  + `epel-7`
    - RDO repo
    - built in [copr](https://copr.fedoraproject.org/coprs/jruzicka/rdo-juno-epel-7/)

* **Icehouse**
  + `fedora-21`
    - available from official Fedora 21 repos
    - built through `koji` (`f21` branch)
  + `fedora-20`
    - RDO repo
    - Fedora 21 builds from `koji` reused
  + `epel-7`
    - RDO repo
    - built in [copr](https://copr.fedoraproject.org/coprs/jruzicka/rdo-icehouse-epel-7/)
  + `epel-6`
    - RDO repo
    - built in [copr](https://copr.fedoraproject.org/coprs/jruzicka/rdo-icehouse-epel-6/)


### rdopkg

[rdopkg](https://github.com/redhat-openstack/rdopkg) is a command line tool
that automates many operations on RDO packages including:

 * rebases to new version
 * introducing patches
 * modifying .spec file: bumping versions, managing patches, writing
   changelog, producing meaningful commit messages, ...
 * build packages in supported build systems

On top of that, `rdopkg` also serves as [**RDO**](http://rdoproject.org) update/CI frontend,
it can obtain various information about RDO for you and more.

`rdopkg` is a Swiss army knife of RDO packaging and it avoids a number of
repetitive and error prone processes involving several underlying tools, each
with its own quirks.

See [rdopkg on github](https://github.com/redhat-openstack/rdopkg) and also
[man rdopkg](https://www.rdoproject.org/packaging/rdopkg/rdopkg.1.html).

## Master Packaging Guide

In order to build an `RPM` with the master packaging you'll need to
install [delorean](https://github.com/openstack-packages/delorean),
following the instructions described in this
[README](https://github.com/openstack-packages/delorean/blob/master/README.rst).

### Run Delorean

Run `delorean` for the package you are trying to build.

```bash
$> delorean --config-file projects.ini --local --package-name openstack-cinder
```

This will clone the packaging for the project you're interested in into
`data/openstack-cinder_repo`, you can now change this packaging and
rerun the `delorean` command in test your changes.

If you have locally changed the packaging make sure to include `--dev`
in the command line. This switches `delorean` into "dev mode" which
causes it to preserve local changes to your packaging between runs so
you can iterate on spec changes. It will also cause the most current
public master repository to be installed in your build image(as some
of its contents will be needed for dependencies) so that the packager
doesn't have to build the entire set of packages.

The output from `delorean` is a repository containing the packages you
just built along with the most recent successfully built version of
each package. To find the most recent repository follow the symbolic
link `./data/repos/current`

### Submitting changes to gerrit

Once you are happy that you have your changes ready to be reviewed,
create a `git commit` with an appropriate comment, add a `git remote`
pointing to gerrit and then submit your patch

```bash
$> git clone -o gerrit https://review.gerrithub.io/openstack-packages/<package-name>
$> git commit -p
$> git review rpm-master
```

### Browsing gerrit for reviews

To look at all open patches for the upstream packaging simply use the following link
<a src="https://review.gerrithub.io/#/q/status:open+project:^openstack-packages/.*,n,z">https://review.gerrithub.io/#/q/status:open+project:^openstack-packages/.*,n,z</a>

### Differences between master and rawhide packaging

There are a number of expected differences between the master packaging and
the packaging in rawhide

* The `delorean` packaging has had `Version:` and `Release:` fields
  both set to `XXX` in the `delorean` packaging as we take both of
  these from the tags set on the git repositories

* Because we are packaging master, patches aren't backported into the
  `delorean` packaging

* All of the master specs contain a reference to `%{upstream_version}`
  in the `%setup macro`, this is because the subdirectory contained in
  the source tarball contains both the version and release, this is
  being passed into `rpmbuild`. In the Fedora packaging, spec can
  include compatibility macro e.g. [Nova](https://github.com/openstack-packages/nova/blob/rdo-liberty/openstack-nova.spec#L11)
  to avoid conflicts when backporting change from master packaging.

* %changelog section is empty in master packaging

* The files `sources` and `.gitignore` have been truncated in the
  master packaging

* In `%files` avoid using `%{version}` and use instead wildcard `*`

To Assist in identifing difference the report being output by the
production `delorean` includes a spec delta link showing a diff
between the two repositories:

* [Fedora 23](http://trunk.rdoproject.org/f21/report.html)

* [CentOS 7](http://trunk.rdoproject.org/centos7/report.html)


### How to add a new package to RDO master packaging

* Prepare a public git repository with the initial .spec in rpm-master branch.
  + Please don't reinvent a wheel. There is a great chance that some similar projects are already packaged for RDO master. For example, if you need to package a vendor library for Neutron, please base your new package on one of python-networking-* packages already in the project. This will help to avoid unneeded diversity, and should give you a better clue about RDO master expectations as for the style and quality of packaging.
  + Repository name should be equal to the upstream source repository name for standalone projects e.g. nova and with python- prefix for libraries and clients e.g. python-networking-arista. Please also consider aligning the name with other packages that are already present in RDO master.
  + Add .gitreview (e.g [example](https://github.com/openstack-packages/nova/blob/rpm-master/.gitreview))
  + Please note differences to Fedora Rawhide packaging described in the previous section!

* Ask one of the owners in [openstack-packages org](https://github.com/orgs/openstack-packages/people) to create a new repository and import from your public repository.

  + Owners: after creating and importing repository in github, replicate it to gerrithub by selecting openstack-packages at https://review.gerrithub.io/plugins/github-plugin/static/repositories.html. After import, add rdo-packagers group as an Owner in <a src="https://review.gerrithub.io/#/admin/projects/openstack-packages/PROJECT,access">https://review.gerrithub.io/#/admin/projects/openstack-packages/PROJECT,access</a>

* Submit all further updates via gerrithub.

* When ready, send pull-request to add the package in rdoinfo e.g. <a src="https://github.com/redhat-openstack/rdoinfo/pull/30">https://github.com/redhat-openstack/rdoinfo/pull/30</a>

<a id="#rdo-pkg-guide"></a>

## RDO Packaging Guide

This guide attempts to describe entire process of packaging new version of
an OpenStack package and getting it into [**RDO**](http://rdoproject.org).

`$PROJECT` variable is used throughout the guide. Substitute it with your
OpenStack project such as `nova`, `neutron`, `heat` etc.

Note that some projects such as client libraries follow slightly different
naming conventions.

Also Note that any packaging updates going into RDO should first be submitted
to the master packaging (described above) then cherry picked into rawhide.


<a id="prereqs"></a>

### Prerequisites

* You need to have **Fedora account**[^1]
  and be **Fedora packager** in order to interact with Fedora build system ([koji](https://koji.fedoraproject.org/koji/))
  [Join the package collection maintainers](https://fedoraproject.org/wiki/Join_the_package_collection_maintainers) if you haven't yet!

* TBD Gerrit account for submitting RDO updates

#### Permissions You'll Need

* **Fedora [dist-git](#dist-git)**: visit
  [pkgdb](https://admin.fedoraproject.org/pkgdb/package/openstack-nova/) for
  your package, `+ Request Commit Access` and optionally poke Main Contact or
  Package Administrator of your choice.

* **[patches branches](#patches-branch) @ `github.com/redhat-openstack`**: request
  permissions for [your project](https://github.com/redhat-openstack/nova) from a
  [redhat-openstack admin](https://github.com/orgs/redhat-openstack/teams/owners).
  Note that you're looking for `/$PROJECT`, not `/openstack-$PROJECT`. You can tell
  you're in the right repo when there are branches with `-patches` suffix.

* **copr build system**: Request build permissions in relevant
  https://copr.fedoraproject.org/coprs/jruzicka[jruzicka's coprs] listed
  below. Check the `Is Builder` box and hit `Update` for each copr. Poke
  `jruzicka` to accelerate the approval.
  + Juno copr:
    - [rdo-juno-epel-7](https://copr.fedoraproject.org/coprs/jruzicka/rdo-juno-epel-7/permissions/)

  + Icehouse coprs:
    - [rdo-icehouse-epel-6](https://copr.fedoraproject.org/coprs/jruzicka/rdo-icehouse-epel-6/permissions/)
    - [rdo-icehouse-epel-7](https://copr.fedoraproject.org/coprs/jruzicka/rdo-icehouse-epel-7/permissions/)


#### Software

##### Fedora packaging tools

`fedora-packager` package available in standard Fedora repositories pulls in
tools for packaging and interacting with Fedora infrastructure including
`fedpkg` and [koji](https://koji.fedoraproject.org/koji/),
[bodhi](https://admin.fedoraproject.org/updates), and
[pkgdb](https://admin.fedoraproject.org/pkgdb/) clients.

```bash
$> yum install fedora-packager
```

You need to setup your FAS certificate to communicate with Fedora systems:

```bash
$> fedora-packager-setup
```

##### `rdopkg`

See [rdopkg on github](https://github.com/redhat-openstack/rdopkg) for all
installation options. I recommend using
[jruzicka/rdopkg copr](https://copr.fedoraproject.org/coprs/jruzicka/rdopkg),
see the link for instructions on howto enable the copr. Once enabled,

```bash
$> yum install -y rdopkg
```

##### `rdopkg coprbuild`

In order to use `rdopkg coprbuild` action to easily build packages in
https://copr.fedoraproject.org/coprs/jruzicka[jruzicka's coprs], you need to
save your copr API token into `~/.config/copr` as described in
http://copr.fedoraproject.org/api.

Although `rdopkg` shares this config with `copr-cli` (you can use `copr-cli`
to validate it), `rdopkg` has it's own copr client implementation
footnote:[`copr-cli` was not reusable at the time of writing] and doesn't
require `copr-cli` to
work.


### Initial repository setup

With all the [prerequisites](#prereqs) met, it's time to clone the package
[dist-git](#dist-git) using `fedpkg`.

```bash
$> fedpkg clone openstack-$PROJECT
$> cd openstack-$PROJECT
```

You also need to be able to access to your project's [patches branches](#patches-branch). +
`rdopkg` expects the `git` remote containing [patches branches](#patches-branch) to be named `patches`:

```bash
$> git remote add -f patches git@github.com:redhat-openstack/$PROJECT.git
```

Finally, you need a remote with upstream source in order to cherry-pick
upstream patches and rebase [patches branches](#patches-branch) on new version:

```bash
$> git remote add -f openstack git://github.com/openstack/$PROJECT.git
```

You can check your setup with:

```bash
$> rdopkg pkgenv
```

### Requirements management

Please see [man rdopkg-adv-requirements](rdopkg/rdopkg-adv-requirements.7.html)
 for complete introduction to `rdopkg` requirements management magic.


### Modifying the package

The package metadata is stored in `.spec` file which is found in top
directory of [dist-git](#dist-git), usually `openstack-$PROJECT.spec`. Every
change to a package requires at least a change in `.spec` file and possibly
other [dist-git](#dist-git) files (add/remove patches, init scripts, ...).

Every time you do a new build, you need to:

* Bump `Release` (when source tarball stays the same) or change `Version`  and
  reset `Release` (on update to new upstream version/tarball) in `.spec` file.
* Provide useful `%changelog` entry at the end of `.spec` file describing your
  change.
* Commit the [dist-git](#dist-git) changes with meaningful commit message.

Following sections provide examples for most common packaging scenarios.

#### Simple `.spec` fix

The simplest kind of change that doesn't introduce/remove patches or
different source tarball.

* Make required changes.
* Bump `Release`.
* Provide useful `%changelog` entry describing your change.
* Commit the [dist-git](#dist-git) changes with meaningful commit message.

Although this change is simple, `rdopkg fix` can still make some string
manipulation for you. In following example, I add a new dependency to `nova`
package:

```bash
$> cd openstack-nova
$> rdopkg fix
```

Action required: Edit .spec file as needed and describe changes in
changelog. Once done, run `rdopkg -c` to continue:

```bash
$> vim openstack-nova.spec
# Add Requires line and describe the change in %changelog
$> rdopkg -c
```

After this, `rdopkg` generates new commit from the %changelog entry you
provided and displays the diff:

```diff
    Name:             openstack-nova
    Version:          2014.2
   -Release:          0.1.b2%{?dist}
   +Release:          0.2.b2%{?dist}
    Summary:          OpenStack Compute (nova)

    ...

   +Requires:         banana
    Requires:         python-nova = %{version}-%{release}

    ...

    %changelog
   +* Tue Aug 12 2014 Jakub Ruzicka <jruzicka@redhat.com> 2014.2-0.2.b2
   +- Require banana package for the lulz
   +
    * Sun Aug 03 2014  Vladan Popovic <vpopovic@redhat.com> 2014.2-0.1.b2
    - Update to upstream 2014.2.b2
    - openstack-nova-compute should depend on libvirt-daemon-kvm, not libvirt - rhbz#996715
```

#### Introducing/removing patches

When new patches are introduced to [patches branches](#patches-branch) (usually
by `git review`), [dist-git](#dist-git) must be updated with new patches files
and `.spec` file patch definitions.

`rdopkg` provides:

* `rdopkg update-patches`: low-level action that only updates `.spec` file
  from local [patches branches](#patches-branch)
* `rdopkg patch`: high-level action on top of `update-patches` with extra
  features (reset local patches branch from remote, bump release, generate
  changelog entry)

Because a lot of the packages are python and use setuptools and pbr, some patches may not apply correctly because the sdist tarball changes the format of setup.cfg.
This will show up during rpm build time with an error applying the patch.  This issue can be worked around using the following process.

* unpack the source tarball
* git clone the patches branch
* copy the config.cfg file from the tarball into your git tree
* git commit the change
* git revert HEAD
* edit the patches_base line to `# patches_base=+1`
* reorder the patches on the patches branch so that the initial change is first, then the revert is second after the tarball
* rdopkg patch uses the patches_base line to skip the first patch but apply the second

This results in patches that apply to the upstream git tree applying without modification on the tarball.


#### Rebasing to new version

See
[man rdopkg-adv-new-version](rdopkg/rdopkg-adv-new-version.7.html) for
an example of using `rdopkg new-version` to update a package to a new upstream
version.


### Building the package

After you have modified [dist-git](#dist-git) to your liking, it's time to build.
You need to be on the dist-git branch of respective Fedora release such as
`master` or `f21`, see [Releases & dists overview](#release-overview).


#### local build with mock

You can build the Fedora package locally using `mock` to ensure it builds
and/or test it:

```bash
$> fedpkg mockbuild
```
                              
Find the results in `./results_$PACKAGE/$VERSION/$RELEASE` directory. The
most interesting file is `build.log`.

You can also test EL builds using `mock`, but you may be missing certain build
requirements only available at [**RDO**](http://rdoproject.org)
[coprs](https://copr.fedoraproject.org/coprs/jruzicka/):

```bash
$> fedpkg --dist el7 mockbuild --root epel-7-x86_64
```

#### copr build of EL package

Beginning with the Icehouse release, EL packages are built in
[copr](https://copr.fedoraproject.org/coprs/jruzicka/rdo-juno-epel-7/) build
system due to constraints of Fedora [dist-git](#dist-git).

Because a push to Fedora [dist-git](#dist-git) is irreversible, building in `copr` first is
recommended. You may find some EL specific problems and solve them without the need
of new package release.

The following command creates a source RPM for selected distro using
`fedpkg srpm`, uploads it to your `fedorapeople.org` space and submits it to
be built in `copr`:

```bash
$> rdopkg coprbuild -d epel-7 -f up.yml
```

Also, `-f up.yml` instructs `rdopkg` to dump the build information
into `up.yml` file that can be used later to submit an [**RDO**](http://rdoproject.org)
update using `rdopkg update -f up.yml`.

See a full example of using `rdopkg coprbuild` in
[man rdopkg-adv-building](rdopkg/rdopkg-adv-building.7.html).


#### koji build of Fedora package

Push your Fedora [dist-git](#dist-git) changes and build using `fedpkg`:

```bash
$> git push
$> fedpkg build
```

### Submitting an update

After your builds finished, you need to submit the package(s) for
update in *RDO* using:

```bash
$> rdopkg update
```

By default, `rdopkg update` tries to autodetect which package you're trying to
update and opens an YAML update file template in text editor. You need to
specify all builds that should be updated at once in the update file.

See **ACTION: update** in
[man rdopkg](rdopkg/rdopkg.1.html#_action_update).
and also
[man rdopkg-adv-building](rdopkg/rdopkg-adv-building.7.html).
for an example of how to do `copr` and `koji` builds and prepare and submit the
update file non-interactively.

`rdopkg update` submits the update through `git review` and prints the URL to
gerrit. The update needs to pass CI in order to be merged and later pushed to
*RDO* repositories.

To track your update, use:

```bash
$> rdopkg list-updates -r
```

#### Fedora update

```bash
$> fedpkg update
```

<div class="alert alert-info"> TODO<a>




[^1]: also known as FAS account - [Fedora Account System](https://admin.fedoraproject.org/accounts/)
