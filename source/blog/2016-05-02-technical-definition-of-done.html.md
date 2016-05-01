---
title: Technical definition of done
author: trown
tags: openstack, packaging
date: 2016-05-02 00:00:00 CEST
---


Before releasing Mitaka, we agreed on a tecnical definition of done[1]. This can always evolve to add more coverage, but this is what we currently test when deciding whether a release is ready from a technical perspective:

- Packstack all-in-one deployments testing the 3 upstream scenarios 
- TripleO single contoller and single compute deployment validated with Tempest smoke tests
- TripleO three controller and single compute deployment with pacemaker validated using a Heat template based ping test

These same tests are used to validate our trunk repos[2]. 

[1]: https://meetbot.fedoraproject.org/rdo/2016-04-06/rdo_meeting_%282016-04-06%29.2016-04-06-15.00.log.html#l-269
[2]: https://ci.centos.org/view/rdo/view/promotion-pipeline/
