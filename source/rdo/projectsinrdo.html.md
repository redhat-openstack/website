---
title: ProjectsInRDO
authors: ggillies, hguemar, ihrachys
wiki_title: ProjectsInRDO
wiki_revision_count: 13
wiki_last_updated: 2015-07-31
---

# Projects in RDO

The following is a list of Openstack Projects which are already packaged or currently in the process of being packaged and shipped as part of RDO. For the full list, see [rdo.yml](https://github.com/redhat-openstack/rdoinfo/blob/master/rdo.yml)

### Keystone

Keystone provides authentication, authorization and service discovery mechanisms via HTTP primarily for use by projects in the OpenStack family. It is most commonly deployed as an HTTP interface to existing identity systems, such as LDAP.

*   Homepage: <https://wiki.openstack.org/wiki/Keystone>
*   Code: <https://github.com/openstack/keystone>
*   Package Maintainers:
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-keystone>

### Glance

The Glance project provides services for discovering, registering, and retrieving virtual machine images. Glance has a RESTful API that allows querying of VM image metadata as well as retrieval of the actual image.

*   Homepage: <https://wiki.openstack.org/wiki/Glance>
*   Code: <https://github.com/openstack/glance>
*   Package Maintainers: hguemar@fedoraproject.org
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-glance>

### Cinder

Cinders goal is to implement services and libraries to provide on demand, self-service access to Block Storage resources. Provide Software Defined Block Storage via abstraction and automation on top of various traditional backend block storage devices.

*   Homepage: <https://wiki.openstack.org/wiki/Cinder>
*   Code: <https://github.com/openstack/cinder>
*   Package Maintainers: hguemar@fedoraproject.org
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-cinder>

### Swift

Swift is a distributed object storage system designed to scale from a single machine to thousands of servers. Swift is optimized for multi-tenancy and high concurrency. Swift is ideal for backups, web and mobile content, and any other unstructured data that can grow without bound.

*   Homepage: <https://wiki.openstack.org/wiki/Swift>
*   Code: <https://github.com/openstack/swift>
*   Package Maintainers: zaitcev@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-swift>

### Nova

OpenStack Nova provides a cloud computing fabric controller, supporting a wide variety of virtualization technologies, including KVM, Xen, LXC, VMware, and more. In addition to its native API, it includes compatibility with the commonly encountered Amazon EC2 and S3 APIs.

*   Homepage: <https://wiki.openstack.org/wiki/Nova>
*   Code: <https://github.com/openstack/nova>
*   Package Maintainers:
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-nova>

### Neutron

Neutron is a virtual network service for Openstack.

*   Homepage: <https://wiki.openstack.org/wiki/Neutron>
*   Code: <https://github.com/openstack/neutron>
*   Package Maintainers: ihrachys@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-neutron>

### Heat

Heat is a service to orchestrate multiple composite cloud applications using templates, through both an OpenStack-native ReST API and a CloudFormation-compatible Query API.

*   Homepage: <https://wiki.openstack.org/wiki/Heat>
*   Code: <https://github.com/openstack/heat>
*   Package Maintainers:
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-heat>

### Ceilometer

The Ceilometer project aims to become the infrastructure to collect measurements within OpenStack so that no two agents would need to be written to collect the same data. Its primary targets are monitoring and metering, but the framework should be easily expandable to collect for other needs. To that effect, Ceilometer should be able to share collected data with a variety of consumers.

*   Homepage: <https://wiki.openstack.org/wiki/Ceilometer>
*   Code: <https://github.com/openstack/ceilometer>
*   Package Maintainers: pkilambi@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ceilometer>

Gnocchi is the project name of a TDBaaS (Time Series Database as a Service) project started under the Ceilometer program umbrella.

*   Homepage: <https://wiki.openstack.org/wiki/Gnocchi>
*   Code: <https://github.com/openstack/gnocchi>
*   Package Maintainers: pkilambi@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-gnocchi>

### Horizon

Horizon is a Django-based project aimed at providing a complete OpenStack Dashboard along with an extensible framework for building new dashboards from reusable components.

*   Homepage: <https://wiki.openstack.org/wiki/Horizon>
*   Code: <https://github.com/openstack/horizon>
*   Package Maintainers: mrunge@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-horizon>

### Ironic

Ironic is an integrated OpenStack project which aims to provision bare metal machines instead of virtual machines, forked from the Nova Baremetal driver. It is best thought of as a bare metal hypervisor API and a set of plugins which interact with the bare metal hypervisors. By default, it will use PXE and IPMI in concert to provision and turn on/off machines, but Ironic also supports vendor-specific plugins which may implement additional functionality.

*   Homepage: <https://wiki.openstack.org/wiki/Ironic>
*   Code: <https://github.com/openstack/ironic>
*   Package Maintainers: dtantsur@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-ironic>

### Trove

Trove is Database as a Service for Open Stack.

*   Homepage: <https://wiki.openstack.org/wiki/Trove>
*   Code: <https://github.com/openstack/trove>
*   Package Maintainers: victoria@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-trove>

### Sahara

Sahara aims to provide users with simple means to provision a Hadoop cluster by specifying several parameters like Hadoop version, cluster topology, nodes hardware details and a few more.

*   Homepage: <https://wiki.openstack.org/wiki/Sahara>
*   Code: <https://github.com/openstack/sahara>
*   Package Maintainers: egafford@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-sahara>

### Tempest

Tempest is a set of integration tests to be run against a live OpenStack cluster. Tempest has batteries of tests for OpenStack API validation, Scenarios, and other specific tests useful in validating an OpenStack deployment.

*   Homepage: <https://github.com/openstack/tempest>
*   Code: <https://github.com/openstack/tempest>
*   Package Maintainers:
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=tempest>

### Manila

Manila is a shared filesystem management project for OpenStack.

*   Homepage: <https://wiki.openstack.org/wiki/Manila>
*   Code: <https://github.com/openstack/manila>
*   Package Maintainers: zaitcev@redhat.com, hguemar@fedoraproject.org
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-manilla>

### Designate

Designate is an OpenStack inspired DNSaaS.

*   Homepage: <https://wiki.openstack.org/wiki/Designate>
*   Code: <https://github.com/openstack/designate>
*   Package Maintainers: jschwarz@redhat.com, ihrachys@redhat.com
*   Report Bug/Issues: <https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&component=openstack-designate>
