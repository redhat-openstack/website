---
title: Enabling Migrations
authors: dansmith
wiki_title: Enabling Migrations
wiki_revision_count: 4
wiki_last_updated: 2014-04-24
---

# Enabling Migrations

Migration support in Nova allows the relocation of instances to different compute nodes, and is the fundamental component that enables resize operations. There are two types of migrations supported, Live and "Cold" or "Offline" operations, both with different setup requirements.

## Cold/Offline Migrations

The arguably safer and less-complicated mechanism of an offline migration is purely instrumented by nova and is relatively easy to set up. Simply create and distribute password-less SSH keys for the "nova" user, starting on one of the nodes:

      # su -s /bin/bash nova
      $ ssh-keygen
      Generating public/private rsa key pair.
      Enter passphrase (empty for no passphrase): 
      Enter same passphrase again: 
      Your identification has been saved in id_rsa.
      Your public key has been saved in id_rsa.pub.
      The key fingerprint is:
      56:1d:13:c5:3c:fd:93:01:fa:66:68:38:48:73:24:5c dan@compute1
      The key's randomart image is:
      +--[ RSA 2048]----+
      |      ...E  +*o. |
      |       .o  ..o+..|
      |       o ....  .+|
      |      . +.. o  o.|
      |       .So o +  .|
      |       .  o o    |
      |                 |
      |                 |
      |                 |
      +-----------------+

This key needs to be authorized to log in as nova, so we need to put it into the authorized_keys list:

      $ cat .ssh/id_rsa.pub >> .ssh/authorized_keys
      $ chmod 600 .ssh/authorized_keys

Next, we need to build a known_hosts file with the host key of every compute node (including this one:

      ssh-keyscan compute1 compute2 compute3 compute4 > ~/.ssh/known_hosts

Now, we need to distribute the entire .ssh directory to all the rest of the hosts. If you used something like packstack and already have root ssh key authentication set up, then you can do this as root:

      for host in compute1 compute2 compute3 compute4; do
          tar cf - ~nova/.ssh | ssh $host "cd /; tar xf -"
      done

To test that this is working, try ssh'ing from one compute node to another as the nova user:

      # su -s /bin/bash nova
      $ ssh compute2 "echo It worked!"
      It worked!
      $

In case you get a "This account is currently not available." error, you will need to enable logins to the "nova" user with:

      # usermod -s /bin/bash nova

<!--
FIXME: SELinux?
-->

At this point, you should be able to use the offline migration and resize commands (i.e. "nova migrate" and "nova resize") properly.

## Live Migrations

Enabling live migration of instances is a little more complicated than the process for offline migrations, but it shares a lot of the same setup steps. Since live migrations are orchestrated by libvirt instead of nova, the private key must be installed for the root user (libvirt runs as root) instead of (or in addition to) the nova user. To start, follow the offline instructions above, but install the id_rsa private key for the root user on each compute node. If you used packstack or some other tool to install your deployment, this may already be done for you. The test is that you must be able to run this from any compute node to any other compute node, without being asked to approve a host key or type in a password:

      # id -u
      0
      # ssh compute2 "It works!"
      It works!
      #

The first additional step you need to take is to configure nova on the compute nodes to not bind vnc consoles to the IP of the compute node. Without this, migrations will fail because the receiving compute node will not be able to bind to the address of the sending one. In /etc/nova/nova.conf, set the bind address to any:

      vncserver_listen = 0.0.0.0

Next, you need to configure the firewall to not block libvirt ephemeral ports used during live migration:

      iptables -I INPUT -p tcp --dport 49152:49215 -j ACCEPT

Once this is done, you should be able to live-migrate instances from one host to the other.
