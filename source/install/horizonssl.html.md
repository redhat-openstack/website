---
title: HorizonSSL
authors: rbowen
wiki_title: HorizonSSL
wiki_revision_count: 1
wiki_last_updated: 2013-10-15
---

# Horizon SSL

From a [post by carltm](http://openstack.redhat.com/forum/discussion/671/resolved-ssl-for-horizon-dashboard):

With the current (Oct. 2013) version of packstack the CONFIG_HORIZON_SSL=y fails for both grizzly and havana. Here is a guide to setting up ssl after the installation.

install the ssl module for apache

         yum -y install mod_ssl

copy the certificate and key files to /etc/httpd/conf.d

update /etc/httpd/conf.d/ssl.conf

         SSLCertificateFile /etc/httpd/conf.d/mycert.crt
         SSLCertificateKeyFile /etc/httpd/conf.d/mycert.key

update /etc/httpd/conf.d/openstack-dashboard.conf

    sed -i '1 i\
    #these lines force an ssl connection\
    RewriteEngine On\
    RewriteCond %{HTTPS} !on\
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]\
    '  /etc/httpd/conf.d/openstack-dashboard.conf

make a backup of the ssl.conf file (in case packstack is re-run)

         tar cfz /etc/httpd/conf.d/ssl.tz /etc/httpd/conf.d/ssl.conf

restart the web service

         service httpd restart
