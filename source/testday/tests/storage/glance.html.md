---
title: Glance
authors: gfidente, tshefi
wiki_title: Tests/Storage/Glance
wiki_revision_count: 12
wiki_last_updated: 2014-01-06
---

# Glance

## January 2014 Test Day

Glance testing should include image manipulation commands below, tested on different deployment scenarios\\back-ends.

*   Create images:
    -   using image from file.
    -   using image from http.
*   Upload different types:
    -   Using different disk formats (iso,qcow,vdi,vmdk..).
    -   Using different containers types (bare,ovf,..).
*   Delete image.
*   Image details:
    -   list images.
    -   show specific detail of an image.
*   Image-update, change image parameters check that it updated.
*   Use images:
    -   Boot instance from image, using nova boot from image, to test a bootable image.
    -   Test several instances for different operating systems (Linux\\Windows..).
    -   Make image from instance.
*   Create image from volume.
*   Create volume from image.
*   Image share\\unshare\\show permissions.
*   Check multi project image access\\permissions.

For command help: glance --help \\ glance -help image-create
