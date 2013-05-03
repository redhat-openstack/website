---
title: Uninstalling RDO
authors: dneary, kashyap, larsks, rbowen
wiki_title: Uninstalling RDO
wiki_revision_count: 20
wiki_last_updated: 2015-03-31
---

## Uninstalling RDO

There is no automated uninstall process for RDO. If you have a previously installed version of OpenStack, you will need to uninstall it first, before installing the RDO packages. We do plan to support upgrades from version N to N+1 in the future.

To completely uninstall RDO, including all application data, and all packages which are installed on a base system, run the following script.

WARNING: This script will remove packages including Puppet, httpd, Nagios and others which you may require for other packages. The script will also delete all MySQL databases and Nagios application data. Use at your own risk.

    # Warning! Dangerous step! Destroys VMs
    for x in $(virsh list --all | grep instance- | awk '{print $2}') ; do
        virsh destroy $x ;
        virsh undefine $x ;
    done ;

    # Warning! Dangerous step! Removes lots of packages
    yum remove -y nrpe "*nagios*" puppet "*ntp*" "*openstack*" \
    "*nova*" "*keystone*" "*glance*" "*cinder*" "*swift*" \
    mysql mysql-server httpd "*memcache*" scsi-target-utils \
    iscsi-initiator-utils perl-DBI perl-DBD-MySQL ;

    ps -ef | grep -i repli | grep swift | awk '{print $2}' | xargs kill ;

    # Warning! Dangerous step! Deletes local application data
    rm -rf /etc/nagios /etc/yum.repos.d/packstack_* /root/.my.cnf \
    /var/lib/mysql/ /var/lib/glance /var/lib/nova /etc/nova /etc/swift \
    /srv/node/device*/* /var/lib/cinder/ /etc/rsync.d/frag* \
    /var/cache/swift /var/log/keystone ;

    umount /srv/node/device* ;
    killall -9 dnsmasq tgtd httpd ;
    setenforce 1 ;
    vgremove -f cinder-volumes ;
    losetup -a | sed -e 's/:.*//g' | xargs losetup -d ;
    find /etc/pki/tls -name "ssl_ps*" | xargs rm -rf ;
    for x in $(df | grep "/lib/" | sed -e 's/.* //g') ; do
        umount $x ;
    done

<Category:Documentation>
