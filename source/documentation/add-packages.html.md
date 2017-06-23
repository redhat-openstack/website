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

1. Create a "Package Review" bug in [Red Hat bugzilla](https://bugzilla.redhat.com/)
following the best practices described in [RDO OpenStack Packaging Guidelines](/documentation/rdo-packaging-guidelines/). Once the bug has been created, and an initial license check has been conducted, you can continue with steps 2 and 3.

2. Send a review adding the new project in rdo.yml to the [rdoinfo project in
review.rdoproject.org](https://review.rdoproject.org/r/#/q/project:rdoinfo). In
this change you must provide the project information and Package Review bugzilla
ticket in the commit message (see [this example](https://review.rdoproject.org/r/#/c/1408/)).
In the project definition in **rdo.yml** file, only `under-review` must be uncommented as project tags
and comment all releases where package should be built, as for example:
    
        - project: murano-dashboard
          name: openstack-murano-ui
          tags:
            under-review:
            #newton-uc:
            #newton:
            #mitaka:
          conf: rpmfactory-core
          maintainers:
          - atsamutali@mirantis.com
          - iyozhikov@mirantis.com
     
    **Note:** Maintainers must be registered in review.rdoproject.org and use the registered email in the rdoinfo review.
    This is required to set your permissions on your project.

    As part of the review process, some tasks will be carried out by the RDO team:

    * The required projects will be created in [https://review.rdoproject.org](https://review.rdoproject.org).
    * Users included in maintainers list will received required permissions to manage the project.
    * The new projects will be added to zuul configuration in review.rdoproject.org
    (as in [this example](https://review.rdoproject.org/r/#/c/1418/)).
    * Once the projects are created, the change will be merged in rdoinfo project.

3. Create a new review to the new distgit project with the needed content (spec
file, etc...) for the initial import as in [this example](https://review.rdoproject.org/r/#/c/1417/).
This will trigger a CI job to test the package build.

4. Once the initial distgit import is merged, go back to the Package Review
Bugzilla and update it with the final spec and SRPM. Then, the formal package 
review will be conducted by the reviewer, who will set the `rdo-review +` flag.

5. Finally, send a new review to rdoinfo project to remove the `under-review` tag and uncomment the required versions where the package must be built ([example](https://review.rdoproject.org/r/#/c/1422/)).
This change can be sent before merging review in step 3 if a `Depends-On: <gerrit-change-id step 3>`
is added, but the review will only be approved once the `rdo-review +` flag has been
set in the Bugzilla.

Once the change is merged in rdoinfo, a new package should be automatically built
and published in the [RDO Trunk repos](http://trunk.rdoproject.org/centos7-master/report.html).

In order to track all review requests related to a new package process, it's recommended
to use the same topic (as `add-osc-lib` in the above examples) for all these reviews.

RDO project is working to automate as much as possible this process. If you need
help to add new packages, you can ask on `#rdo` or `rdo-list` mailing list.

<a id="#rdo-pkg-guide"></a>

### How to add a new puppet module to RDO Trunk

Adding a new puppet module to RDO Trunk is done using the same process as adding a new
package to RDO Trunk with a few small differences. Use the following steps referencing the above
[How to add a new packGage to RDO Trunk](#how-to-add-a-new-openstack-package-to-rdo-trunk)
for details on submitting a new puppet module. The steps here correspond to the
steps above offering details specific to puppet modules.

1. Submit the Package Review, instead of including a spec file reference that the
spec file will be generated.

2. Send a review to rdoinfo according to the package requirements. The under-review tag
is still required. Use this as example content:
        - project: puppet-congress
          conf: rpmfactory-puppet
          tags:
            under-review:
            #ocata-uc:
            #ocata:

3. Generate the spec file to submit to the new distgit project using https://github.com/strider/opm-toolbox

4. Process is the same as standard packages

### How to add a new puppet module to openstack-puppet-modules (OPM)

For a puppet module to be included as a part of the collection of puppet
modules used to deploy RDO, the package that was created in the previous
section must be added to the requires list of the
openstack-puppet-modules-distgit package.

Clone the openstack-puppet-modules-distgit project using rdopkg. Submit a
review with the puppet module package name added to the list of requires in
the spec file maintained in the openstack-puppet-modules-distgit project.

