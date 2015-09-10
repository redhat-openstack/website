---
title: RDO Meetup, OpenStack Summit Vancouver
date: 2015-05-26 13:21:12
author: rbowen
---

On Thursday morning at the OpenStack Summit in Vancouver, roughly 60 RDO enthusiasts gathered to discuss a variety of topics around the RDO project. Officially we had just 40 minutes, but since we were followed by a coffee break, we went overtime by about 20 minutes, and there was still some hallway discussion following that.

![](https://lh5.googleusercontent.com/-vEtHoB0VaWw/VWSeAzcsSWI/AAAAAAAAK8s/Zi3dVmSHm2w/w937-h527-no/IMG_20150521_101851.jpg)

The complete agenda can be seen in the [meeting etherpad](https://etherpad.openstack.org/p/RDO_Vancouver). Highlights include:

* Perry Myers talked some about the packaging effort - the status, and where people can get involved in that. Several people in attendance expressed a desire to get more involved. There was also some talk about how we are going to handle packaging for Fedora in the future.

* Jaromir Coufal gave an overview of the [RDO-Manager](https://www.rdoproject.org/RDO-Manager) project, which is the effort to build an installer/manager for your RDO OpenStack cloud, based on TripleO and other OpenStack projects.

* There was some discussion around what will be included in future packaging of RDO - for example, whether it will include the newly minted projects such as [Murano](https://wiki.openstack.org/wiki/Murano), [Congress](https://wiki.openstack.org/wiki/Congress), [Mistral](https://wiki.openstack.org/wiki/Mistral), and so on. The consensus appears to be that this is up to who steps up to do that work, and so is another incentive to get more people involved in packaging.

* Karsten Wade gave an update on the CentOS infrastructure, including the recent release of [CentOS RDO package repositories](https://www.redhat.com/archives/rdo-list/2015-May/msg00209.html). Questions here include the relationship between these new repos and the existing RDO repos on repos.fedorapeople.org - the intent is that the repos on mirrors.centos.org will replace these. Karsten also talked about the CentOS project's plan for OpenStack/CentOS CI such that upgrades to CentOS never break OpenStack, and vice versa, if you use these repos.

* Following from this, there was discussion of the [CI infrastructure](https://ci.centos.org/view/rdo/) which is key to that decision. It was noted that other related projects, such as libvirt, are also using that infrastructure, which could lead to helpful cooperation between the projects.

* Dan Radez gave an overview of [OPNFV](https://www.opnfv.org/) and the plans to integrate it with RDO.

* Dan also talked about [TryStack](http://trystack.org/), and the plans to improve it in the months to come.

* In the coming weeks, this website will be migrating off of MediaWiki and Vanilla Forums, to a git-based system using [Middleman](https://middlemanapp.com/). This will make it easier for people to contribute to the content, and will also solve other persistent technical problems related the the current system, authentication, and URL mapping. It will also ensure better historical tracking of content. There was some discussion of plans to reorganize the content of the site to better facilitate community engagement.

* Given the quantity of topics, and the lack of time, we talked about trying to do a full-day event at FOSDEM, in conjunction with the CentOS Dojo there, where we could devote an hour to each topic, rather than cutting everyone off after 5 minutes.



All of the above items will be discussed further on the mailing list in the coming weeks. The meetup, while very valuable, wasn't long enough to do much more than start conversations and find interested people. Look for these conversations soon - or start one yourself if there's a topic that you're particular interested in.

Once again, a huge thanks to everyone that attended, and everyone that presented topics.
