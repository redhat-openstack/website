---
title: 2015-03-18-instack-based-deployment-flow
authors: jcoufal
wiki_title: RDO-Manager/user-guides/2015-03-18-instack-based-deployment-flow
wiki_revision_count: 17
wiki_last_updated: 2015-03-19
---

# 2015-03-18-instack-based-deployment-flow

<div class="row">
<div class="offset1 span10">
## March 18, 2015 - Instack Based Deployment Flow

<hr style="margin-top: -8px"/>
*   Following flow is **pinned** to certain date (2015-03-18)
*   Flow is based on [Instack scripts](https://repos.fedorapeople.org/repos/openstack-m/instack-undercloud/html/index.html) to that date
    -   Source documentation is being updated to follow the latest code, therefor **this flow might diverge from the source docs** in time
*   This flow should be working in time as long as enabled repositories stay pinned to certain package builds (in this guide we are pointing to these builds)

<!-- -->

*   Supported Environments: **Virtual**

<!-- -->

*   Supported Distributions: **RHEL 7.1**, **CentOS 7**
*   Code specific for the distributions is having [RHEL] or [CentOS] tags

## Select Your Operating System

<hr style="margin-top: -8px"/>
There is a slightly different workflow to ensure that your host machine is set up correctly to proceed with the following steps. You should choose one of the supported operating systems and execute the commands listed for that Operating System, ignoring the other Operating Systems. For any section NOT tagged, this should work identically regardless of your Operating System.'

## Preparing Virtual Environment

<hr style="margin-top: -8px"/>
Operations in this sections are performed on hosting bare metal machine.

We encourage to use a machine which you can fully dedicate to RDO-Manager because during virtual setup Instack will enable multiple repositories and manipulate with your libvirt setup.

**\1**

<hr style="margin-top: 0"/>
[CentOS]

    # provision your host machine with CentOS 7

    if $(grep -Eqs 'CentOS Linux release 7' /etc/redhat-release); then
        echo "Environment is set to use CentOS 7 specific commands."
    else
        echo "CentOS 7 is NOT your operating system."
    fi

[RHEL]

    # provision your host machine with RHEL 7.1

    if $(grep -Eqs 'Red Hat Enterprise Linux' /etc/redhat-release) && $(grep -Eqs 'release 7.1' /etc/redhat-release); then
        echo "Environment is set to use RHEL 7.1 specific commands."

        # register your machine and subscribe it to pool (enter credentials for username, password and pool)
        sudo subscription-manager register --username=$rh_user_name --password=$rh_password
        sudo subscription-manager attach --pool=$rh_pool_id
        # sudo subscription-manager repos --list   # make sure you have repositories available
    else
        echo "RHEL 7.1 is NOT your operating system. Commands were not executed."
    fi

**\1**

<hr style="margin-top: 0"/>
    sudo useradd stack
    sudo passwd stack  # specify a password

    echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
    sudo chmod 0440 /etc/sudoers.d/stack

    su - stack

**\1**

<hr style="margin-top: 0"/>
    export DELOREAN_REPO=${DELOREAN_REPO:-"http://104.130.230.24/centos70/4a/1d/4a1d1169acdf6b63239b60a898a33caf428acb5c_291a4aa4/delorean.repo"}
    sudo curl -o /etc/yum.repos.d/delorean.repo $DELOREAN_REPO

    export DELOREAN_RHEL7_REPO=${DELOREAN_RHEL7_REPO:-"http://trunk-mgt.rdoproject.org/repos/79/9c/799cbe5c677af79643fbed96fe62c814d913e3f5_45568b15/delorean.repo"}
    sudo curl -o /etc/yum.repos.d/delorean-rdo-management.repo $DELOREAN_RHEL7_REPO
    sudo sed -i 's/delorean/delorean-rdo-management/' /etc/yum.repos.d/delorean-rdo-management.repo

    if ! rpm -q rdo-release; then
      sudo yum install -y https://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo-0.noarch.rpm
    fi

    if ! rpm -q epel-release; then
      sudo yum install -y http://mirrors.einstein.yu.edu/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    fi

    if ! rpm -q python-zope-interface; then
      sudo yum install -y http://mirrors.kernel.org/fedora//releases/20/Everything/x86_64/os/Packages/p/python-zope-interface-4.0.5-2.fc20.x86_64.rpm
    fi

    sudo yum install -y openstack-heat-templates
    sudo yum install -y openstack-tripleo-puppet-elements

[RHEL] - add on top of above listed repositories

    # for RHEL enable extra repositories from subscription-manager on top of above listed repositories

    if $(grep -Eqs 'Red Hat Enterprise Linux Server release 7.1' /etc/redhat-release); then
        sudo subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-optional-rpms --enable=rhel-7-server-extras-rpms
    elif $(grep -Eqs 'Red Hat Enterprise Linux Workstation release 7.1' /etc/redhat-release); then
        sudo subscription-manager repos --enable=rhel-7-workstation-rpms --enable=rhel-7-workstation-optional-rpms --enable=rhel-7-workstation-extras-rpms
    else
        echo "RHEL 7.1 is NOT your operating system. Commands were not executed."
    fi

**\1**

<hr style="margin-top: 0"/>
    sudo yum install -y instack-undercloud

**\1**

<hr style="margin-top: 0"/>
[CentOS]

    if $(grep -Eqs 'CentOS Linux release 7' /etc/redhat-release); then
        # use in case of cloud based image
        # a web server containing the CentOS guest cloud image
        export DIB_CLOUD_IMAGES="http://cloud.centos.org/centos/7/images/"
        export BASE_IMAGE_FILE=CentOS-7-x86_64-GenericCloud.qcow2

        # use in case when you download image manually
        # download and use images locally (need to be saved in /home/stack/)
        # curl -O http://...   # OR #   'scp ...'
        # export DIB_LOCAL_IMAGE=CentOS-7-x86_64-GenericCloud.qcow2   # or the image name you have downloaded

        # select image distribution
        export NODE_DIST="centos7"
    else
        echo "CentOS 7 is NOT your operating system. Commands were not executed."
    fi

[RHEL]

    if $(grep -Eqs 'Red Hat Enterprise Linux' /etc/redhat-release) && $(grep -Eqs 'release 7.1' /etc/redhat-release); then
        # use in case of cloud based image
        # a web server containing the RHEL guest cloud image
        # export DIB_CLOUD_IMAGES="<http://server/path/containing/image>"
        # export BASE_IMAGE_FILE=<image_name.qcow2>

        # use in case when you download image manually
        # download and use images locally (need to be saved in /home/stack/), image can be downloaded from Red Hat portal
        # curl -O http://...   # OR #   'scp ...'
        export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150224.0.x86_64.qcow2   # or the image name you have downloaded

        # select image distribution and registration method
        export NODE_DIST="rhel7"
        export REG_METHOD=portal

        # find this with `subscription-manager list --available` (enter credentials)
        export REG_USER="<user_name>"
        export REG_PASSWORD="<password>"
        export REG_POOL_ID="<pool_id>"
        export REG_REPOS="rhel-7-server-rpms rhel-7-server-extras-rpms rhel-ha-for-rhel-7-server-rpms rhel-7-server-optional-rpms rhel-7-server-openstack-6.0-rpms"
        export REG_HALT_UNREGISTER=1
    else
        echo "RHEL 7.1 is NOT your operating system. Commands were not executed."
    fi

**\1**

<hr style="margin-top: 0"/>
    export UNDERCLOUD_VM_NAME="rdo_manager"
    export UNDERCLOUD_NODE_MEM=4096
    export UNDERCLOUD_NODE_CPU=1

    export NODE_COUNT=2
    export NODE_MEM=4096
    export NODE_CPU=1

**\1**

<hr style="margin-top: 0"/>
    instack-virt-setup

    # if above script fails with KVM permission denied then
    sudo chgrp kvm /dev/kvm
    sudo chmod g+rw /dev/kvm
    sudo virsh start rdo_manager

## Stand up RDO-Manager (Undercloud)

<hr style="margin-top: -8px"/>
**\1**

<hr style="margin-top: 0"/>
    ssh root@<instack-vm-ip>
    # you can get the IP with 'arp -n' command

**\1**

<hr style="margin-top: 0"/>
    su - stack

**\1**

<hr style="margin-top: 0"/>
    export DELOREAN_REPO=${DELOREAN_REPO:-"http://104.130.230.24/centos70/4a/1d/4a1d1169acdf6b63239b60a898a33caf428acb5c_291a4aa4/delorean.repo"}
    sudo curl -o /etc/yum.repos.d/delorean.repo $DELOREAN_REPO

    export DELOREAN_RHEL7_REPO=${DELOREAN_RHEL7_REPO:-"http://trunk-mgt.rdoproject.org/repos/79/9c/799cbe5c677af79643fbed96fe62c814d913e3f5_45568b15/delorean.repo"}
    sudo curl -o /etc/yum.repos.d/delorean-rdo-management.repo $DELOREAN_RHEL7_REPO
    sudo sed -i 's/delorean/delorean-rdo-management/' /etc/yum.repos.d/delorean-rdo-management.repo

    if ! rpm -q rdo-release; then
      sudo yum install -y https://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo-0.noarch.rpm
    fi

    if ! rpm -q epel-release; then
      sudo yum install -y http://mirrors.einstein.yu.edu/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    fi

    if ! rpm -q python-zope-interface; then
      sudo yum install -y http://mirrors.kernel.org/fedora//releases/20/Everything/x86_64/os/Packages/p/python-zope-interface-4.0.5-2.fc20.x86_64.rpm
    fi

    sudo yum install -y openstack-heat-templates
    sudo yum install -y openstack-tripleo-puppet-elements

**\1**

<hr style="margin-top: 0"/>
    sudo yum install -y instack-undercloud

**\1**

<hr style="margin-top: 0"/>
    cp /usr/share/instack-undercloud/instack.answers.sample ~/instack.answers

**\1**

<hr style="margin-top: 0"/>
    instack-install-undercloud

**\1**

<hr style="margin-top: 0"/>
    sudo cp /root/tripleo-undercloud-passwords .
    sudo cp /root/stackrc .

## Use RDO-Manager for Deploying RDO (Overcloud)

<hr style="margin-top: -8px"/>
**\1**

<hr style="margin-top: 0"/>
    source stackrc

**\1**

<hr style="margin-top: 0"/>
[CentOS]

    if $(grep -Eqs 'CentOS Linux release 7' /etc/redhat-release); then
        # use in case of cloud based image
        # a web server containing the CentOS guest cloud image
        export DIB_CLOUD_IMAGES="http://cloud.centos.org/centos/7/images/"
        export BASE_IMAGE_FILE=CentOS-7-x86_64-GenericCloud.qcow2

        # use in case when you download image manually
        # download and use images locally (need to be saved in /home/stack/)
        # curl -O http://...   # OR #   'scp ...'
        # export DIB_LOCAL_IMAGE=CentOS-7-x86_64-GenericCloud.qcow2   # or the image name you have downloaded

        # select image distribution
        export NODE_DIST="centos7"
    else
        echo "CentOS 7 is NOT your operating system. Commands were not executed."
    fi

[RHEL]

    if $(grep -Eqs 'Red Hat Enterprise Linux' /etc/redhat-release) && $(grep -Eqs 'release 7.1' /etc/redhat-release); then
        # use in case of cloud based image
        # a web server containing the RHEL guest cloud image
        # export DIB_CLOUD_IMAGES="<http://server/path/containing/image>"
        # export BASE_IMAGE_FILE=<image_name.qcow2>

        # use in case when you download image manually
        # download and use images locally (need to be saved in /home/stack/), image can be downloaded from Red Hat portal
        # curl -O http://...   # OR #   'scp ...'
        export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150224.0.x86_64.qcow2   # or the image name you have downloaded

        # select image distribution and registration method
        export NODE_DIST="rhel7"
        export REG_METHOD=portal

        # find this with `subscription-manager list --available` (enter credentials)
        export REG_USER="<user_name>"
        export REG_PASSWORD="<password>"
        export REG_POOL_ID="<pool_id>"
        export REG_REPOS="rhel-7-server-rpms rhel-7-server-extras-rpms rhel-ha-for-rhel-7-server-rpms rhel-7-server-optional-rpms rhel-7-server-openstack-6.0-rpms"
        export REG_HALT_UNREGISTER=1
    else
        echo "RHEL 7.1 is NOT your operating system. Commands were not executed."
    fi

**\1**

<hr style="margin-top: 0"/>
    instack-build-images

**\1**

<hr style="margin-top: 0"/>
    instack-prepare-for-overcloud

**\1**

<hr style="margin-top: 0"/>
    instack-ironic-deployment --nodes-json instackenv.json --register-nodes

**\1**

<hr style="margin-top: 0"/>
    instack-ironic-deployment --discover-nodes
    instack-ironic-deployment --show-profile

**\1**

<hr style="margin-top: 0"/>
    instack-ironic-deployment --setup-flavors

**\1**

<hr style="margin-top: 0"/>
    # source proper network settings for virtual environment
    source /usr/share/instack-undercloud/deploy-virt-overcloudrc

    # deploy
    instack-deploy-overcloud

## Test Overcloud

<hr style="margin-top: -8px"/>
    # download testing image (Fedora) and add path to variables
    curl -O https://repos.fedorapeople.org/repos/openstack-m/tripleo-images-rdo-juno/fedora-user.qcow2
    export IMAGE_PATH=/home/stack/

    # launch instack testing script
    instack-test-overcloud

</div>
</div>
