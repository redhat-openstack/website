---
author: hguemar
title: RDO OpenStack Packaging Guidelines
---

# RDO OpenStack Packaging Guidelines
1. toc
{:toc}

## Introduction

This document collects guidelines and practical tips


## Packaging Guidelines

RDO packages mostly follow [Fedora Packaging Guidelines](https://fedoraproject.org/wiki/Packaging:Guidelines).
There are two exceptions:

 * Override rules listed in this document.
 * Exceptions granted by RDO Packaging Group (e.g. bundling)

A set of examples for spec and other useful files can be found in
[openstack-example-spec](https://github.com/openstack-packages/openstack-example-spec) github repository. These files can be used as templates for new packages although
some adjustments may be needed for each particular case.

## Package Naming Guidelines

RDO packages mostly follow [Fedora Package Naming Guidelines](https://fedoraproject.org/wiki/Packaging:Naming).
On top of it to maintain consistency in package names across different sets of RDO packages we follow:-

- For service package: name it like 'openstack-<service name>', ex. openstack-nova, openstack-cinder, etc.
- For python library: name it like 'python-<library name>', ex. python-oslo-cache, python-novaclient, etc.
- For puppet package: name it like 'puppet-<module name>', ex. puppet-nova, puppet-cinder, etc.
- For tempest plugin: name it like 'python-<tested service>-tests-tempest', ex. python-heat-tests-tempest, python-mistral-tests-tempest, etc.
- For ui package: name it like 'openstack-<service>-ui', ex. openstack-heat-ui, openstack-octavia-ui, etc.
- For ansible role: name it like 'ansible-role-<role name>', ex. ansible-role-container-registry, ansible-role-chrony, etc.
- For ansible collection: name it like 'ansible-collection-<collection-name>, ex. ansible-collection-containers-podman, etc.

**NOTE:** In case of python packages, srpms names should be prefixed with 'python-' and sub packages with 'python2-' or 'python3-'.

## RDO Guidelines

### Systemd packaging

* All services must be configured to allow automated restart

```bash
Restart=[on-failure|always]
```
* If a service depends on other for proper start, you can use the `After=` and
optionally `Requires=` parameters in unit configuration file. An example of
dependencies for neutron-openvswitch-agent service:

```bash
After=syslog.target network.target network.service openvswitch.service
Requires=openvswitch.service
```

* The systemd package provides a set of rpm macros to handle systemd operations
on %post, %preun and %postun (more details [here](https://fedoraproject.org/wiki/Packaging:Scriptlets#Systemd)).

### python packaging guidelines

* Remove requirements files used by pip to download dependencies from the network.
That may hide missing dependencies or integration issues (e.g. a dependency package only available in an incompatible version)

```bash
  rm -rf {,tests-}requirements.txt
```

* Use versioned python macros everywhere.

### Packages requirements

* Check your package dependencies with ```rdopkg reqcheck```.

* Versions for build requirements are not needed as the latest available version
will be always installed at build time by the packaging tools.

* Actual requirements for default or common configurations of services must be
added as explicit requires.

* Optional requirements for specific configurations must not be added as explicit
requires.

* When versioning of explicit requires is needed be aware that epoch is used in
some RDO packages. In those cases remember to add the epoch in the required
version as in:

```bash
Requires:         python-oslo-config >= 2:2.6.0
```

### Configuration files

* Use oslo-config-generator to generate configuration files.

```bash
oslo-config-generator --config-file=config-generator/keystone.conf
```

* Configuration files must be in /etc and not /usr/etc.

### Tests packaging

OpenStack projects provide different tests including unit tests and functional
tests, typically using the tempest framework.

* Core packages shouldn't include tests as are not required in runtime.

* Unit tests should be included in a &lt;package name>-tests-unit package that
should depend on the test requirements.

* Tempest tests should be included in a &lt;package name>-tests-tempest package
which should depend on the dependencies to run the provided tests. Note that
some projects include tempest tests in the main project git repository (so tempest
package would be a subpackage in the same spec file) while others use a separate
git repository (so a specific distgit and spec will be needed).

* &lt;package name>-tests: includes all tests, and should be a virtual package
requiring &lt;package name>-tests-tempest and &lt;package name>-tests-unit.

### Other considerations

* To enforce consistency accross OpenStack services packages, use the following snippet to set upstream project name.

```bash
%global service keystone
```

RDO project provides different examples specs in
[openstack-example-spec](https://github.com/openstack-packages/openstack-example-spec)
for the different package types (OpenStack service, library, client, dashboard
plugin, etc...). This examples can be used as templates for new packages being
added to RDO repositories.

### Patches

RDO is and intends to remain a vanilla distribution of OpenStack.
Our default policy is to refuse downstream patches, but RDO Packaging Group may grant
exceptions on per-case basis

* Feature patches: must be submitted upstream

* Security patches: requires RDO Security team clearance.

* FTBFS patches: requires peer review, and must be submitted upstream when possible.
