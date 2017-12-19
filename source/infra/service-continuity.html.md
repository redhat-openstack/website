---
title: Service Continuity Plan for RDO Infra
category: documentation,infrastructure
---

# Planning for RDO Infra service continuity

(**NOTE:** this is still work in progress, and subject to discussion)

## Introduction

The RDO Infrastructure has traditionally been created and managed in an ad-hoc basis, with little planning or consistency. While RDO does not provide a business-critical service, some of the services provided by the RDO Infra are consumed by the upstream OpenStack community, and any outage can impact multiple CI jobs, and ultimately impact the RHOS delivery pipeline.

The migration of our infrastructure to the RDO Cloud gives us an opportunity to rethink how we are deploying our services, and requires some planning to ensure that the impact of any outage in the RDO Cloud is minimized.

## Criticality levels

As a first step, we need to define the criticality levels we will apply to this service, to justify their contingency measures.

* **High**: outage has a large impact on the RDO consumers. We should have a plan to be able to restore service in less than 4 hours since it is detected.
* **Medium**: outage has an impact on the RDO users, although it will not impact other communities that depend on RDO. We should have a plan to restore service in less than 24 hours since it is detected.
* **Low**: outage has a low impact. We should have a plan to restore service in less than 5 days since it is detected.

## Available resources

We need to consider that the amount of resources available to the RDO community is limited. At the same time, we should not *put all eggs in the same basket* to prevent a single outage from bringing down all of our infrastructure, [see this example](http://status.redhat.com/incidents/2hhpnqqnw807).

We will have the following resources at our disposal:

* **RDO Cloud**: this is our main resource, and most/all services should be located there by default.
* **Offsite cloud**: a second pool of cloud resources, located in a public cloud out of the Red Hat network. Using a public cloud will incur on additional costs, so we should keep usage down to a minimum (services with high criticality, and services with medium criticality when justified).

## Service plan

The plan to ensure service continuity should always include two types of measures:

* **Contingency plan**, to ensure that services with the highest criticality can be provided even if the system(s) running it fail.

* **Redeployment plan**, to ensure we can rebuild the system(s) from scratch in the event of a catastrophic failure. For this, it is highly advisable to have an automated way to deploy and configure the service, using configuration management tools like Ansible or Puppet.

The following table details the high-level plan for each service. A link to a detailed procedure will be added for each service, when available.


| Service name  | Criticality           | Contingency plan  | More details |
| ------------- |:---------------------:| ------------------| -------------|
| review.rdoproject.org | Medium         | Current: Periodic rsync from offsite node using the new sf-ops playbook to enable fast recovery. In case of an outage in the RDO Cloud, rebuild and restore data from backup. | [This URL](https://softwarefactory-project.io/docs/operator/backup_restore.html#recover-a-backup) contains details about the backup process|
| review.rdoproject.org (nodepool-builder) | Medium | Current: restore on the same offsite node | The Software Factory deployment architecture (arch.yaml) can be collapsed to run all the service on a single node (allinone). |
| review.rdoproject.org nodepool nodes | High | Have multiple clouds | Our current nodepool setup only include one cloud (RDO Cloud). We need to keep more than one cloud in the configuration, to make sure we can always have some available node for nodepool needs. With a static node (or with the nodepool-drivers coming with ZuulV3), some job could still be executed without a cloud. |
| review.rdo storage + logs | Medium | *Could we live without artifacts for a day or two? Could we lose them completely?* ||
| RDO Trunk repositories | High | trunk.rdoproject.org runs on the offsite cloud, and hosts the repos created by the DLRN builder instance. In case of an outage in the offsite cloud, we can switch the DNS entry for trunk.rdoproject.org to the DLRN Builder instance in the RDO Cloud, which has the same repositories. ||
| DLRN Builder instance | Medium | Built repos are synced using rsync to https://trunk.rdoproject.org (in the offsite cloud). ||
| DLRN DB instance | High |DB will be synced to a slave instance in the offsite cloud. In case of an outage to the RDO cloud, we can set the slave instance as master, and re-configure DLRN instances to use it. | <https://review.rdoproject.org/etherpad/p/mariadb-replication-procedures> |
| DLRN instance for upstream rpm-packaging | Medium | Built repos can be synced using rsync to https://trunk.rdoproject.org (in the offsite cloud). In case of an outage in the RDO cloud, we can switch the DNS entry to the machine in trunk.rdoproject.org (maybe some vhost is needed here????). | |
| images.rdoproject.org (+ CI docker registry) | High | Rsync to machine in offsite cloud. In case of an outage in the RDO cloud, we can switch the DNS entry to the machine in the offsite cloud. ||
| www.rdoproject.org | High | Web contents are static and stored in <https://github.com/redhat-openstack/website> . In case of an outage, we can switch the DNS entry to a machine in the offsite cloud. The builder and web deployment are maintained by OSAS at rdo-web-builder.osci.io and can be recreated using Ansible (<https://gitlab.com/osas/community-cage-infra-ansible>)) | For rdo-release.rpm rdoproject.org redirects to <https://repos.fedorapeople.org/repos>. This is out of RDO infra but is used by different CI jobs and users. *I assume repos.fedorapeople.org has its own replication/DR, right?*|
| blogs.rdoproject.org | Medium | Previous Enovance blog, still has content published from time to time. Machine is unmaintained (old Debian Squeeze and old WordPress). Needs rework.||
| planet.rdoproject.org | Low | Hosted on Rich's VPS | |
| dashboards.rdoproject.org | Low | Hosted on the same VM as www. | Deployed using ansible like www. |
| master.monitoring.rdoproject.org | Low | *Recreate machine (automated?)* |
| ara.rdoproject.org | Low | *Recreate machine (automated?)* |
| lists.rdoprojects.org | High | The server can be recreated using Ansible (<https://gitlab.com/osas/community-cage-infra-ansible>, later to be moved in the RDO repo). Important data are in a separate persistent storage and a regular backup is in place. MX2 is provided by OSAS/OSCI | This is using Mailman 2 (and would later need to be migrated to Mailman 3 when ready) |

## Service diagram

![](/infra/dr-diagram.png "Logo Title Text 1")
