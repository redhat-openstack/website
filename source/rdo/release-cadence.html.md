---
title: Release-Cadence
authors: apevec, kashyap, larsks, snecklifter
---

# Release-cadence

## RDO packaging release cadence

This page describes the release cadence of RDO packages in relation to different community distributions, giving an approximate idea of *community support* status of any given OpenStack release.

### CentOS Versions

Due to the slower release cadence of RHEL and therefore CentOS, only the most recent release plus the previous one are supported, in keeping up with upstream policy. Older versions of the operating system such as CentOS 7 do not receive later releases.

When there is a new major CentOS release, the following OpenStack version is packaged for both for the new and the previous version of CentOS. The purpose of this policy is to ease the trasition between them.

|------------------|----------|-----------|
| CentOS Stream 9  | Zed      | supported |
| CentOS Stream 9  | Yoga     | supported |
| CentOS Stream 8  | Yoga     | supported |
| CentOS Stream 8  | Xena     | supported |
| CentOS Stream 8  | Wallaby  | supported |
| CentOS Stream 8  | Victoria | supported |

### RHEL compatibility

Although it is expected that RDO works fine in Red Hat Enterprise Linux (RHEL) OS, it is currently not tested on it. Note that CentOS Stream is a continuosly delivered distribution that tracks just ahead of RHEL and differences between both distributions at a certain point are expected.

* [What is CentOS Stream?](https://www.redhat.com/en/topics/linux/what-is-centos-stream)

### Fedora

The RDO team, in coordination with the Fedora OpenStack SIG maintains the OpenStack Clients in Fedora repositories.

* [Fedopra OpenStack SIG](https://fedoraproject.org/wiki/SIGs/OpenStack)

### References

*   [OpenStack Releases](http://releases.openstack.org/)

