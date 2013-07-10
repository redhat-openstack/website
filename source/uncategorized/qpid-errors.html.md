---
title: Qpid errors
authors: rbowen
wiki_title: Qpid errors
wiki_revision_count: 5
wiki_last_updated: 2015-03-13
---

# Qpid errors

After several uninstall/reinstall cycles, certain parts of the system can get broken. One of these appears to be qpidd.

In particular, as discussed in [forum thread](http://openstack.redhat.com/forum/discussion/293/error-on-openstack-status#Item_5|this), the qpid user database may become corrupted. This may be evidenced by error messages such as:

         qpidd: unable to open Berkeley db /var/lib/qpidd/qpidd.sasldb: No such file or directory

You can recreate the sasldb file using the following command:

         saslpasswd2 -f /var/lib/qpidd/qpidd.sasldb -u QPID guest

Provide the password at the command line (usually 'guest'), and the file will be created. You should further ensure that /etc/cinder/cinder.conf references the correct username and password corresponding with this file.

You can verify the presence of users accounts in that file with:

         sasldblistusers2 -f /var/lib/qpidd/qpidd.sasldb
