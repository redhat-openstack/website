---
title: Why does Red Hat contribute to RDO?
author: Nick Barcet
date: 2016-02-04 10:20:56 UTC
tags: redhat, openstack, upstream, philosophy
comments: true
published: true
---

Red Hat's philosophy is 'Upstream First'. When we participate in an open source project, our contributions go into the upstream project first, as a prerequisite to deliver it in the downstream offering. Our continued focus, over the past years and in the future, is to reduce to a bare minimum the differences between Upstream, RDO and RHEL OpenStack Platform at General Availabilty time, as we believe this is the only way we can maximise our velocity in delivering new features. In doing so, we, as any successful enterprise would do, need to focus our efforts on what matters in respect to our "downstream" strategy, and it means that we do prioritize our efforts accordingly as we are contributing particular features and fixes.

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