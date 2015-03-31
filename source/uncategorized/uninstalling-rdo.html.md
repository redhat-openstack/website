---
title: Uninstalling RDO
authors: dneary, kashyap, larsks, rbowen
wiki_title: Uninstalling RDO
wiki_revision_count: 20
wiki_last_updated: 2015-03-31
---

# Uninstalling RDO

There is no automated uninstall process for RDO (or OpenStack in general). This is because OpenStack consists of multiple services, (possibly) running across multiple systems, and there is not, at this time, any way to identify all of the various parts, where they are, and a safe way to uninstall them.

Since OpenStack installations are almost certain to be deployed on dedicates systems (or VMs), the reasonable way to "uninstall" RDO is to reinstall the base OS and start fresh.
