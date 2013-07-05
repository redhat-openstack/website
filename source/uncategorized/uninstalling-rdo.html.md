---
title: Uninstalling RDO
authors: dneary, kashyap, larsks, rbowen
wiki_title: Uninstalling RDO
wiki_revision_count: 20
wiki_last_updated: 2015-03-31
---

# Uninstalling RDO

There is no automated uninstall process for RDO. If you have a previously installed version of OpenStack, you will need to uninstall it first, before installing the RDO packages. We do plan to support upgrades from version N to N+1 in the future.

## Big hammer method

To completely uninstall RDO, including all application data, and all packages which are installed on a base system, run the following script. This assumes that you are only running OpenStack on this machine - if you are using this machine for anything else, STOP! And go to the [ "Slightly smaller hammer"](uninstalling RDO#Slightly_smaller_hammer_method) section below

WARNING: This script will remove packages including Puppet, httpd, Nagios and others which you may require for other packages. The script will also delete all MySQL databases and Nagios application data. Use at your own risk. <b>DO NOT use this on systems that are doing anything other than RDO</b>, as it will install a large number of unrelated packages.

    # Warning! Dangerous step! Destroys VMs
    for x in $(virsh list --all | grep instance- | awk '{print $2}') ; do
        virsh destroy $x ;
        virsh undefine $x ;
    done ;

    # Warning! Dangerous step! Removes lots of packages, including many
    # which may be unrelated to RDO.
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

## Slightly smaller hammer method

The following script removes only OpenStack specific application data and packages. It may also leave some OpenStack related data behind.

    for x in $(virsh list --all | grep instance- | awk '{print $2}') ; do
        virsh destroy $x ;
        virsh undefine $x ;
    done ;

    yum remove -y "*openstack*" "*nova*" "*keystone*" "*glance*" "*cinder*" "*swift*" "*rdo-release*";

    ps -ef | grep -i repli | grep swift | awk '{print $2}' | xargs kill ;

    rm -rf  /etc/yum.repos.d/packstack_* /var/lib/glance /var/lib/nova /etc/nova /etc/swift \
    /srv/node/device*/* /var/lib/cinder/ /etc/rsync.d/frag* \
    /var/cache/swift /var/log/keystone ;

    # Ensure there is a root user and that we know the password
    service mysql stop
    cat > /tmp/set_mysql_root_pwd << EOF
    UPDATE mysql.user SET Password=PASSWORD('MyNewPass') WHERE User='root';
    FLUSH PRIVILEGES;
    EOF

    /usr/bin/mysqld_safe --init-file=/tmp/set_mysql_root_pwd &
    rm /tmp/set_mysql_root_pwd

    mysql -uroot -pMyNewPass -e "drop database nova; drop database cinder; drop database keystone; drop database glance;"

    umount /srv/node/device* ;
    vgremove -f cinder-volumes ;
    losetup -a | sed -e 's/:.*//g' | xargs losetup -d ;
    find /etc/pki/tls -name "ssl_ps*" | xargs rm -rf ;
    for x in $(df | grep "/lib/" | sed -e 's/.* //g') ; do
        umount $x ;
    done

<Category:Documentation>
