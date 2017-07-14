---
title: Post Installation Tests
authors: dron, rbowen
---

# Post Installation Tests

## After installation, run the following on your setup:

setting up:

1.  log into Horizon
2.  create a new project called RedHat and set a high numbers quota
3.  create a new project user with admin rights called Pinky Brain
4.  log out

Admin in tenant:

1.  log in to Project RedHat using Pinky Brain user
2.  create a new Image called qcow_image
3.  create the following user's as members:

*   Peter PP
*   Homer HH
*   Francine FF
*   Jeff JJ
*   Tom TT
*   Daniel DD

1.  create a private network called PB
2.  launch 6 instances from the created image called 'TV'
3.  create a new volume from an image called 'image-volume'
4.  create a new empty volume called 'blank-volume'
5.  create a snapshot from both volumes
6.  create a backup for both volumes
7.  launch an instance from the 'image-volume'
8.  attach the empty volume to an instance

Member of tenant:

1.  log in to horizon using Peter Griffin's user
