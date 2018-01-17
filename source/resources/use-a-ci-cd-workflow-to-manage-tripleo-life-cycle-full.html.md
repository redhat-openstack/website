---
title: Use a CI/CD workflow to manage TripleO life cycle
author: Nicolas Hicher
tags: openstack, rdo, tripleo, software-factory
date: 2017-03-01 15:18:31 EST
---

In this post, I will present how to use a CI/CD workflow to manage TripleO deployment life cycle within an OpenStack tenant.

The goal is to use Software-Factory to submit reviews to create or update a TripleO deployment. The review process ensure peers validation before executing the deployment or update command. The deployment will be done within Openstack tenants. We will split each roles in a different tenant to ensure network isolation between services.

![](/images/sf-project.png)

## Tools

### Software Factory

[Software Factory](https://github.com/redhat-cip/software-factory) (also called SF) is a collection of services that provides a powerful platform to build software.

The main advantages of using Software Factory to manage the deployment are:

* Cross-project gating system (through user defined jobs).
* Code-review system to ensure peer validation before changes are merged.
* Reproducible test environment with ephemeral slave

### Python-tripleo-helper

[Python-tripleo-helper](https://github.com/redhat-openstack/python-tripleo-helper) is a library provides a complete Python API to drive an OpenStack deployment (TripleO). It allow to:

* Deploy OpenStack with TripleO within an OpenStack tenant
* Can deploy a virtual OpenStack using the baremetal workflow with IPMI commands.

### TripleO

[Tripleo](https://wiki.openstack.org/wiki/TripleO) is a program aimed at installing, upgrading and operating OpenStack clouds using OpenStack's own cloud facilities as the foundations.

## Prepare OpenStack projects

To have a good isolation between each role, we will use 3 different OpenStack projects:

* software-factory: for the software-factory instance.
* sf-slaves: for Nodepool slaves (theses slaves will be used to drive the deployment).
* sf-tripleo: for the tripleo deployment.

For this demo, We will deploy 4 nodes within sf-tripleo project:

* 1 undercloud node
* 1 controller node
* 1 compute node
* 1 bmc node (for controlling virtual machines using IPMI commands)

We will need to create an OpenStack project (tenant) with the following quotas:

* 35GB of ram
* 18 vcpus

The undercloud needs a large flavor with 16G of ram, controller and compute will use the same flavor with 8G of ram.

### Create users and projects

You need an admin account to create the projects and users, we will create 3 projects and 3 users:

    source admin-openrc
    for project in software-factory sf-slaves sf-tripleo; do
        openstack project create $project
        openstack user create --password ${project}-userpass $project
        openstack role add --project $project --user $project _member_
    done

For all users, the password will be $username followed by -userpass

Create an sf-openrc file for software-factory user, containing (replace $OPENSTACK_AUTH_URL with the ip address of your OpenStack):

    cat <<EOF > software-factory-openrc
    export OS_NO_CACHE=True
    export COMPUTE_API_VERSION=1.1
    export OS_USERNAME=software-factory
    export OS_TENANT_NAME=software-factory
    export OS_AUTH_URL=http://$OPENSTACK_AUTH_URL:5000/v2.0/
    export NOVA_VERSION=1.1
    export OS_PASSWORD=software-factory-userpass
    EOF

Create sf-tripleo-openrc and sf-slaves-openrc

    cp sf-openrc sf-slaves-openrc
    cp sf-openrc sf-tripleo-openrc
    sed -i 's/software-factory/sf-slaves/g' sf-slaves-openrc
    sed -i 's/software-factory/sf-tripleo/g' sf-tripleo-openrc

for sf-tripleo-openrc, you need to add OS_TENANT_ID value to tripleo-openrc file, you can get the project id with the following command:

    source admin-openrc
    openstack project show sf-tripleo -f value -c id

We will need an ssh keys to get access to software-factory instance:

        source software-factory-openrc
        openstack keypair create sf-key > sf-key.pem
        chmod 600 sf-key.pem

### Setup Networking for sf-slaves

#### Project sf-slaves

For this project, we will  create network, subnet and router and open port 22 for ssh access

    source sf-slaves-openrc
    openstack network create private
    openstack subnet create --subnet-range 192.168.10.0/24 --network private --dns-nameserver 8.8.8.8 private
    openstack router create router
    openstack router set router --external-gateway $public_network
    openstack router add subnet router private
    openstack security group rule create --proto tcp --dst-port 22:22 --remote-ip 0.0.0.0/0 default

## Software Factory

### Install Software Factory

The first thing to do is to download and upload Software Factory image in the software-factory project (you can find the last image link on  [software factory github](https://github.com/redhat-cip/software-factory)

    curl -O http://46.231.132.68:8080/v1/AUTH_b50e80d3969f441a8b7b1fe831003e0a/sf-images/softwarefactory-C7.0-2.3.0.img.qcow2
    openstack image create --disk-format qcow2 --container-format bare --file softwarefactory-C7.0-2.3.0.img.qcow2 sf-2.3.0

We will also download a CentOS image used to build the Nodepool slaves, let's download and upload this image in the sf-slaves project:

    source sf-slaves-openrc
    curl -O http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
    openstack image create --disk-format qcow2 --container-format bare --file ~/CentOS-7-x86_64-GenericCloud.qcow2 centos7-cloud

We can now deploy Software Factory using heat templates ([documentation](https://softwarefactory-project.io/docs/operator/deployment.html?highlight=deploy#deploying-with-heat))

    image_id=$(openstack image show sf-2.3.0 -f value -c id)
    key_name="sf-key"
    domain="sftests.com"
    # for domain, on this openstack, the public network name is public
    network_id=$(openstack network show public -f value -c id)
    wget http://46.231.132.68:8080/v1/AUTH_b50e80d3969f441a8b7b1fe831003e0a/sf-images/softwarefactory-C7.0-2.3.0-allinone.hot
    heat stack-create --template-file ./softwarefactory-C7.0-2.3.0-allinone.hot -P "key_name=$key_name;domain=$domain;image_id=$image_id;external_network=$network_id" sf_stack

You have to wait until the stack is available, check the status until the stack is created:

    openstack stack list
    +--------------------------------------+------------+--------------------+----------------------+--------------+
    | ID                                   | Stack Name | Stack Status       | Creation Time        | Updated Time |
    +--------------------------------------+------------+--------------------+----------------------+--------------+
    | dbe7650d-b32d-48f9-af30-da8019ce30d4 | sf_stack   | CREATE_IN_PROGRESS | 2017-02-16T19:32:25Z | None         |
    +--------------------------------------+------------+--------------------+----------------------+--------------+

You can find the public ip for software factory instance using:

    openstack server list
    +--------------------------------------+----------------------+--------+-------------------------------------------------------------+------------+
    | ID                                   | Name                 | Status | Networks                                                    | Image Name |
    +--------------------------------------+----------------------+--------+-------------------------------------------------------------+------------+
    | 50a2ba0e-65cf-4e3e-911f-9f3c24eb357e | managesf.sftests.com | ACTIVE | sf_stack-sf_net-3ibiqr3iqwmh=192.168.240.5, $public_ip      |            |
    +--------------------------------------+----------------------+--------+-------------------------------------------------------------+------------+

For future ease of use, we will add an entry to /etc/hosts with our domain:

    echo "$public_ip sftests.com" | sudo  tee -a /etc/hosts

We can now connect to our instance using the previously generated ssh key

    $ ssh -i sf-key.pem root@sftests.com
    Role softwarefactory
    Version C7.0-2.3.0

    [centos@managesf ~]$

Congrats, you can now configure your sf instance

### Configure Software Factory

The first thing is to edit /etc/software-factory/sfconfig.yaml. In this configuration file, we will set the nodepool parameters to join sf-slaves tenant and change the fqdn if needed. You have to change the admin password too.

Here the configuration I used to configure nodepool (don't forget to change the $OPENSTACK_AUTH_URL)

        nodepool:
              disabled: False
              providers:
                - name: default
                  auth_url: http://$OPENSTACK_AUTH_URL:5000/v2.0/
                  project_id: sf-slaves
                  username: sf-slaves
                  password: sf-slaves-userpass
                  max_servers: 2

We will disable oauth2 auth for github, google and openid to use local user in /etc/software-factory/sfconfig.yaml

The next thing to do is to edit /etc/software-factory/arch.yaml, we will use a minimal arch, use this arch:

	description: "Minimal Software Factory deployment"
	inventory:
	  - name: managesf
	    ip: 192.168.240.5
	    roles:
	      - install-server
	      - mysql
	      - gateway
	      - cauth
	      - managesf
	      - gerrit
	      - zuul
	      - jenkins
	      - nodepool
	    mem: 8
	    cpu: 4
	    disk: 20

It's now time to run the installation script, simply execute the following command:

    sfconfig.sh

The script will configure all the services defined in arch.yaml. With the minimal architecture, it should take only few minutes to have a functional deployment

Now we have a functional software factory deployed. You can connect to the dashboard opening https://sftests.com in your browser and use the admin login/password (use toggle login form for local user)

![](/images/sf-login_page.png)


The next thing to do is to create your user, use sfmanager to manage user and membership. You will need to have an ssh keypair to be able to summit review on sftests.com. If you don't have a keypair, you have to create [one](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/). Copy your public key on the software factory instance:

    rsync -a ~/.ssh/id_rsa.pub sftests.com:/tmp/

Your are now ready to create your user:

    sfmanager user create --username nhicher --password superpass123 \
    --email nhicher@123.com --fullname "Nicolas Hicher" --ssh-key /tmp/id_rsa.pub
    +----------+----------------+--------------------+
    | Username |    Fullname    |       Email        |
    +----------+----------------+--------------------+
    | nhicher  | Nicolas Hicher |  nhicher@123.com   |
    +----------+----------------+--------------------+

Connect to sftests.com with your user, open https://sftests.com/r/#/settings/ssh-keys to sync your gerrit account.

### Setup nodepool slaves

To configure a project on Software Factory, we have to use the config repository. Everything is define in this repository. As we use the default configuration, Software Factory is configured with a self-signed certificate, so we have to use the following commands to clone the repository:

    export GIT_SSL_NO_VERIFY=1
    git clone https://sftests.com/r/config
    cd config

The first thing to do is to add your user in resources/resources.yaml config file, after the review will be merge, you will be able to validate config repository reviews:

    ...
    groups:
      config-ptl:
        description: Team lead for the config repo
        members:
          - admin@sftests.com
          - nhicher@123.com
      ...

Now, we will configure nodepool. We already add a centos image to the sf-slave tenant. We will use this image as a base image to build our slave image. This image will be used by nodepool to build our slave instances. Edit nodepool/images.yaml and define our image parameters:

    - provider: default
      images:
           - name: centos7
             base-image: centos7-cloud
             username: centos
             private-key: /var/lib/jenkins/.ssh/id_rsa
             setup: bare_centos_setup.sh
             min-ram: 4096

We need to have a custom build script to modify /etc/hosts to add the address of our Software Factory instance, create a file "nodepool/bare_centos_setup.sh" with this content (you have to replace $public_ip with the software factory instance public ip):

    #!/bin/bash

    . base.sh

    # add sftests.com in /etc/hosts
    echo "$public_ip sftests.com" |  sudo tee --append /etc/hosts

    # sync FS, otherwise there are 0-byte sized files from the yum/pip installations
    sudo sync
    sudo sync

    echo "SUCCESS: bare-centos-7 done."

Now we can edit nodepool/labels.yaml to define the label used by nodepool to spawn the slave instances:

    labels:
      - name: tripleo-centos7-slave
        image: centos7
        min-ready: 2
        providers:
          - name: default

We have a last modification to do, the base.sh script is not functional in 2.3.0, we need to add a package to install zuul:

    sed -i 's/python-magic/python-magic pytz/' nodepool/base.sh

And that's it finish. Now we will summit our first review with these changes:

    git add -A
    git commit -am 'configure nodepool'
    git review

The next point will be to approve the review to apply the modification. On your browser, open https://sftests.com/, use the admin account (use toolge login form, the admin password is define on /etc/software-factory/sfconfig.yaml if you didn't change it), go on the gerrit view and choose the review "configure nodepool". You have to validate the review, select reply and add +2 for Code-review and +1 for Workflow to merge the modification

![](/images/sf-gerrit.png)

When the review is merged, nodepool starts to build the tripleo-centos7-slave using bare_centos_setup.sh script:

    [root@managesf ~]# nodepool -l image-list
    +----+----------+---------+-----------------------------+------------+----------+--------------------------------------+----------+-------------+
    | ID | Provider | Image   | Hostname                    | Version    | Image ID | Server ID                            | State    | Age         |
    +----+----------+---------+-----------------------------+------------+----------+--------------------------------------+----------+-------------+
    | 1  | default  | centos7 | template-centos7-1486669346 | 1486669346 | None     | 066a12c8-1243-4fff-a5d6-69285e7630fe | building | 00:00:03:46 |
    +----+----------+---------+-----------------------------+------------+----------+--------------------------------------+----------+-------------+

You can follow the build process in /var/log/nodepool/image.log

Do not forget to update your git tree in your local config repository directory after the review is merged:

    git pull

After building the image, nodepool will start 2 slaves, these slaves will be used later when we submit a review for our deployment project:

    [root@managesf ~]# nodepool -l /etc/nodepool/logging.conf list
    +----+----------+------+-----------------------+---------+---------+---------------------------------+---------------------------------+--------------------------------------+----------------+-------+-------------+
    | ID | Provider | AZ   | Label                 | Target  | Manager | Hostname                        | NodeName                        | Server ID                            | IP             | State | Age         |
    +----+----------+------+-----------------------+---------+---------+---------------------------------+---------------------------------+--------------------------------------+----------------+-------+-------------+
    | 1  | default  | None | tripleo-centos7-slave | default | None    | tripleo-centos7-slave-default-1 | tripleo-centos7-slave-default-1 | 1db20714-5a53-4dce-b9b1-6e9830022774 | 198.154.189.65 | ready | 00:00:02:26 |
    | 2  | default  | None | tripleo-centos7-slave | default | None    | tripleo-centos7-slave-default-2 | tripleo-centos7-slave-default-2 | eca39fb9-a852-4412-9a37-076fbfa61ee8 | 198.154.189.63 | ready | 00:00:02:58 |
    +----+----------+------+-----------------------+---------+---------+---------------------------------+---------------------------------+--------------------------------------+----------------+-------+-------------+
    [root@managesf ~]#

## Demo-sf-triple project

### Create the project within software factory

Now we have to add some credential in jenkins, these credentials will be used during the deployment to get access to the sf-tripleo tenant (via sf-tripleo-openrc), we also need to create an ssh key to allow the jenkins user to connect to the undercloud to execute deployment commands. Start by creating an ssh keypair for the tenant:

    source sf-tripleo-openrc
    openstack keypair create sf-tripleo > sf-tripleo.pem
    chmod 600 sf-tripleo.pem

We need to add sf-tripleo.pem and sf-tripleo-openrc as credentials in Jenkins, connect to https://sftests.com with the admin account and go to https://YOURDOMAIN/jenkins/credential-store/domain/\_/.
* add the ssh private key sf-tripleo.pem: "kind: secret file"
* add the sf-tripleo-openrc file: "kind: secret file"

You need to get the **credential-id** for each resource, select your credential, the credential id is part of the url (screenshot), these credentials will be used in the job definition. There will be copy on the slave during the job execution.

![](/images/sf-credential_id.png)

We have a Software Factory instance and a nodepool project with 2 slaves, it's now time to create demo-sf-tripleo project. We will use the new management system via the config repository ([documentation](https://softwarefactory-project.io/docs/user/index.html)). In the config directory, create resources/demo-tripleo.yaml with the following content:

    # resources/demo-tripleo.yaml
	resources:
	  projects:
	    demo-sf-tripleo:
	      description: Demo TripleO life cycle project
	      contacts:
	        - nhicher@123.com
	      source-repositories:
	        - demo-sf-tripleo
	  repos:
	    demo-sf-tripleo:
	      description: Demo TripleO life cycle repository
	      acl: demo-sf-tripleo-dev-acl
	  acls:
	    demo-sf-tripleo-dev-acl:
	      file: |
	        [access "refs/*"]
	          read = group demo-sf-tripleo-core
	          owner = group demo-sf-tripleo-ptl
	        [access "refs/heads/*"]
	          label-Code-Review = -2..+2 group demo-sf-tripleo-core
	          label-Code-Review = -2..+2 group demo-sf-tripleo-ptl
	          label-Verified = -2..+2 group demo-sf-tripleo-ptl
	          label-Workflow = -1..+1 group demo-sf-tripleo-core
	          label-Workflow = -1..+1 group demo-sf-tripleo-ptl
	          label-Workflow = -1..+0 group Registered Users
	          submit = group demo-sf-tripleo-ptl
	          read = group demo-sf-tripleo-core
	          read = group Registered Users
	        [access "refs/meta/config"]
	          read = group demo-sf-tripleo-core
	          read = group Registered Users
	        [receive]
	          requireChangeId = true
	        [submit]
	          mergeContent = false
	          action = fast forward only
	      groups:
	        - demo-sf-tripleo-ptl
	        - demo-sf-tripleo-core
	  groups:
	    demo-sf-tripleo-ptl:
	      members: []
	      description: Project Techincal Leaders of demo-sf-tripleo-cloud
	    demo-sf-tripleo-core:
	      members:
	        - nhicher@123.com
	      description: Project Core of demo-sf-tripleo-cloud

You have now to summit the review:
    git add -A
    git commit -am 'create demo-sf-tripleo project'
    git review

As before, go to https://sftests.com to validate and merge the review, it's now possible to use your user account instead the admin's account.

It's time to create our job, in config repository directory, create a file jobs/tripleo.yaml and add the following content (do not forget to replace $credential-id-ssh-key and $credential-id-openrc with the right id grabbed from the jenkins UI):

    - project:
        name: demo-sf-tripleo
        jobs:
          - '{name}-unit-tests'
          - 'deploy'
        node: tripleo-centos7-slave

    - job:
        name: 'deploy'
        defaults: global
        builders:
          - prepare-workspace
          - shell: |
              cd $ZUUL_PROJECT
              cp ${OPENRC} openrc
              cp ${SSH_PRIV} ~/.ssh/id_rsa
              chmod 600 ~/.ssh/id_rsa
              ./ovb-deploy.sh
        wrappers:
          - credentials-binding:
              - file:
                  credential-id: $credential-id-openrc
                  variable: OPENRC
              - file:
                  credential-id: $credential-id-ssh-key
                  variable: SSH_PRIV
        triggers:
          - zuul
        node: tripleo-centos7-slave

In this file we create a project named demo-sf-tripleo. We define 2 jobs for our project, the first one is a default job (it will run run_tests.sh that we will create in our project repository), the second one is a custom job we define later on the file). With the last statement, we specify the node (label) used to run the jobs.

In the second part, we define the custom **deploy** job ([job documentation](https://softwarefactory-project.io/docs/project_config/jenkins_user.html)).


Now, we will create a file, zuul/tripleo.yaml with this content to define which job will be executed by each pipeline ([pipelines documentation](https://softwarefactory-project.io/docs/project_config/zuul_user.html#pipelines-default-configuration)).

    projects:
      - name: demo-sf-tripleo
        check:
          - demo-sf-tripleo-unit-tests
        gate:
          - deploy

Now, we have to  summit a review with our changes

    git add -A
    git commit -m 'add demo-sf-tripleo project configuration for zuul en jenkins'
    git review

As before, go to https://sftests.com to validate and merge the review.

### Configure the network and security group for sf-tripleo project

Create a security group to allow the incoming SSH connections::

    openstack security group create ssh --description "SSH"
    openstack security group rule create --proto tcp --dst-port 22:22 --remote-ip 0.0.0.0/0 ssh

Create a private the network

    source sf-tripleo-openrc
    openstack network create private
    openstack subnet create --subnet-range 192.168.1.0/24 --network private --dns-nameserver 8.8.8.8 private
    openstack router create router
    openstack router set router --external-gateway $public_network
    openstack router add subnet router private
    openstack security group rule create --proto tcp --dst-port 22:22 --remote-ip 0.0.0.0/0 default

Create two floating IP:

    neutron floatingip-create $public_network
    neutron floatingip-create $public_network

### Get images for the deployment

Now, we have to install 2 images, the first one ipxe.usb will be used by python-tripleo-helper to start the deployment. The second on, centos, will be used to install the undercloud:

    source sf-slaves-openrc
    curl -O http://boot.ipxe.org/ipxe.usb
    curl -O http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
    openstack image create --disk-format qcow2 --container-format bare --file ipxe.usb ipxe.usb
    openstack image create --disk-format qcow2 --container-format bare --file ~/CentOS-7-x86_64-GenericCloud.qcow2 centos7-cloud

### Check project quotas

You have to ensure you have enough ram and vpcus in your tenant to do the deployment, if not update the tenant quotas:

    source admin-openrc
    tenant=$(openstack project show -f value -c id sf-tripleo)
    nova quota-update --ram 35000 $tenant
    nova quota-update --cores 20 $tenant


### Populate sf-demo-tripleo project

Now, we have to create the files to manage the deployment. We need some files for SF gating system, to configure tripleo-helper and for the tripleo deployment itself.

We start by cloning the demo-sf-tripleo project we previously created:

    export GIT_SSL_NO_VERIFY=1
    git clone https://sftests.com/r/demo-sf-tripleo

#### Software Factory

On software factory side, we need to create 2 files:

* run_tests.sh: will be used by the check job after summitting a review, here we will only check the yaml syntax:

~~~~
#!/bin/bash
export PATH="$HOME/.local/bin/:$PATH"
pip install --user yamllint
exec yamllint .
~~~~

* ovb-deploy.sh: will be run by the gate job after peer validation for the review. This script will install ovb and execute the deployment commands

~~~~
#!/bin/bash
install_python_tripleo_helper() {
    sudo yum install -y python-devel gcc libffi-devel openssl-devel patch
    sudo pip install futures
    sudo pip install --upgrade setuptools
    sudo pip install -U git+https://github.com/redhat-openstack/python-tripleo-helper
    for patch in $(find patches -name '*patch'); do
        sudo patch -d /usr/lib/python2.7/site-packages/tripleohelper/ < $patch
    done
}

install_osp() {
    echo "Install tripleo"
    chainsaw-ovb --config-file tripleohelper_centos.yaml provisioning
    chainsaw-ovb --config-file tripleohelper_centos.yaml undercloud
    chainsaw-ovb --config-file tripleohelper_centos.yaml overcloud
}

update_osp() {
    echo "Update tripleo"
    chainsaw-ovb --config-file tripleohelper_centos.yaml update
}

install_python_tripleo_helper

source openrc

if ! nova list | grep -qE '\bundercloud\b'; then
    install_osp
else
    update_osp
fi
~~~~

#### Python-tripleo-helper

For tripleo-helper, we have to create 3 files. the tripleo-helper configuration file, a yamllint file as we have url longuer than 80 char in our config file, we need to avoid error during the gate job. The last file is a patch to add an update command to python-tripleo-helper.

* tripleohelper_centos.yaml

~~~~
---
config_file: /tmp/tripleo-helper.log
provisioner:
    type: openstack
    image:
        name: CentOS-7.3
    flavor: m1.large
    # undercloud_config: /home/jenkins/workspace/deploy/demo-sf-tripleo/undercloud.conf
    undercloud_flavor: m1.xlarge
    heat_templates_dir: /home/jenkins/workspace/deploy/demo-sf-tripleo/templates
    deployment_file: /home/jenkins/workspace/deploy/demo-sf-tripleo/manage_tripleo.sh
    network: private
    keypair: sf-tripleo
    security-groups:
        - ssh
ssh:
    private_key: /home/jenkins/.ssh/id_rsa

# Extra repository to enable
repositories: &DEFAULT_REPOSITORIES
    - type: yum_repo
      content: |
          [delorean]
          name=delorean-python-networking-arista-16363807c743e6433c30673ff6f14cf939bb0224
          baseurl=https://trunk.rdoproject.org/centos7-newton/16/36/16363807c743e6433c30673ff6f14cf939bb0224_1c58fc02
          enabled=1
          gpgcheck=0
          priority=1
      dest: /etc/yum.repos.d/delorean-newton.repo
    - type: yum_repo
      content: |
          [delorean-newton-testing]
          name=dlrn-newton-testing
          baseurl=http://buildlogs.centos.org/centos/7/cloud/$basearch/openstack-newton/
          enabled=1
          gpgcheck=0

          [delorean-newton-pending]
          name=dlrn-newton-pending
          baseurl=http://cbs.centos.org/repos/cloud7-openstack-common-pending/$basearch/os/
          gpgcheck=0
          enabled=0

          [rdo-qemu-ev]
          name=RDO CentOS-$releasever - QEMU EV
          baseurl=http://mirror.centos.org/centos/7/virt/$basearch/kvm-common/
          gpgcheck=0
          enabled=1
      dest: /etc/yum.repos.d/delorean-deps-newton.repo

undercloud:
    repositories: *DEFAULT_REPOSITORIES
    floating_ip: $FLOATING_IP

overcloud:
    ironic-python-agent:
        image_path: "https://buildlogs.cdn.centos.org/centos/7/cloud/x86_64/tripleo_images/newton/delorean/ironic-python-agent.tar"
    overcloud-full:
        image_path: "https://buildlogs.cdn.centos.org/centos/7/cloud/x86_64/tripleo_images/newton/delorean/overcloud-full.tar"
~~~~

* Yamllint:

~~~~
cat << EOF > .yamllint
---
rules:
  line-length:
      max: 150
      allow-non-breakable-words: yes
      allow-non-breakable-inline-mappings: no
EOF
~~~~

The last thing will be to create a patches directory to add an update command to python tripleo helper, to allow us to update the deployment.

* add_update_cmd_ovb_shell.patch

~~~~
mkdir patches
cat << EOF > patches/add_update_cmd_ovb_shell.patch
--- /usr/lib/python2.7/site-packages/tripleohelper/ovb_shell.py	2016-10-19 19:02:24.000000000 +0000
+++ add_update_cmd_ovb_shell.py	2016-10-19 19:08:37.000000000 +0000
@@ -143,7 +143,7 @@
 @click.option('--config-file', required=True, type=click.File('rb'),
               help="Chainsaw path configuration file.")
 @click.argument('step', nargs=1, required=True,
-                type=click.Choice(['provisioning', 'undercloud', 'overcloud', 'cleanup']))
+                type=click.Choice(['provisioning', 'undercloud', 'overcloud', 'cleanup', 'update']))
 def cli(os_auth_url, os_username, os_password, os_project_id, config_file, step):
     config = yaml.load(config_file)
     logger.setup_logging(config_file=config.get('config_file'))
@@ -294,5 +294,25 @@
         undercloud.ssh_pool.stop_all()
         exit(0)

+    if step == 'update':
+        provisioner = config['provisioner']
+        templates = provisioner.get('heat_templates_dir')
+        undercloud.manage_overcloud_templates(templates)
+
+        deployment_file = provisioner.get('deployment_file')
+        if deployment_file:
+            remote_path = "/home/stack/%s" % os.path.basename(deployment_file)
+            undercloud.send_file(deployment_file, remote_path, user='stack',
+                                 unix_mode=0o755)
+            undercloud.start_overcloud_deploy(deploy_command=remote_path)
+        else:
+            undercloud.start_overcloud_deploy(
+                control_scale=1,
+                compute_scale=1,
+                control_flavor='control',
+                compute_flavor='compute',
+                environments=[
+                    '/home/stack/network-environment.yaml'])
+
 # This is for setuptools entry point.
 main = cli
EOF
~~~~

#### Tripleo

We need 2 files to manage the deployment:

* manage_tripleo.sh contains the deployment command:

~~~
#!/bin/bash
openstack overcloud deploy --templates \
                           --log-file overcloud_deployment.log \
                           --ntp-server north-america.pool.ntp.org \
                           --control-scale 1 \
                           --compute-scale 1 \
                           --ceph-storage-scale 0 \
                           --block-storage-scale 0 \
                           --swift-storage-scale 0 \
                           --control-flavor control \
                           --compute-flavor compute \
                           --ceph-storage-flavor baremetal \
                           --block-storage-flavor baremetal \
                           --swift-storage-flavor baremetal \
                           -e /home/stack/templates/network-environment.yaml
~~~

Here we have a typical deployment command, we specify a template file to use (with the -e option), so we have to create it. We will simply specify a dns server

* templates/network-environment.yaml

~~~
mkdir templates
cat << EOF > templates/network-environment.yaml
parameter_defaults:
   DnsServers: [8.8.8.8]
EOF
~~~

Now prepare and push the review:

    git add -A
    git commit -m 'prepare deployment'
    git review

### Deploy OpenStack

After validating the review, the deployment will start in sf-tripleo tenant. You can follow the job exectution on the jenkins console.

![](/images/sf-deployment.png)

When the job finishes, you can connect to the undercloud:

    source sf-tripleo-openrc
    openstack server show undercloud -c addresses
    +-----------+----------------------------------------------------------------+
    | Field     | Value                                                          |
    +-----------+----------------------------------------------------------------+
    | addresses | provision_bob=192.0.2.240; private=192.168.1.7, $PUBLIC_IP     |
    +-----------+----------------------------------------------------------------+
    ssh -i sf-tripleo.pem stack@$PUBLIC_IP
    Last login: Wed Feb 15 19:08:22 2017

You can source overcloudrc openrc file if you want to interact with the deployed openstack:

    [stack@undercloud ~]$ source overcloudrc
    [stack@undercloud ~]$ openstack ...

### Update Openstack

To update the openstack, you can edit the template file or add another template (update the deployment command), summit a review, validate it. The update command will be applied on the deployed openstack. If you want to do another deployment, you have to delete all the servers within sf-tripleo project, and push a reivew.
