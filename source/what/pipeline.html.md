---
title: RDO: Delivery pipeline
author: hguemar
---

# The delivery pipeline

This is the 10,000 foot view of the RDO delivery pipeline. For more
detail, see the various more in-depth documents:

## Trunk chasing

We use [DLRN](https://www.rdoproject.org/what/dlrn/) to track upstream changes and build continuously OpenStack as a RPM distribution.
Then our [CI](https://ci.centos.org/view/rdo/view/promotion-pipeline/) hosted on [CentOS community CI](https://wiki.centos.org/QaWiki/CI) runs multiple jobs
on DLRN snapshots. We use the [WeIRDO](https://github.com/rdo-infra/weirdo) framework to run the same jobs as upstream CI on our packages.
This allows us to detect early integration issues and get either our packaging or upstream projects fixed. This also includes installers such as OPM, TripleO or PackStack.

We also create Ocata tags in CentOS Community Build System (CBS) in order to build dependencies that are incompatible with currently supported releases.


## Branching

We start branching RDO stable release around milestone 3, and have stable builds getting bootstrapped. This includes:

* registering packages in CBS, which is scripted using the rdoinfo database.
* syncing requirements in packages.
* branching distgit repositories.
* building upstream releases in CBS. This part used to be semi-automated using rdopkg tool, and currently being consolidated into a cron job creating reviews.
* tag builds in <release>-testing repositories, some automation is in preparation.

Trunk chasing continues, but we pay attention in keeping promotions happening more frequently to avoid a gap between tested upstream commits and releases.

## GA publication

Since OpenStack does releases slightly ahead of time, we have most of GA releases built in CBS, but some of them comes late.
We also trim final GA repositories, use repoclosure utility to check if there's no missing dependencies.
Before mass-tagging builds in <release>-release we launch stable promotion CI jobs and if they're green, we publish them.

At this stage, CentOS Core team, creates final GA repositories and sign packages.

For Newton, it took 10 hours between upstream GA announcement and repositories publication, 4 hours up to stable tagging. As for Ocata, all stable builds + CI jobs were finished within 2 hours.
