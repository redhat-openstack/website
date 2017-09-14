---
title: Let rdopkg manage your RPM package
author: jruzicka
tags: rdopkg, rpm, packaging
date: 2017-03-08 13:37:00 CET
---

[rdopkg][] is a RPM packaging automation tool which was written to
efortlessly keep packages in sync with (fast moving) upstream.

`rdopkg` is a little opinionated, but when you setup your environment right,
most packaging tasks are **reduced to a single rdopkg command**:

 * Introduce/remove patches: `rdopkg patch`
 * Rebase patches on a new upstream version: `rdopkg new-version`

`rdopkg` builds upon the concept
[distgit](https://www.rdoproject.org/documentation/rdo-packaging/#distgit---where-the-spec-file-lives)
which simply refers to maintaining RPM package source files in a `git`
repository. For example, all Fedora and CentOS packages are maintained in
`distgit`.

Using Version Control System for packaging is great, so `rdopkg` extends this
by requiring patches to be also maintained using `git` as opposed to storing
them as simple `.patch` files in distgit.

For this purpose, `rdopkg` introduces concept of
[patches branch](https://www.rdoproject.org/documentation/rdo-packaging/#patches-branch)
which is simply a `git` branch containing... yeah, patches. Specifically,
patches branch contains upstream `git` tree with optional downstream patches
on top.

In other words, patches are maintained as `git` commits. The same way they are
managed upstream. To introduce new patch to a package, just `git cherry-pick`
it to patches branch and let `rdopkg patch` do the rest. Patch files are
generated from `git`, `.spec` file is changed automatically.

When new version is released upstream, `rdopkg` can *rebase patches branch* on
new version and update distgit automatically. Instead of hoping some `.patch`
files apply on ever changing tarball, `git` can be used to rebase the patches
which brings many advantages like automatically dropping patches already
included in new release and more.


## Requirements

### upstream repo requirements

You project needs to be maintained in a `git` repository and use
[Semantic Versioning](http://semver.org/) tags for its releases, such as
`1.2.3` or `v1.2.3`.

### distgit

Fedora packages already live in `distgit` repos which packagers can get by

    fedpkg clone package

If your package doesn't have a `distgit` yet, simply create a `git` repository
and put all the files from `.src.rpm SOURCES` in there.

`el7` distgit branch is used in following example.

### patches branch

Finally, you need a repository to hold your patches branches. This can be the
same repo as `distgit` or a different one. You can use various processes to
manage your patches branches, simplest one being packager maintaining them
manually like he would with `.patch` files.

`el7-patches` patches branch is used in following example.

### install rdopkg

[rdopkg][] page contains installation instructions. Most likely, this will do:

    dnf install rdopkg


## Initial setup

Start with cloning distgit:

    git clone $DISTGIT
    cd $PACKAGE

Add `patches` remote which contains/is going to contain patches branches
(unless it's the same as `origin`):

    git remote add -f patches $PATCHES_BRANCH_GIT

While optional, it's strongly recommended to also add `upstream` remote with
project upstream to allow easy initial patches branch setup, cherry-picking
and some extra `rdopkg` automagic detection:

    git remote add -f upstream $UPSTREAM_GIT

## Clean .spec

In this example we'll assume we'll building a package for EL 7 distribution
and will use `el7` branch for our distgit:

    git checkout el7

Clean the `.spec` file. Replace hardcoded version strings (especially
in `URL`) with macros so that `.spec` is current when `Version` changes. Check
`rdopkg pkgenv` to see what `rdopkg` thinks about your package:

    editor foo.spec
    rdopkg pkgenv
    git commit -a


## Prepare patches branch

By convention, rdopkg expects `$BRANCH` distgit branch to have appropriate
`$BRANCH-patches` patches branch.

Thus, for our `el7` distgit, we need to create `el7-patches` branch.

First, see current `Version:`:

    rdopkg pkgenv | grep Version

Assume our package is at `Version: 1.2.3`.

`upstream` remote should contain associated `1.2.3` version tag which should
correspond to `1.2.3` release tarball so let's use that as a base for our new
patches branch:

    git checkout -b el7-patches 1.2.3

Finally, if you have some `.patch` files in your `el7` distgit branch, you
need to apply them on top `el7-patches` now.

Some patches might be present in `upstream` remote (like backports) so you can
`git cherry-pick` them.

Once happy with your patches on top of `1.2.3`, push your patches branch into
the `patches` remote:

    git push patches el7-patches


## Update distgit

With `el7-patches` patches branch in order, try updating your `distgit`:

    git checkout el7
    rdopkg patch

If this fails, you can try lower-level `rdopkg update-patches` which skips
certain magics but isn't reccommended normal usage.

Once this succeeds, inspect newly created commit that updated the `.spec`
file and `.patch` files from `el7-patches` patches branch.


## Ready to rdopkg

After this, you should be able to manage your package using `rdopkg`.

Please note that both `rdopkg patch` and `rdopkg new-version` will **reset
local** `el7-patches` to remote `patches/el7-patches` unless you supply
`-l`/`--local-patches` option.

To **introduce/remove patches**, simply modify remote `el7-patches` patches
branch and let `rdopkg patch` do the rest:

    rdopkg patch

To **update your package to new upstream version** including patches rebase:

    git fetch --all
    rdopkg new-version

Finally, if you just want to **fix your .spec** file without touching
patches:

    rdopkg fix
    # edit .spec
    rdopkg -c


## More information

List all `rdopkg` actions with:

    rdopkg -h

Most `rdopkg` actions have some handy options, see them with

    rdopkg $ACTION -h

Read the
[friendly manual](https://github.com/openstack-packages/rdopkg/blob/master/doc/rdopkg.1.adoc):

    man rdopkg

You can also read [RDO packaging guide](https://www.rdoproject.org/documentation/rdo-packaging/#rdo-cloudsig-packaging-guide)
which contains some examples of `rdopkg` usage in RDO.


### Happy packaging!

[rdopkg]: https://github.com/openstack-packages/rdopkg
