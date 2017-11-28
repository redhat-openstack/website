---
title: A summary of Sydney OpenStack Summit docs sessions
author: pmkovar
date: 2017-11-27 17:00:00 UTC
tags: openstack, summit, sydney, docs, documentation
published: true
comments: true
---

Here I'd like to give a summary of the [Sydney OpenStack Summit](https://www.openstack.org/summit/sydney-2017/) docs sessions that I took part in, and share my comments on them with the broader OpenStack community.

# Docs project update

At this session, we discussed a recent major refocus of the Documentation project work and restructuring of the OpenStack official documentation. This included migrating documentation from the core docs suite to project teams who now own most of the content.

We also covered the most important updates from the [Documentation planning sessions](https://etherpad.openstack.org/p/docs-i18n-ptg-queens) held at the Denver Project Teams Gathering, including our new [retention policy for End-of-Life documentation](http://specs.openstack.org/openstack/docs-specs/specs/queens/retention-policy.html), which is now being implemented.

This session was recorded, you can watch the recording here:

* [https://www.youtube.com/watch?v=OZPPI7yju54](https://www.youtube.com/watch?v=OZPPI7yju54)

# Docs/i18n project onboarding

This was a session jointly organized with the [i18n community](https://wiki.openstack.org/wiki/I18nTeam). Alex Eng, Stephen Finucane, and yours truly gave three short presentations on translating OpenStack, OpenStack + Sphinx in a tree, and introduction to the docs community, respectively.

As it turned out, the session was not attended by newcomers to the community, instead, community members from various teams and groups joined us for the onboarding, which made it a bit more difficult to find out what the proper focus of the session should be to better accommodate the different needs and expectations of those in the audience. Definitely something to think about for the next Summit.

# Installation guides updates and testing

I held this session to identify what are the views of the community on the future of installation guides and testing of installation procedures.

The feedback received was mostly focused on three points:

* A better feedback mechanism for new users who are the main audience here. One idea is to bring back comments at the bottom of install guides pages.

* To help users better understand the processes described in instructions and the overall picture, provide more references to conceptual or background information.

* Generate content from install shell scripts, to help with verification and testing.

The session etherpad with more details can be found here:

* [https://etherpad.openstack.org/p/SYD-install-guide-testing](https://etherpad.openstack.org/p/SYD-install-guide-testing)

# Ops guide transition and maintenance

This session was organized by Erik McCormick from the OpenStack Operators community. There is an ongoing effort driven by the Ops community to migrate retired OpenStack Ops docs over to the OpenStack wiki, for easy editing.

We mostly discussed a number of challenges related to maintaining the technical content in wiki, and how to make more vendors interested in the effort.

The session etherpad can be found here:

* [https://etherpad.openstack.org/p/SYD-forum-ops-guide-transition](https://etherpad.openstack.org/p/SYD-forum-ops-guide-transition)

# Documentation and relnotes, what do you miss?

This session was run by Sylvain Bauza and the focus of the discussion was on identifying gaps in content coverage found after the documentation migration. 

Again, Ops-focused docs tuned out to be a hot topic as well as providing more detailed conceptual information together with the procedural content, and structuring of release notes. We should also seriously consider (semi-)automating checks for broken links.

You can read more about the discussion points here:

* [https://etherpad.openstack.org/p/SYD-forum-docs-relnotes](https://etherpad.openstack.org/p/SYD-forum-docs-relnotes)
