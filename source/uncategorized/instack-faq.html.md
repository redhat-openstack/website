---
title: Instack FAQ
authors: bcrochet, bnemec, ccrouch, rbowen, rbrady, rlandy, slagle, sradvan
wiki_title: Instack FAQ
wiki_revision_count: 62
wiki_last_updated: 2015-02-13
---

# Instack FAQ

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

This page includes tips, fixes and debugging steps for Instack installs:

*   If the undercloud machine was installed using LVM, when deploying overcloud nodes, you may see an error related to the disk being "in use". The workaround for this error is to:
        # Modify /etc/lvm/lvm.conf to set use_lvmetad to be 0
        vi /etc/lvm/lvm.conf
        use_lvmetad=0
        # Disable and stop relevant services
        systemctl stop lvm2-lvmetad
        systemctl stop lvm2-lvmetad.socket
        systemctl disable lvm2-lvmetad.socket
        systemctl stop lvm2-lvmetad
