---
title: Post Installation Tests
authors: dron, rbowen
wiki_title: Post Installation Tests
wiki_revision_count: 6
wiki_last_updated: 2014-10-01
---

# Post Installation Tests

**After installation, please run the following on your setup:**

As Admin user:

1. create a new image

2. launch 4 new instances from the image

3. create a snapshot

4. create a volume from the image

5. launch an instance

6. connect to the volume instance and one of the image instances and write to the image

7. create a new project with : 1 admin user, 2 Member users

8. create a new privet network

9. attach floating ips to an instance

10. attach a new ip from the second privet network.

11. shut off an instance

12. destroy the volume instance

13. launch a new instance from the volume -> connect to the instance via console -> make sure that the changes to the volume were not deleted on instance termination.

14. create a new flavor and launch an instance with the flavor

15. terminate all instances

**As new created users:**

1. . launch an instance from image as the new admin user

2. try to launch a user as Member user

3. try to terminate an instance as member user

4. try to launch an instance from the volume as a Member user

5. launch an instance from the volume as the new admin user.

6. connect via console to the volume instance as a Member user.

7. destroy all images as a Member user

8. delete volume and image as Member user
