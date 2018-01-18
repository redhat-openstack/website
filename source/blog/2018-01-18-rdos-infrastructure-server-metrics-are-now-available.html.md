---
title: RDO's infrastructure server metrics are now available
author: rbowen
date: 2018-01-18 21:06:37 UTC
tags: infra,metrics,softwarefactory,grafana
comments: true
published: true
---

*Reposted from dev@lists.rdoproject.org post by David Moreau Simard*

We have historically been monitoring RDO's infrastructure through Sensu and it has served us well to pre-emptively detect issues and maximize our uptime.

At some point, [Software Factory](https://softwarefactory-project.io/)  grew an implementation of Grafana, InfluxDB and Telegraf in order to monitor the health of the servers, not unlike how upstream's openstack-infra leverages cacti.
This implementation was meant to eventually host graphs such as the ones for Zuul and Nodepool upstream.

While there are still details to be ironed out for the Zuul and Nodepool data collection, there was nothing preventing us from just deploying telegraf everywhere just for the general server metrics.
It's one standalone package and one configuration file, that's it.

Originally, we had been thinking about [feeding the Sensu metric data to Influxdb](https://bugzilla.redhat.com/show_bug.cgi?id=1514089) ... but why even bother if it's there for free in Software Factory ?
So here we are.

The metrics are now available [here](https://review.rdoproject.org/grafana)
We will use this as a foundation to improve visibility into RDO's infrastructure, make it more "open" and accessible in the future.

We're not getting rid of Sensu although we may narrow it's scope to keep some of the more complex service and miscellaneous monitoring that we need to be doing.
We'll see what time has in store for us.

Let me know if you have any questions !
