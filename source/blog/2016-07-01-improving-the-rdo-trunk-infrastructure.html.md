---
title: Improving the RDO Trunk infrastructure
author: jpena
tags: 
date: 2016-07-01 11:53:17 CEST
---

Quite often, projects tend to to outgrow their initial expectations, and in those cases we face issues as they grow. This has been the case with our [RDO Trunk repositories](https://trunk.rdoproject.org) and the [DLRN tool](https://github.com/openstack-packages/DLRN) that builds them.

I had my first contact with the tool a bit more than a year ago, when I took the task of migrating it from the virtual machine it was running on to a more powerful one. Fast-forward to the present, we have 5 RDO Trunk builders, and the RDO Trunk repos are used by the TripleO, Kolla, Puppet OpenStack and Packstack CIs (maybe more!). This means we need to provide a more performant and resilient infrastructure than we used to have.

### Our main issues

Considering our growth, we were facing several issues:

- Performance was suffering due to the many workers building packages at once. To make things worse, the same system building packages was also serving them, so any CPU or disk contention would affect any consumers of the repository.

- While we had a high-availability mechanism in place, it was quite rudimentary, and it involved running lsyncd to synchronize all repo contents to a backup server. With the huge amount of small files present in the system, lsyncd only contributed to making things slower.

### The solution

With the help from kbsingh and dmsimard, we came out with a new design for the RDO Trunk infrastucture:

![RDO Trunk infrastructure](../images/blog/dlrn-infra.png "RDO Trunk infrastructure")

- A server inside the ci.centos.org infrastructure is used to build packages. That server is not publicly accessible, so we need a way to make our repositories available.

- The CentOS CDN is used to distribute the repositories that successfully passed CI tests, using several directories in the [CentOS Cloud SIG space](http://buildlogs.centos.org/centos/7/cloud/x86_64/). That gives us a fast, highly available way to make the repos available, specially for end-users and the RDO Test Days, when we need them to be 100% ready.

- In addition to that, we still need CI users and packagers to be able to access the individual repositories created by DLRN when a package is built. To accomplish this, another server is providing those via the well known https://trunk.rdoproject.org URL.

We needed a way to have the build server push each repo to the public-facing server, and the old lsyncd-based method was not working well for us. Thus, we had to [patch DLRN](https://github.com/openstack-packages/DLRN/commit/56cff6b1a49b71c67a71a78f3a3005c622978c11) to add this feature, which seems to be working quite well so far.

### Future steps

This architecture still has some single points of failure: the build server can fail, and the same could happen to the public-facing server. In both cases, there are mitigation measures in place to minimize the impact (we can quickly rebuild the systems using our Puppet modules), but still, there is work ahead to do.

Do you want to help us do it?
