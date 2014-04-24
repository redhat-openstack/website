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

      # su -s /bin/bash nova
      $ ssh-keygen
      Generating public/private rsa key pair.
      Enter passphrase (empty for no passphrase): 
      Enter same passphrase again: 
      Your identification has been saved in id_rsa.
      Your public key has been saved in id_rsa.pub.
      The key fingerprint is:
      56:1d:13:c5:3c:fd:93:01:fa:66:68:38:48:73:24:5c dan@compute1
      The key's randomart image is:
      +--[ RSA 2048]----+
      |      ...E  +*o. |
      |       .o  ..o+..|
      |       o ....  .+|
      |      . +.. o  o.|
      |       .So o +  .|
      |       .  o o    |
      |                 |
      |                 |
      |                 |
      +-----------------+

This key needs to be authorized to log in as nova, so we need to put it into the authorized_keys list:

      $ cat .ssh/id_rsa.pub >> .ssh/authorized_keys
      $ chmod 600 .ssh/authorized_keys

Next, we need to build a known_hosts file with the host key of every compute node (including this one). This is a bit of a clumsy process, but the following script snippet should help automate the process:

      for host in compute1 compute2 compute3 compute 4; do
          ssh $host -oPasswordAuthentication=no -oStrictHostKeyChecking=no true
      done

You will see a bunch of "Permission denied" messages since the keys are not yet distributed, but when it is done, there should be an entry in ~nova/.ssh/known_hosts for each compute host. Now, we need to distribute the entire .ssh directory to all the rest of the hosts. If you used something like packstack and already have root ssh key authentication set up, then you can do this as root:

      for host in compute1 compute2 compute3 compute4; do
          tar cf - ~nova/.ssh | ssh $host "cd /; tar xf -"
      done

To test that this is working, try ssh'ing from one compute node to another as the nova user:

      # su -s /bin/bash nova
      $ ssh compute2 "echo It worked!"
      It worked!
      $

---> SELinux?

At this point, you should be able to use the offline migration and resize commands (i.e. "nova migrate" and "nova resize") properly.

## Live Migrations

Enabling live migration of instances is a little more complicated than the process for offline migrations, but it shares a lot of the same setup steps. Since live migrations are orchestrated by libvirt instead of nova, the keys must be installed for the root user (libvirt runs as root) instead of the nova user. To start, follow the offline instructions above, but generate and install keys for the root user instead (or in addition to the nova user). If you used packstack or some other tool to install your deployment, this may already be done for you. The test is that you must be able to run this from any compute node to any other compute node, without being asked to approve a host key or type in a password:

      # id -u
      0
      # ssh compute2 "It works!"
      It works!
      #
