---
title: Keystone integration with IDM
authors: admiyo, dneary, msolberg, rcritten
wiki_title: Keystone integration with IDM
wiki_revision_count: 25
wiki_last_updated: 2014-04-17
---

# Keystone integration with IDM

## Overview

This page describes a possible Keystone and Red Hat IDM integration scenario. There are many possible ways to integrate the two technologies. This scenario meets the following requirements:

*   Keystone Accounts, Tenants, and Roles are stored in the Red Hat IDM database.
*   User accounts are managed by Red Hat IDM.
*   Tenants and Roles are managed by Keystone.
*   The Keystone service catalog is stored in MySQL.

Roles and privileges are created so that a Keystone administrator (or service) can not inadvertantly write to objects in the standard Red Hat IDM tree.

This page does not yet cover creating Host or Service objects in Red Hat IDM for OpenStack.

## Example Architecture

In this example, two systems will be used. The first (`ipa01`) is an IDM master server. Information on initial installation and configuration of the IDM software is here:

<https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Identity_Management_Guide/installing-ipa.html>

The second system (`keystone`) is a RDO Keystone server. Information on the initial installation and configuration of Keystone is here:

<http://docs.openstack.org/grizzly/openstack-compute/install/yum/content/ch_installing-openstack-identity-service.html>

This guide assumes a manual installation of RDO and its services (i.e. not using packstack).

## IDM Preparation

Either install Red Hat IDM from scratch or start with an existing Red Hat IDM directory. In this example, we have an existing directory rooted at `dc=example,dc=com` User accounts are stored in `cn=users,cn=accounts,dc=example,dc=com` as per the default.

### Install the Keystone schema

Keystone will pull user account information from `cn=users,cn=accounts`, but we'll configure it to store Tenants and Roles in `cn=openstack`. This allows us to grant permission to that tree while restricting permissions to the standard tree. The following schema needs to be imported to support Keystone:

    dn: cn=openstack,dc=example,dc=com
    objectClass: top
    objectClass: nsContainer
    cn: openstack

    dn: cn=enabled_users,cn=openstack,dc=example,dc=com
    objectClass: groupOfNames
    objectClass: top
    cn: enabled_users

    dn: ou=tenants,cn=openstack,dc=example,dc=com
    objectClass: top
    objectClass: organizationalUnit
    ou: tenants

    dn: cn=enabled_tenants,cn=openstack,dc=example,dc=com
    objectClass: groupOfNames
    objectClass: top
    cn: enabled_tenants

    dn: ou=roles,cn=openstack,dc=example,dc=com
    objectClass: top
    objectClass: organizationalUnit
    ou: roles

The `enabled_users` and `enabled_tenants` groups are used to emulate the "enabled" attribute, since it is unsupported in Red Hat IDM's default schema. It is possible to use any groupOfNames for the "enabled emulation" feature. Implementations may wish to use an existing group in IDM instead. For example, using the `cn=ipausers,cn=groups,cn=accounts,dc=example,dc=com` group will automatically "enable" all IDM users in Keystone.
