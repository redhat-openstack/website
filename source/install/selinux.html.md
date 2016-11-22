---
title: SELinux
authors: lon
wiki_title: SELinux
wiki_revision_count: 1
wiki_last_updated: 2014-01-09
---

# SELinux in an RDO Deployment

RDO releases should operate with SELinux in enforcing mode without issue. If it does not work for you, please see the [SELinux_issues](/documentation/selinux-issues/) page for more information on how to troubleshoot and what information to gather for filing bugzillas.

From time to time, especially with the EL6 releases of RDO, certain measures are taken to ensure that RDO works and are distributed as part of the *openstack-selinux* package. This package contains fixes to ensure RDO continues working on top of the latest Red Hat Enterprise Linux 6 and CentOS 6 releases. It always advised to run the very latest *selinux-policy* package appropriate for your distribution, even if you upgrade nothing else. For example, if you are running CentOS 6.4, it is recommended to run the latest selinux-policy package from CentOS 6.5 if at all possible.

Occasionally, RDO developers will even release updated selinux-policy packages to ensure that your RDO systems stay operational with the latest RDO releases.

# SELinux during RDO Development

RDO releases interim releases during upstream OpenStack development based on upstream milestones. For example, "icehouse-1". Shortly thereafter, the RDO team schedules Test Days in order to gather information on what needs to be fixed.

OpenStack is often in heavy development during these interim releases. Consequently, SELinux is likely to stand in the way of performing useful testing during these test days. For this reason, it is recommended to run in *permissive* mode during test days and gather AVCs:

    sudo setenforce 0

The RDO team typically waits to coordinate with upstream SELinux policy developers until after the upstream "-3" milestone, which is the Feature Freeze for the next OpenStack release. This is because the high pace of innovation that takes place during OpenStack development cycles makes writing SELinux policy modules difficult to keep up with; it is similar to trying to keep localization work up to date.

# What about a modular SELinux policy?

I get a lot of questions about this. The short answer is that SELinux policies are not conducive to being separated in to multiple git repositories/packages at this time.

(still work in progress)
