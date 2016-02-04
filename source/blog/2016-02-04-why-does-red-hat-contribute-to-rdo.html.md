---
title: Why does Red Hat contribute to RDO?
author: rbowen
date: 2016-02-04 10:20:56 UTC
tags: redhat, openstack, upstream, philosophy
published: false
comments: true
---

Red Hat's philosophy is 'Upstream First'. When we participate in an open source project, our contributions go into the upstream project first, before we focus on our own downstream offering. However, this isn't to say that we don't have specific reasons for contributing particular features and fixes.

Thus, it's useful to consider why Red Hat participates in RDO in the specific ways that we do.

Red Hat is focusing on delivering a distribution of OpenStack targeting Enterprise private clouds and Telco NFVi needs. In order to do so, we invest on the upstream features that are the most commonly requested by our user base and by our investigations on the needs of these markets. Common themes on these markets are:

- easy and automatizable deployments
- life cycle and upgrade management, limiting down time
- optional intergrated operational tools
- high availability of the control plane
- optional high availability of VMs
- disaster recovery scenarios
- scalability & composability of deployments
- multi-site deployments
- performance improvements in networking, storage and compute

We are also keen to enable integration of OpenStack with third party products below (storage, networking, compute, etc...) and above (management, orchestration, reporting, etc..) through well defined and stable interfaces defined upstreams, and using upstream developed integration, so that those integration are the easiest to consume by our customers and allowing them as much choice as possible at all level of the stack.

