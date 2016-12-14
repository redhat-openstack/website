---
title: TripleO USB key
authors: weshayutin, 
wiki_title: TripleO USB Key
wiki_revision_count: 1
wiki_last_updated: 2016-07-07
---

# TripleO USB key

## Introduction

The TripleO USB key a.k.a oooq-usbkey combines tripleo-quickstart and prebuilt RDO OpenStack images into a USB key for a plug and play TripleO install experience.

## How to

First download the following image:

    curl -O https://images.rdoproject.org/ooo-usbkey/mitaka.img

You may wish to verify the MD5 sum, which you can find at
[https://images.rdoproject.org/ooo-usbkey/mitaka.img.md5](https://images.rdoproject.org/ooo-usbkey/mitaka.img.md5)

Make sure you know the device your USB key is assigned to:

    blkid -c /dev/null

    /dev/sda1: UUID="0d9b692e-7459-41be-9a77-52755d5c9b88" TYPE="ext4" PARTUUID="978a4b9b-01"
    /dev/sdb1: LABEL="ooo-quickstart" UUID="ef48e45e-0d56-46fe-8735-9077adea9056" TYPE="ext4" PARTUUID="6e39c5ae-01"

Now copy the image to the USB key.

**Note:** loopback mounts will also work if you do not have a key.

   dd if=ooo-usbkey.img of=/dev/sdb

Once the image has been copied to the USB key, plug the key into your test machine.

**Note:** The TripleO USB key requires a non-root user with `sudo` access.

If your test machine did not auto mount the USB key, run the following commands:

    [foo@localhost ~]$ pwd
    /home/foo

    mkdir mount
    sudo mount /dev/sdb1 mount

Let's see what is on the key before running:

    [foo@localhost mount]$ ls
    ansible_env  README.md  RUN_ME.sh  tripleo-quickstart  undercloud.qcow2  undercloud.qcow2.md5  USBKEY_README.txt

Now let's install:

    bash RUN_ME.sh

You should see the following.

**Note:** The invocation of `quickstart.sh` is only a simple example.

    [foo@localhost mount]$ bash RUN_ME.sh 
    ~/mount/tripleo-quickstart ~/mount
    ===================================================================
    Installing Dependencies
    NOTICE: installing dependencies
    Loaded plugins: priorities, product-id, search-disabled-repos, subscription-manager
    This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    Package git-1.8.3.1-6.el7_2.1.x86_64 already installed and latest version
    Package python-virtualenv-1.10.1-2.el7.noarch already installed and latest version
    Package gcc-4.8.5-4.el7.x86_64 already installed and latest version
    Package libyaml-0.1.4-11.el7_0.x86_64 already installed and latest version
    Package libselinux-python-2.2.2-6.el7.x86_64 already installed and latest version
    Package libffi-devel-3.0.13-16.el7.x86_64 already installed and latest version
    Package 1:openssl-devel-1.0.1e-51.el7_2.5.x86_64 already installed and latest version
    Nothing to do
    ===================================================================
    Running tripelo-quickstart in 15 seconds w/ the following command

    See https://github.com/openstack/tripleo-quickstart for the latest
    documenation and source code
    ===================================================================

    bash quickstart.sh --requirements ci-scripts/usbkey/usb_requirements.txt --playbook quickstart-usb.yml --extra-vars image_cache_dir=/home/foo --extra-vars undercloud_image_url=file:///home/foo/mount/undercloud.qcow2 localhost

## Beyond the basics

You can customize the command and run it without the `RUN_ME.sh` script. For instance, you may want use the very latest OpenStack images available for Mitaka.

Simply remove the option `-extra-vars undercloud_image_url=file:///home/foo/mount/undercloud.qcow2` and tripleo-quickstart will download the very latest verified images.

    cd tripleo-quickstart
    bash quickstart.sh --requirements ci-scripts/usbkey/usb_requirements.txt --playbook quickstart-usb.yml --extra-vars image_cache_dir=/home/foo   localhost

If you would like to have tripleo-quickstart deploy your overcloud and validate automatically, simply add `--tags all`.

    cd tripleo-quickstart
    bash quickstart.sh --tags all --requirements ci-scripts/usbkey/usb_requirements.txt --playbook quickstart-usb.yml --extra-vars image_cache_dir=/home/foo   localhost

Thanks for reading through this and we hope you are successful with your deployments! We will be updating the image from time to time, so be on the look out for the Newton version.
