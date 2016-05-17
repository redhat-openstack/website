---
title: RDO blogs over the last few weeks
author: rbowen
date: 2016-05-17 17:18:56 UTC
tags: blogs, openstack
comments: true
published: true
---

I've been traveling a lot over the last few weeks, and have fallen behind on the blog post updates. Here's what RDO enthusiasts have been blogging about since OpenStack Summit.

I posted a number of "**What Did You Do In Mitaka**" interview posts, so here those are, all together:

* [Ivan Chavero](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-ivan-chavero/)
* [Ihar Hrachyshka](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-ihar-hrachyshka-talks-about-neutron/)
* [Chandan Kumar](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-chandan-kumar/)
* [Haïkel Guémar](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-haikel-guemar/)
* [Javier Peña](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-javier-pena/)
* [Emilien Macchi](https://www.rdoproject.org/blog/2016/05/what-did-you-do-in-mitaka-emilien-macchi/)
* [David Moreau Simard](https://www.rdoproject.org/blog/2016/05/what-did-you-do-in-mitaka-david-moreau-simard/)
* [Adam Young](https://www.rdoproject.org/blog/2016/05/what-did-you-do-in-mitaka-adam-young/)

Additionally, there were the following:

**Deploying the new OpenStack EC2 API project** by Tim Bell

> OpenStack has supported a subset of the EC2 API since the start of the project. This was originally built in to Nova directly. At CERN, we use this for a number of use cases where the experiments are running across both the on-premise and AWS clouds and would like a consistent API. A typical example of this is the HTCondor batch system which can instantiate new workers according to demand in the queue on the target cloud.

... read more at [http://tm3.org/6e](http://tm3.org/6e)

**Running Keystone Unit Tests against older Versions of RDO Etc** by Adam Young

> Just because upstrem is no longer supporting Essix doesn’t mean that someone out there is not running it. So, if you need to back port a patch, you might find yourself in the position of having to run unit tests against an older version of Keystone (or other) that does not run cleanly against the files installed by tox.

... read more at [http://tm3.org/6f](http://tm3.org/6f)

**Containers and the CERN cloud** by Ricardo Rocha

> In recent years, different groups at CERN started looking at using containers for different purposes, covering infrastructure services but also end user applications. These efforts have been mostly done independently, resulting in a lot of repeated work especially for the parts which are CERN specific: integration with the identity service, networking and storage systems. In many cases, the projects could not complete before reaching a usable state, as some of these tasks require significant expertise and time to be done right. Alternatively, they found different solutions to the same problem which led to further complexity for the supporting infrastructure services. However, the use cases were real, and a lot of knowledge had been built on the available tools and their capabilities.

... read more at [http://tm3.org/6g](http://tm3.org/6g)

**Meet Red Hat OpenStack Platform 8** by Sean Cohen

> Last week we marked the general availability of our Red Hat OpenStack Platform 8 release, the latest version of Red Hat’s highly scalable IaaS platform based on the OpenStack community “Liberty” release. A co-engineered solution that integrates the proven foundation of Red Hat Enterprise Linux with Red Hat’s OpenStack technology to form a production-ready cloud platform, Red Hat OpenStack Platform is becoming a gold standard for large production OpenStack deployments. Hundreds of global production deployments and even more proof-of-concepts are underway, in the information, telecommunications, financial sectors, and large enterprises in general. Red Hat OpenStack Platform also benefits from a strong ecosystem of industry leaders for transformative network functions virtualization (NFV), software-defined networking (SDN), and more.

... read more at [http://tm3.org/6h](http://tm3.org/6h)

**OpenStack Summit Austin: Day 1** by Gordon Tillmore

> We’re live from Austin, Texas, where the 13th semi-annual OpenStack Summit is officially underway! This event has come a long way from its very first gathering six years ago, where 75 people gathered to learn about OpenStack in its infancy. That’s a sharp contrast with the 7,000+ people in attendance here, in what marks Austin’s second OpenStack Summit, returning to where it all started!

... read more at [http://tm3.org/6i](http://tm3.org/6i)

**OpenStack Summit Austin: Day 2** by Gordon Tillmore

> Hello again from Austin, Texas where the second busy day of OpenStack Summit has come to a close. Not surprisingly, there was plenty of news, interesting sessions, great discussions on the showfloor, and more.

... read more at [http://tm3.org/6j](http://tm3.org/6j)

**Culture and technology can drive the future of OpenStack** by E.G.Nadhan

> “OpenStack in the future is whatever we expand it to”, said Red Hat Chief Technologist, Chris Wright during his keynote at the OpenStack Summit in Austin. After watching several keynotes including those from Gartner and AT&T, I attended other sessions during the course of the day culminating in a session by Lauren E Nelson, Senior Analyst at Forrester Research. Wright’s statement made me wonder about what lies in store for OpenStack and where would the OpenStack Community — the “we” that Wright referred to — take it to in the future. 

... read more at [http://tm3.org/6k](http://tm3.org/6k)

**OpenStack Summit Austin: Day 3** by Gordon Tillmore
 
> Hello again from Austin, Texas where the third day of OpenStack Summit has come to a close. As with the first two days of the event, there was plenty of news, interesting sessions, great discussions on the showfloor, and more. All would likely agree that the 13th OpenStack Summit has been a Texas-sized success so far!

... read more at [http://tm3.org/6l](http://tm3.org/6l)

**Resource management at CERN** by Tim Bell

> As part of the recent OpenStack summit in Austin, the Scientific Working group was established looking into how scientific organisations can best make use of OpenStack clouds.

... read more at [http://tm3.org/6m](http://tm3.org/6m)

**OpenStack Summit Austin: Day 4** by Gordon Tillmore 

> Hello again from Austin, Texas where the fourth day of the main OpenStack Summit has come to a close. While there are quite a few working sessions and contributor meet-ups on Friday, Thursday marks the last official day of the main summit event. The exhibition hall closed its doors around lunch time, and the last of the vendor sessions occurred later in the afternoon. As the day concluded, many attendees were already discussing travel plans for OpenStack Summit Barcelona in October!

... read more at [http://tm3.org/6n](http://tm3.org/6n)

**OpenStack Summit Newton from a Telemetry point of view** by Julien Danjou

> It's again that time of the year, where we all fly out to a different country to chat about OpenStack and what we'll do during the next 6 months. This time, it was in Austin, TX and we chatted about the new Newton release that will be out in October.

... read more at [http://tm3.org/6o](http://tm3.org/6o)


**Identity work for the OpenStack Newton release** by Adam Young

> The Newton Summit is behind us, and we have six months to prepare for the next release in both upstream OpenStack and RDO. Here is my attempt to build a prioritized list of the large tasks I want to tackle in this release.

... read more at [http://tm3.org/6p](http://tm3.org/6p)

**Mitaka Cinder Recap sessions** by Gorka Eguileor

> During Mitaka we introduced some big changes in Cinder that have a great impact for developers working on new and existing functionality. These new features include, but are not limited to, API microversions, support for Rolling Upgrades, and conditional DB update functionality to remove API races. So we decided to have Recap Sessions during the OpenStack Summit in Austin.

... read more at [http://tm3.org/6q](http://tm3.org/6q)

**Analysis of techniques for ensuring migration completion with KVM** by Daniel Berrange

> Live migration is a long standing feature in QEMU/KVM (and other competing virtualization platforms), however, by default it does not cope very well with guests whose workload are very memory write intensive. It is very easy to create a guest workload that will ensure a migration will never complete in its default configuration. For example, a guest which continually writes to each byte in a 1 GB region of RAM will never successfully migrate over a 1Gb/sec NIC. Even with a 10Gb/s NIC, a slightly larger guest can dirty memory fast enough to prevent completion without an unacceptably large downtime at switchover. Thus over the years, a number of optional features have been developed for QEMU with the aim to helping migration to complete.

... read more at [http://tm3.org/6r](http://tm3.org/6r)

**What did everyone do for the Mitaka release of OpenStack ?** by David Moreau Dimard

> Just what did everyone do for the Mitaka OpenStack release ?
> RDO community liaison Rich Bowen went to find out.
> He interviewed some developers and engineers that worked on OpenStack and RDO throughout the Mitaka cycle and asked them what they did and what they were up to for the Newton cycle.

... read more at [http://tm3.org/6s](http://tm3.org/6s)

