---
title: ML2 plugin
category: networking
authors: jlibosva, larsks, rbowen, rkukura
wiki_category: Networking
wiki_title: ML2 plugin
wiki_revision_count: 10
wiki_last_updated: 2014-06-04
---

# ML2 plugin

The Modular Layer 2 plugin (ML2) is new in havana. Unlike existing monolithic plugins, ML2:

*   Supports an extensible set of network types, each implemented as a TypeDriver
*   Works with a variety of virtual networking mechanisms (simultaneously), each supported via a MechanismDriver
*   Supports multi-segment L2 networks
*   Supports heterogeneous network configurations

MechanismDrivers are included that work with the familiar openvswitch and linuxbridge layer 2 agents. The openvswitch and linuxbridge monolithic plugins that also support these L2 agents are being deprecated in icehouse, and will be removed in the following release. No new features are being added to the openvswitch and linuxbridge plugins in icehouse, and devstack now defaults to the ML2 plugin with the openvswitch L2 agent.
