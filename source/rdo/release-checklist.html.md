---
title: Release-Checklist
authors: rbowen
---

# Release checklist

An important part of doing a release is getting word out to the
community, and telling the right stories about the release. In the case
of RDO, it's important to give appropriate credit to the upstream, while
pointing out what we've done on top of that.

Here's a helpful checklist of things that we should do around a release.

## Communicate with the community

* Notify CentOS that a release is imminent, so that we can queue any
  additional jobs that must run, and get availability of support people
  to help with that.
* Notify various press outlets that this is coming, so that we can
  schedule stories if desired.
* Notify user community (RDO, CentOS) that a release is coming.

## Talking Points

What's new or interesting in this release that we
want to talk about? We should work on this in the 2 weeks leading up
to a release, rather than trying to put it together the day of the
release.

* What's in the release?
* What upstream features are most important (point to upstream news
  source for this)
* Who did awesome stuff in the release? This can be generated using data
  from Gerrit, and the `gerritstats` project:
  below instructions:
    * Set up on a Fedora container based on the instructions on GitHub, then:

    ./gerrit_downloader.sh --after-date 2017-02-22 --server review.rdoproject.org --output-dir gerrit_out/

    * Enter the gerrit_out directory, and copy all the -distgit- json files to another directory `gerrit_distgit/` and run:

    ./gerrit_stats.sh --branches rpm-master -f gerrit_distgit/

## Technical release criteria

Before formally announcing a new release to the community, it is necessary to ensure that some
technical conditions are met with CloudSIG builds in order to validate the release works as expected.

* All the packages provided in the repository are installable with no errors in an updated CentOS Stream system.
* The three packstack all-in-one upstream scenarios can be executed successfully.
* All the puppet-openstack-integration scenarios can be executed successfully.

This criteria has been agreed for Antelope GA and may be updated for next releases.

## Release fanfare

A week before a release, we should write a release announcement in a public etherpad,
inviting a number of stakeholders to see it and comment on it. The invite list should
be very inclusive, but not so large as to result in bikeshedding.

A release announcement should include:

* Where to get it
* What's in it
* When the *next* release is coming
* Highlight the work of individuals when possible, especially people
  that are not @redhat.com
* How one can get involved in the project
* (Link to) [basic information about RDO](/rdo)

The release announcement should be sent to the following lists:

* rdo dev list - dev@lists.rdoproject.org
* rdo users list - users@lists.rdoproject.org
* centos-devel - centos-devel@centos.org
* openstack-discuss - openstack-discuss@lists.openstack.org
* Twitter - @rdocommunity
* Facebook - http://facebook.com/rdocommunity
* RDO blog - http://rdoproject.org/blog

## What not to do

* Release on Friday
* Take credit for work done in the upstream

## After the release

* Update the [release cadence doc](/rdo/release-cadence/)
* Update this doc with whatever was learned
* Continue to mention it on the above channels during the lifetime of
  the release, and when people mention that they're using older
  versions.
* Update [what's in RDO](/rdo/projectsinrdo) with any added packages

