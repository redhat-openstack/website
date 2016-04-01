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

Expanding your single-node OpenStack cloud to include a second compute node requires a second network adapter: in order for our pair of nodes to share the same private network, we must replace the "lo" interface we used for the private network with a real nic.

### Edit the answer file

First, you must edit the "answer file" generated during the initial packstack setup. You'll find it in the directory from which you ran packstack.

NOTE: by default $youranswerfile is called packstack-answer-$date-$time.txt

    $EDITOR $youranswerfile

Replace $EDITOR with your preferred editor.

#### Adjust network card names

Change both `CONFIG_NOVA_COMPUTE_PRIVIF` and `CONFIG_NOVA_NETWORK_PRIVIF` from `lo` to `eth1` or whatever name your network card uses.

Your second NIC may have a different name. You can find the names of your devices by running:

    ifconfig | grep '^\S'

#### Change IP addresses

Change the value for `CONFIG_COMPUTE_HOSTS` from the value of your first host IP address to the value of your second host IP address. Ensure that the key `CONFIG_NETWORK_HOSTS` exists and is set to the IP address of your first host.

#### Skip installing on an already existing servers

In case you do not want to run the installation over again on the already configured servers, add the following parameter to the answerfile:

      EXCLUDE_SERVERS=<serverIP>,<serverIP>,...

### Re-run packstack with the new values

Run packstack again, specifying your modified answer file:

NOTE: by default $youranswerfile is called packstack-answer-$date-$time.txt

    sudo packstack --answer-file=$youranswerfile

Packstack will prompt you for the root password for each of your nodes.
