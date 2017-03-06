---
title: RDO Ocata Release Behind The Scenes
author: hguemar
date: 2017-02-28 08:00:00 UTC
tags: openstack,ocata,release,releng,behind-the-scenes
comments: true
published: true
---

I have been involved in 6 GA releases of RDO (From Juno to Ocata), and I wanted to share a glimpse of the preparation work.
Since Juno, our process has tremendously evolved: we refocused RDO on EL7, joined the CentOS Cloud SIG, moved to [Software Factory](https://www.redhat.com/archives/rdo-list/2015-October/msg00123.html).

Our release process does not start when upstream announces GA or even a milestone, no it starts from the very beginning of upstream cycle.

**Trunk chasing**

We have been using [DLRN](https://www.rdoproject.org/what/dlrn/) to track upstream changes and build continuously OpenStack as a RPM distribution.
Then our [CI](https://ci.centos.org/view/rdo/view/promotion-pipeline/) hosted on [CentOS community CI](https://wiki.centos.org/QaWiki/CI) runs multiple jobs
on DLRN snapshots. We use the [WeIRDO](https://github.com/rdo-infra/weirdo) framework to run the same jobs as upstream CI on our packages.
This allows us to detect early integration issues and get either our packaging or upstream projects fixed. This also includes installers such as OPM, TripleO or PackStack.

We also create Ocata tags in CentOS Community Build System (CBS) in order to build dependencies that are incompatible with currently supported releases.


**Branching**

We start branching RDO stable release around milestone 3, and have stable builds getting bootstrapped. This includes:

* registering packages in CBS, I scripted this part for Ocata using rdoinfo database.
* syncing requirements in packages.
* branching distgit repositories.
* building upstream releases in CBS, this part used to be semi-automated using rdopkg tool, Alfredo is consolidating that into a cron job creating reviews.
* tag builds in <release>-testing repositories, some automation is in preparation.

Trunk chasing continues, but we pay attention in keeping promotions happening more frequently to avoid a gap between tested upstream commits and releases.

**GA publication**

Since OpenStack does releases slightly ahead of time, we have most of GA releases built in CBS, but some of them comes late.
We also trim final GA repositories, use repoclosure utility to check if there's no missing dependencies.
Before mass-tagging builds in <release>-release we launch stable promotion CI jobs and if they're green, we publish them.

At this stage, CentOS Core team, creates final GA repositories and sign packages.

For Newton, it took 10 hours between upstream GA announcement and repositories publication, 4 hours up to stable tagging. As for Ocata, all stable builds + CI jobs were finished within 2 hours. 

Fun fact, Alan and I were doing the last bits of the Ocata release in the Atlanta PTG hallway and even get to see Doug Hellmann to send the GA announcement live (which started the chronometer for us). So we sprinted to have RDO Ocata GA ready as soon as possible (CI included!). We still have room for improvement but we were the first binary OpenStack distro available!    


**Thoughts**

As of Ocata, there are still areas of improvement:

* documenting releases process: many steps are still manual or require specific knowledge. During Newton/Ocata releases, we enabled Alfredo to do large chunks of the release preparation work. 
With post-mortems, this helped us clarifying the process, and prepare to allow more people helping in the release process.
* dependencies CI: dependencies are a critical factor to release RDO in time. We need to test dependencies against RDO releases, RDO against CentOS updates and ensure that nothing is broken. That's one of our goals for Pike.
* tag management: tags are used in CBS to determine where builds are to be published. Unlike Fedora, CBS has no automated pipeline to manage updates, so we have to manually tag builds. I'm currently working on having a gerrit-based process to manage tags. The tricky part is how to avoid inconsistencies in repositories (e.g avoid breaking dependencies, accidental untagging etc.)
* dependencies updates: we want dependencies to remain compatible with Fedora packages, as Fedora is the foundation of next RHEL/CentOS, some of them are maintained in Fedora, others in
[RDO common](https://github.com/rdo-common), some with basic patches to fix EL7 build issues (not acceptable in Fedora), the rest being forks that we effectively maintain (e.g MariaDB).
As a first step, we want to have the last set of packages to be maintained in our gerrit instances to allow maintainers doing builds without any releng support.
* more contributions! Our effort into automating the release pipeline also serves the goal of empowering more contributors into the release work, so if you're interested, just come and tell us. ;-)

I hope this gave you an overview of how RDO is released and what are our next steps for Pike release.
