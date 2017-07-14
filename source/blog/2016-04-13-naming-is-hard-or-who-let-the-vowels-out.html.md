---
title: Naming is hard or Who Let The Vowels Out
author: apevec
date: 2016-04-13 12:00:00 UTC
tags: openstack, trunk, packaging
comments: true
published: true
---

When [Derek Higgins](http://www.openstack.org/blog/2014/02/open-mic-spotlight-derek-higgins/) started the [tool](https://github.com/openstack-packages/DLRN/commit/496baa4eb177873ba1421c6fbd7cc7041bd584a4) to build OpenStack packages based on latest upstream aka "trunk" changes, the name Delorean seemed like a good choice: the tool is keeping older builds so you could "go back in time" like with a [time machine](https://en.wikipedia.org/wiki/DeLorean_time_machine), it's geeky enough and there's [Irish connection](https://en.wikipedia.org/wiki/DeLorean_Motor_Company#Manufacturing_facility).

Fast forward earlier this year, when this tool is used and maintained by the [RDO team](https://www.rdoproject.org/community/) to build [RDO trunk](https://trunk.rdoproject.org/) repositories, it was felt the time is right for the first release. And here is the first lesson when naming a (Python) project: check that name is available in [PyPI](https://pypi.python.org/pypi) and reserve it! Unfortunately, it turned that name Delorean was already [taken by another project](https://pypi.python.org/pypi/Delorean). Next, lesson two: check if there is an active company using that name to avoid any possibility of trademark issues! In this case, a new company [got rights for the original DMC (TM)](https://en.wikipedia.org/wiki/DeLorean_Motor_Company#Today).

On [RDO community meeting](https://www.rdoproject.org/community/community-meeting/) we decided to start collecting new name proposals and came up with the [list](https://etherpad.openstack.org/p/RDO-Delorean-rename) more or less in the same time travel and BTTF theme. The first proposal was [fluzo](https://es.wikipedia.org/wiki/Condensador_de_flujo) by our Spanish-speaking folks but that was dismissed after finding out there is a company with exactly that name! Next was OUTATIME, the DeLorean time machine's license plate text, but there's actually a real movie with that name coming soon, so it was discarded to avoid confusion and possible trademark issues. Finally, staying with the license plate idea, DLRN was chosen: written as DLRN but you can read it Delorean.

The RDO community has already started work towards replacing mentions of "Delorean" in documentation, websites, code, and repositories. As a special case references mentioning "Delorean repository" will be renamed as "RDO trunk repository" to better describe the content.

P.S. The answer to the question in the title is dprince! [1]

[1]: https://meetbot.fedoraproject.org/rdo/2016-03-09/rdo_meeting_%282016-03-09%29.2016-03-09-15.01.log.html#l-141