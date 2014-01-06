---
title: Glance
authors: gfidente, tshefi
wiki_title: Tests/Storage/Glance
wiki_revision_count: 12
wiki_last_updated: 2014-01-06
---

# Glance

## January 2014 Test Day

Glance testing should include image manipulation commands below, tested on different deployment scenarios\\back-ends and supported operating systems.

*   Create images: image-create , upload images based on file and on URL, locations
*   Upload different image formats (iso,qcow,vdi,vmdk..)
*   Upload imaesg of differnt containers types (bare,ovf,..)
*   Delete image
*   Image list\\show specific detail of an image
*   Image-update, change image aparmanters check that it updated.
*   Boot instance from image, using nova boot from image, to test a bootable image.
*   Make image from instance
*   Image share\\unshare\\show permissions
*   Check multi project image access\\permissions
*   Check Glance V2 API commands
*   Check Glance with multiple backends, glance-api.conf,show_multiple_locations = True

For command help: glance --help \\ glance -help image-create

*   Semi distributed, local storage
*   Semi distributed, remote storage
*   Fully distributed, local storage
*   Fully distributed, remote storage
*   Fully distributed, HA
