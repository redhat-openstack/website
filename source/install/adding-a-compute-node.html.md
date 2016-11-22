---
title: Adding a compute node
authors: alourie, carltm, dneary, fastingaciu, garrett, jasonbrooks, rbowen, sebastian,
  vaneldik
wiki_title: Adding a compute node
wiki_revision_count: 27
wiki_last_updated: 2015-03-05
---

{:.no_toc}

# Adding a compute node

Expanding your single-node OpenStack cloud to include a second compute node requires a second network adapter. In order for your pair of nodes to share the same private network, replace the `lo` interface used for the private network with a real NIC.

### Edit the answer file

First, edit the "answer file" generated during the initial Packstack setup. You'll find the file in the directory from which you ran Packstack.

**Note:** By default, `$youranswerfile` is called `packstack-answer-$date-$time.txt`.

    $EDITOR $youranswerfile

Replace `$EDITOR` with your preferred editor.

#### Adjust network card names

Change both `CONFIG_NOVA_COMPUTE_PRIVIF` and `CONFIG_NOVA_NETWORK_PRIVIF` from `lo` to `eth1` or whatever name your network card uses.

Your second NIC may have a different name. You can find the names of your devices by running:

    ip l | grep '^\S' | cut -d: -f2

#### Change IP addresses

Change the value for `CONFIG_COMPUTE_HOSTS` from the value of your first host IP address to the value of your second host IP address. Ensure that the key `CONFIG_NETWORK_HOSTS` exists and is set to the IP address of your first host.

#### Skip installing on an already existing servers

In case you do not want to run the installation over again on the already configured servers, add the following parameter to the "answer file":

      EXCLUDE_SERVERS=<serverIP>,<serverIP>,...

### Re-run Packstack with the new values

Run Packstack again, specifying your modified "answer file":

    packstack --answer-file=$youranswerfile

Packstack will prompt you for the root password for each of your nodes.
