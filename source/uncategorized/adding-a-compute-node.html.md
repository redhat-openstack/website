---
title: Adding a compute node
authors: alourie, carltm, dneary, fastingaciu, garrett, jasonbrooks, rbowen, sebastian,
  vaneldik
wiki_title: Adding a compute node
wiki_revision_count: 27
wiki_last_updated: 2015-03-05
---

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
# Adding a compute node

Expanding your single-node OpenStack cloud to include a second compute node requires a second network adapter: in order for our pair of nodes to share the same private network, we must replace the "lo" interface we used for the private network with a real nic.

### Edit the answer file

First, you must edit the "answer file" generated during the initial packstack setup. You'll find it in the directory from which you ran packstack.

FIXME: change $youranswerfile to the default filename for the answefile

    vi $youranswerfile

If you're not familiar with vi, you may use another editor such as "nano".

=== Adjust network card names ==

Change both `CONFIG_NOVA_COMPUTE_PRIVIF` and `CONFIG_NOVA_NETWORK_PRIVIF` from `lo` to `eth1` or whatever name your network card uses.

Your second NIC may have a different name. You can find the names of your devices by running: <kbd>ifconfig | grep '^\\w\*:'</kbd>

#### Change IP addresses

Change the value for `CONFIG_NOVA_COMPUTE_HOSTS` from your the value of first host IP address to the value of your second host IP address.

### Re-run packstack with the new values

Run packstack again, specifiying your modified answer file:

    sudo packstack --answer-file=$youranswerfile

Packstack will prompt you for the root password for each of your nodes.
