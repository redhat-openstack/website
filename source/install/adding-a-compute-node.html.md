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

Expanding your single-node OpenStack cloud to include a second compute node requires a second network adapter, if you want to separate the Neutron tenant network traffic.

### Edit the answer file

First, edit the "answer file" generated during the initial Packstack setup. You'll find the file in the directory from which you ran Packstack.

**Note:** By default, `$youranswerfile` is called `packstack-answer-$date-$time.txt`.

    $EDITOR $youranswerfile

Replace `$EDITOR` with your preferred editor.

#### Adjust network card names

Set `CONFIG_NEUTRON_OVS_TUNNEL_IF` to `eth1` or whatever name your network card uses. Note this is not mandatory, but it may be a good idea to separate tunnel traffic through a separate interface.

Your second NIC may have a different name. You can find the names of your devices by running:

    ip l | grep '^\S' | cut -d: -f2

#### Change IP addresses

If you want to have your new node as the only compute node, change the value for `CONFIG_COMPUTE_HOSTS` from the value of your first host IP address to the value of your second host IP address. You can also have both systems as compute nodes, if you add them as a comma-separated list:

    CONFIG_COMPUTE_HOSTS=<serverIP>,<serverIP>,...

Ensure that the key `CONFIG_NETWORK_HOSTS` exists and is set to the IP address of your first host.

#### Skip installing on an already existing servers

In case you do not want to apply any modification on the already configured servers, add the following parameter to the "answer file":

    EXCLUDE_SERVERS=<serverIP>,<serverIP>,...

You may not want to exclude the existing server if it will stay as a compute node, since live migration between compute nodes needs to add the SSH keys to each of them.

### Re-run Packstack with the new values

Run Packstack again, specifying your modified "answer file":

    packstack --answer-file=$youranswerfile

Packstack will prompt you for the root password for each of your nodes.
