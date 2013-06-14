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

To add the schema to the Red Hat IDM database, first save the LDIF above into a text file in root's home directory on `ipa01`. Edit the file, replacing `dc=example,dc=com` with the correct domain suffix. Then load the schema with `ldapadd`:

    [root@ipa01 ~]# ldapadd -x -D"cn=Directory Manager" -W < openstack.ldif

You will be prompted for the Directory Manager password.

Next, create an "OpenStack Administrator" role with permission to edit that subtree. Before running these or any other `ipa` commands, authenticate as the IDM administrator using `kinit`:

    [root@ipa01 ~]# kinit admin
    [root@ipa01 ~]# ipa role-add --desc="OpenStack Administrator" "OpenStack Administrator"
    [root@ipa01 ~]# ipa permission-add "Manage OpenStack Tenants and Roles" \
     --subtree="ldap:///cn=openstack,dc=example,dc=com" \
     --permissions=write,add,delete \
     --attrs=member,roleOccupant
    [root@ipa01 ~]# ipa privilege-add "Manage OpenStack" --desc "Manage OpenStack Tenants and Roles"
    [root@ipa01 ~]# ipa privilege-add-permission "Manage OpenStack" \
      --permissions="Manage OpenStack Tenants and Roles"
    [root@ipa01 ~]# ipa role-add-privilege --privileges "Manage OpenStack" "OpenStack Administrator"

Last, create a group named `osadmins` with the role that was created above.

    [root@ipa01 ~]# ipa group-add --desc="OpenStack Admins" osadmins
    [root@ipa01 ~]# ipa role-add-member --groups=osadmins "OpenStack Administrator"

### Creating the OpenStack administrator account

User accounts in OpenStack will be drawn from the IDM user list. The following steps will create an initial administration account to use in creating the initial Keystone Tenants, Roles, and Service Catalog. An existing administrator or human account could be used as well - add the account to the `osadmins` group to inherit the "OpenStack Administrator" role which grants write access to the subtree.

    [root@ipa01 ~]# kinit admin
    [root@ipa01 ~]# ipa user-add
    First name: RDO
    Last name: Administrator
    User login [radministrator]: rdoadmin
    ---------------------
    Added user "rdoadmin"
    ---------------------
    [root@ipa01 ~]# ipa user-mod --email=rdoadmin@example.com rdoadmin
    [root@ipa01 ~]# ipa passwd rdoadm
    [root@ipa01 ~]# ipa group-add-member --users=rdoadmin osadmins

Next, add the user to the `enabled_users` group in the `cn=openstack` tree. Use the account which was added to the `osadmins` group to verify that the privilege was inherited correctly:

    [root@ipa01 ~]# ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    > dn: cn=enabled_users,cn=openstack,dc=example,dc=com
    > changetype: modify
    > add: member
    > member: uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com
    > 
    > EOF
    Enter LDAP Password: 
    modifying entry "cn=enabled_users,cn=openstack,dc=atl,dc=salab,dc=redhat,dc=com"

If the `ldapmodify` command does not succeed, troubleshoot the role, permission, and privilege created in the first step.

If using an existing IDM group to determine whether or not an account is "enabled" for OpenStack, the administrative user will need to be added to that group instead of `cn=enabled_users,cn=openstack`.

## Keystone Configuration

### Creating a keystone.conf

Install the Keystone software, create the MySQL database, create the service token, and populate the MySQL database using the instructions provided here:

<http://docs.openstack.org/grizzly/openstack-compute/install/yum/content/install-keystone.html>

After running `keystone-manage db_sync`, edit `/etc/keystone/keystone.conf`. In the `identity` section, comment out the SQL Identity driver and uncomment the LDAP driver:

    [identity]
    #driver = keystone.identity.backends.sql.Identity
    driver = keystone.identity.backends.ldap.Identity

Then, configure the `ldap` section to use the Red Hat IDM LDAP database.

    [ldap]
    url = ldap://ipa01.example.com
    user = uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com
    password = <password>
    suffix = cn=openstack,dc=example,dc=com
    use_dumb_member = False
    allow_subtree_delete = False
    # dumb_member = cn=dumb,dc=example,dc=com

    # Maximum results per page; a value of zero ('0') disables paging (default)
    # page_size = 0

    # The LDAP dereferencing option for queries. This can be either 'never',
    # 'searching', 'always', 'finding' or 'default'. The 'default' option falls
    # back to using default dereferencing configured by your ldap.conf.
    # alias_dereferencing = default

    # The LDAP scope for queries, this can be either 'one'
    # (onelevel/singleLevel) or 'sub' (subtree/wholeSubtree)
    # query_scope = one

    user_tree_dn = cn=users,cn=accounts,dc=example,dc=com
    # user_filter =
    user_objectclass = person
    #user_domain_id_attribute = businessCategory
    user_id_attribute = uid
    user_name_attribute = uid
    user_mail_attribute = mail
    # user_pass_attribute = userPassword
    # user_enabled_attribute = enabled
    # user_enabled_mask = 0
    # user_enabled_default = True
    user_attribute_ignore =  tenant_id,tenants
    user_allow_create = False
    user_allow_update = False
    user_allow_delete = False
    user_enabled_emulation = True
    user_enabled_emulation_dn = cn=enabled_users,cn=openstack,dc=example,dc=com

    tenant_tree_dn = ou=tenants,cn=openstack,dc=example,dc=com
    # tenant_filter =
    # tenant_objectclass = groupOfNames
    tenant_domain_id_attribute = businessCategory
    tenant_id_attribute = cn
    tenant_member_attribute = member
    # tenant_name_attribute = ou
    tenant_desc_attribute = description
    # tenant_enabled_attribute = enabled
    tenant_attribute_ignore =
    # tenant_allow_create = True
    # tenant_allow_update = True
    # tenant_allow_delete = True
    tenant_enabled_emulation = True
    tenant_enabled_emulation_dn = cn=enabled_tenants,cn=openstack,dc=example,dc=com

    role_tree_dn = ou=roles,cn=openstack,dc=example,dc=com
    # role_filter =
    # role_objectclass = organizationalRole
    # role_id_attribute = cn
    # role_name_attribute = ou
    # role_member_attribute = roleOccupant
    role_attribute_ignore =
    # role_allow_create = True
    # role_allow_update = True
    # role_allow_delete = True
