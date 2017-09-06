---
title: Writing a SELinux policy from the ground up
date: 2017-09-06
author: tristanC
tags: security, SELinux, Zuul
---

SELinux is a mechanism that implements mandatory access controls in Linux systems.
This article shows how to create a SELinux policy that confines a standard service:
* Limit its network interfaces,
* Restrict its system access, and
* Protect its secrets.

## Mandatory access control

By default, unconfined processes use discretionary access controls (DAC).
A user has all the permissions over its objects, for example the
owner of a log file can modify it or make it world readable.

In contrast, mandatory access control (MAC) enables more fine grained controls,
for example it can restrict the owner of a log file to only append operations.
Moreover, MAC can also be used to reduce the capability of a regular
process, for example by denying debugging or networking capabilities.

This is great for system security, but is also a powerful tool
to control and better understand an application.
Security policies reduce services' attack surface and describes
service system operations in depth.


## Policy module files

A SELinux policy is composed of:

* A type enforcement file (*.te*): describes the policy type and access control,
* An interface file (*.if*): defines functions available to other policies,
* A file context file (*.fc*): describes the path labels, and
* A package spec file (*.spec*): describes how to build and install the policy.

The packaging is optional but highly recommended since it's a standard
method to distribute and install new pieces on a system.

Under the hood, these files are written using macros processors:

* A policy file (*.pp*) is generated using: make NAME=targeted -f "/usr/share/selinux/devel/Makefile"
* An intermediary file (*.cil*) is generated using: /usr/libexec/selinux/hll/pp


## Policy developpment workflow:

The first step is to get the services running in a confined domain.
Then we define new labels to better protect the service.
Finally the service is run in permissive mode to collect the access it needs.

