---
title: TryStackDocker
authors: radez
wiki_title: TryStackDocker
wiki_revision_count: 2
wiki_last_updated: 2014-09-18
---

### TryStack Docker

There is a fedora docker image already imported and publicly available for use on TryStack named "fedora".
This How-To shows the process of how that fedora image was imported into Glance.

1. . **Import a Docker Image**
 First, Build your own image or search for one in the public docker registry.

      $ docker search fedora
      NAME                                   DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
      fedora                                 (Semi) Official Fedora base image.              75        [OK] 

Then, pull the image and push it to Glance:

      $ docker pull fedora
      $ docker save fedora | glance image-create  --container-format=docker --disk-format=raw --name fedora -P hypervisor-type docker -P os-command-line /bin/bash

The important parts of that last command are:

*   make sure that the glance --name value is identical to the name of the docker image. Docker will use the glance image's name to reference the docer image. If they mismatch the container won't launch.
*   ensure that "-P hypervisor-type docker" is set so that the instances launched in OpenStack go to the Docker compute node.
*   ensure that "-P os-command-line" /path/to/a/command is set if the image doesn't have a command built into it.
