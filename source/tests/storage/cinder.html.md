---
title: Cinder
authors: gfidente, yrabl
wiki_title: Tests/Storage/Cinder
wiki_revision_count: 19
wiki_last_updated: 2014-01-06
---

# Cinder

Marker

## January 2014 Test Day

The general idea for the Cinder's test is to test the actions of the component in different environments and with different back ends. Cinder should be able to do the following actions with each back end and in every topology:

*   Create a volume (simple creation, from an image, from a snapshot and a copy of another volume).
*   Delete a volume.
*   Create a snapshot.
*   Delete a snapshot.
*   Upload the volume to an image.
*   Backup the volume.
*   Attach/ detach the volume from an instance.

## Packstack Based Installation (Storage Components) - work in progress

| Config Name                                                   | Release | BaseOS      | Status | HOWTO                                                                                                                                   | Who | Date | BZ/LP | Notes Page |
|---------------------------------------------------------------|---------|-------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------|-----|------|-------|------------|
| All-in-One w/ Cinder backed by GlusterFS                      |
| All-in-One w/ Cinder ThinLVM                                  |         | CentOS 6.5  | ??     | [Quickstart](Quickstart) + [Using ThinLVM for Cinder with RDO Havana](Using ThinLVM for Cinder with RDO Havana)   | ??  | ??   | None  | None       |
|                                                               |         | Fedora 19   | ??     | [Quickstart](Quickstart) + [Using ThinLVM for Cinder with RDO Havana](Using ThinLVM for Cinder with RDO Havana)   | ??  | ??   | None  | None       |
|                                                               |         | Fedora 20   | ??     | [Quickstart](Quickstart) + [Using ThinLVM for Cinder with RDO Havana](Using ThinLVM for Cinder with RDO Havana)   | ??  | ??   | None  | None       |
|                                                               |         | RHEL 6.5    | ??     | [Quickstart](Quickstart) + [Using ThinLVM for Cinder with RDO Havana](Using ThinLVM for Cinder with RDO Havana)   | ??  | ??   | None  | None       |
|                                                               |         | RHEL 7 Beta | ??     | [Quickstart](Quickstart) + [Using ThinLVM for Cinder with RDO Havana](Using ThinLVM for Cinder with RDO Havana)   | ??  | ??   | None  | None       |
| All-in-One w/ Cinder LVM                                      |         | CentOS 6.5  | ??     | [Quickstart](Quickstart)                                                                                                     | ??  | ??   | None  | None       |
|                                                               |         | Fedora 19   | ??     | [Quickstart](Quickstart)                                                                                                     | ??  | ??   | None  | None       |
|                                                               |         | Fedora 20   | ??     | [Quickstart](Quickstart)                                                                                                     | ??  | ??   | None  | None       |
|                                                               |         | RHEL 6.5    | ??     | [Quickstart](Quickstart)                                                                                                     | ??  | ??   | None  | None       |
|                                                               |         | RHEL 7 Beta | ??     | [Quickstart](Quickstart)                                                                                                     | ??  | ??   | None  | None       |
| All-in-One w/ Cinder NFS                                      |         | CentOS 6.5  | ??     | [Quickstart](Quickstart) + [Using NFS for Cinder with RDO](Using NFS for Cinder with RDO)                         | ??  | ??   | None  | None       |
|                                                               |         | Fedora 19   | ??     | [Quickstart](Quickstart) + [Using NFS for Cinder with RDO](http://openstack.redhat.com/Tests/Storage/Cinder#Cinder_with_NFS) | ??  | ??   | None  | None       |
|                                                               |         | Fedora 20   | ??     | [Quickstart](Quickstart) + [Using NFS for Cinder with RDO](http://openstack.redhat.com/Tests/Storage/Cinder#Cinder_with_NFS) | ??  | ??   | None  | None       |
|                                                               |         | RHEL 6.5    | ??     | [Quickstart](Quickstart) + [Using NFS for Cinder with RDO](http://openstack.redhat.com/Tests/Storage/Cinder#Cinder_with_NFS) | ??  | ??   | None  | None       |
|                                                               |         | RHEL 7 Beta | ??     | [Quickstart](Quickstart) + [Using NFS for Cinder with RDO](http://openstack.redhat.com/Tests/Storage/Cinder#Cinder_with_NFS) | ??  | ??   | None  | None       |
| semi destributed component/ AIO+component on different server |         | CentOS 6.5  | ??     | [Quickstart](Quickstart) but pass to Packstack either --cinder-host or --glance-host to use a remote system                  | ??  | ??   | None  | None       |
|                                                               |         | Fedora 19   | ??     | [Quickstart](Quickstart) but pass to Packstack either --cinder-host or --glance-host to use a remote system                  | ??  | ??   | None  | None       |
|                                                               |         | Fedora 20   | ??     | [Quickstart](Quickstart) but pass to Packstack either --cinder-host or --glance-host to use a remote system                  | ??  | ??   | None  | None       |
|                                                               |         | RHEL 6.5    | ??     | [Quickstart](Quickstart) but pass to Packstack either --cinder-host or --glance-host to use a remote system                  | ??  | ??   | None  | None       |
| Full Distribution/ Different components on each server        |         | CentOS 6.5  | ??     | [Quickstart](Quickstart) but pass to Packstack both --cinder-host or --glance-host to use remote systems                     | ??  | ??   | None  | None       |
|                                                               |         | Fedora 19   | ??     | [Quickstart](Quickstart) but pass to Packstack both --cinder-host or --glance-host to use remote systems                     | ??  | ??   | None  | None       |
|                                                               |         | Fedora 20   | ??     | [Quickstart](Quickstart) but pass to Packstack both --cinder-host or --glance-host to use remote systems                     | ??  | ??   | None  | None       |
|                                                               |         | RHEL 6.5    | ??     | [Quickstart](Quickstart) but pass to Packstack both --cinder-host or --glance-host to use remote systems                     | ??  | ??   | None  | None       |
