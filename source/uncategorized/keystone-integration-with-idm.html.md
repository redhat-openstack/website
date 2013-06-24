---
title: Keystone integration with IDM
authors: admiyo, dneary, msolberg, rcritten
wiki_title: Keystone integration with IDM
wiki_revision_count: 25
wiki_last_updated: 2014-04-17
---

# Keystone integration with IDM

__NOTOC__

## Overview

This page describes a possible Keystone and Red Hat IdM integration scenario. There are many possible ways to integrate the two technologies. This scenario meets the following requirements:

*   Keystone Accounts, Tenants, and Roles are stored in the Red Hat IdM database.
*   User accounts are managed by Red Hat IdM.
*   Tenants and Roles are managed by Keystone.
*   The Keystone service catalog is stored in MySQL.

Roles and privileges are created so that a Keystone administrator (or service) can not inadvertantly write to objects in the standard Red Hat IdM tree.

## Example Architecture

In this example, two systems will be used. The first (`ipa01`) is an IdM master server. Information on initial installation and configuration of the IdM software is here:

<https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Identity_Management_Guide/installing-ipa.html>

The second system (`keystone`) is a RDO Keystone server. Information on the initial installation and configuration of Keystone is here:

<http://docs.openstack.org/grizzly/openstack-compute/install/yum/content/ch_installing-openstack-identity-service.html>

This guide assumes a manual installation of RDO and its services (i.e. not using packstack).

## IdM Preparation

Either install Red Hat IdM from scratch or start with an existing Red Hat IdM directory. In this example, we have an existing directory rooted at `dc=example,dc=com` User accounts are stored in `cn=users,cn=accounts,dc=example,dc=com` as per the default.

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

The `enabled_users` and `enabled_tenants` groups are used to emulate the "enabled" attribute, since it is unsupported in Red Hat IdM's default schema. It is possible to use any groupOfNames for the "enabled emulation" feature. Implementations may wish to use an existing group in IdM instead. For example, using the `cn=ipausers,cn=groups,cn=accounts,dc=example,dc=com` group will automatically "enable" all IdM users in Keystone.

To add the schema to the Red Hat IdM database, first save the LDIF above into a text file in root's home directory on `ipa01`. Edit the file, replacing `dc=example,dc=com` with the correct domain suffix. Then load the schema with `ldapadd`:

    [admin@ipa01 ~]$ ldapadd -x -D"cn=Directory Manager" -W < openstack.ldif

You will be prompted for the Directory Manager password.

Next, create an "OpenStack Administrator" role with permission to edit that subtree. Before running these or any other `ipa` commands, authenticate to IdM as a user which has administrative privileges.

    [admin@ipa01 ~]$ ipa role-add --desc="OpenStack Administrator" "OpenStack Administrator"
    [admin@ipa01 ~]$ ipa permission-add "Manage OpenStack Tenants and Roles" \
     --subtree="ldap:///cn=openstack,dc=example,dc=com" \
     --permissions=write,add,delete \
     --attrs=member,roleOccupant
    [admin@ipa01 ~]$ ipa privilege-add "Manage OpenStack" --desc "Manage OpenStack Tenants and Roles"
    [admin@ipa01 ~]$ ipa privilege-add-permission "Manage OpenStack" \
      --permissions="Manage OpenStack Tenants and Roles"
    [admin@ipa01 ~]$ ipa role-add-privilege --privileges "Manage OpenStack" "OpenStack Administrator"

Last, create a group named `osadmins` with the role that was created above.

    [admin@ipa01 ~]$ ipa group-add --desc="OpenStack Admins" osadmins
    [admin@ipa01 ~]$ ipa role-add-member --groups=osadmins "OpenStack Administrator"

### Creating the OpenStack administrator account

User accounts in OpenStack will be drawn from the IdM user list. The following steps will create an initial administration account to use in creating the initial Keystone Tenants, Roles, and Service Catalog. An existing administrator or human account could be used as well - add the account to the `osadmins` group to inherit the "OpenStack Administrator" role which grants write access to the subtree.

    [admin@ipa01 ~]$ ipa user-add
    First name: RDO
    Last name: Administrator
    User login [radministrator]: rdoadmin
    ---------------------
    Added user "rdoadmin"
    ---------------------
    [admin@ipa01 ~]$ ipa user-mod --email=rdoadmin@example.com rdoadmin
    [admin@ipa01 ~]$ ipa passwd rdoadm
    [admin@ipa01 ~]$ ipa group-add-member --users=rdoadmin osadmins

