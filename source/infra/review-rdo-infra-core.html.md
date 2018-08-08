---
title: review.rdoproject.org Infrastructure core administrators
category: documentation,infrastructure
---

# review.rdoproject.org infrastructure core administrators

The `config-core` group for review.rdoproject.org takes care of managing all configuration for the Software Factory instance used by the RDO project.

## Current core list

The current core list can be found [at this link](https://review.rdoproject.org/r/#/admin/groups/6,members).

The `rdo-provenpackagers` group is also included. Members of this group who are not part of the `config-core` group are expected to focus on the packaging-related side of the configuration.

## Review rules for changes to the config project

The Software Factory config project contains the configuration for the following aspects:

* Gerrit configuration (replication to GitHub)
* Nodepool configuration (connections to clouds, quotas, etc.)
* Zuul configuration (jobs, pipelines, 3rd party CI configuration)
* Jenkins configuration (job definition)
* Resource configuration (project creation, role assignments to projects)

Each of the cores will probably have knowledge on some of the areas, but not on others. We are all trusted to review and approve changes on areas where we have knowledge, and seek for help of others when dealing with areas where we are not comfortable enough.

The policy to merge a change is:

* Reviews can be merged with a single +2 from one of the cores, if he/she is confident enough about the change (for example, the change looks ok and has been proposed by another core).
* If the reviewer thinks that a second reviewer is required (for large/complex changes), he/she will add the other cores to the review and ask for help.

## Becoming a config core

The process to join the config-core group is:

* Contribute to the repo by submitting changes and performing reviews on your area of expertise. During that period, you must show that you got a good grasp of the platform and dedication to help maintaining it.
* Once the time has come, add the nomination as a topic to the weekly RDO meeting. We will discuss the nomination and provide feedback.
* Submit a review to the [config repo](https://github.com/rdo-infra/review.rdoproject.org-config/blob/master/resources/config.yaml#L3) with the proposal. See [this example](https://review.rdoproject.org/r/10008).
* Enjoy!

## Useful resources

The following documentation can be useful when working on changes to the config repository:

* [Introduction to Software Factory](https://www.rdoproject.org/blog/2017/06/introducing-Software-Factory-part-1/)
* [Software Factory user documentation](https://softwarefactory-project.io/docs/user/index.html)
* [Managing Software Factory resources via the config repository](https://softwarefactory-project.io/docs/user/resources_user.html#managing-resources-via-the-config-repository)
* [Contents of the Software Factory config repository](https://softwarefactory-project.io/docs/operator/deepdive.html#the-config-repo)
* [Jenkins Job Builder documentation](https://docs.openstack.org/infra/jenkins-job-builder/)
* [Zuul administration guide](https://docs.openstack.org/infra/zuul/admin/index.html)
