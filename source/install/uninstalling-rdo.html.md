---
title: Uninstalling RDO
authors: dneary, kashyap, larsks, rbowen
---

# Uninstalling RDO

There is no automated uninstall process for RDO (or OpenStack in general) because OpenStack consists of multiple services, (possibly) running across multiple systems. At this time there is no way to identify all of the various parts, locate them, and safely uninstall them.

Since OpenStack installations are almost certain to be deployed on dedicated systems (or VMs), the most reasonable way to "uninstall" RDO is to reinstall the base OS and start fresh.
