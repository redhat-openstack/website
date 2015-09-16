---
title: Securing Services Foreman
authors: rcritten
wiki_title: Securing Services Foreman
wiki_revision_count: 18
wiki_last_updated: 2014-02-20
---

# Securing Services Foreman

{:.no_toc}

## Overview

The default OpenStack configuration doesn't include securing internal services with SSL. This document provides instructions for securing some of the services within a Foreman-managed environment.

This can be seen as extending <http://openstack.redhat.com/Deploying_RDO_Using_Foreman>

## Preparation

You'll need a CA to issue server certificates, along with the CA certificate itself. Instructions for issuing certificates is beyond the scope of this document, but the subject of the server certificates should include CN=<fqdn> for SSL to work.

Depending on your host configuration, some services may be running on separate machines. Keep this in mind when restarting services.

The location of the certificates is not mandatory, but be aware of SELinux issues if you decide to locate them elsewhere.

Optionally you may use an IPA server to streamline issuance and management of services. You will need the hostname of an IPA master and a user with the permissions to create hosts and services.

### Manual CA

If you want to test with a self-signed OpenSSL CA you can generate one by creating a location for the CA and generating it with a configuration file.

Lets create our own CA using the OpenSSL defaults.

    # mkdir /root/CA
    # cd /root/CA
    # mkdir certs crl newcerts private requests
    # echo 01 > serial
    # touch index.txt index.txt.attr
    # cp /etc/pki/tls/openssl.cnf .

apply this diff

    diff openssl.cnf  /etc/pki/tls/openssl.cnf
    42c42
    < dir           = /root//CA             # Where everything is kept
    ---
    > dir           = /etc/pki/CA           # Where everything is kept

