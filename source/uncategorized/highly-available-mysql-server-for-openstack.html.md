---
title: Highly Available MySQL server for OpenStack
authors: dneary, radez
wiki_title: Highly Available MySQL server for OpenStack
wiki_revision_count: 40
wiki_last_updated: 2013-10-07
---

# Highly Available MySQL with RDO

When running OpenStack API services with MySQL on a single node, the database is a single point of failure. This guide will show how to manually deploy pacemaker and and use it to manage your MySQL cluster across multiple nodes.

### Prerequisites

This guide assumes that OpenStack has been deployed in a configuration with two or more control nodes. One way to do this would be to re-use the answerfile from your packstack install to run the installer on multiple nodes. Another would be to use foreman to provision multiple control nodes. See the RDO QuickStart guide for more information. For this guide we'll assume all control services run on two nodes.

### Overview

Most of the services on a control node are stateless, this in nice because it means you can run the service on as many nodes as you'd like and they won't interfere with each other. The coordination pacemaker takes care of includes a floating ip, the database, messaging and nova-consoleauth.