Next, add the user to the `enabled_users` group in the `cn=openstack` tree. Use the account which was added to the `osadmins` group to verify that the privilege was inherited correctly:

    [admin@ipa01 ~]$ ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    > dn: cn=enabled_users,cn=openstack,dc=example,dc=com
    > changetype: modify
    > add: member
    > member: uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com
    > 
    > EOF
    Enter LDAP Password: 
    modifying entry "cn=enabled_users,cn=openstack,dc=example,dc=com"

If the `ldapmodify` command does not succeed, troubleshoot the role, permission, and privilege created in the first step.

If using an existing IdM group to determine whether or not an account is "enabled" for OpenStack, the administrative user will need to be added to that group instead of `cn=enabled_users,cn=openstack`.

## Keystone Configuration

### Creating a keystone.conf

Install the Keystone software, create the MySQL database, create the service token, and populate the MySQL database using the instructions provided here:

<http://docs.openstack.org/grizzly/openstack-compute/install/yum/content/install-keystone.html>

After running `keystone-manage db_sync`, edit `/etc/keystone/keystone.conf`. In the `identity` section, comment out the SQL Identity driver and uncomment the LDAP driver:

    [identity]
    #driver = keystone.identity.backends.sql.Identity
    driver = keystone.identity.backends.ldap.Identity

Then, configure the `ldap` section to use the Red Hat IdM LDAP database.

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

Change the above suffixes to reflect the IdM installation (i.e. dc=example,dc=com). Note that this configuration uses the `rdoadmin` account created above to authenticate Keystone to IPA. If a different account was created for that purpose above, change the `user` and `password` value in the configuration file.

Here are some possible variations on the configuration values above:

*   The `user_id_attribute` and `user_name_attribute` could be mapped to other LDAP attributes in IdM. For example, to get a UUID for a user_id, `user_id_attribute` could be set to the `ipaUniqueId` attribute. The `uidNumber` attribute would be another good candidate for the `user_id_attribute` mapping. To get human readible user names, the `user_name_attribute` could be mapped to the `cn` attribute. Note that most authentication and role assignments are performed against the user <em>name</em> and not the user <em>id</em>. In most installations, both `user_id_attribute` and `user_id_attribute` should be set to `uid`.
*   As discussed above, the `user_enabled_emulation_dn` setting could be assigned to an existing IdM group. This simplifies new OpenStack account creation somewhat.

### Testing the configuration

Once the `keystone.conf` file has the correct mappings to the IdM database, restart the `openstack-keystone` service. Set the `SERVICE_TOKEN` and `SERVICE_ENDPOINT` environment variables to match the settings in `keystone.conf`:

    [root@keystone ~]# export SERVICE_TOKEN=012345SECRET99TOKEN012345
    [root@keystone ~]# export SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/

If the LDAP mappings are correct in `keystone.conf`, the `user-list` command should show the list of users in the IdM database, including the one we enabled above.

    [root@keystone ~]# keystone user-list
    +------------+------------+---------+-------------------------------+
    |     id     |    name    | enabled |             email             |
    +------------+------------+---------+-------------------------------+
    |   admin    |   admin    |  False  |                               |
    ....
    |  rdoadmin  |  rdoadmin  |   True  | rdoadmin@example.com |
    ...
    +------------+------------+---------+-------------------------------+

If keystone returns a 401 error or a 404 error, confirm the settings in `/etc/keystone/keystone.conf`. Also consider setting `debug = True` in the `[DEFAULT]` section. This will print the actual LDAP queries being run against the IdM server and their return codes in `/var/log/keystone/keystone.log`.

### Creating Tenants and Roles

Next, create the initial set of Tenants for OpenStack users and services to use. The following examples use the Tenant names from the OpenStack installation guide:

    [root@keystone ~]# keystone tenant-create --name demo --description "Default Tenant"
    [root@keystone ~]# keystone tenant-create --name service --description "Service Tenant"

