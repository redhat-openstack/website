---
title: "[Announcement] Migration to review.rdoproject.org"
author: hguemar
date: 2016-05-03 11:49:37 UTC
comments: true
published: true
---

After releasing RDO Mitaka, we migrated our current packaging workflow from gerrithub to a brand-new platform hosted at  [https://review.rdoproject.org](https://review.rdoproject.org) right before the Newton Summit.
During the last cycle, we've worked with [Software Factory](https://software-factory.io) folks to build a new packaging workflow based on the very same foundations as upstream OpenStack (using gerrit, zuul, nodepool). We're now relying on RPMFactory which is a specialization of Software Factory fitted for RPM packaging needs.

The migration was planned in order to satisfy some criteria:

- providing a consistent user experience to RDO contributors
- simplify and streamline our workflow
- consolidate resources


### Workflow changes

So now, packages are maintained through [https://review.rdoproject.org](https://review.rdoproject.org)
and packages dist-git are replicated to the [rdo-packages](https://github.com/rdo-packages) github organization.
The rdopkg utility has been updated to support the new workflow with new
commands: clone, review-patch and review-spec.

Anyone can submit changes for the review, which can be approved by the following groups:

-  rdo-provenpackager much like Fedora provenpackagers can +2 and +W changes for all projects.
-  PROJECT-core: package maintainers listed in rdoinfo can +2 and +W
changes for their projects.

### Howto

We're working to refresh documentation, but here's a short howto to hack
on packaging:

0. dnf copr enable jruzicka/rdopkg && dnf install -y rdopkg
1. rdopkg clone <mypackage> [-u <githubuser>]  This will create the following remotes
    - origin: dist-git
    - patches: upstream sources at current package version
    - upstream: upstream sources
    - review-origin: used to interact with RPMFactory
    - review-patches: used to interact with RPMFactory
2. modify packaging
3. rdopkg review-spec
4. review then merge

For downstream patches, the workflow is a bit different as we don't
merge patches but keep reviews open in order to keep the whole patch
chain history.
rdopkg has been updated to behave properly in that aspect.

We still have improvements coming but no major changes to this workflow,
if you have any questions, feel free to ping us on irc (#rdo @freenode)
or the [mailing list](https://www.redhat.com/mailman/listinfo/rdo-list).

Regards,
The RDO Eng. team