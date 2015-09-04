---
title: Domains
authors: msolberg
wiki_title: Domains
wiki_revision_count: 14
wiki_last_updated: 2014-04-28
---

# Domains

__NOTOC__

''This is a page to collect information on Keystone V3 Domains in RDO ''

## Use Case

### Delegation of Authority

The Cloud Administrator:

*   Creates/Updates/Deletes Domains and Users.
*   Grants/Revokes Roles on Domains.

The Cloud Administrator delegates the following tasks to Domain Administrators:

*   Create/Update/Delete Projects within their Domain
*   Create/Update/Delete Users within their Domain
*   Grant/Revoke Roles on Projects and Domains

The Cloud Administrator also delegates the assignment of resource quotas to Domain Administrators.

## Implementation

*   Install openstack client

<!-- -->

    root@localhost ~]# yum -y install openstack-packstack

*   Download updated policy file

<!-- -->

    [root@localhost ~]# wget https://raw.githubusercontent.com/openstack/keystone/master/etc/policy.v3cloudsample.json  -O /etc/keystone/policy.json
    --2014-04-23 23:00:05--  https://raw.githubusercontent.com/openstack/keystone/master/etc/policy.v3cloudsample.json
    Resolving raw.githubusercontent.com... 199.27.74.133
    Connecting to raw.githubusercontent.com|199.27.74.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 9032 (8.8K) [text/plain]
    Saving to: “/etc/keystone/policy.json”

    100%[======================================>] 9,032       --.-K/s   in 0.02s   

    2014-04-23 23:00:05 (434 KB/s) - “/etc/keystone/policy.json” saved [9032/9032]

*   Change the keystone entries in the service catalog to point to v3 (could/should do this with openstack client instead)

<!-- -->

    [root@localhost ~]# export OS_SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/
    [root@localhost ~]# export OS_SERVICE_TOKEN=`grep ^admin_token /etc/keystone/keystone.conf | awk -F'=' '{print $2}'`
    [root@localhost ~]# keystone service-list | grep keystone
    | 302276e563ad4d61a404e33931be492e |  keystone  |   identity   |   OpenStack Identity Service   |
    [root@localhost ~]# SERVICE_ID=`keystone service-list | grep keystone | awk '{print $2}'`
    [root@localhost ~]# keystone endpoint-list | grep $SERVICE_ID
    | a1ce3a4cca764b35a545fdfb4418fd67 | RegionOne |         http://192.168.0.10:5000/v2.0          |         http://192.168.0.10:5000/v2.0          |       http://192.168.0.10:35357/v2.0      | 302276e563ad4d61a404e33931be492e |
    [root@localhost ~]# keystone endpoint-create --region RegionOne --service-id $SERVICE_ID --publicurl http://192.168.0.10:5000/v3 --internalurl http://192.168.0.10:5000/v3 --adminurl http://192.168.0.10:35357/v3
    [root@localhost ~]# keystone endpoint-list | grep $SERVICE_ID
    | 63105d9244c24bb1af9543072f6d3f94 | RegionOne |          http://192.168.0.10:5000/v3           |          http://192.168.0.10:5000/v3           |        http://192.168.0.10:35357/v3       | 302276e563ad4d61a404e33931be492e |
    | a1ce3a4cca764b35a545fdfb4418fd67 | RegionOne |         http://192.168.0.10:5000/v2.0          |         http://192.168.0.10:5000/v2.0          |       http://192.168.0.10:35357/v2.0      | 302276e563ad4d61a404e33931be492e |
    [root@localhost ~]# keystone endpoint-delete a1ce3a4cca764b35a545fdfb4418fd67
    Endpoint has been deleted.
    [root@localhost ~]# keystone endpoint-list | grep $SERVICE_ID
    | 63105d9244c24bb1af9543072f6d3f94 | RegionOne |          http://192.168.0.10:5000/v3           |          http://192.168.0.10:5000/v3           |        http://192.168.0.10:35357/v3       | 302276e563ad4d61a404e33931be492e |

*   Create the "admin" domain

<!-- -->

    [root@localhost ~]# export OS_URL=http://127.0.0.1:35357/v3
    [root@localhost ~]# export OS_TOKEN=`grep ^admin_token /etc/keystone/keystone.conf | awk -F'=' '{print $2}'`
    [root@localhost ~]# openstack --os-identity-api-version 3 domain create --description "Admin Domain" admin
    +-------------+----------------------------------------------------------------------------------+
    | Field       | Value                                                                            |
    +-------------+----------------------------------------------------------------------------------+
    | description | Admin Domain                                                                     |
    | enabled     | True                                                                             |
    | id          | 24015fdbfc5343b0af5acc802a695c8a                                                 |
    | links       | {u'self': u'http://127.0.0.1:35357/v3/domains/24015fdbfc5343b0af5acc802a695c8a'} |
    | name        | admin                                                                            |
    +-------------+----------------------------------------------------------------------------------+

*   Update default v3 keystone policy with the domain id

<!-- -->

    [root@localhost ~]# export OS_DOMAIN_ID=`openstack --os-identity-api-version 3 domain show admin | grep id | awk '{print $4}'`
    [root@localhost ~]# sed -i "s+admin_domain_id+$OS_DOMAIN_ID+g" /etc/keystone/policy.json

*   Grant the "admin" role to the "admin" user on the "admin" domain

