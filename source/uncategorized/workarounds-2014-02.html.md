---
title: Workarounds 2014 02
authors: apevec, cmyster, jruzicka, kashyap, larsks, pixelbeat, queria, whayutin,
  yfried
wiki_title: Workarounds 2014 02
wiki_revision_count: 25
wiki_last_updated: 2014-03-25
---

# Workarounds 2014 02

This page documents workarounds that may be required for installing RDO Icehouse Milestone 2. This page is associated with the [RDO_test_day_Icehouse_milestone_2](RDO_test_day_Icehouse_milestone_2). Please see [Workarounds](Workarounds) for a recommended format for writing up these workarounds.

## Active

### Error: 87 lines match pattern '\[DEFAULT\]' in file '/etc/nova/nova.conf

*   **Bug:** [1059815](https://bugzilla.redhat.com/show_bug.cgi?id=1059815)
*   **Affects:** RHEL, CentOS
*   FIXED

### Error: Package: openstack-dashboard-2014.1-0.1b1.fc21.noarch (openstack-icehouse)

*   **Bug:** [1060334](https://bugzilla.redhat.com/show_bug.cgi?id=1060334)
*   **Affects:** Fedora 20
*   **Workaround:** Ensure python-troveclient >= 1.0 is installed from [updates](https://admin.fedoraproject.org/updates/python-troveclient-1.0.3-1.fc20)

### Error: nova-compute fails to start properly

*   **Bug:** [1049391](https://bugzilla.redhat.com/show_bug.cgi?id=1049391)
*   **Affects:** Fedora 20
*   **Workaround:** Ensure libvirt >= 1.1.3.3-5 is installed from [updates-testing](https://admin.fedoraproject.org/updates/libvirt-1.1.3.3-5.fc20,openwsman-2.4.3-1.fc20)

### Error: Heat, packstack install fails due to heat db migrate

*   **Bug:** [1060904](https://bugzilla.redhat.com/show_bug.cgi?id=1060904)
*   **Affects:** RHEL, CentOS ( intermittent, rerun packstack a second time )
*   Work around: Turn off heat in packstack answer file

### Error: mysql-devel install error if PROVISION_TEMPEST is y

*   **Bug:** [1060923](https://bugzilla.redhat.com/show_bug.cgi?id=1060923)
*   **Affects:** RHEL, CentOS ( if set to y, set provision_tempest to 'n')
*   **FIXED**
