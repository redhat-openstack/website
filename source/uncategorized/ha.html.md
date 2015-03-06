---
title: HA
authors: beekhof, radez, rbowen
wiki_title: HA
wiki_revision_count: 19
wiki_last_updated: 2015-03-09
---

# HA

## Purpose

In our [Openstack HA Guide](https://github.com/beekhof/osp-ha-deploy/blob/master/ha-openstack.md) we document a high level architecture for a highly available control plane and set of compute nodes based on the [Pacemaker](http://clusterlabs.org) cluster manager and [HA Proxy](http://www.haproxy.org) which provides:

*   detection and recovery of machine and application-level failures
*   startup/shutdown ordering between applications
*   preferences for other applications that must/must-not run on the same machine
*   provably correct response to any failure or cluster state

## Why Pacemaker

At its core, a cluster is a distributed finite state machine capable of co-ordinating the startup and recovery of inter-related services across a set of machines.

Even a distributed and/or replicated application that is able to survive failures on one or more machines can benefit from a cluster manager:

*   Awareness of other applications in the stack

While SYS-V init replacements like systemd can provide deterministic recovery of a complex stack of services, the recovery is limited to one machine and lacks the context of what is happening on other machines - context that is crucial to determine the difference between a local failure, clean startup and recovery after a total site failure.

*   Awareness of instances on other machines

Services like RabbitMQ and Galera have complicated boot-up sequences that require co-ordination, and often serialization, of startup operations across all machines in the cluster. This is especially true after site-wide failure or shutdown where we must first determine the last machine to be active.

*   Data integrity through fencing (a non-responsive process does not imply it is not doing anything)

A single application does not have sufficient context to know the difference between failure of a machine and failure of the applcation on a machine. The usual practice is to assume the machine is dead and carry on, however this is highly risky - a rogue process or machine could still be responding to requests and generally causing havoc. The safer approach is to make use of remotely accessible power switches and/or network switches and SAN controllers to fence (isolate) the machine before continuing.

*   Automated recovery of failed instances

While the application can still run after the failure of several instances, it may not have sufficient capacity to serve the required volume of requests. A cluster can automatically recover failed instances to prevent additional load induced failures.

## Why HA Proxy

HAProxy is a free, open source solution, providing load balancing and proxying for TCP and HTTP-based applications by spreading requests across multiple servers. It is written in C and has a reputation for being fast and efficient, both in terms of processor and memory usage.

Integrating a proxy into the architecture has four key benefits:

*   Load distribution

Many services can act in an active/active capacity, however they usually require an external mechanism for distributing requests to one of the available instances. The proxy server can serve this role.

*   API isolation

By sending all API access through the proxy, we can clearly identify service interdependancies. We can also move them to locations other than \`localhost\` to increase capacity if the need arises.

*   Simplified process for adding/removing of nodes

Since all API access is directed to the proxy, adding or removing nodes has no impact on the configuration of other services. This can be very useful in upgrade scenarios where an entirely new set of machines can be configured and tested in isolation before telling the proxy to direct traffic there instead.

*   Enhanced failure detection

The proxy can be configured as a secondary mechanism for detecting service failures. It can even be configured to look for nodes in a degraded state (such as being 'too far' behind in the replication) and take them out of circulation.

## Details

Implementation details are contained in scripts linked to from the main document. Read them carefully before considering to run them in your own environment.

The current target for this document is CentOS 7 and the Juno release of Openstack.

## Securing Services

The document [ Securing Services](Securing_Services) has some additional information on securing MySQL, qpid and Apache services.
