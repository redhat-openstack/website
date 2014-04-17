---
title: Setting-up-HA-of-Keystone
authors: kashyap
wiki_title: Setting-up-HA-of-Keystone
wiki_revision_count: 2
wiki_last_updated: 2014-04-17
---

## Setting-up-HA-of-Keystone

On both nodes of Keystone (rhos4-keystone1|rhos4-keystone2):

    $ yum install -y openstack-keystone openstack-utils openstack-selinux

For the first instance of Keystone (rhos4-keystone1):

    mysql --user=root --password=mysqltest --host=vip-mysql

    CREATE DATABASE keystone;
    GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystonetest';
    FLUSH PRIVILEGES;
    quit

Create the Keystone service token:

    export SERVICE_TOKEN=$(openssl rand -hex 10)
    echo $SERVICE_TOKEN &gt; /srv/rhos/configs/ks_admin_token

On the second instance of Keystone (rhos4-keystone2):

    export SERVICE_TOKEN=$(cat /srv/rhos/configs/ks_admin_token)

On both nodes of Keystone (rhos4-keystone1|rhos4-keystone2), setup `keystone.conf`:

    openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $SERVICE_TOKEN
    openstack-config --set /etc/keystone/keystone.conf sql connection mysql://keystone:keystonetest@vip-mysql/keystone
    openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_endpoint 'http://vip-keystone:%(admin_port)s/'
    openstack-config --set /etc/keystone/keystone.conf DEFAULT public_endpoint 'http://vip-keystone:%(public_port)s/'

On the first Keystone instance (rhos4-keystone1), setup PKI:

    keystone-manage pki_setup --keystone-user keystone --keystone-group keystone
    chown -R keystone:keystone /var/log/keystone    /etc/keystone/ssl/
    su keystone -s /bin/sh -c &quot;keystone-manage db_sync&quot;

    cd /etc/keystone/ssl
    tar cvp -f /srv/rhos/configs/keystone_ssl.tar *

On the second Keystone instance (rhos4-keystone2):

    mkdir -p /etc/keystone/ssl
    cd /etc/keystone/ssl
    tar xvp -f /srv/rhos/configs/keystone_ssl.tar
    chown -R keystone:keystone /var/log/keystone    /etc/keystone/ssl/

On both nodes of Keystone (rhos4-keystone1|rhos4-keystone2), configure pacemaker, and setup Keystone:

    chkconfig pacemaker on
    pcs cluster setup --name rhos4-keystone rhos4-keystone1 rhos4-keystone2
    pcs cluster start

    sleep 30

    pcs stonith create keystone1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rhos4-keystone1

    pcs stonith create keystone2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rhos4-keystone2

    pcs resource create keystone lsb:openstack-keystone --clone

    export SERVICE_ENDPOINT=&quot;http://vip-keystone:35357/v2.0&quot;

    keystone service-create --name=keystone --type=identity --description=&quot;Keystone Identity Service&quot;

    keystone endpoint-create --service keystone --publicurl 'http://vip-keystone:5000/v2.0' --adminurl 'http://vip-keystone:35357/v2.0' --internalurl 'http://vip-keystone:5000/v2.0'

    keystone user-create --name admin --pass keystonetest
    keystone role-create --name admin
    keystone tenant-create --name admin
    keystone user-role-add --user admin --role admin --tenant admin

    cat &gt; /srv/rhos/configs/keystonerc_admin &lt;&lt; EOF
    export OS_USERNAME=admin
    export OS_TENANT_NAME=admin
    export OS_PASSWORD=keystonetest
    export OS_AUTH_URL=http://vip-keystone:35357/v2.0/
    export PS1='[\u@\h \W(keystone_admin)]$ '
    EOF

    keystone user-create --name fabbione --pass fabbionetest
    keystone role-create --name Member
    keystone tenant-create --name TENANT
    keystone user-role-add --user fabbione --role Member --tenant TENANT

    cat &gt; /srv/rhos/configs/keystonerc_user &lt;&lt; EOF
    export OS_USERNAME=fabbione
    export OS_TENANT_NAME=TENANT
    export OS_PASSWORD=fabbionetest
    export OS_AUTH_URL=http://vip-keystone:5000/v2.0/
    export PS1='[\u@\h \W(keystone_user)]$ '
    EOF

    keystone tenant-create --name services --description &quot;Services Tenant&quot;

    # TEST
    . /srv/rhos/configs/keystonerc_user
    keystone token-get
    . /srv/rhos/configs/keystonerc_admin
    keystone user-list