<!-- -->

    [root@localhost ~]# openstack --os-identity-api-version 3 role add --user admin --domain admin admin
    [root@localhost ~]# openstack --os-identity-api-version 3 user list --role --domain admin admin
    +----------------------------------+-------+--------+-------+
    | ID                               | Name  | Domain | User  |
    +----------------------------------+-------+--------+-------+
    | 548386103d43421886b0ab6a1962513a | admin | admin  | admin |
    +----------------------------------+-------+--------+-------+

*   Update the keystonerc_admin file with the new domain scope

<!-- -->

    [root@localhost ~]# cat > ~/keystonerc_admin <<EOF
    > export OS_USERNAME=admin
    > export OS_DOMAIN_NAME=admin
    > export OS_PASSWORD=password
    > export OS_AUTH_URL=http://127.0.0.1:5000/v3/
    > export PS1='[\u@\h \W(keystone_admin)]$ '
    > EOF

## Using Domains

### Create a Domain

    [root@localhost ~]# . ./keystonerc_admin 
    [root@localhost ~(keystone_admin)]$ openstack --os-identity-api-version 3 domain create --description domain01 domain01
    +-------------+-------------------------------------------------------------------------------------+
    | Field       | Value                                                                               |
    +-------------+-------------------------------------------------------------------------------------+
    | description | domain01                                                                            |
    | enabled     | True                                                                                |
    | id          | 6a79d7f2a8ad4654b19eff4688d5eaea                                                    |
    | links       | {u'self': u'http://192.168.0.10:35357/v3/domains/6a79d7f2a8ad4654b19eff4688d5eaea'} |
    | name        | domain01                                                                            |
    +-------------+-------------------------------------------------------------------------------------+

### Delegate control of the Domain to a Domain Admin

    [root@localhost ~]# . ./keystonerc_admin 
    [root@localhost ~(keystone_admin)]$ openstack --os-identity-api-version 3 user create --password password --email 'admin@domain01' --domain domain01 --description 'domain01 admin' domain01_admin
    +-------------+-----------------------------------------------------------------------------------+
    | Field       | Value                                                                             |
    +-------------+-----------------------------------------------------------------------------------+
    | description | domain01 admin                                                                    |
    | domain_id   | 6a79d7f2a8ad4654b19eff4688d5eaea                                                  |
    | email       | admin@domain01                                                                    |
    | enabled     | True                                                                              |
    | id          | 012867a298864c1c95dbcdd3a0e16f07                                                  |
    | links       | {u'self': u'http://192.168.0.10:35357/v3/users/012867a298864c1c95dbcdd3a0e16f07'} |
    | name        | domain01_admin                                                                    |
    +-------------+-----------------------------------------------------------------------------------+
    [root@localhost ~(keystone_admin)]$ openstack --os-identity-api-version 3 role add --user domain01_admin --domain domain01 admin
    [root@localhost ~(keystone_admin)]$ openstack --os-identity-api-version 3 user list --role --domain domain01 domain01_admin
    +----------------------------------+-------+----------+----------------+
    | ID                               | Name  | Domain   | User           |
    +----------------------------------+-------+----------+----------------+
    | 548386103d43421886b0ab6a1962513a | admin | domain01 | domain01_admin |
    +----------------------------------+-------+----------+----------------+

### Create a Project under the Domain as the Domain Admin

    [root@localdomain ~(keystone_admin)]$ cat > keystonerc_domain01_admin <<EOF
    > export OS_USERNAME=domain01_admin
    > export OS_USER_DOMAIN_NAME=domain01
    > export OS_PASSWORD=password
    > export OS_AUTH_URL=http://127.0.0.1:5000/v3/
    > export PS1='[\u@\h \W(keystone_domain01_admin)]$ '
    > EOF
    [root@localdomain ~(keystone_admin)]$ . ./keystonerc_domain01_admin 
    [root@localdomain ~(keystone_domain01_admin)]$ openstack --os-identity-api-version 3 project create --domain domain01 --description "Project 01" project01
    ERROR: cliff.app You are not authorized to perform the requested action, identity:list_domains. (HTTP 403)
    Hrm.

## Open Issues

### Nova

The following blueprint is outstanding for Nova:

*   <https://blueprints.launchpad.net/nova/+spec/domains-nova>

### Quotas

Domain quotas need to be implemented in each of the services:

*   <https://blueprints.launchpad.net/nova/+spec/domain-quota-driver>
*   <https://blueprints.launchpad.net/nova/+spec/domain-quota-driver-api>
*   <https://blueprints.launchpad.net/nova/+spec/domain-quota-driver-v3-api>
*   <https://blueprints.launchpad.net/nova/+spec/domain-quota-manage-commands>
*   <https://blueprints.launchpad.net/neutron/+spec/domain-quota-driver>
*   <https://blueprints.launchpad.net/cinder/+spec/domain-quota-driver>

### Bugs

<https://bugs.launchpad.net/keystone/+bug/1221805>

### Multiple Domain Identifiers

<http://lists.openstack.org/pipermail/openstack-dev/2014-April/032833.html>

### Hierarchical Multitenancy

Another approach is laid out here: <https://blueprints.launchpad.net/keystone/+spec/hierarchical-multitenancy>

## References

*   <https://wiki.openstack.org/wiki/Domains>
*   <http://www.mirantis.com/blog/manage-openstack-projects-using-domains-havana/>
*   <http://adam.younglogic.com/2013/09/keystone-v3-api-examples/>
*   <http://www.madorn.com/keystone-v3-api.html>
