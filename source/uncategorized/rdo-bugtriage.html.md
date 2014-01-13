---
title: RDO-BugTriage
authors: kashyap, larsks
wiki_title: RDO-BugTriage
wiki_revision_count: 9
wiki_last_updated: 2014-05-21
---

# RDO-Bug Triage

## BUG TRIAGE DAY

Wednesday, January 15, 14:00 UTC is our next bug triage day. That's `date -d "14:00 UTC"` in your local timezone. Please feel free to stop by `#rdo` on IRC (Freenode) to help out or ask questions.

## Bugzilla queries

*   List of un-triaged bugs (NEW state) -- <http://goo.gl/NqW2LN>
*   List of all ASSIGNED bugs (with and without Keyword 'Triaged') -- <http://goo.gl/oFY9vX>
*   List of all ON_QA bugs -- <http://goo.gl/CZX92r>

## Bugzilla workflow

### Initial Triage (NEW) -- FIXME

If a bug/RFE has already been fixed in the 'current' current stable RDO release (Say Havana), then

*   Update the "Fixed In Version" field with the NVR (Name-Version-Release) of the package
*   Move the bug to CLOSED->CURRENTRELEASE

## References

Upstream OpenStack bug triage

*   <https://wiki.openstack.org/wiki/BugTriage>

Some existing community projects which use Red Hat bugzilla, and their workflows for bug triage:

*   <http://fedoraproject.org/wiki/BugZappers/BugStatusWorkFlow>
*   <http://fedoraproject.org/wiki/BugZappers/StockBugzillaResponses>
*   <https://fedoraproject.org/wiki/BugZappers/How_to_Triage>
