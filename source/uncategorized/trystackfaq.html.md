---
title: TryStackFAQ
authors: radez, rbowen
wiki_title: TryStackFAQ
wiki_revision_count: 13
wiki_last_updated: 2014-10-06
---

# Try Stack FAQ

## What's the root password to the instances?

We don't know. Please use ssh keys to authenticate to the hosts. A how-to on this would be a great doc for someone to contribute to TryStack.

## Can't ssh / ping

The way this is usually resolved is by resetting your router.</br> Unfortunately a router has a collection of steps to be reset. Follow these steps and see if if helps:</br> 1. disassociate and release all your floating ips on the access and security / Floating IPs tab</br> 2. clear the gateway on your router on the router menu</br> 3. click the router to see the interface list</br> 4. remove the interface</br> 5. terminate your instance (in case it didn't get an ip)

Now you have an empty router.</br> 1. relaunch your instance</br> 2. add the interface back to your router</br> 3. set the gateway on your router</br> 4. allocate and associate the floating ip to the new instance</br>
