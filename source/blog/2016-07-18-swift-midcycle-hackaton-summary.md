---
title: OpenStack Swift mid-cycle hackathon summary
author: cschwede
tags: blog, openstack, swift
date: 2016-07-18 12:21:00 CEST
published: true
---

# OpenStack Swift mid-cycle hackathon summary

Last week more than 30 people from all over the world met at the Rackspace
office in San Antonio, TX for the Swift mid-cycle hackathon. All major companies
contributing to Swift sent people, including Fujitsu, HPE, IBM, Intel, NTT,
Rackspace, Red Hat, and Swiftstack. As always it was a packed week with a lot
of deep technical discussions around current and future changes within Swift.

There are always way more topics to discuss than time, therefore we collected
topics first and everyone voted afterwards. We came up with the following major
discussions that are currently most interesting within our community:

- Hummingbird replication
- Crypto - what's next
- Partition power increase
- High-latency media
- Container sharding
- Golang - how to get it accepted in master
- Policy migration

There were a lot more topics, and I like to highlight a few of them.

## H9D aka Hummingbird / Golang

This was a big topic - as expected. It has been shown by Rackspace already that
H9D improves the performance of the object servers and replication
significantly compared to the current Python implementation. There were also
some investigations if it would be possible to improve the speed using PyPy and
other improvements; however the major problem is that Python blocks processes
on file I/O, no matter if it is async IO or not. Sam wrote a very nice summary
about this earlier on [[1]][1].

NTT also benchmarked H9D, and showed some impressive numbers as well. Shortly
summarized, throughput increased 5-10x depending on parameters like object size
and the like. It seems disks are no longer the bottleneck - now the proxy CPU is
the new bottleneck. That said, inode cache memory seems to be even more
important because with H9D one can do many more disk requests.

Of course there were also discussions about another proposal to accept golang
within OpenStack and discussions will continue [[2]][2]. My personal view is that
the H9D implementation has some major advantages and hopefully (a refactored
subset) will be accepted to be merged to master.

## Crypto retro & what's next

Swift 2.9.0 has been released the past week and includes the merged crypto
branch [[3]][3]. Kudos to everyone involved, especially Janie and Alistair! This
middleware make it possible for operators to fully encrypt object data on
disk.

We did a retro on the work done so far; it has been the third time that we used
a feature branch and a final soft-freeze to land a major change within Swift.
There are pros and cons for this, but overall it worked pretty well again.  It
also made sense that reviewers stepped in late in the process, because this
added new sights onto the whole work. Soft freezes also enforce more reviewers
to contribute to it and get it merged finally.

Swiftstack benchmarked the crypto branch; as expected the throughput decreases
somewhat with crypto enabled (especially with small objects), while proxy CPU
usage increases.  There were some discussions about improving the performance,
and it seems the impact from checksumming is significant here.

Next steps to improve the crypto middleware is to work on some external key
master implementations (for example using Barbican) as well as key rotation.

## Partition power increase

Finally there is a patch ready for review now, that will allow an operator to
increase the partition power without downtime for end users [[4]][4].

I gave an overview about the implementation, and also showcased a demo how this
works. Based on discussions during the last week I spotted some minor
eventualities that have been fixed meanwhile, and I hope to get this merged
before Barcelona. We somewhat dreamed about a future Swift that might be usable
with automatic partition power increase, where an operator needs to think about
this much less than today.

## Various middlewares

There are some proposed middlewares that are important to their authors, and we
discussed quite a few of them. This includes:

- High-latency media (aka archiving)
- symlinks
- notifications
- versioning

The idea to support high-latency media is to use cold storage (like tape or
other public cloud object storage with a possible multi-hour latency) for less
frequently accessed data and especially to offer a low-cost long-term archival
solution based on Swift [[5]][5]. This is somewhat challenging for the upstream
community, because most contributors don't have access to large enterprise tape
libraries for testing. In the end this middleware needs to be supported by the
community, and a stand-alone repository outside of Swift itself might make most
sense therefore (similar to the swift3 middleware [[6]][6]).

A new proposal to implement true history-based versioning has been proposed
earlier on, and some open questions have been talked about. This should land
hopefully soon, adding an improved way to versioning compared to today's
stack-based versioning [[7]][7].

Sending out notifications based on writes to Swift have been discussed earlier
on, and thankfully Zaqar now supports temporary signed urls, solving some of
the issues we faced earlier on. I'll update my patch shortly [[8]][8]. There is
also another option to use oslo.messaging. All in all, the whole idea will be
to use a best-effort approach - it's simply not possible to guarantee a
notification has been delivered successfully without blocking requests.


## Container sharding

As of today it's a good idea to avoid billions of objects in a single container
in Swift, because writes to that container can get slow then. Matt started
working on container sharding sometime ago [[9]][9], and iterated once again because
he faced new problems with the previous ideas. My impression is that the new
idea is getting much closer to something that will eventually be merged, thanks
to Matt's persistence on this topic.

## Summary

There were a lot more (smaller) topics that have been discussed, but this
should give you an overview of the current work going on in the Swift
community and the interesting new features that we'll see hopefully soon in
Swift itself. Thanks everyone who contributed and participated and special
thanks to Richard for organizing the hackathon - it was a great week and I'm
looking forward to the next months!

[1]: http://lists.openstack.org/pipermail/openstack-dev/2016-May/094549.html
[2]: https://review.openstack.org/#/c/339175/
[3]: http://lists.openstack.org/pipermail/openstack-announce/2016-July/001339.html
[4]: https://review.openstack.org/#/c/337297/
[5]: https://wiki.openstack.org/wiki/Swift/HighLatencyMedia
[6]: https://github.com/openstack/swift3
[7]: https://review.openstack.org/#/c/214922/
[8]: https://review.openstack.org/#/c/196755/
[9]: https://github.com/matthewoliver/swift/tree/sharding_snip
