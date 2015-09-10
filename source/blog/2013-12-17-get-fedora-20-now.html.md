---
title: Get Fedora 20 now!
date: 2013-12-17 10:24:59
author: mattdm
---

Fedora 20 is out -- get it now from http://cloud.fedoraproject.org/

    Import into glance:
    glance image-create --name "Fedora 20 x86_64" --disk-format qcow2 \
         --container-format bare --is-public true --copy-from \
         http://cloud.fedoraproject.org/fedora-20.x86_64.qcow2 


From an OpenStack point of view, one notable addition is the addition of the
Heat tools provisioning images.

As with Fedora 19, cloud-init is configured to create a user `fedora` by
default.
