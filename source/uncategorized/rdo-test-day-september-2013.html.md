---
title: RDO Test Day September 2013
authors: acalinciuc, admiyo, ajeain, apevec, bdperkin, dneary, eglynn, hateya, ichavero,
  jlibosva, jpichon, jruzicka, mlessard, mrunge, ndipanov, nsantos, oblaut, otherwiseguy,
  pixelbeat, pmyers, rbowen, rcritten, red trela, rkukura, shardy, tgraf, vaneldik,
  whayutin, xqueralt, yrabl
wiki_title: RDO Test Day September 2013
wiki_revision_count: 74
wiki_last_updated: 2013-09-11
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# RDO Test day, September, 2013

We plan to hold an RDO test day on September 10th and 11th, 2013. This will be coordinated through the #rdo channel on freenode, and through this wiki and RDO forums.

You can read about the previous test day at <https://fedoraproject.org/wiki/Test_Day:2013-04-02_OpenStack> to get an idea of what's involved. More details will be posted here as they are available.

### Who's Available

The following cast of characters will be available testing, workarounds, bug fixes, and general discussion. You can participate in the conversation on the #rdo IRC channel on the Freenode IRC network.

Development

*   pixelbeat (Pádraig Brady)
*   jruzicka (Jakub Ruzicka)

Testing

*   rbowen (Rich Bowen)
*   mosulica (Alin Calinciuc)
*   weshay ( Wes Hayutin)

### Prerequisite for Test Day

*   Hardware virtualization support (e.g. Intel VT or AMD-V).
*   Up to 10-20Gb free disk space. Guest images take up a lot of space.
*   ...

*Hardware Requirements: You can do basic testing of OpenStack in a virtual machine, which is auto detected by the install script below*

### How To Test

### Test Cases

### Test Results

If you have problems with any of the tests, report a bug to [Bugzilla](https://bugzilla.redhat.com) usually for one of the [openstack-nova](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-nova), [openstack-glance](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-glance), [openstack-keystone](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-keystone), [openstack-cinder](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-cinder),[openstack-quantum](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-quantum), [openstack-swift](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-swift) or [openstack-heat](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-heat) or [openstack-ceilometer](https://bugzilla.redhat.com/enter_bug.cgi?product=RDO&version=18&component=openstack-ceilometer) components. If you are unsure about exactly how to file the report or what other information to include, just ask on IRC and we will help you.

Once you have completed the tests, add your results to the Results table below, following the example results from the first line as a template. The first column should be your name with a link to your User page in the Wiki if you have one. For each test case, use the [result template](template:result) to enter your result, as shown in the example result line.
