---
title: Troubleshooting
category: documentation
authors: dneary, jasonbrooks, msolberg, rbowen
wiki_category: Documentation
wiki_title: Troubleshooting
wiki_revision_count: 19
wiki_last_updated: 2013-08-28
---

# Troubleshooting

Every piece of software as complex as OpenStack has some pitfalls in its usage. We will use this page to collect tips and tricks related to installation and configuration issues, and issues which people run into during the lifetime of their OpenStack deployment.

### SELinux troubleshooting

SELinux can sometimes be a source of issues with OpenStack. On a system with SELinux enabled (as it is by default on Fedora and RHEL), you can check for denial messages with the command:

    sudo cat /var/log/audit/audit.log | grep denied

You can check the SELinux enforcement status of your machine with the command "sestatus" and can temporarily place SELinux in enforcing (in which it blocks access violations) or permissive (logs access violations, but does not block) with the commands "setenforce 1" and "setenforce 0", respectively.

To make SELinux enforcement changes that persist between reboots, edit the file /etc/selinux/config.

For more information on SELinux troubleshooting, see <http://fedoraproject.org/wiki/SELinux/Troubleshooting>.

<Category:Documentation>
