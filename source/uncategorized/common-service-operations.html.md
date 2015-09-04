---
title: Common service operations
authors: kashyap
wiki_title: Common service operations
wiki_revision_count: 2
wiki_last_updated: 2013-05-25
---

# Common service operations

## Frequently used **service** operations

### All OpenStack services

To STOP all currently *running* OpenStack services:

    $ for j in `for i in $(ls -1 /etc/init.d/openstack-*) ; \
    do $i status | grep running ; done | awk '{print $1}'`; \
    do service $j stop ; done

To START all currently *stopped* OpenStack services:

    $ for j in `for i in $(ls -1 /etc/init.d/openstack-*) ; \
    do $i status | grep stopped; done | awk '{print $1}'`; \
    do service $j start ; done

To RESTART all currently *running* services:

    $ for j in `for i in $(ls -1 /etc/init.d/openstack-*) ; \
    do $i status | grep running ; done | awk '{print $1}'`; \
    do service $j restart ; done

To see STATUS of all openstack services:

    $ openstack-status

### Component specific services

For brevity's sake, just noting commands specific to **nova**.

To RESTART all currently *running* **nova** services:

    $ for j in `for i in $(ls -1 /etc/init.d/openstack-nova-*) ; \
    do $i status | grep running ; done | awk '{print $1}'`; \
    do service $j restart ; done

To STOP all currently *running* **nova** services:

    $ for j in `for i in $(ls -1 /etc/init.d/openstack-nova-*) ; \
    do $i status | grep running ; done | awk '{print $1}'`; \
    do service $j stop ; done

To START all currently *stopped* **nova** services:

    $ for j in `for i in $(ls -1 /etc/init.d/openstack-nova-*) ; \
    do $i status | grep stopped; done | awk '{print $1}'`; \
    do service $j start ; done

Similarly, for other services: **glance, cinder, keystone, swift** , you can trivially modify the above commands to suit your needs.
