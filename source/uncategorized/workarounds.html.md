---
title: Workarounds
authors: apevec, arifali, avladu, dustymabe, eglynn, ekuris, eyepv6, fbayhan, flaper87,
  hma, iovadia, jpichon, jruzicka, kashyap, larsks, mmagr, pixelbeat, rbowen, rdo,
  rohara, rwmjones, sasha, shardy, sschinna, stoner, stzilli, tshefi, vaneldik, weshayutin,
  whayutin, xqueralt
wiki_title: Workarounds
wiki_revision_count: 100
wiki_last_updated: 2015-05-07
---

# Workarounds

See [Workaround_archive](Workaround_archive) for workarounds that we believe to be resolved. Please move them back here if they appear to still be necessary.

## Unable to start nova-api

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1139771>
*   **Affects:** Fedora 20, CentOS7

#### symptoms

Packstack fails with the error:

    Error: Could not start Service[nova-api]: Execution of '/sbin/service openstack-nova-api start' returned 1: 

/var/log/audit/audit.log contains:

    type=AVC msg=audit(1412109980.125:4612): avc:  denied  { getattr } for  pid=3296 comm="nova-api" name="/" dev="tmpfs" ino=13317 scontext=system_u:system_r:nova_api_t:s0 tcontext=system_u:object_r:tmpfs_t:s0 tclass=filesystem permissive=0

#### workaround

You can place selinux in permissive mode:

    # setenforce 0

You can build an selinux module that permits the necessary access. On a Fedora 20 machine, place this in a file called nova_allow_tmpfs.te:

    module nova_allow_tmpfs 1.0;

    require {
        type tmpfs_t;
        type nova_api_t;
        class filesystem getattr;
    }

    #============= nova_api_t ==============
    allow nova_api_t tmpfs_t:filesystem getattr;

On a RHEL7 or CentOS7 server, place this in a file called nova_allow_tmpfs.te:

    module nova_allow_tmpfs 1.0;

    require {
        type tmpfs_t;
        type nova_api_t;
        class filesystem getattr;
        class dir { search write add_name remove_name } ;
        class file { create read write open link unlink getattr } ;
    }

    #============= nova_api_t ==============
    allow nova_api_t tmpfs_t:filesystem getattr;
    allow nova_api_t tmpfs_t:dir { search write add_name remove_name } ;
    allow nova_api_t tmpfs_t:file { create read write open link unlink getattr } ;

And then:

    # yum -y install selinux-policy-devel
    # make -f /usr/share/selinux/devel/Makefile nova_allow_tmpfs.pp
    Compiling targeted nova_allow_tmpfs module
    /usr/bin/checkmodule:  loading policy configuration from tmp/nova_allow_tmpfs.tmp
    /usr/bin/checkmodule:  policy configuration loaded
    /usr/bin/checkmodule:  writing binary representation (version 17) to tmp/nova_allow_tmpfs.mod
    Creating targeted nova_allow_tmpfs.pp policy package
    rm tmp/nova_allow_tmpfs.mod.fc tmp/nova_allow_tmpfs.mod
    # semodule -i nova_allow_tmpfs.pp

## Provisioning of glance does not work for demo environment

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148346>
*   **Affects:** CentOS 7, RHEL 7

#### symptoms

Packstack fails with the following error

    10.0.0.1_provision_glance.pp:                     [ ERROR ]             
    Applying Puppet manifests                         [ ERROR ]

    ERROR : Error appeared during Puppet run: 10.0.0.1_provision_glance.pp
    Error: Could not prefetch glance_image provider 'glance': Execution of '/usr/bin/glance -T services -I glance -K 86f175e8c0884d77 -N http://10.0.0.1:35357/v2.0/ index' returned 2: usage: glance [--version] [-d] [-v] [--get-schema] [--timeout TIMEOUT]
    You will find full trace in log /var/tmp/packstack/20141001-091112-m6iWqu/manifests/10.0.0.1_provision_glance.pp.log
    Please check log file /var/tmp/packstack/20141001-091112-m6iWqu/openstack-setup.log for more information

#### workaround

You can downgrade to the earlier version of `python-glanceclient`:

    yum downgrade python-glanceclient

Or you can configure packstack to not provision a demo user, images, etc by setting `CONFIG_PROVISION_DEMO=n` in the packstack answers file.

After making one of the above changes, re-run packstack with:

     packstack --answer-file=<generated packstack file>

## Enabling Tempest gives Glance error

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148459>
*   **Affects:** CentOS7

#### symptoms

         ERROR : Error appeared during Puppet run: 10.0.0.1_provision_glance.pp
         Error: Could not prefetch glance_image provider 'glance': Execution of '/usr/bin/glance -T 
            services -I glance -K 0f75673432f84bef -N `[`http://10.0.0.1:35357/v2.0/`](http://10.0.0.1:35357/v2.0/)` index' returned 
            2: usage: glance [--version] [-d] [-v] [--get-schema] [--timeout TIMEOUT]
         You will find full trace in log /var/tmp/packstack/20141001-131918-KS5XQ4/manifests/10.0.0.1_provision_glance.pp.log

#### workaround

          yum downgrade python-glanceclient

## Packstack --allinone fails to remove firewalld

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148426>
*   **Affects:** Fedora 20

#### symptoms

Applying 192.168.122.48_prescript.pp 192.168.122.48_prescript.pp: [ ERROR ] Applying Puppet manifests [ ERROR ]

ERROR : Error appeared during Puppet run: 192.168.122.48_prescript.pp Error: Execution of '/usr/bin/rpm -e firewalld-0.3.11-3.fc20.noarch' returned 1: error: Failed dependencies: You will find full trace in log /var/tmp/packstack/20141001-080818-TOTPkh/manifests/192.168.122.48_prescript.pp.log

#### workaround

yum remove firewalld

This will also remove the anaconda package dependency

## Error removing firewalld

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148426>
*   **Affects:** CentOS7, Fedora 20

#### symptoms

prescript.pp fails with the following error:

         Error: Execution of '/usr/bin/rpm -e firewalld-0.3.9-7.el7.noarch' returned 1: error: Failed dependencies:
             firewalld >= 0.3.5-1 is needed by (installed) anaconda-19.31.79-1.el7.centos.4.x86_64
             firewalld = 0.3.9-7.el7 is needed by (installed) firewall-config-0.3.9-7.el7.noarch

#### workaround

Remove firewalld:

          sudo yum rm firewalld

Then re-run packstack with the same answer file.

## Packstack fails when mariadb-server is installed

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=1148578>
*   **Affects:** Fedora 20

#### symptoms

192.168.122.48_mysql.pp: [ ERROR ] Applying Puppet manifests [ ERROR ]

ERROR : Error appeared during Puppet run: 192.168.122.48_mysql.pp Error: Execution of '/usr/bin/yum -d 0 -e 0 -y install mariadb-galera-server' returned 1: Error: mariadb-galera-server conflicts with 1:mariadb-server-5.5.39-1.fc20.x86_64 You will find full trace in log /var/tmp/packstack/20141001-084831-5JyrbC/manifests/192.168.122.48_mysql.pp.log Please check log file /var/tmp/packstack/20141001-084831-5JyrbC/openstack-setup.log for more information

#### workaround

Remove the mariadb-server package: yum remove mariadb-server

And rerun packstack

## Example Problem Description

*   **Bug:** <https://bugzilla.redhat.com/show_bug.cgi?id=12345>
*   **Affects:** Operating Systems Affected

#### symptoms

Describe symptoms here

#### workaround

Describe how to work around the problem.
