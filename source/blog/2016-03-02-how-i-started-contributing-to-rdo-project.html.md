---
title: How i started contributing to the RDO Project
author: chandankumar
tags: 
date: 2016-03-02 22:20:36 IST
---

During my internship period at Red Hat, [Kushal](https://kushaldas.in/) used to play with OpenStack and got a problem that a created instance is not able to get a public IP address so that he can access it from outside.

From there I got introduced to OpenStack. I started by trying to install OpenStack (Icehouse) following the upstream documentation, to reproduce this problem.
There, I found the steps were wrong, and from there I sent my first patch to the OpenStack docs which is when my [contribution](http://stackalytics.com/report/users/chandankumar-093047) to OpenStack begins.
I tried devstack, packstack, and other installers to deploy OpenStack.

But I exactly don't remember how I got involved with [RDO Project](https://www.rdoproject.org/). As per [Gerrit Hub Review history](https://review.gerrithub.io/#/q/owner:chkumar246%2540gmail.com+status:merged),
I made my first contribution to the RDO packages in March 2015. Since last year, I started attending [RDO meetings](https://www.rdoproject.org/community/community-meeting) regularly.
In the beginning, I just used to read the meeting logs and try to find out what is happening in the community.
But later on, I started taking action items and tried to prepare for next meeting. 
I failed a lot of times in the beginning and worked with the motive to complete the tasks properly.
One day, I accidently raised my hand for chairing RDO meeting and it was a nice experience.
Now I usually volunteer for chairing the RDO meeting.

During the starting of liberty release, the RDO CI used to break due to missing packages. It was then I learned about [RPM packaging](https://www.rdoproject.org/packaging/rdo-packaging.html) and started fixing those packages. Currently, I am maintaining 16 [Fedora packages](https://admin.fedoraproject.org/pkgdb/packager/chandankumar/) and have learned a lot on how to fix packages when things went wrong.

At the same time, I had started sending out [RDO Bug Statistics](https://www.redhat.com/archives/rdo-list/2016-March/msg00004.html) to the RDO mailing list. It's a plain text report of how many new bugs were filed for different component, linked with the RDO product from Bugzilla, with comparisons to the previous week. You can look out for RDO bug statistics email on every Wednesday on the RDO mailing list.

I am also involved in Python3 porting and including test requirements for RDO packages, which are still in progress. I learned how to help other package maintainers to improve their packages, which are consumed as a dependency in RDO.

In last three months, I worked with the CERN guys to package Magnum and Magnum client, where I learned how a new OpenStack service is packaged and imported in RDO.

Apart from that, I am contributing to the Delorean Project which powers the RDO CI and the RDO website during DOC and RDO test days. I've been also maintaining 4 [RDO packages](https://github.com/redhat-openstack/rdoinfo/blob/master/rdo.yml).

**So, is contributing to RDO easy?**
Yes.

* Are you a newcomer (want to dive into OpenStack)?
    - First try and test it using RDO Project [quick start guide](https://www.rdoproject.org/install/quickstart/) and get your cloud running in 15 minutes.
    - Next, try out different scenarios and configure OpenStack services using RDO website documentation, look for anything wrong or enhancements that can be made in the documentation.
      RDO Project [website source](https://github.com/redhat-openstack/website) is on Github and requires Markdown, so feel free to create an issue and send a pull request.
* Participate in weekly RDO meeting every Wednesday on #rdo channel on Freenode. Take action items and participate in the conversation. It will help you to know what is happening in the community and what's new coming.
* Check the RDO Bug stats each Wednesday and help them in getting it traised.
* Participate in RDO Docs day and Mitaka RDO test days.
* Help in answering OpenStack Questions on [ask.openstack.org](https:ask.openstack.org)
* Learn RPM packaging and start reviewing new package review bugs and fix the spec of RDO Packaging.
* Know Python, contribute to [Delorean](https://github.com/openstack-packages/delorean) and [rdopkg](https://github.com/redhat-openstack/rdopkg) which powers the RDO packages development.
* Look for issues in the OpenStack services and feel free to report the issue to the OpenStack upstream.

Lastly, contributing to RDO Project helps you to contribute to OpenStack upstream and also helps growing the RDO Community.

Thanks to [apevec](https://twitter.com/apevec_), [number80](https://twitter.com/hguemar), [rbowen](https://twitter.com/rbowen), [jpena](https://twitter.com/fj_pena), [dmsimard](https://twitter.com/dmsimard), [EmilienM](https://twitter.com/EmilienMacchi), [mrunge](https://twitter.com/matrunge), jruzicka and many more who helped me with fixing my silly mistakes and encouraging me to contribute more.
