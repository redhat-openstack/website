---
title: Using RDO on TryStack
category: documentation
authors: dneary, sgordon
wiki_category: Documentation
wiki_title: Using RDO on TryStack
wiki_revision_count: 8
wiki_last_updated: 2013-06-05
---

# Using RDO on TryStack

If you want to get familiar with the OpenStack dashboard interface, and experiment with the creation of instances and shared volumes, [TryStack](http://trystack.org) could be for you. If you connect to "OpenStack Grizzly on x86/RHEL", you will be connecting to a public sandboxed instance of RDO, on hardware which has been contributed by Red Hat, and installed and maintained by [ Dan Radez](People#radez), a member of Red Hat's OpenStack team.

# Signing up

To get started on TryStack:

1. Join the [TryStack Facebook group](https://www.facebook.com/groups/269238013145112) - we use Facebook to authenticate users for the TryStack instance afterwards. 2. Once your membership in the group os approved, [Log in](https://x86.trystack.org/dashboard/) to the TryStack instance. You're connected to an OpenStack Dashboard instance.

# Booting an instance

Once you're signed up, you can launch and connect to an instance.

To do this, there are a few things we need to do:

1.  In "Access and security": In the "Security groups" tab, edit the rules to enable connection on TCP port 22 to enable SSH remote access
2.  In "Keypairs", either import an existing public SSH key, or create a new keypair, to enable you to authenticate without a password when connecting to the instance
3.  Finally, let's launch an instance from "Images & snapshots". There are two pre-installed operating system images available, Fedora18-x86_64 and Ubuntu-12.10-x86_64. Choose one, and click "Launch instance"
    -   In the "Details" tab, give your instance a unique name
    -   Under "Access & Security", ensure you embed the correct keypair to allow you to connect afterwards
    -   Then click "Launch"

The instance will go through a few steps in the "Build" state: "Networking", "Block device mapping", and "Spawning", before finally the status will change to "Active", and you will be able to connect to it.

# Connecting to an instance

When your instance is booted, you can see its private (internal) IP address and public access IP address in the Instances dashboard. To connect over SSH, ensure that your private SSH key has been correctly added to your local keyring, and run \`ssh root@<public IP address>\`

# Attaching a volume

You can create a block storage volume and attach it to your running instance from the dashboard.

1. In the Volumes tab, chlick "Create volume", set a unique volume name, set the size (limit is 1 GB) , and create the volume. 2. Once the volume has been created, attach it to the instance. Click "Edit attachments", and in the "Select an instance" drop-down box, select your running instance. Confirm the attachment. A few seconds later, the volume will be attached.

To make the storage available to use in your instance, you will need to make it available as a mounted filesystem.

1. Note down the hardware node of the block device in the Instances view on the Dashboard (eg. vdb) 2. Inside your instance, create a filesystem on this volume: \`mkfs.ext4 /dev/vdb\` 3. Mount the volume as you normally would inside the instance: \`mount /dev/vdb /mnt/myvolume\`

You now can use this volume to store data on your instance.

<Category:Documentation>