Verify that the tenants were created:

    [root@keystone ~]# keystone tenant-list
    +----------------------------------+---------+---------+
    |                id                |   name  | enabled |
    +----------------------------------+---------+---------+
    | 573429b5b7cc4312b981117890c1e9d8 |  demo   |   True  |
    | a459741dfa8f4a8cb74306f001c564e3 | service |   True  |
    +----------------------------------+---------+---------+

Once the initial tenants have been created, add the `rdoadmin` user to the `demo` tenant on the IdM server:

    [admin@ipa01 ~]$ ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    dn: cn=573429b5b7cc4312b981117890c1e9d8,ou=tenants,cn=openstack,dc=example,dc=com
    changetype: modify
    add: member
    member: uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com
    EOF

    Enter LDAP Password: 
    modifying entry "cn=573429b5b7cc4312b981117890c1e9d8,ou=tenants,cn=openstack,dc=example,dc=com"

Next, create the initial set of Roles for OpenStack users and services to use back on the `keystone` server. The following examples create an `admin` and `user` role.

    [root@keystone ~]# keystone role-create --name admin
    [root@keystone ~]# keystone role-create --name user
    [root@keystone ~]# keystone role-list
    +----------------------------------+-------+
    |                id                |  name |
    +----------------------------------+-------+
    | d797691eb43640adb401c9b698fb4cef | admin |
    | 69dd03c5b0fb43c38da33c0af7b52cfc |  user |
    +----------------------------------+-------+

Lastly, grant the `admin` role to the OpenStack Administrator account in the demo Tenant:

    [root@keystone]# keystone user-role-add --user-id rdoadmin --tenant-id 573429b5b7cc4312b981117890c1e9d8 --role-id d797691eb43640adb401c9b698fb4cef

To test, create a `keystonerc_rdoadmin` file with the following contents:

    export OS_USERNAME=rdoadmin
    export OS_TENANT_NAME=demo
    export OS_PASSWORD=<password>
    export OS_AUTH_URL=http://10.17.12.12:35357/v2.0/
    export PS1='[\u@\h \W(keystone_admin)]$ '

Initiate a new shell session on `keystone` without the `SERVICE_TOKEN` environment variable set, source the `keystonerc_rdoadmin` script and then test retrieving a token:

    [root@keystone ~(keystone_admin)]# keystone token-get
    +-----------+----------------------------------+
    |  Property |              Value               |
    +-----------+----------------------------------+
    |  expires  |       2013-06-15T02:15:17Z       |
    |     id    | a6a8fd0ac3c443dd9425489a4990be3b |
    | tenant_id | 573429b5b7cc4312b981117890c1e9d8 |
    |  user_id  |             rdoadmin             |
    +-----------+----------------------------------+

The `rdoadmin` user should also be able to list all users as it was granted the `admin` role:

    [root@keystone ~(keystone_admin)]# keystone user-list
    +------------+------------+---------+-------------------------------+
    |     id     |    name    | enabled |             email             |
    +------------+------------+---------+-------------------------------+
    |   admin    |   admin    |  False  |                               |
    ....
    |  rdoadmin  |  rdoadmin  |   True  | rdoadmin@example.com |
    ...
    +------------+------------+---------+-------------------------------+

## Creating Service Users

The glance, nova, ec2, cinder, and swift services all have service accounts in IdM to authenticate to Keystone. To create these accounts, use the following proceedure:

*   Create the user account in IdM

<!-- -->

    [admin@ipa01 ~]$ ipa user-add glance --cn=glance --first=glance --last=service
    -------------------
    Added user "glance"
    -------------------
      User login: glance
      First name: glance
      Last name: service
      Full name: glance
      Display name: glance service
      Initials: gs
      Home directory: /home/glance
      GECOS field: glance service
      Login shell: /bin/sh
      Kerberos principal: glance@EXAMPLE.COM
      UID: 1840200016
      GID: 1840200016
      Password: False
      Kerberos keys available: False

*   Set the user's password

