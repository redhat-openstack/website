---
title: Domains
authors: msolberg
wiki_title: Domains
wiki_revision_count: 14
wiki_last_updated: 2014-04-28
---

# Domains

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

*   Download updated policy file

<!-- -->

    [root@laptop ~]# wget https://raw.githubusercontent.com/openstack/keystone/master/etc/policy.v3cloudsample.json  -O /etc/keystone/policy.json
    --2014-04-23 23:00:05--  https://raw.githubusercontent.com/openstack/keystone/master/etc/policy.v3cloudsample.json
    Resolving raw.githubusercontent.com... 199.27.74.133
    Connecting to raw.githubusercontent.com|199.27.74.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 9032 (8.8K) [text/plain]
    Saving to: “/etc/keystone/policy.json”

    100%[======================================>] 9,032       --.-K/s   in 0.02s   

    2014-04-23 23:00:05 (434 KB/s) - “/etc/keystone/policy.json” saved [9032/9032]

*   Change the keystone entries in the service catalog to point to v3:

...

## References

*   <https://wiki.openstack.org/wiki/Domains>
*   <http://www.mirantis.com/blog/manage-openstack-projects-using-domains-havana/>
*   <http://adam.younglogic.com/2013/09/keystone-v3-api-examples/>
*   <http://www.madorn.com/keystone-v3-api.html>