Now generate the private key for the CA

    # openssl req -nodes -new -newkey rsa:2048 -keyout private/cakey.pem -out careq.pem -config ./openssl.cnf
    Generating a 2048 bit RSA private key
    .......................+++
    ...........................+++
    writing new private key to 'private/cakey.pem'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:US
    State or Province Name (full name) []:NC
    Locality Name (eg, city) [Default City]:Raleigh
    Organization Name (eg, company) [Default Company Ltd]:Example Corp.
    Organizational Unit Name (eg, section) []:
    Common Name (eg, your name or your server's hostname) []:Example Certificate Authority
    Email Address []:certs@example.com

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:

Sign the CA and issue a 10-year certificate. Yes, this is overkill for testing.

      # openssl ca -create_serial -out cacert.pem -days 3650 -keyfile private/cakey.pem -selfsign -extensions v3_ca -config ./openssl.cnf -infiles careq.pem

On the controller, generate a CSR for the public and private certs.

    # openssl req -newkey rsa:1024 -nodes -sha1 -keyout /etc/pki/tls/private/set1client1.public.example.com-horizon.key  -keyform PEM -out /root/public.req -outform PEM

    Generating a 1024 bit RSA private key
    .++++++
    .........++++++
    writing new private key to '/etc/pki/tls/private/set1client1.public.example.com-horizon.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:US
    State or Province Name (full name) []:NC
    Locality Name (eg, city) [Default City]:Raleigh
    Organization Name (eg, company) [Default Company Ltd]:Example Corp.
    Organizational Unit Name (eg, section) []:
    Common Name (eg, your name or your server's hostname) []:set1client1.public.example.com
    Email Address []:root@example.com

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:

Then do something similar for the private interface

    # openssl req -newkey rsa:1024 -nodes -sha1 -keyout /etc/pki/tls/private/set1client1.private.example.com-mysql.key  -keyform PEM -out /root/private.req -outform PEM

On the CA sign the requests

Copy the two request files and put them into /root/CA/requests. You'll be asked to confirm the certificates, answer yes.

    # openssl ca -config ./openssl.cnf -infiles requests/private.req
    # openssl ca -config ./openssl.cnf -infiles requests/public.req

The output of each signing is the public certificate. Copy that into the appropriate location on the controller, such as

    /etc/pki/tls/certs/set1client1.public.example.com-horizon.crt
    /etc/pki/tls/certs/set1client1.private.example.com-mysql.crt

We cheat and use the same certificate for qpid as mysql. For production purposes you'd want separate certificates for each service.

    # cp /etc/pki/tls/certs/set1client1.private.example.com-mysql.crt /etc/pki/tls/certs/set1client1.private.example.com-qpid.crt
    # cp /etc/pki/tls/private/set1client1.private.example.com-mysql.key  /etc/pki/tls/private/set1client1.private.example.com-qpid.key

Copy /root/CA/cacert.pem to the controller machine /etc/pki/tls/certs/openssl.crt

You could probably use the puppet CA for this as well. My assumption is that the organization already has a CA somewhere and that eventually that CA will be used to issue the certificates used for OpenStack.

When you set up seeds.rb you want to use values that look something like this:

      "mysql_ca"                      => "/etc/pki/tls/certs/openssl.crt",
      "mysql_cert"                    => "/etc/pki/tls/certs/set1client1.private.example.com-mysql.crt",
      "mysql_key"                     => "/etc/pki/tls/private/set1client1.private.example.com-mysql.key",
      "qpid_ca"                       => "/etc/pki/tls/certs/openssl.crt",
      "qpid_cert"                     => "/etc/pki/tls/certs/set1client1.private.example.com-qpid.crt",
      "qpid_key"                      => "/etc/pki/tls/private/set1client1.private.example.com-qpid.key",
      "horizon_ca"                    => "/etc/pki/tls/certs/openssl.crt",
      "horizon_cert"                  => "/etc/pki/tls/certs/set1client1.public.example.com-horizon.crt",
      "horizon_key"                   => "/etc/pki/tls/private/set1client1.public.example.com-horizon.key",

### Provisioning

The automatic provisioning capabilities of Foreman is not currently supported. Some manual work is needed on the hosts prior to applying the node configuration. It will work, in that your hosts will be created, but the resulting services will not be running due to missing certificates.

## Foreman server Installation

The Foreman installation is largely the same as a non-SSL installation with the exception that FQDNs need to be provided to the installer in order SSL to work.

As an example, with 3 machines: a foreman server, a controller node and a compute node. The controller and compute nodes at least have two separate networks, private and public. The bin/seeds.rb might look like:

    "controller_priv_host"          => 'controller.private.example.com',
    "controller_pub_host"           => 'controller.public.example.com',
    "mysql_host"                    => 'controller.private.example.com',
     ...
    "qpid_host"                     => 'controller.private.example.com',
    ...
    "mysql_ca"                      => "/etc/ipa/ca.crt",
    "mysql_cert"                    => "/etc/pki/tls/certs/controller.private.example.com-mysql.crt",
    "mysql_key"                     => "/etc/pki/tls/private/controller.private.example.com-mysql.key",
    "qpid_ca"                       => "/etc/ipa/ca.crt",
    "qpid_cert"                     => "/etc/pki/tls/certs/controller.private.example.com-qpid.crt",
    "qpid_key"                      => "/etc/pki/tls/private/controller.private.example.com-qpid.key",
    "horizon_cert"                  => "/etc/pki/tls/certs/controller.public.example.com-horizon.crt",
    "horizon_key"                   => "/etc/pki/tls/private/controller.public.example.com-horizon.key",

## Initial Node installation

Before running the foreman_client.sh on your compute and controller node to register the hosts with Foreman you'll need to do some pre-configuration work, one of the following:

### Manual SSL Configuration

For a manual installation the SSL certificates need to be pre-positioned on the controller or compute node.

The default location for the certificates are defined in the node hostgroup. The defaults are:

      mysql_ca        /etc/ipa/ca.crt
      mysql_cert     /etc/pki/tls/certs/FQDN-mysql.crt
      mysql_key      /etc/pki/tls/private/FQDN-mysql.key
      qpid_ca          /etc/ipa/ca.crt
      qpid_cert       /etc/pki/tls/certs/FQDN-qpid.crt
      qpid_key        /etc/pki/tls/private/FQDN-qpid.key
      horizon_ca    /etc/ipa/ca.crt
      horizon_cert /etc/pki/tls/certs/FQDN-horizon.crt
      horizon_key  /etc/pki/tls/certs/FQDN-horizon.key

Where FQDN is the fully-qualfied domain name of the private interface of the node. Change these as needed. These settings are found in the Foreman UI under More -> Configuration -> Host groups. Select each hostgroup then look in Parameters for the SSL options. To change a value select override, then add a new value at the bottom of the page.

Don't worry about file ownership, puppet should set them as needed.

### IPA Configuration

Enroll the compute and controller nodes as IPA client machines (ipa-client-install).

Now you need to pre-create the services that IPA will need to generate the SSL certificates. On the IPA master run:

      $ kinit admin
      $ ipa service-add mysql/controller.private.example.com
      $ ipa service-add qpid/controller.private.example.com
      $ ipa service-add horizon/controller.public.example.com
      $ ipa service-add-host --hosts=controller.private.example.com horizon/controller.public.example.com

The controller node configuration will automatically obtain the SSL certificate.

## Node Configuration

First, log in to your Foreman instance (https://{foreman_fqdn}). The default login and password are admin/changeme; we recommend changing this if you plan on keeping this host around.

Next, you’ll need to assign the correct puppet classes to each of your hosts. Click the HOSTS link and select your host from the list. Select EDIT HOST and add the appropriate Host Group.

### Controller

In either case select either the Nova or Neutron Controller host group.

#### Manual SSL Configuration

Override ssl to true. freeipa should be false which is the default. Verify that the paths to the various SSL certs match what you've pre-positioned into the filesystem on the controller node.

#### IPA Configuration

Override ssl and freeipa values and set them to true.

### Compute

In both cases (manual or IPA SSL configuration) only ssl needs to be set to true if the Controller node has ssl enabled. This is true for both Nova and Neutron compute host groups.

Be sure to verify that the interface names match the system.

## Apply Configuration

      puppet agent -tv

## Verifying Configuration on the Controller

Here are some basic steps to ensure that the services are working as expected.

### IPA Configuration

First confirm that the certificates for qpid, mysql and horizon were retrieved and are being tracked for renewal:

      # ipa-getcert list

The output should contain 4 Request IDs in a monitoring state. These include:

*   a certificate for the host itself
*   the qpid certificate
*   the mysql certificate
*   the horizon certificate

The status in certmonger should be MONITORING. If it isn't then something went wrong.

### Common for Manual and IPA Configuration

#### mysql

Using the mysql client, verify that SSL is available, where ssl-ca is the path to the CA certificate that issued the mysql certificate. This example uses the IPA CA:

      # mysql --ssl-ca=/etc/ipa/ca.crt -e '\s'

The output should include a line like this:

      SSL:                    Cipher in use is DHE-RSA-AES256-SHA

#### qpid

Here is a simple AMQP python script that will exercise a connection over SSL:

      import sys
      from qpid.messaging import *
      broker = sys.argv[1]
      address = "amq.topic" 
      connection = Connection(broker)
      connection.transport = 'ssl'
      connection.port = 5671
      try:
        connection.open()
        session = connection.session()
        sender = session.sender(address)
        receiver = session.receiver(address)
        sender.send(Message("Hello world!"));
        message = receiver.fetch()
        print message.content
        session.acknowledge()
      except MessagingError,m:
        print m
      connection.close()

To use it:

      ` # python test.py `hostname` `
      Hello world!

#### horizon

Use curl to verify that Horizon is up and SSL works. You need to do this request on the public interface:

`# curl --cacert /etc/ipa/ca.crt `[`https://hostname.public.example.com/`](https://hostname.public.example.com/)

You'll get a redirect which will confirm that SSL is a-ok:

     <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
     <html><head>
     <title>301 Moved Permanently</title>
     </head><body>
     <h1>Moved Permanently</h1>
     <p>The document has moved <a href="https://controller.example.com/dashboard/">here</a>.</p>
     <hr>
     <address>Apache/2.2.15 (Red Hat) Server at controller.example.com Port 443</address>
     </body></html>

### Cleanup

If you are using an IPA server as your certificate source and you want to re-install an existing controller node there will be some additional steps. You need to clean up the environment on the host itself and on the IPA server.

#### On the host

Tell certmonger to stop tracking its certificates and remove the PEM files.

Run `ipa-getcert list`. There should be four tracked certificates. The first one is for the host itself with the location being /etc/pki/nssdb. We can leave this one alone.

For each of the others, cancel tracking by request id for each one:

`# ipa-getcert stop-tracking -i `<request_id>

Remove the private key and certificate pem files for the mysql and horizon certificates:

      ` # rm /etc/pki/tls/certs/`hostname`-mysql.crt `
      ` # rm /etc/pki/tls/private/`hostname`-mysql.crt `
      ` # rm /etc/pki/tls/certs/`hostname`-horizon.crt `
      ` # rm /etc/pki/tls/private/`hostname`-horizon.crt `

#### On the IPA master

The controller node has permission to request a certificiate for its public interface but not permission to revoke or replace it so you'll need to do that in advance:

      # ipa service-show horizon/hostname.public.example.com

Note the serial number

`# ipa cert-revoke `<serial_number>
      # ipa service-mod horizon/hostname.public.example.com --certificate=

This sets the certificate to nothing which effectively removes it from the entry.

You are now ready to reinstall on the controller node.