<!-- -->

    [admin@ipa01 ~]$ ipa passwd glance
    New Password: 
    Enter New Password again to verify: 
    --------------------------------------------------
    Changed password for "glance@EXAMPLE.COM"
    --------------------------------------------------
    [admin@ipa01 ~]$ kinit glance@EXAMPLE.COM
    Password for glance@EXAMPLE.COM: 
    Password expired.  You must change it now.
    Enter new password: 
    Enter it again: 

*   Add the user to the `enabled_users` group in the `cn=openstack` subtree

<!-- -->

    [admin@ipa01 ~]$ ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    > dn: cn=enabled_users,cn=openstack,dc=example,dc=com
    > changetype: modify
    > add: member
    > member: uid=glance,cn=users,cn=accounts,dc=example,dc=com
    > EOF
    Enter LDAP Password: 
    modifying entry "cn=enabled_users,cn=openstack,dc=example,dc=com"

*   Add the user to the `service` tenant in the `cn=openstack` subtree

<!-- -->

    [admin@ipa01 ~]$ ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    > dn: cn=a459741dfa8f4a8cb74306f001c564e3,ou=tenants,cn=openstack,dc=example,dc=com
    > changetype: modify
    > add: member
    > member: uid=glance,cn=users,cn=accounts,dc=example,dc=com
    > EOF
    Enter LDAP Password: 
    modifying entry "cn=a459741dfa8f4a8cb74306f001c564e3,ou=tenants,cn=openstack,dc=example,dc=com"

*   Add the `admin` role to the user account in the `service` tenant.

<!-- -->

    [root@keystone ~]# keystone user-role-add --user-id glance --tenant-id a459741dfa8f4a8cb74306f001c564e3 --role-id d797691eb43640adb401c9b698fb4cef

Repeat this process with each of the other services which will be enabled in this OpenStack instance. For each of those services, edit the appropriate configuration file and set the `keystone_authtoken` attributes to match the IdM user account. For example:

    [keystone_authtoken]
    auth_host = <your keystone IP>
    auth_port = 35357
    auth_protocol = http
    admin_tenant_name = service
    admin_user = glance
    admin_password = <password>

## Populating the Service Catalog

The last step in Keystone configuration is to populate the Service Catalog. In this example, services are stored in the MySQL database. The following page describes the population of the Service Catalog:

<http://docs.openstack.org/grizzly/openstack-compute/install/yum/content/keystone-service-endpoint-create.html>

## Managing User Accounts

### Granting OpenStack privileges to an existing Red Hat IdM user

To grant privileges to an existing IdM user, use the following process:

*   Add the account to the OpenStack enabled_users group:

<!-- -->

    [admin@ipa01 ~]$ ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    > dn: cn=enabled_users,cn=openstack,dc=example,dc=com
    > changetype: modify
    > add: member
    > member: uid=msolberg,cn=users,cn=accounts,dc=example,dc=com
    > EOF
    Enter LDAP Password: 
    modifying entry "cn=enabled_users,cn=openstack,dc=example,dc=com"

*   Add the account to the appropriate tenant

<!-- -->

    [admin@ipa01 ~]$ ldapmodify -x -D"uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com" -W <<EOF
    dn: cn=573429b5b7cc4312b981117890c1e9d8,ou=tenants,cn=openstack,dc=example,dc=com 
    changetype: modify
    add: member                                                               
    member: uid=msolberg,cn=users,cn=accounts,dc=example,dc=com
    EOF

    Enter LDAP Password: 
    modifying entry "cn=573429b5b7cc4312b981117890c1e9d8,ou=tenants,cn=openstack,dc=example,dc=com"

*   Add the the appropriate role to the tenant in Keystone

<!-- -->

    [root@keystone ~]# keystone user-role-add --user-id msolberg --tenant-id 573429b5b7cc4312b981117890c1e9d8 --role-id 69dd03c5b0fb43c38da33c0af7b52cfc

## Securing OpenStack Services

By default, communication between the services which comprise RDO is not encrypted or authenticated. The following steps walk through creating certificates for these services using the Red Hat IdM certificate infrastructure. It is assumed that each service is already configured as per the OpenStack Installation Guide:

<http://docs.openstack.org/grizzly/openstack-compute/install/yum/content/>

### Securing Horizon

