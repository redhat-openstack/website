---
title: RDO Pike released
author: rbowen
date: 2017-08-30 15:00:00 UTC
tags: release,pike,rdo,openstack,upstream
comments: true
published: false
---

The RDO community is pleased to announce the general availability of the RDO build for OpenStack Pike for RPM-based distributions, CentOS Linux 7 and Red Hat Enterprise Linux.
RDO is suitable for building private, public, and hybrid clouds. Pike is the 16th release from the [OpenStack project](http://openstack.org), which is the work of more than 2300 contributors from around the world ([source](http://stackalytics.com/)).

The [RDO community project](https://www.rdoproject.org/) curates, packages, builds, tests and maintains a complete OpenStack component set for RHEL and CentOS Linux and is a member of the [CentOS Cloud Infrastructure SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud).
The Cloud Infrastructure SIG focuses on delivering a great user experience for CentOS Linux users looking to build and maintain their own on-premise, public or hybrid clouds.

All work on RDO, and on the downstream release, Red Hat OpenStack Platform, is 100% open source, with all code changes going upstream first.

## New and Improved

Interesting things in the Pike release include:

- [Ironic](https://github.com/openstack/ironic) now supports [booting from Cinder volumes](https://docs.openstack.org/ironic/pike/admin/boot-from-volume.html), [rolling upgrades](https://docs.openstack.org/ironic/pike/admin/upgrade-guide.html#rolling-upgrades) and [Redfish protocol](https://docs.openstack.org/ironic/pike/admin/drivers/redfish.html).
- We added OVN support to Packstack.
- We added support to install the Horizon plugins for several services in Packstack.

## Added/Updated packages

The following packages and services were added or updated in this
release:

- [Kuryr](https://github.com/openstack/kuryr) and [Kuryr-kubernetes](https://github.com/openstack/kuryr-kubernetes): an integration between OpenStack and Kubernetes networking.
- [Senlin](https://github.com/openstack/senlin): a clustering service for OpenStack clouds.
- [Shade](https://github.com/openstack-infra/shade): a simple client library for interacting with OpenStack clouds, used by Ansible among others.
- [python-pankoclient](https://github.com/openstack/python-pankoclient):  a client library for the event storage and REST API for Ceilometer.
- [python-scciclient](https://github.com/openstack/python-scciclient): a ServerView Common Command Interface Client Library, for the FUJITSU iRMC S4 - integrated Remote Management Controller.

Other additions include:

### Python Libraries

* os-xenapi
* ovsdbapp (deps)
* python-daiquiri (deps)
* python-deprecation (deps)
* python-exabgp
* python-json-logger (deps)
* python-netmiko (deps)
* python-os-traits
* python-paunch
* python-scciclient
* python-scrypt  (deps)
* python-sphinxcontrib-actdiag (deps) (pending)
* python-sphinxcontrib-websupport (deps)
* python-stestr (deps)
* python-subunit2sql  (deps)
* python-sushy
* shade (SDK)
* update XStatic packages (update)
* update crudini to 0.9 (deps) (update)
* upgrade liberasurecode and pyeclib libraries to 1.5.0 (update) (deps)

### Tempest Plugins

* python-barbican-tests-tempest
* python-keystone-testst-tempest
* python-kuryr-tests-tempest
* python-patrole-tests-tempest
* python-vmware-nsx-tests-tempest
* python-watcher-tests-tempest

###  Puppet-Modules

* puppet-murano
* puppet-veritas_hyperscale
* puppet-vitrage

###  OpenStack Projects

* kuryr
* kuryr-kubernetes
* openstack-glare
* openstack-panko
* openstack-senlin

### OpenStack Clients

* mistral-lib
* python-glareclient
* python-pankoclient
* python-senlinclient

## Contributors

During the Pike cycle, we started the
[EasyFix](https://github.com/redhat-openstack/easyfix) initiative, which
has resulted in several new people joining our ranks. These include:

* Christopher Brown
* Anthony Chow
* T. Nicole Williams
* Ricardo Arguello

But, we wouldn't want to overlook anyone. Thank you to all 172
contributors who participated in producing this release:

Aditya Prakash Vaja, Alan Bishop, Alan Pevec, Alex Schultz, Alexander Stafeyev, Alfredo Moralejo, Andrii Kroshchenko, Anil, Anonymous Coward, Antoni Segura Puimedon, Arie Bregman, Assaf Muller, Ben Nemec, Bernard Cafarelli, Bogdan Dobrelya, Brent Eagles, Brian Haley, Carlos Gonçalves, Chandan Kumar, Christian Schwede, Christopher Brown, Damien Ciabrini, Dan Radez, Daniel Alvarez, Daniel Farrell, Daniel Mellado, David Moreau Simard, Derek Higgins, Doug Hellmann, Dougal Matthews, Edu Alcañiz, Eduardo Gonzalez, Elise Gafford, Emilien Macchi, Eric Harney, Eyal, Feng Pan, Frederic Lepied, Frederic Lepied, Garth Mollett, Gaël Chamoulaud, Giulio Fidente, Gorka Eguileor, Hanxi Liu, Harry Rybacki, Honza Pokorny, Ian Main, Igor Yozhikov, Ihar Hrachyshka, Jakub Libosvar, Jakub Ruzicka, Janki, Jason E. Rist, Jason Joyce, Javier Peña, Jeffrey Zhang, Jeremy Liu, Jiří Stránský, Johan Guldmyr, John Eckersberg, John Fulton, John R. Dennis, Jon Schlueter, Juan Antonio Osorio, Juan Badia Payno, Julie Pichon, Julien Danjou, Karim Boumedhel, Koki Sanagi, Lars Kellogg-Stedman, Lee Yarwood, Leif Madsen, Lon Hohberger, Lucas Alvares Gomes, Luigi Toscano, Luis Tomás, Luke Hinds, Martin André, Martin Kopec, Martin Mágr, Matt Young, Matthias Runge, Michal Pryc, Michele Baldessari, Mike Burns, Mike Fedosin, Mohammed Naser, Oliver Walsh, Parag Nemade, Paul Belanger, Petr Kovar, Pradeep Kilambi, Rabi Mishra, Radomir Dopieralski, Raoul Scarazzini, Ricardo Arguello, Ricardo Noriega, Rob Crittenden, Russell Bryant, Ryan Brady, Ryan Hallisey, Sarath Kumar, Spyros Trigazis, Stephen Finucane, Steve Baker, Steve Gordon, Steven Hardy, Suraj Narwade, Sven Anderson, T. Nichole Williams, Telles Nóbrega, Terry Wilson, Thierry Vignaud, Thomas Hervé, Thomas Morin, Tim Rozet, Tom Barron, Tony Breeds, afazekas, danpawlik, dnyanmpawar, hamzy, inarotzk, j-zimnowoda, kamleshp, marios, mdbooth, michaelhenkel, mkolesni, numansiddique, pawarsandeepu, prateek1192, ratailor, shreshtha90, vakwetu, vtas-hyperscale-ci, yrobla, zhangguoqing, Vladislav Odintsov, Xin Wu, XueFengLiu, Yatin Karel, Yedidyah Bar David, adriano petrich, bcrochet, changzhi, diana, djipko, dprince, dtantsur, eggmaster, eglynn, elmiko, flaper87, gpocentek, gregswift, hguemar, jason guiditta, jprovaznik, mangelajo, marcosflobo, morsik, nmagnezi, sahid, sileht, slagle, trown, vkmc, wes hayutin, xbezdick, zaitcev, and zaneb.


## Getting Started

There are three ways to get started with RDO.

- To spin up a proof of concept cloud, quickly, and on limited hardware, try an [All-In-One Packstack](https://www.rdoproject.org/install/packstack/) installation. You can run RDO on a single node to get a feel for how it works.
- For a production deployment of RDO, use the [TripleO Quickstart](https://www.rdoproject.org/tripleo/) and you'll be running a production cloud in short order.
- Finally, if you want to try out OpenStack, but don't have the time or hardware to run it yourself, visit [TryStack](http://trystack.org/), where you can use a free public OpenStack instance, running RDO packages, to experiment with the OpenStack management interface and API, launch instances, configure networks, and generally familiarize yourself with OpenStack. (TryStack is not, at this time, running Pike, although it is running RDO.)


## Getting Help
    
The RDO Project participates in a Q&A service at [ask.openstack.org](http://ask.openstack.org), for more developer-oriented content we recommend joining the [rdo-list mailing list](https://www.redhat.com/mailman/listinfo/rdo-list). Remember to post a brief introduction about yourself and your RDO story. You can also find extensive documentation on the [RDO docs site](https://www.rdoproject.org/use).

The #rdo channel on Freenode IRC is also an excellent place to find help and give help.

We also welcome comments and requests on the [CentOS mailing lists](https://lists.centos.org/) and the CentOS and TripleO IRC channels (#centos, #centos-devel, and #tripleo on irc.freenode.net), however we have a more focused audience in the RDO venues.


## Getting Involved

To get involved in the OpenStack RPM packaging effort, see the [RDO community pages](https://www.rdoproject.org/contribute/) and the [CentOS Cloud SIG page](https://wiki.centos.org/SpecialInterestGroup/Cloud). See also the [RDO packaging documentation](https://www.rdoproject.org/packaging/).

Join us in #rdo on the Freenode IRC network, and follow us at [@RDOCommunity](http://twitter.com/rdocommunity) on Twitter. If you prefer Facebook, [we're there too](http://facebook.com/rdocommunity), and also [Google+](http://tm3.org/rdogplus).