As an example, we are going to create a security policy for the scheduler
service of the [Zuul](https://docs.openstack.org/infra/zuul/) program.


### Confining a Service

To get the basic policy definitions, we use the
[sepolicy generate](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/SELinux_Users_and_Administrators_Guide/Security-Enhanced_Linux-The-sepolicy-Suite-sepolicy_generate.html)
command to generate a bootstrap zuul-scheduler policy:

```bash
sepolicy generate --init /opt/rh/rh-python35/root/bin/zuul-scheduler
```

The *--init* argument tells the command to generate a service policy. Other
types of policy could be generated such as user application, inetd daemon
or confined administrator.

The *.te* file contains:

* A new *zuul_scheduler_t* domain,
* A new *zuul_scheduler_exec_t* file label,
* A domain transition from systemd to *zuul_scheduler_t* when the *zuul_scheduler_exec_t* is executed, and
* Miscellaneous definitions such as the ability to read localization settings.

The *.fc* file contains regular expressions to match a file path with a label:
*/bin/zuul-scheduler* is associated with *zuul_scheduler_exec_t*.

The *.if* file contains methods (macros) that enable role extension. For example,
we could use the zuul_scheduler_admin method to authorize a staff role to administrate
the zuul service. We won't use this file because the admin user (root) is unconfined
by default and it doesn't need special permission to administrate the service.

To install the zuul-scheduler policy we can run the provided script:
```bash
$ sudo ./zuul_scheduler.sh
Building and Loading Policy
+ make -f /usr/share/selinux/devel/Makefile zuul_scheduler.pp
Creating targeted zuul_scheduler.pp policy package
+ /usr/sbin/semodule -i zuul_scheduler.pp
```
Restarting the service should show (using "ps Zax") that it is now
running with the *system_u:system_r:zuul_scheduler_t:s0* context instead of
the *system_u:system_r:unconfined_service_t:s0*.

And looking at the audit.log, it should show many "avc: denied error" because no
permissions have yet been defined. Note that the service is running fine because
this initial policy defines the zuul_scheduler_t domain as permissive.

Before authorizing the service's access, let's define the zuul resources.

### Define the service resources

The service is trying to access */etc/opt/rh/rh-python35/zuul* and
*/var/opt/rh/rh-python35/lib/zuul* which inherited the *etc_t* and *var_lib_t* labels.
Instead of giving *zuul_scheduler_t* access to *etc_t* and *var_lib_t*,
we will create new types. Moreover the zuul-scheduler manages secret keys
we could isolate from its general home directory and it requires two tcp ports.

In the *.fc* file, define the new paths:
```
/var/opt/rh/rh-python35/lib/zuul/keys(/.*)?  gen_context(system_u:object_r:zuul_keys_t,s0)
/etc/opt/rh/rh-python35/zuul(/.*)?           gen_context(system_u:object_r:zuul_conf_t,s0)
/var/opt/rh/rh-python35/lib/zuul(/.*)?       gen_context(system_u:object_r:zuul_var_lib_t,s0)
/var/opt/rh/rh-python35/log/zuul(/.*)?       gen_context(system_u:object_r:zuul_log_t,s0)
```

In the *.te* file, declare the new types:
```
# System files
type zuul_conf_t;
files_type(zuul_conf_t)
type zuul_var_lib_t;
files_type(zuul_var_lib_t)
type zuul_log_t;
logging_log_file(zuul_log_t)

# Secret files
type zuul_keys_t;
files_type(zuul_keys_t)

# Network label
type zuul_gearman_port_t;
corenet_port(zuul_gearman_port_t)
type zuul_webapp_port_t;
corenet_port(zuul_webapp_port_t);
```

Note that the *file_type()* macro is important since it provides unconfined access to
the new types. Without it, even the admin user could not access the file.

In the *.spec* file, add the new path and setup the tcp port labels:
```
%define relabel_files() \
restorecon -R /var/opt/rh/rh-python35/lib/zuul/keys
...

# In the %post section, add
semanage port -a -t zuul_gearman_port_t -p tcp 4730
semanage port -a -t zuul_webapp_port_t -p tcp 8001

# In the %postun section, add
for port in 4730 8001; do semanage port -d -p tcp $port; done
```

Rebuild and install the package:
```bash
sudo ./zuul_scheduler.sh && sudo rpm -ivh ./noarch/*.rpm
```

Check that the new types are installed using "ls -Z" and "semanage port -l":
```bash
$ ls -Zd /var/opt/rh/rh-python35/lib/zuul/keys/
drwx------. zuul zuul system_u:object_r:zuul_keys_t:s0 /var/opt/rh/rh-python35/lib/zuul/keys/
$ sudo semanage port -l | grep zuul
zuul_gearman_port_t            tcp      4730
zuul_webapp_port_t             tcp      8001
```


### Update the policy

With the service resources now declared, let's restart the service and start
using it to collect all the access it needs.

After a while, we can update the policy using "./zuul_scheduler.sh --update"
which basically does: "ausearch -m avc --raw | audit2allow -R".
This collects all the permissions denied to generates type enforcement rules.

We can repeat this steps until all the required accesses are collected.

Here's what looks like the resulting zuul-scheduler rules:

```
allow zuul_scheduler_t gerrit_port_t:tcp_socket name_connect;
allow zuul_scheduler_t mysqld_port_t:tcp_socket name_connect;
allow zuul_scheduler_t net_conf_t:file { getattr open read };
allow zuul_scheduler_t proc_t:file { getattr open read };
allow zuul_scheduler_t random_device_t:chr_file { open read };
allow zuul_scheduler_t zookeeper_client_port_t:tcp_socket name_connect;
allow zuul_scheduler_t zuul_conf_t:dir getattr;
allow zuul_scheduler_t zuul_conf_t:file { getattr open read };
allow zuul_scheduler_t zuul_exec_t:file getattr;
allow zuul_scheduler_t zuul_gearman_port_t:tcp_socket { name_bind name_connect };
allow zuul_scheduler_t zuul_keys_t:dir getattr;
allow zuul_scheduler_t zuul_keys_t:file { create getattr open read write };
allow zuul_scheduler_t zuul_log_t:file { append open };
allow zuul_scheduler_t zuul_var_lib_t:dir { add_name create remove_name write };
allow zuul_scheduler_t zuul_var_lib_t:file { create getattr open rename write };
allow zuul_scheduler_t zuul_webapp_port_t:tcp_socket name_bind;
```

Once the service is no longer being denied permissions, we can remove the
"permissive zuul_scheduler_t;" declaration and deploy it in production. To avoid
issues, the domain can be set to permissive at first using:

```bash
$ sudo semanage permissive -a zuul_scheduler_t
```


## Too long, didn't read

In short, to confine a service:
* Use sepolicy generate
* Declare the service's resources
* Install the policy and restart the service
* Use audit2allow

Here are some useful documents:
* [The reference policy](https://selinuxproject.org/page/NB_RefPolicy)
* [Object Classes and Permissions](https://selinuxproject.org/page/NB_ObjectClassesPermissions
)
* [Dan Walsh's Blog](http://danwalsh.livejournal.com/)
* [Writing SELinux Policy](https://mgrepl.fedorapeople.org/PolicyCourse/writingSELinuxpolicy_MUNI.pdf) presentation by Miroslav Grepl
