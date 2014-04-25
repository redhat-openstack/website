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

    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ domain list
    +---------+---------+---------+----------------------------------------------------------------------+
    | ID      | Name    | Enabled | Description                                                          |
    +---------+---------+---------+----------------------------------------------------------------------+
    | default | Default | True    | Owns users and tenants (i.e. projects) available on Identity API v2. |
    +---------+---------+---------+----------------------------------------------------------------------+
    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ domain create Admin
    +---------+----------------------------------------------------------------------------------+
    | Field   | Value                                                                            |
    +---------+----------------------------------------------------------------------------------+
    | enabled | True                                                                             |
    | id      | 73e400376ec0434d9785b5e9ea36e265                                                 |
    | links   | {u'self': u'http://127.0.0.1:35357/v3/domains/73e400376ec0434d9785b5e9ea36e265'} |
    | name    | Admin                                                                            |
    +---------+----------------------------------------------------------------------------------+
    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ domain list
    +----------------------------------+---------+---------+----------------------------------------------------------------------+
    | ID                               | Name    | Enabled | Description                                                          |
    +----------------------------------+---------+---------+----------------------------------------------------------------------+
    | 73e400376ec0434d9785b5e9ea36e265 | Admin   | True    |                                                                      |
    | default                          | Default | True    | Owns users and tenants (i.e. projects) available on Identity API v2. |
    +----------------------------------+---------+---------+----------------------------------------------------------------------+
    [root@localhost ~]# sed -i 's+admin_domain_id+73e400376ec0434d9785b5e9ea36e265+g' /etc/keystone/policy.json

*   Create the cloud_admin user

<!-- -->

    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ user create --domain Admin --password password --description "Cloud Administrator" cloud_admin
    +-------------+--------------------------------------------------------------------------------+
    | Field       | Value                                                                          |
    +-------------+--------------------------------------------------------------------------------+
    | description | Cloud Administrator                                                            |
    | domain_id   | 73e400376ec0434d9785b5e9ea36e265                                               |
    | enabled     | True                                                                           |
    | id          | 298e956fa0b048c2bb5310cf703d83b7                                               |
    | links       | {u'self': u'http://127.0.0.1:35357/v3/users/298e956fa0b048c2bb5310cf703d83b7'} |
    | name        | cloud_admin                                                                    |
    +-------------+--------------------------------------------------------------------------------+
    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ role list
    +----------------------------------+---------------+
    | ID                               | Name          |
    +----------------------------------+---------------+
    | 3bd6c80d3a094073803bac869eb3be34 | SwiftOperator |
    | 548386103d43421886b0ab6a1962513a | admin         |
    | 9fe2ff9ee4384b1894a90878d3e92bab | _member_      |
    | a944477ab7dc416cac48ce43299d5962 | ResellerAdmin |
    +----------------------------------+---------------+
    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ role add --user cloud_admin --domain Admin admin
    [root@localhost ~]# openstack --os-identity-api-version 3 --os-token $OS_SERVICE_TOKEN --os-url http://127.0.0.1:35357/v3/ user list --domain Admin --role cloud_admin
    +----------------------------------+-------+--------+-------------+
    | ID                               | Name  | Domain | User        |
    +----------------------------------+-------+--------+-------------+
    | 548386103d43421886b0ab6a1962513a | admin | Admin  | cloud_admin |
    +----------------------------------+-------+--------+-------------+

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
