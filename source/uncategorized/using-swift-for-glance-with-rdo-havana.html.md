---
title: Using Swift for Glance with RDO Havana
authors: gfidente
wiki_title: Using Swift for Glance with RDO Havana
wiki_revision_count: 5
wiki_last_updated: 2014-01-08
---

# Using Swift for Glance with RDO Havana

The default backend driver configured for Glance is the local filesystem but it supports a set of alternative backends, including Swift. If you want to store the Glance images on Swift, a few post-install configuration steps are needed:

       # openstack-config --set /etc/glance/glance-api.conf DEFAULT default_store = swift
` # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_auth_address = `[`http://$KEYSTONE_HOST:5000/v2.0/`](http://$KEYSTONE_HOST:5000/v2.0/)
       # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_user = services:glance
       # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_key = $SERVICE_PASSWORD (you can find this in the packstack answers file)
       # openstack-config --set /etc/glance/glance-api.conf DEFAULT swift_store_create_container_on_put = True

You will also need to add the "ResellerAdmin" role to the "glance" user or it won't be able to create containers.

       # keystone user-role-add -tenant_id=[uuid of the services tenant] –user=[uuid of the glance account] –role=[uuid of the ResellerAdmin role]

Feel free to create the "ResellerAdmin" role first if it's not found.
