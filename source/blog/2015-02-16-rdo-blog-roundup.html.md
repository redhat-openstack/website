---
title: RDO blog roundup, February 16, 2015
date: 2015-02-16 16:01:00
author: rbowen
---

Here's what RDO engineers have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!

**External networking for Kubernetes services**, by Lars Kellogg-Stedman

> I have recently started running some "real" services (that is, "services being consumed by someone other than myself") on top of Kubernetes (running on bare metal), which means I suddenly had to confront the question of how to provide external access to Kubernetes hosted services. Kubernetes provides two solutions to this problem, neither of which is particularly attractive out of the box:

... read more at http://tm3.org/blog89

**Installing nova-docker with devstack**, by Lars Kellogg-Stedman

> This is a long-form response to this question, and describes how to get the nova-docker driver up running with devstack under Ubuntu 14.04 (Trusty). I wrote a similar post for Fedora 21, although that one was using the RDO Juno packages, while this one is using devstack and the upstream sources.

... read more at http://tm3.org/blog90

**Debugging OpenStack with rpdb**, by Adam Young

> OpenStack has many different code bases.  Figuring out how to run in a debugger can be maddening, especially if you are trying to deal with Eventlet and threading issues.  Adding HTTPD into the mix, as we did for Keystone, makes it even trickier.  Here’s how I’ve been handling things using the remote pythong debugger (rpdb).

... read more at http://tm3.org/blog91

**Writing a Gnocchi storage driver for ceph**, by  Mehdi Abaakouk 

> As presented by Julien Danjou, Gnocchi is designed to store metric metadata into an indexer (usually a SQL database) and store the metric measurements into another backend. The default backend creates timeseries using Carbonara (a pandas based library) and stores them into Swift.,

... read more at http://tm3.org/blog92

**Unpacking Docker images with Undocker**, by Lars Kellogg-Stedman

> In some ways, the most exciting thing about Docker isn't the ability to start containers. That's been around for a long time in various forms, such as LXC or OpenVZ. What Docker brought to the party was a convenient method of building and distributing the filesystems necessary for running containers. Suddenly, it was easy to build a containerized service and to share it with other people.

... read more at http://tm3.org/blog93

**Red Hat Enterprise Virtualization 3.5 transforms modern data centers that are built on open standards**, by Raissa Tona

> This week we announced the general availability of Red Hat Enterprise Virtualization 3.5. Red Hat Enterprise Virtualization 3.5 allows organizations to deploy an IT infrastructure that services traditional virtualization workloads while building a solid base for modern IT technologies.

... read more at http://tm3.org/blog94

**Adding an LDAP backed domain to a Packstack install**, by Adam Young

> I’ve been meaning to put all the steps together to do this for a while:
> 
> Got an IPA server running on Centos7
> Got a Packstack all in one install on Centos 7. I registered this host as a FreeIPA client, though that is not strictly required.

... read more at http://tm3.org/blog95
