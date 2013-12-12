---
title: RDO-BugTriage
authors: kashyap, larsks
wiki_title: RDO-BugTriage
wiki_revision_count: 9
wiki_last_updated: 2014-05-21
---

# RDO-Bug Triage

## Bugzilla queries

List of un-triaged bugs (NEW state) for RDO component in bugzilla.redhat.com -- <http://goo.gl/NqW2LN>

## Bugzilla workflow

### Initial Triage (NEW)

When a reporter files a bug, the report automatically starts out in a NEW state. If a bug/RFE has already been fixed in the 'current' current stable RDO release (Say Havana), then

*   Update the "Fixed In Version" field with the NVR (Name-Version-Release) of the package
*   Move the bug to CLOSED->CURRENTRELEASE, and

## References

*   <http://fedoraproject.org/wiki/BugZappers/BugStatusWorkFlow>
*   <http://fedoraproject.org/wiki/BugZappers/StockBugzillaResponses>
