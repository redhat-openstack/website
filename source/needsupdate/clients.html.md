---
title: Clients
category: needsupdate
authors: jruzicka, rbowen
wiki_category: NeedsUpdate
wiki_title: Clients
wiki_revision_count: 7
wiki_last_updated: 2015-07-16
---

# Clients

## RDO OpenStack clients

### Basic Information

*   Clients provide **python library** and **CLI executable** for communicating with respective service API.
*   Client packages are named `python-${PROJECT}client` and contain `${PROJECT}client` python module and `$PROJECT` executable.
    -   example: `python-novaclient` provides `novaclient` python module and `nova` executable for communicating with Nova API
*   `jruzicka` maintains all the RDO client packages. You can talk to him on `#rdo` IRC channel @ Freenode.

### Client releases are independent

*   Upstream client releases are **independent** on OpenStack releases and milestones.
*   Clients are supposed to be backward compatible, but this **isn't** enforced/ensured.

### Client stable/$RELEASE branches

*   To ensure release stability, `jruzicka` maintains **stable client branches for RDO**.
*   Stable branches `stable/$RELEASE` live at `https://github.com/redhat-openstack/python-${PROJECT}client`.
    -   example: [novaclient stable/havana](https://github.com/redhat-openstack/python-novaclient/tree/stable/havana)
*   Generally, stable clients are **frozen at latest upstream version available at OpenStack release**.
*   Patches are backported to stable branches if needed.

![](clients-stable-branches.png "fig:clients-stable-branches.png")
