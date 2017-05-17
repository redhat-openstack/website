---
title: Some lessons an IT department can learn from OpenStack
author: jpena
tags: 
date: 2017-05-17 13:39:19 CEST
---

I have spent a lot of my professional career working as an IT Consultant/Architect. In those positions, you talk to many customers with different backgrounds, and see companies that run their IT in many different ways. Back in 2014, I joined the OpenStack Engineering team at Red Hat, and started being involved with the OpenStack community. And guess what, I found yet another way of managing IT.

These last 3 years have taught me a lot about how to efficiently run an IT infrastructure at scale, and what's better, they proved that many of the concepts I had been previously preaching to customers (_automate, automate, automate!_) are not only viable, but also required to handle ever-growing requirements with a limited team and budget.

So, would you like to know what I have learnt so far in this 3-year journey?

## Processes

The OpenStack community relies on several processes to develop a _cloud operating system_. Most of these processes have evolved over time, and together they allow a very large contributor base to collaborate effectively. Also, we need to manage a complex infrastructure to support this our processes.

- **Infrastructure as code**: there are several important servers in the OpenStack infrastructure, providing service to thousands of users every day: the Git repositories, the Gerrit code review infrastructure, the CI bits, etc. The deployment and configuration of all those pieces is automated, as you would expect, and the Puppet modules and Ansible playbooks used to do so are available at their [Git repository](http://git.openstack.org/cgit/openstack-infra/system-config). There can be no snowflakes, no "this server requires a very specific configuration, so I have to log on and do it manually" excuses. If it cannot be automated, it is not efficient enough. Also, storing our infrastructure definitions as code allows us to take changes through peer-review and CI before applying in production. More about that later.

- **Development practices**: each OpenStack project follows the same structure:

  * There is a Project Team Leader (PTL), elected from the project contributors every six months. A PTL acts as a project coordinator, rather than a manager in the traditional sense, and is usually expected to rotate every few cycles.
  * There are several core reviewers, people with enough knowledge on the project to judge if a change is correct or not.
  * And then we have multiple project contributors, who can create patches and peer-review other people's patches.

  Whenever a patch is created, it is sent to review using a code review system, and then:

  * It is checked by multiple CI jobs, that ensure the patch is not breaking any existing functionality.
  * It is reviewed by other contributors.

  Peer review is done by core reviewers and other project contributors. Each of them have the rights to provide different votes:

  * A +2 vote can only be set by a core reviewer, and means that the code looks ok for that core reviewer, and he/she thinks it can be merged as-is.
  * Any project contributor can set a +1 or -1 vote. +1 means "code looks ok to me" while -1 means "this code needs some adjustments". A vote by itself does not provide a lot of feedback, so it is expanded by some comments on what should be changed, if needed.
  * A -2 vote can only be set by a core reviewer, and means that the code cannot be merged until that vote is lifted. -2 votes can be caused by code that goes against some of the project design goals, or just because the project is currently in _feature freeze_ and the patch has to wait for a while.

  When the patch passes all CI jobs, and received enough +2 votes from the core reviewers (usually two), it goes through another round of CI jobs and is finally merged in the repository. 

  This may seem as a complex process, but it has several advantages:

  * It ensures a certain level of quality on the master branch, since we have to ensure that CI jobs are passing.
  * It encourages peer reviews, so code should always be checked by more than one person before merging.
  * It engages core reviewers, because they need to have enough knowledge of the project codebase to decide if a patch deserves a +2 vote.
  
- **Use the cloud**: it would not make much sense to develop a cloud operating system if we could not use the cloud ourselves, would it? As expected, all the OpenStack infrastructure is hosted in [OpenStack-based clouds donated by different companies](https://www.openstack.org/foundation/companies/#infra-donors). Since the infrastructure deployment and configuration is automated, it is quite easy to manage in a cloud environment. And as we will see later, it is also a perfect match for our continuous integration processes.

- **Automated continuous integration**: this is a key part of the development process in the OpenStack community. Each month, 5000 to 8000 commits are reviewed in all the OpenStack projects. This requires a large degree of automation in testing, otherwise it would not be possible to review all those patches manually. 

  * Each project defines a number of CI jobs, covering unit and integration tests. These projects are defined as code using [Jenkins Job Builder](https://docs.openstack.org/infra/jenkins-job-builder/), and reviewed just like any other code contribution.
  * For each commit:
    * Our CI automation tooling will spawn short-lived VMs in one of the OpenStack-based clouds, and add them to the test pool
    * The CI jobs will be executed on those short-lived VMs, and the test results will be fed back as part of the code review 
    * The VM will be deleted at the end of the CI job execution

  This process, together with the requirement for CI jobs to pass before merging any code, minimizes the amount of regressions in our codebase.
  
- **Use (and contribute to) Open Source**: one of the "Four Opens" that drive the OpenStack community is [Open Source](https://docs.openstack.org/project-team-guide/open-source.html). As such, all of the development and infrastructure processes happen using Open Source software. And not just that, the OpenStack community has created several libraries and applications with great potential for reuse outside the OpenStack use case. Applications like [Zuul](https://docs.openstack.org/infra/zuul/) and [nodepool](https://docs.openstack.org/infra/nodepool/index.html), general-purpose libraries like [pbr](https://docs.openstack.org/developer/pbr/), or the contributions to the [SQLAlchemy](https://www.sqlalchemy.org/) library are good examples of this.

## Tools

So, which tools do we use to make all of this happen? As stated above, the OpenStack community relies on several open source tools to do its work:
    
- **Infrastructure as code**
  * Git to store the infrastructure definitions
  * Puppet and Ansible as configuration management and orchestration tools
- **Development**
  * Git as a code repository
  * Gerrit as a code review and repository management tool
  * Etherpad as a collaborative editing tool
- **Continuous integration**
  * Zuul as an orchestrator of the gate checks
  * Nodepool to automate the creation and deletion of short-lived VMs for CI jobs across multiple clouds
  * Jenkins to execute CI jobs (actually, it has now been replaced by Zuul itself)
  * Jenkins Job Builder as a tool to define CI jobs as code


## Replicating this outside OpenStack

It is perfectly possible to replicate this model outside the OpenStack community. We use it in RDO, too! Although we are very closely related to OpenStack, we have our own infrastructure and tools, following a very similar process for development and infrastructure maintenance.

We use an integrated solution, [SoftwareFactory](https://softwarefactory-project.io/docs/index.html), which includes most of the common tools described earlier (and then some other interesting ones). This allows us to simplify our toolset and have:
    
- **Infrastructure as code**
  * [https://github.com/rdo-infra](https://github.com/rdo-infra) contains the definitions of our infrastructure components
- **Development and continuous integration**
  * [https://review.rdoproject.org](https://review.rdoproject.org), our SoftwareFactory instance, to integrate our development and CI workflow
  * Our own RDO Cloud as an infrastructure provider


## You can do it, too

Implementing this way of working in an established organization is probably a non-straightforward task. It requires your IT department and application owners to become as _cloud-conscious_ as possible, reduce the amount of micro-managed systems to a minimum, and establish a whole new way of managing your development... But the results speak for themselves, and the OpenStack community (also RDO!) is a proof that it works.
