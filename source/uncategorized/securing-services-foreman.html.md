---
title: Securing Services Foreman
authors: rcritten
wiki_title: Securing Services Foreman
wiki_revision_count: 18
wiki_last_updated: 2014-02-20
---

# Securing Services Foreman

__NOTOC__

**DRAFT**

**These instructions rely on patches only available upstream or currently under review**

## Overview

The default OpenStack configuration doesn't include securing internal services with SSL. This document provides instructions for securing some of the services within a Foreman-managed environment.

This can be seen as extending <http://openstack.redhat.com/Deploying_RDO_Using_Foreman>

## Preparation

You'll need a CA to issue server certificates, along with the CA certificate itself. Instructions for issuing certificates is beyond the scope of this document, but the subject should include CN=<fqdn> for SSL to work.

Depending on your host configuration, some services may be running on separate machines. Keep this in mind when restarting services.

The location of the certificates is not mandatory, but be aware of SELinux issues if you decide to locate them elsewhere.

Optionally you may use an IPA server to streamline issuance and management of services. You will need the hostname of an IPA master and a user with the permissions to create hosts and services.

### Provisioning

Automatic provisioning of Foreman is not currently supported. Some manual work is needed on the hosts prior to applying the node configuration. It will work, in that your hosts will be created, but the resulting services will not be running due to missing certificates.

## Foreman server Installation

The Foreman installation is largely the same. FQDNs need to be provided to the installer in order SSL to work.

As an example, with 3 machines: a foreman server, a controller node and a compute node, the foreman_server.sh might look like:

      PUPPETMASTER=foreman.example.com
      ...
      PRIVATE_CONTROLLER_FQDN=controller.example.com
      PRIVATE_INTERFACE=eth0
      PRIVATE_NETMASK=192.168.122.1/24
      PUBLIC_CONTROLLER_FQDN=controller.example.com
      PUBLIC_INTERFACE=eth0
      PUBLIC_NETMASK=192.168.122.1/24
      FOREMAN_GATEWAY=false
      FOREMAN_PROVISIONING=false

## Initial Node installation

Before running the foreman_client.sh on your compute and controller node to register the hosts with Foreman you'll need to do some pre-configuration work, one of the following:

### Manual SSL Configuration

For a manual installation the SSL certificates need to be pre-positioned on the controller node.

The default location for the certificates are defined in the controller configuration. The defaults are:

      mysql_ca     /etc/ipa/ca.crt
      mysql_cert  /etc/pki/tls/certs/FQDN-mysql.crt
      mysql_key   /etc/pki/tls/private/FQDN-mysql.key
      qpid_ca       /etc/ipa/ca.crt
      qpid_cert    /etc/pki/tls/certs/FQDN-qpid.crt
      qpid_key     /etc/pki/tls/private/FQDN-qpid.key

Where FQDN is the fully-qualfied domain name of the private interface of the controller node. Change these as needed. These settings are found in the Foreman UI under More -> Configuration -> Host groups. Select each hostgroup then look in Parameters for the SSL options. To change a value select override, then add a new value at the bottom of the page.

The certificate and private key location for Apache for a secured Horizon/dashboard are not currently configurable. The need to be in:

/etc/pki/tls/private/httpd.key /etc/pki/tls/certs/httpd.crt

Don't worry about file ownership, applying the controller node should set them as needed.

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

Next, you’ll need to assign the correct puppet classes to each of your hosts. Click the HOSTS link and select your host from the list. Select EDIT HOST and add the appropriate Host Group (OpenStack Controller or OpenStack Compute).

### Manual SSL Configuration

The default settings are ssl = true and freeipa = false. It is ok to leave things as-is.

### IPA Configuration

ssl is enabled by default. Override the freeipa value and set it to true.

## Apply Configuration

      puppet agent -tv

## Verifying Configuration

Here are some basic steps to ensure that the services are working as expected.

### IPA Configuration

First confirm that the certificates for qpid and mysql were retrieve and are being tracked for renewal:

      ipa-getcert list

The output should contain 3 Request IDs in a monitoring state. These include:

*   the host certificate
*   the qpid certificate
*   the mysql certificate

### Common for Manual and IPA Configuration

#### mysql

Using the mysql client, verify that SSL is available, where ssl-ca is the path to the CA certificate that issued the mysql certificate. This example uses the IPA CA:

      # mysql --ssl-ca=/etc/ipa/ca.crt -e '\s'

The output should include a line like this:

      SSL:                    Cipher in use is DHE-RSA-AES256-SHA

#### qpid

You can confirm it has an SSL certificate with:

      # certutil -L -d /etc/pki/qpidd

The output should include a nickname named broker.

Here is a simple AMQP python script that will really exercise a connection over SSL:

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

Use curl to verify that Horizon is up and SSL works:

`# curl --cacert /etc/ipa/ca.crt `[`` https://`hostname`/ ``](https://`hostname`/)

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
