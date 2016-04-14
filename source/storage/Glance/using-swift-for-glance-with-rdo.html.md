---
title: Using Swift for Glance with RDO Liberty
authors: coolsvap
wiki_title: Using Swift for Glance with RDO Liberty
wiki_revision_count: 1
wiki_last_updated: 2015-10-15
---

# Using Swift for Glance with RDO

The default backend driver configured for Glance is the local filesystem but it supports a set of alternative backends, including Swift. If you want to store the Glance images on Swift, a few post-install configuration steps are needed:
    ` # openstack-config --set /etc/glance/glance-api.conf DEFAULT default_store swift`
    ` # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_auth_address `[`http://$KEYSTONE_HOST:5000/v2.0/`](http://$KEYSTONE_HOST:5000/v2.0/)
    ` # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_user services:glance`
    ` # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_key $SERVICE_PASSWORD`
    ` # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_create_container_on_put True`

**NOTE**: you should replace $KEYSTONE_HOST with the IP address of the node running Keystone and $SERVICE_PASSWORD with the password assigned to the "glance" user. If you installed using packstack, that is in your answer file, search for `CONFIG_GLANCE_KS_PW`

You will also need to assign the "ResellerAdmin" role to the "glance" user or it won't be able to create containers.

       # keystone user-role-add --tenant_id=$UUID_SERVICES_TENANT --user=$UUID_GLANCE_USER --role=$UUID_ResellerAdmin_ROLE

Feel free to create the "ResellerAdmin" role first if it's not found and lastly restart the needed services:

       # service openstack-glance-api restart
