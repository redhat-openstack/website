---
author: amoralej
title: New OpenStack release
---

## Getting packages ready for new OpenStack releases

When a new OpenStack release is delivered upstream, there is a set of steps that
must be performed in RDO to build and publish new packages both in RDO CloudSIG and
RDO Trunk repos.

### 1. RDO infrastructure preparation
Some weeks before a new OpenStack release is published, some changes in RDO tools and
infrastructure are needed to get the delivery pipeline ready. These tasks are mostly done
by RDO core members, for example:

- Adding a new DLRN builder following stable/<new release> branch.
- Creating CI jobs for new branches.
- Including new release in automation bots.
- etc...

Once these tasks are done, it will be announced in rdo mailing lists so that package
maintainers can start carrying out the next steps.
    
    
### 2. Update package distgits.
Around RC1 time ([check upstream schedule](https://releases.openstack.org/pike/schedule.html)), **package maintainers**
should send required reviews to *rpm-master* branch to adjust distgits contents to the
changes occurred during the cycle. This typically includes updating minimal versions for
existing dependencies, removing not longer used requirements, etc...

### 3. Create new branch &lt;release>-rdo in distgits.
Once the distgits content is ready for the new release, **package maintainers** must request a new
branch &lt;release>-rdo for their packages. This can be done by sending a review to the corresponding package
resource in gerrit configuration. An example of a new branch request can be found
[here](https://review.rdoproject.org/r/#/c/6840/).

**Note:** [config project](https://review.rdoproject.org/r/gitweb?p=config.git;a=tree;f=resources;hb=refs/heads/master)
contains a resource file for each managed package.

### 4. Request new builds for CloudSIG repos.
After new branches are created in distgits and upstream projects have pushed new RC or final
releases (depending on the release model adopted for each upstream project), new builds are
created using Centos Build System by sending a review to the &lt;release>-rdo branch as shown
in [this doc](https://www.rdoproject.org/documentation/rdo-packaging/#rebasing-on-new-version).
Note that RDO uses a bot to propose reviews for new releases automatically in most
cases, however it's recomended that package maintainers pay some attention on this process
and send a review if reviews have not been created on time.

### 5. Pin branchless projects in rdoinfo.
According to stable policies, RDO Trunk repos shouldn't follow master branch after GA.
By default, DLRN builders are configured to use **stable/&lt;release>** branches for non-master
releases. However, some projects packaged in RDO don't create stable branches upstream
or use different ones. For example, some independent projects create a branch for
each supported major package version instead of OpenStack release. For those cases, packages
should be pinned to a
specific git tag, commit or branch. This is done by sending a review to rdoinfo project
using source-branch parameter for the release tag as in [this example](https://review.rdoproject.org/r/#/c/7121).

