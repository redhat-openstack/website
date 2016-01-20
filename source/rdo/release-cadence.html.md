---
title: Release-Cadence
authors: apevec, kashyap, larsks, snecklifter
wiki_title: Release-Cadence
wiki_revision_count: 6
wiki_last_updated: 2016-01-20
---

# Release-Cadence

## RDO packaging release cadence

This page describes the release cadence of RDO packages in relation to different community distributions, giving an approximate idea of "community support" status of any given OpenStack release.

### Fedora

OpenStack upstream, much like Fedora, has a 6-month (approx) release cycle.

RDO packages follow (roughly) the Fedora distribution release schedule. I.e., once N+2 (Liberty) is released, we EOL N (Juno). To map Fedora and OpenStack releases in Fedora official repos:

|-----------|-------------------|-----------|
| Fedora 22 | Juno (2014.2)     | supported |
| Fedora 23 | Kilo (2015.1)     | supported |

### CentOS

Due to the slower release cadence of RHEL and therefore CentOS, only the most recent release plus the previous one are supported, in keeping with upsream policy. Older versions of the operating system such as CentOS 6 do not receive later releases.

|-----------|-------------------|-----------|
| CentOS 6  | Juno (2014.2)     | supported |
| CentOS 7  | Kilo (2015.1)     | supported |
| CentOS 7  | Liberty (2015.2)  | supported |

### References

*   <https://wiki.openstack.org/wiki/Releases>
*   <https://fedoraproject.org/wiki/OpenStack#OpenStack>
