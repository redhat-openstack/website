---
author: ykarel
title: Retiring a package
---

# Retiring a package from RDO

1. toc
{:toc}

### What does retiring a package means

- The package will not be build and published to RDO Trunk repo
- The package will not be build in CBS and published to next CloudSIG repo


**NOTE:** The package can be retired only from the current development release.

### How to remove an OpenStack package from RDO Trunk

Package for a project can exist across different releases. So retiring it in RDO needs to go via stages.

To remove a package, following steps are required:-

**Stage 1:-** Project Source is retired/deleted upstream, but it's package still need to be maintained because it's required by other projects

- Send a review to `rdoinfo` like [Example review](https://review.rdoproject.org/r/#/c/20387/) to pin(add source-branch: `<good commit>`) the project against the tag or commit, so package get's build from pinned commit rather than latest commit(deleted source code).

    ```
    # Need to add source-branch like below
    - project: oslo-sphinx
      tags:
        train-uc:
          source-branch: f92583cfc34292ec1441368f984c9692346946c4
     ```

- Send a review to `config` project like [Example review](https://review.rdoproject.org/r/#/c/20415/) to run DLRN-pinned jobs(legacy-DLRN-rpmbuild-pinned, legacy-DLRN-rpmbuild-fedora-pinned) so package get's build from pinned commit rather than from latest, This is required so that spec changes can be done like https://review.rdoproject.org/r/#/c/20383/.

**Stage 2:-** Package is no longer needed by other projects:-

- Send a review to [rdoinfo project in review.rdoproject.org](https://review.rdoproject.org/r/#/q/project:rdoinfo).
In this change you need to delete the tag for the project for which package is not needed to built.
    
Once the change is merged in rdoinfo, package will no longer exist in RDO trunk repo, but it will still be built for previous releases(for which
tag is defined in `rdoinfo`):-
[RDO Trunk repos](http://trunk.rdoproject.org/centos7-master/report.html).
