---
title: RDO Community Day At FOSDEM 2016
authors: rbowen
---

# RDO Community Day @ FOSDEM 2016

RDO Community Day at FOSDEM 2016 was held in conjunction with the [CentOS
Dojo](https://wiki.centos.org/Events/Dojo/Brussels2016) on the day 
before FOSDEM.

The schedule of talks was as follows:

1. toc
{:toc}

## Opening Keynote: RDO In Production - *Thomas Oulevey*

[[Slides](./presentations/2016/FOSDEM/RDO_in_production_CERN.pdf)]

> CERN, the European laboratory for Particle Physics, uses some of the world's largest and most complex scientific instruments such as the Large Hadron Collider, a 27 KM ring 100m underground on the border between France and Switzerland.
> CERN has been running OpenStack in production since July 2013 to uncover the mysteries of the Universe supporting the work of 13,000 physicists around the world.  
> The CERN IT cloud is currently around 150,000 cores on more than 5,000 servers across the two data centres.
> CERN deploy OpenStack based on an open source distribution from the RDO community. Let's go behind the scenes at CERN and see how RDO with the help of other open source projects help to scale OpenStack and what others can benefit from their experience.


<iframe width="420" height="315"
src="https://www.youtube.com/embed/3hgVKQI-U38" frameborder="0"
allowfullscreen></iframe>

----

## Build a Basic Cloud Using RDO-manager - *K Rain Leander*

> One of the impediments to becoming an active technical contributor in the OpenStack community is setting up your own R&D environment which includes making your own cloud.  How much RAM do you really need? How important is processor speed?  What else do I need to know?

> Using RDO-manager, get a basic cloud up and running with the fewest steps and minimal hardware so you can focus on the fun stuff - development!

> After this presentation, you will be able to build your own basic cloud using RDO-manager.

## Bare metal deployment and introspection in RDO Manager - *Dmitry Tantsur, Imre Farkas*

[Slides - [Dmitry](http://dtantsur.github.io/talks/fosdem2016/),
[Imre](http://ifarkas.github.io/talks/2016-fosdem-rdo-day/)]

> The OpenStack Bare Metal service (codenamed Ironic) is one of the key compoments of RDO Manager. A separate service called Ironic Inspector is used to conduct bare metal introspection before deployment. This talk gives a brief introduction into Ironic's architecture and explains how it is used in RDO Manager. It then covers common problems with deployment and introspection processes, as well as possible solutions.


## Delorean Hands On, and How To Contribute to RDO - *Haïkel Guémar, Alan Pevec*

>In this session, we'll learn how to setup delorean to contribute to RDO. There'll be a quick presentation and then we roll our sleeves and start adding packages to RDO


## RDO configuration files: do's, dont's, gotchas, and rfc - *Ihar Hrachyshka*

> This presentation will give overview of how we configure OpenStack services, in general as well from RDO perspective. Audience should expect brief overview of libraries and techniques used in upstream to manage configuration, new developments in upstream, things to consider when doing packaging for RDO and derived distributions, things upstream projects do wrong about configurations, and how to fix it. At the end, I will present configuration scheme Neutron RDO packages adopted in Kilo+, and suggest it for wider adoption by other projects.

## Debugging openstack with ansible and oslogmerger - *Miguel Angel Ajo*

[[Slides](http://mangelajo.github.io/openstack-debugging-presentation/)]

> Debugging across several openstack services, specially network issues, is becoming increasingly difficult. In this talk I plan to present a methodology for debugging live/production deployments, and development systems as well.

> Also, I will present the oslogmerger tool, which is capable of aggregating logs across several hosts and several services into a single linear one, making cross project/cross agents calls much more easy to follow.

## RPM factory for RDO - *Frederic Lepied*

> How to use an OpenStack like workflow to build RDO packages


