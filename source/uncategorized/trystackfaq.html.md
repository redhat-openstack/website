---
title: TryStackFAQ
authors: radez, rbowen
wiki_title: TryStackFAQ
wiki_revision_count: 13
wiki_last_updated: 2014-10-06
---

# Try Stack FAQ

The following questions are the most commonly asked questions for TryStack. Hopefully you can find your answer here. If you can't then ask it and add the answer here after you get one.

## What's the root password to the instances?

We don't know. Please use ssh keys to authenticate to the hosts. A how-to on this would be a great doc for someone to contribute to TryStack.

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
