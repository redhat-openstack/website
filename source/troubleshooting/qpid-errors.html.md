---
title: Qpid errors
authors: rbowen
wiki_title: Qpid errors
wiki_revision_count: 5
wiki_last_updated: 2015-03-13
---

# Qpid errors

## Config file errors

If you see something like the following message in your system log when the qpidd service attempts to start:

    Jul 22 15:39:08 localhost qpidd[8631]: 2013-07-22 15:39:08 [Broker] critical Unexpected error: Error in configuration file /etc/qpidd.conf: Bad argument: |cluster-mechanism=DIGEST-MD5 ANONYMOUS|

Replace 'cluster-mechanism' with 'ha-mechanism' in /etc/qpidd.conf then restart the qpidd service, or reboot.

## sasldb errors

As discussed in [forum thread](http://rdoproject.org/forum/discussion/293/error-on-openstack-status#Item_5|this), the qpid user database may become corrupted. This may be evidenced by error messages such as:

         qpidd: unable to open Berkeley db /var/lib/qpidd/qpidd.sasldb: No such file or directory

You can recreate the sasldb file using the following command:

         saslpasswd2 -f /var/lib/qpidd/qpidd.sasldb -u QPID guest

Provide the password at the command line (usually 'guest'), and the file will be created. You should further ensure that /etc/cinder/cinder.conf references the correct username and password corresponding with this file. Then restart qpidd:

         service qpidd restart

You can verify the presence of users accounts in that file with:

         sasldblistusers2 -f /var/lib/qpidd/qpidd.sasldb
