---
title: JunoForeman
authors: msolberg
wiki_title: JunoForeman
wiki_revision_count: 5
wiki_last_updated: 2015-03-26
---

# Juno Foreman

*   Minimum install Centos 7
*   Update packages:

       # yum -y update

*   Do steps 0, 1, and 2 here <https://www.rdoproject.org/Quickstart>
*   Install Foreman <http://theforeman.org/manuals/1.6/quickstart_guide.html>)(:

` # yum install `[`http://yum.theforeman.org/releases/1.6/el7/x86_64/foreman-release.rpm`](http://yum.theforeman.org/releases/1.6/el7/x86_64/foreman-release.rpm)
       # yum -y --nogpgcheck install foreman-release-scl
       # yum install foreman-installer
       # foreman-installer

<http://theforeman.org/manuals/1.6/index.html#3.1.3FirewallConfiguration> firewall-cmd --add-port=8140/tcp

       # yum install openstack-puppet-modules

*   Add /usr/share/openstack-puppet/modules to the basemodulepath in /etc/puppet/puppet.conf