OpenStack end users communicate with the Horizon dashbard over HTTP using a web browser. The following steps will encrypt that communication:

*   Join the host to IdM (if you haven't already)

<!-- -->

    [root@dashboard]# yum -y install ipa-client
    [root@dashboard]# ipa-client-install

*   Test IdM

<!-- -->

    [root@dashboard]# getent group ipausers

*   On the IdM server, create a service principal for the host, substituting the hostname of the service which runs the dashboard:

<!-- -->

    [admin@ipa01]$ ipa service-add HTTP/dashboard.example.com

*   On the dashboard host, install mod_ssl on the system:

<!-- -->

    [root@dashboard ~]# yum -y install mod_ssl

*   Request a web certificate

<!-- -->

    [root@dashboard ~]# ipa-getcert request -r -f /etc/pki/tls/certs/`hostname -s`-http.crt -k /etc/pki/tls/private/`hostname -s`-http.key -N CN=`hostname --fqdn` -D `hostname` -U id-kp-serverAuth -K HTTP/`hostname --fqdn`

*   Edit ssl.conf and point httpd to the new cert and key:

<!-- -->

    [root@dashboard ~]# vi /etc/httpd/conf.d/ssl.conf

*   Configure it like:

<!-- -->

    SSLCertificateFile /etc/pki/tls/certs/<host>-http.crt
    SSLCertificateKeyFile /etc/pki/tls/private/<host>-http.key
    SSLCertificateChainFile /etc/ipa/ca.crt

*   Optionally create a VirtualHost entry which redirects clients to the SSL. Substitute the hostname of the server running the dashboard in this example.

<!-- -->

    [root@dashboard ~]# cat >> /etc/httpd/conf.d/redirect.conf <<EOF
    > NameVirtualHost *:80
    > <VirtualHost *:80>
    >    ServerName dashboard.example.com
    >    Redirect permanent / https://dashboard.example.com/
    > </VirtualHost>
    EOF

*   Restart apache

<!-- -->

    [root@dashboard ~]# service httpd restart

Requests to the web service on dashboard.example.com now be redirected to the SSL virtual host on that server. Ensure that the certificate presented to the web browser is valid and signed by the IdM master server.

## Securing MySQL (WIP)

*   On the IdM server, create a service principal for the host, substituting the hostname of the server running MySQL:

<!-- -->

    [admin@ipa01]$ ipa service-add mysql/mysql.example.com

*   Request a certificate

<!-- -->

    [root@mysql ~]# ipa-getcert request -r -f /etc/pki/tls/certs/`hostname -s`-mysql.crt -k /etc/pki/tls/private/`hostname -s`-mysql.key -N CN=`hostname --fqdn` -D `hostname` -U id-kp-serverAuth -K mysql/`hostname --fqdn`

*   Edit /etc/my.conf and point mysqld to the new cert and key:

<!-- -->

    [client]
    ssl_ca=/etc/ipa/ca.crt
    ...
    [mysqld]
    ssl_ca=/etc/ipa/ca.crt
    ssl_cert=/etc/pki/tls/certs/<host>-mysql.crt
    ssl-key=/etc/pki/tls/private/<host>-mysql.key

*   Restart mysqld:

<!-- -->

    [root@mysql ~]# service mysqld restart

*   Test that SSL is working:

<!-- -->

    [root@mysql ~]# mysql -e "\s"
    --------------
    mysql  Ver 14.14 Distrib 5.5.31, for Linux (x86_64) using readline 5.1

    Connection id:          487
    Current database:
    Current user:           root@localhost
    SSL:                    Cipher in use is DHE-RSA-AES256-SHA
    Current pager:          stdout
    Using outfile:          ''
    Using delimiter:        ;
    Server version:         5.5.31 MySQL Community Server (GPL)
    Protocol version:       10
    Connection:             Localhost via UNIX socket
    Server characterset:    latin1
    Db     characterset:    latin1
    Client characterset:    utf8
    Conn.  characterset:    utf8
    UNIX socket:            /var/lib/mysql/mysql.sock
    Uptime:                 2 sec

    Threads: 10  Questions: 791702  Slow queries: 0  Opens: 91  Flush tables: 1  Open tables: 84  Queries per second avg: 4.800

*   Configure the OpenStack services to use SSL. Set the SQL connection (either connection or sql_connection, depending on the service) . **Note**: that this also changes from addressing the host by IP address to FQDN:

<!-- -->

    connection = mysql://keystone_admin:a3a9e1219b81473e@mysql.example.com/keystone?ssl_ca=/etc/ipa/ca.crt

*   To these files:
    -   /etc/glance/glance-api.conf
    -   /etc/glance/glance-registry.conf
    -   /etc/cinder/cinder.conf
    -   /etc/nova/nova.conf
    -   /etc/keystone/keystone.conf

<!-- -->

*   Restart the services:

<!-- -->

    [root@mysql ~]# service openstack-glance-api restart
    [root@mysql ~]# service openstack-glance-registry restart
    [root@mysql ~]# service openstack-cinder restart
    [root@mysql ~]# service openstack-nova-api restart
    [root@mysql ~]# service openstack-nova-cert restart
    [root@mysql ~]# service openstack-nova-compute restart
    [root@mysql ~]# service openstack-nova-conductor restart
    [root@mysql ~]# service openstack-nova-consoleauth restart
    [root@mysql ~]# service openstack-nova-network restart
    [root@mysql ~]# service openstack-nova-novncproxy restart
    [root@mysql ~]# service openstack-nova-scheduler restart
    [root@mysql ~]# service openstack-keystone restart

## Securing Keystone

When a server joins an IdM domain, the OpenLDAP client libraries are configured to communicate with the IdM server over LDAPS. To verify that the system has been configured correctly, check `/etc/openldap/ldap.conf`. It should contain a reference to a certificate file:

     [root@keystone]# cat /etc/openldap/ldap.conf
    #File modified by ipa-client-install

    URI ldaps://ipa01.example.com
    BASE dc=example,dc=com
    TLS_CACERT /etc/ipa/ca.crt

If this is configured correctly, the connection between Keystone and the IdM server can be encrypted by changing the protocol from `ldap://` to `ldaps://` in `/etc/keystone/keystone.conf`. For example:

    [ldap]
    url = ldaps://ipa01.example.com
    user = uid=rdoadmin,cn=users,cn=accounts,dc=example,dc=com
    ...

Support for LDAP with StartTLS in Keystone should be available in the Havana release. That functionality can be tracked here: <https://bugs.launchpad.net/keystone/+bug/1040115>

## Other Considerations

*   The default password policy for IdM users requires them to change their password every 90 days. This will wreak havok upon most OpenStack environments. To mitigate this, create a "Service Account" group in IdM and assign a new password policy to that group. Add cinder, nova, etc. to that group.
*   In the same vein, the account that Keystone uses to authenticate to IdM (set in `/etc/keystone/keystone.conf` is also a service account. It probably makes more sense to name the user `uid=keystone` and add the user to the "Service Account" IdM group as well. Make sure that this service account also has the "OpenStack Administrator" privilege created above.
*   This example architecture is not highly available. It probably makes sense to use a load balancer instead of a direct LDAP connection to the IdM master.
*   It is tempting to use the groups defined in IdM as tenants in OpenStack. This cuts down on the amount of LDIF typing required. Note that OpenStack roles are created underneath tenants, which is probably not what we want in the IdM tree:

<!-- -->

     # d797691eb43640adb401c9b698fb4cef, a459741dfa8f4a8cb74306f001c564e3, tenants
     , openstack, example.com
    dn: cn=d797691eb43640adb401c9b698fb4cef,cn=a459741dfa8f4a8cb74306f001c564e3,ou
     =tenants,cn=openstack,dc=example,dc=com
    objectClass: organizationalRole
    objectClass: top
    roleOccupant: uid=glance,cn=users,cn=accounts,dc=example,dc=com
    roleOccupant: uid=nova,cn=users,cn=accounts,dc=example,dc=com
    roleOccupant: uid=cinder,cn=users,cn=accounts,dc=example,dc=com
    roleOccupant: uid=ec2,cn=users,cn=accounts,dc=example,dc=com
    roleOccupant: uid=swift,cn=users,cn=accounts,dc=example,dc=com
    cn: d797691eb43640adb401c9b698fb4cef
