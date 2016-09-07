---
title: Introducing patches to RDO CloudSIG packages
author: jruzicka
tags: rdo,rdopkg,cloudsig,packaging,patches,howto
date: 2016-09-06 13:37:00 UTC
---

RDO infrastructure and tooling has been changing/improving with each
OpenStack release and we now have our own packaging workflow powered by RPM
factory at [review.rdoproject.org](https://review.rdoproject.org/), designed
to keep up with supersonic speed of upstream development.

Let's see what it takes to land a patch in RDO CloudSIG repos with the new
workflow!


## The Quest

This is a short story about backporting an upstream OpenStack Swift patch into
RDO Mitaka `openstack-swift` package.

Please consult
[RDO Packaging docs](https://www.rdoproject.org/documentation/rdo-packaging/)
for additional information.


## First Things First

Make sure you have latest
[rdopkg](https://github.com/openstack-packages/rdopkg) from
[jruzicka/rdopkg
copr](https://copr.fedorainfracloud.org/coprs/jruzicka/rdopkg/).
This is a new code added alongside existing functionality and it isn't well
tested yet, bugs need to be ironed out. If you encounter `rdopkg` bug, please
[report how it broke](https://github.com/openstack-packages/rdopkg/issues/new).

Inspect [rdoinfo](https://github.com/redhat-openstack/rdoinfo) package
metadata including various URLs using `rdopkg info`:

    $ rdopkg info openstack-swift
    
    name: openstack-swift
    project: swift
    conf: rpmfactory-core
    upstream: git://git.openstack.org/openstack/swift
    patches: http://review.rdoproject.org/r/p/openstack/swift.git
    distgit: http://review.rdoproject.org/r/p/openstack/swift-distgit.git
    master-distgit: http://review.rdoproject.org/r/p/openstack/swift-distgit.git
    review-origin: ssh://review.rdoproject.org:29418/openstack/swift-distgit.git
    review-patches: ssh://review.rdoproject.org:29418/openstack/swift.git
    tags:
      liberty: null
      mitaka: null
      newton: null
      newton-uc: null
    maintainers: 
    - zaitcev@redhat.com

Yeah, that's the Swift we want. Let's use `rdopkg clone` to clone the distgit
and also setup remotes according to `rdoinfo` entry above:

    $ rdopkg clone [-u githubnick] openstack-swift

Which results in following remotes:

    * origin:          http://review.rdoproject.org/r/p/openstack/swift-distgit.git
    * patches:         http://review.rdoproject.org/r/p/openstack/swift.git
    * review-origin:   ssh://githubnick@review.rdoproject.org:29418/openstack/swift-distgit.git
    * review-patches:  ssh://githubnick@review.rdoproject.org:29418/openstack/swift.git
    * upstream:        git://git.openstack.org/openstack/swift


## Send patch for review


**Patches are now stored as open gerrit review chains** on top of upstream
version tags so `patches` remote is now obsolete legacy.

Start with inspecting distgit:

    $ git checkout mitaka-rdo
    $ rdopkg pkgenv

    Package:   openstack-swift
    NVR:       2.7.0-1
    Version:   2.7.0
    Upstream:  2.9.0
    Tag style: X.Y.Z

    Patches style:          review
    Dist-git branch:        mitaka-rdo
    Local patches branch:   mitaka-patches
    Remote patches branch:  patches/mitaka-patches 
    Remote upstream branch: upstream/master
    Patches chain:          unknown

    OS dist:                RDO
    RDO release/dist guess: mitaka/el7

`rdopkg patchlog` doesn't support review workflow yet, sorry.

Next, use `rdopkg get-patches` to create local patches branch from associated
gerrit patches chain and switch to it:

    $ rdopkg get-patches

Cherry-pick the patch into newly created `mitaka-patches` branch. Upstream
source is available in `upstream` remote.

    $ git cherry-pick -x deadbeef

Finally, send the patch for review with `rdopkg review-patch` which is
just a convenience shortcut to `git review -r review-origin $BRANCH`:
    
    $ rdopkg review-patch

This will print an URL to patch review such as
[https://review.rdoproject.org/r/#/c/1145/](https://review.rdoproject.org/r/#/c/1145/).


## Get +2 +1V on the patch review

Patches are never merged, they are kept as open review chains in order to
preserve full patch history.

You need to get +2 from a reviewer and +1 Verified from the CI.


## Update .spec and send it for review

Once the patch has been reviewed, update the .spec file in `mitaka-rdo`:

    $ git checkout mitaka-rdo
    $ rdopkg patch

You can also select specific patches chain by review number with
`-g`/`--gerrit-patches-chain`:

    $ rdopkg patch -g 1337

Inspect the newly created commit which should contain all necessary changes.
If you need to adjust something, do so and use `rdopkg amend` to `git commit
-a --amend` with nice commit message generated from changelog.

Finally, submit distgit change for review with

    $ rdopkg review-spec

Review URL is printed. This is a regular review and once it's merged, you're
done.


#### Happy packaging!
