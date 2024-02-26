---
author: amoralej
title: Adding new packages
---

# Adding new packages to RDO

1. toc
{:toc}


### How to add a new OpenStack package to RDO Trunk

When a new package is required in RDO, it must be added to RDO Trunk packaging.
To include new packages, following steps are required:

1. Create a "Package Review" story in [RDO Jira board](https://issues.redhat.com/projects/RDO/issues). You can clone the [new package template story](https://issues.redhat.com/browse/RDO-255).
Make sure you replace the title with the actual package name, and provide the reason and upstream code repository in the description. The story should be assigned to the Epic "RDO *release name*" and "Fix Version/s" field is also assigned to the desired RDO release.
Once the issue has been created, and an initial license check has been conducted, you can continue with steps 2 and 3.

2. Send a review adding the new project in rdo.yml to the [rdoinfo project in
review.rdoproject.org](https://review.rdoproject.org/r/#/q/project:rdoinfo). In
this change you must provide the project information and Package Review Jira story
ticket in the commit message (see [this example](https://review.rdoproject.org/r/#/c/18644/)).
Add the project definition in **rdo.yml** file and `under-review` tag in **tags/under-review.yml** file,
as for example:
    
        # in rdo.yml
        - project: octavia-lib
          conf: rpmfactory-lib
          maintainers:
          - nmagnezi@redhat.com
          - cgoncalves@redhat.com
          - bcafarel@redhat.com

        # in tags/under-review.yml
        - project: octavia-lib
          tags:
            under-review:
     
    **Note:** Maintainers must be registered in review.rdoproject.org and use the registered email in the rdoinfo review.
    This is required to set your permissions on your project.

    Once the patch is merged, following tasks are done by RDO automation process:-

    * Patch is proposed to create project and assign permissions to maintainers to manage the project.
    (as in [this example](https://review.rdoproject.org/r/#/c/18647/))
    * Once the create project patch is merged, required projects will be created in [https://review.rdoproject.org](https://review.rdoproject.org)
    with repo synched to [github.com](https://github.com/rdo-packages/octavia-lib-distgit).
    * Patch is proposed to add new projects to rdo zuul configuration in [review.rdoproject.org](https://github.com/rdo-infra/review.rdoproject.org-config/blob/master/zuul/rdo.yaml).
    * Patch is proposed to add check jobs to new projects in rdoproject.org.
    (as in [this example](https://review.rdoproject.org/r/#/c/18648/)). CI jobs in this patch will fail
    until the Patch to add new projects to rdo zuul configuration is merged.

3. Create a new review to the new distgit project with the needed content (spec
file, etc...) for the initial import as in [this example](https://review.rdoproject.org/r/#/c/18682/).
This will trigger a CI job to test the package build. The spec will be reviewed by the
core RDO packagers, and **cannot be approved by the requester**.

4. Once the initial spec is considered ready to merge by the reviewers, go back to the Package Review
Story and update it with the final spec and SRPM. Then, the formal package
review will be conducted by the reviewer using fedora-review. Only after the fedora-review output is added
as a comment in the story, the initial spec review will be approved
in Gerrit.

5. Finally, send a new review to rdoinfo project to remove the `under-review` tag from `tags/under-review.yml` file
and add tags for which package needs to be build, For current release Train, 2 files need to be updated(`tags/train.yml`,
`tags/train-uc.yml`) ([example](https://review.rdoproject.org/r/#/c/18757/)).
This change can be sent before merging review in step 3 if a `Depends-On: <gerrit-change-id step 3>`
is added.

Once the change is merged in rdoinfo, a new package should be automatically built
and published in the [RDO Trunk repos](http://trunk.rdoproject.org/centos7-master/report.html).

In order to track all review requests related to a new package process, it's recommended
to use the same topic (as `add-octavia-lib` in the above examples) for all these reviews.

RDO project is working to automate as much as possible this process. If you need
help to add new packages, you can ask on `#rdo` or `rdo-list` mailing list.

<a id="#rdo-pkg-guide"></a>

### How to add a new puppet module to RDO Trunk

Adding a new puppet module to RDO Trunk is done using the same process as adding a new
package to RDO Trunk with a few small differences. Use the following steps referencing the above
[How to add a new package to RDO Trunk](#how-to-add-a-new-openstack-package-to-rdo-trunk)
for details on submitting a new puppet module. The steps here correspond to the
steps above offering details specific to puppet modules.

1. Submit the Package Review, instead of including a spec file reference that the
spec file will be generated.

2. Send a review to rdoinfo according to the package requirements. The under-review tag
is still required. Use this as example content:


        # in rdo.yml
        - project: puppet-congress
          conf: rpmfactory-puppet

        # in tags/under-review.yml
        - project: puppet-congress
          tags:
            under-review:
     
3. Generate the spec file to submit to the new distgit project using this [script](https://github.com/strider/opm-toolbox)

4. Process is the same as standard packages

