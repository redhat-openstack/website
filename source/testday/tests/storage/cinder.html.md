---
title: Cinder Test
authors: gfidente, yrabl, snecklifter
---

# Cinder Test

The general idea for the Cinder's test is to test the actions of the component in different environments and with different back ends. Cinder should be able to do the following actions with each back end and in every topology:

*   Create a volume - for every type try different sizes (1 - ~100 G).
    -   Simple creation.
    -   From an image.
    -   From a snapshot.
    -   Copy of another volume.
*   Delete a volume.
*   Create a snapshot.
    -   A volume in the status of "available".
    -   A volume in "in-use" status.
*   Delete a snapshot.
*   Upload the volume to an image.
*   Backup the volume.
*   Boot an instance from a "bootable" volume.
*   Boot an instance with a volume that is not "bootable".
*   Attach a volume to a working instance:
    -   The instance has booted from an image.
    -   The instance has booted from a volume.
*   Detach a volume from an instance.
