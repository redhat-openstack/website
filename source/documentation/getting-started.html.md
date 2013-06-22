---
title: Getting Started
category: documentation
authors: dneary, rbowen
wiki_category: Documentation
wiki_title: Getting Started
wiki_revision_count: 5
wiki_last_updated: 2013-06-22
---

# Getting Started

## What's the admin password?

The admin dashboard (aka Horizon) is located at <http://CONTROL_NODE/dashboard> The default admin username is 'admin' and the initial password is located in /root/keystonerc_admin

## Installing on RHEL - Prerequisites

If you're installing on RHEL, you must have your system registered with RHD, Satellite server, or a Yum repository. I'ts also a good idea to run "yum update" prior to starting the install, since the OpenStack software evolves very fast.

## Installing with multiple NICs

If you're installing on a system with multiple NICs, "packstack --allinone" may not configure services on the interface you intended. To be certain, run "packstack --gen-answer-file=file_name", and then edit the resulting answer file to ensure that it's using the interface you wanted. Then run "packstack --answer-file=file_name"

<Category:Documentation>
