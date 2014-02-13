---
title: TryStackFAQ
authors: radez, rbowen
wiki_title: TryStackFAQ
wiki_revision_count: 13
wiki_last_updated: 2014-10-06
---

# Try Stack FAQ

The following questions are the most commonly asked questions for [TryStack](http://trystack.org). Hopefully you can find your answer here. If you can't then ask it and add the answer here after you get one.

## TryStack operational boundaries

1. Instances are deleted after 24 hours
We have limited compute capacity to server the 10000+ facebook members we have. You can help keep capactiy under control by terminating your instances once you're done with them and not letting them run to their 24 hour limit.

2. User uploaded images will be set non-public
TryStack doesn't have the man power to support all the images that are uploaded across all users. You're welcome to upload your own and use them, We just can't support sharing them.

3. Neutron Floating IPs and router gateways are released once no longer associated with an instance.
We only have a /24 IP block for all our servers, service IPs and floating IPs, These get used fast with everyone needing atleast 2 (one for your router and a floating IP)

## What's the root password to the instances?

We don't know. Please use ssh keys to authenticate to the hosts. A how-to on this would be a great doc for someone to contribute to TryStack.

## Error: Failed to create ... overlaps with another subnet

If you get an error like this:

Error: Failed to create subnet "192.168.37.0/24" for network "public": 400-{u'NeutronError': {u'message': u'Invalid input for operation: Requested subnet with cidr: 192.168.37.0/24 for network: 5f94cde4-4dd5-4949-a955-50dc5dc6dfa7 overlaps with another subnet.', u'type': u'InvalidInput', u'detail': u''}}

It means the subnet you choose is already being used. The Getting started video erroneously tells you to reuse the same subnet, in reality each tenant's subnet must be a unique block that does not overlap with another network in TryStack.

Unfortunately we don't have a way to help you pick one that's not being used yet, you kinda have to guess. In the example above you can just change the 37 to another number in the range 1-254 until you find one that's not being used.

## Followed getting started video but can't ssh / ping

The way this is usually resolved is by resetting your router, and possibly by rebuilding your network. This becomes necessary because as we work on and add to trystack things get reset. Some of these things are networking related and are set when networks get created.
 Unfortunately routers and networks have a collection of steps to be reset. Follow these steps and see if if helps:
 1. disassociate and release all your floating ips on the access and security / Floating IPs tab
2. clear the gateway on your router on the router menu
3. click the router to see the interface list
4. remove the interface
5. terminate your instance (in case it didn't get an ip)
6. Delete your internal network

Now you have an empty router and no network.
1. recreate your network
2. relaunch your instance
3. add the interface back to your router
4. set the gateway on your router
5. allocate and associate the floating ip to the new instance
