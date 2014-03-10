---
title: HA Architecture
authors: vvaldez
wiki_title: HA Architecture
wiki_revision_count: 2
wiki_last_updated: 2014-03-24
---

# HA Architecture

OpenStack High Availability can be as simple or as complex as required by the deployment. This page looks at two extreme deployments that are possible with RDO.

The first one involves completely isolated clusters for every component. This requires more controllers but allows for extreme scalability and isolation of component clusters. ![](HA_Architecture-full.png "fig:HA_Architecture-full.png")

On the other hand, every OpenStack component can be collapsed onto a set of three controllers. This requires fewer resources for the control plane but can make scaling components and diagnosing issues more difficult than if they were segregated. ![](HA_Architecture-collapsed.png "fig:HA_Architecture-collapsed.png")
