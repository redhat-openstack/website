---
title: Upgrading RDO To Icehouse
authors: dansmith
wiki_title: Upgrading RDO To Icehouse
wiki_revision_count: 4
wiki_last_updated: 2014-04-24
---

# Upgrading RDO To Icehouse

The Icehouse release of OpenStack brings new options for upgrades, as well as a few additional inter-service dependencies that must be managed.

## Nova/Neutron Upgrade Interaction

In Icehouse, Nova and Neutron collaborate on instance booting when using the libvirt hypervisor driver. This means that each service depends on a new feature of the other, which in turn means that care must be taken when crossing this upgrade boundary. The recommended method is:

1.  Upgrade the Nova controller infrastructure
2.  Upgrade Neutron and configure it to send events to Nova
3.  Upgrade Nova compute nodes

This will ensure that a suitably new Nova API will support the event delivery from Neutron prior to Neutron actually sending them. When compute nodes are upgraded from Havana to Icehouse code, events will be sent properly to the new compute nodes as they begin requiring them. If you decide not to pursue the "live" upgrade option in Nova which separates the upgrade of controller and compute nodes, you can disable the delivery of the events from the Neutron side, or disable the requirement on the Nova side.

## Upgrade Methods: Offiline or Live Upgrade?

Icehouse brings the ability to perform a limited live upgrade of a Havana deployment. This means that controller infrastructure can be upgraded independently from the compute nodes, minimizing service disruption. Consider the following to determine which is right for you:

<table border="1">
<tr>
<td>
 

</td>
<td>
<b>Offline</b>

</td>
<td>
<b>Live</b>

</td>
</tr>
<tr>
<td>
<b>Pro</b>

</td>
<td>
Potentially less-risky, well-tested, fewer moving parts

</td>
<td>
Minimal service disruption,
Upgrade of base OS is easier

</td>
</tr>
<tr>
<td>
<b>Con</b>

</td>
<td>
Requires varying levels of service disruption,
Requires all hosts to be on the same version of the base OS and OpenStack Release

</td>
<td>
New technology, less-tested

</td>
</tr>
</table>
