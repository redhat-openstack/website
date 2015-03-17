---
title: Release-Cadence
authors: apevec, kashyap, larsks
wiki_title: Release-Cadence
wiki_revision_count: 6
wiki_last_updated: 2015-03-18
---

# Release-Cadence

## RDO packaging release cadence

This page tries to capture the release cadence of RDO packages in relation to different community distributions, thus giving an approximate idea of "community support" status of any given OpenStack release.

### Fedora

OpenStack upstream, much like Fedora, has a 6-month (approx) release cycle.

So, to briefly explain the OpenStack release cadence in context of Fedora, RDO packages (for Fedora), roughly, follows Fedora distribution release schedule, i.e. once N+2 (Juno) is released, we EOL N (Havana). To map Fedora and OpenStack releases in Fedora official repos:

    Fedora-20 == Havana   (2013.2) -- EOL
    Fedora-21 == IceHouse (2014.1) -- 'supported'
    Fedora-22 == Juno     (2014.2) -- once this transitions to
                                      'supported', Havana will be EOLed)

**NOTE**: Needless to say -- as time goes by, the above information must be updated to reflect the new (future) reality.

### CentOS

[FIXME]

### References

*   <https://wiki.openstack.org/wiki/Releases>
