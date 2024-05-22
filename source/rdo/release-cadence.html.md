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

### Maintained RDO versions in CloudSIG repos

RDO [CloudSIG repositories](https://www.rdoproject.org/what/repos/) are based on tag releases provided by OpenStack project. According to the [definition of maintenance phases of OpenStack](https://docs.openstack.org/project-team-guide/stable-branches.html#maintenance-phases), RDO will not update CloudSIG repos after a release is transitioned to Extended Maintenance status.

Current maintained CloudSIG releases are:

|------------------|----------|-----------|
| CentOS Stream 9  | Caracal  | supported |
| CentOS Stream 9  | Bobcat   | supported |
| CentOS Stream 9  | Antelope | supported |

### Maintained RDO versions in RDO Trunk repos

In order to provide patches merged in OpenStack releases in Extended Maintenance state, RDO mantains [RDO Trunk repositories](https://www.rdoproject.org/what/trunk-repos/) following stable branches or pinned releases until they are EOL.

Currently, RDO maintains following RDO Trunk repositories:

|------------------|----------|-----------|
| CentOS Stream 9  | Caracal  | supported |
| CentOS Stream 9  | Bobcat   | supported |
| CentOS Stream 9  | Antelope | supported |
| CentOS Stream 9  | Zed      | supported |
| CentOS Stream 9  | Yoga     | extended maintenance|
| CentOS Stream 9  | Xena     | extended maintenance|
| CentOS Stream 9  | Wallaby  | extended maintenance |


### RHEL compatibility

Although it is expected that RDO works fine in Red Hat Enterprise Linux (RHEL) OS, it is currently not tested on it. Note that CentOS Stream is a continuosly delivered distribution that tracks just ahead of RHEL and differences between both distributions at a certain point are expected.

* [What is CentOS Stream?](https://www.redhat.com/en/topics/linux/what-is-centos-stream)

### Fedora

The RDO team, in coordination with the Fedora OpenStack SIG maintains the OpenStack Clients in Fedora repositories.

* [Fedopra OpenStack SIG](https://fedoraproject.org/wiki/SIGs/OpenStack)

### References

*   [OpenStack Releases](http://releases.openstack.org/)

