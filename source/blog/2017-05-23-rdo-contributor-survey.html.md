---
title: RDO Contributor Survey
author: rbowen
date: 2017-05-23 15:28:58 UTC
tags: survey,contributor
comments: true
published: true
---

We recently ran a contributor survey in the RDO community, and while the participation was disappointing  (21 respondants), we still gained a few useful insights from it.

First, and unsurprisingly:

![](/images/blog/2017ContributorSurvey/affiliation.png)

Of the 20 people who answered the "corporate affiliation" question, 18 were Red Hat employees. While we are already aware that this is a place where we need to improve, it's good to know just how much room for improvement there is. What's useful here will be figuring out *why* people outside of Red Hat are not participating more. This is touched on in later questions.

Next, we have the frequency of contributions:

![](/images/blog/2017ContributorSurvey/frequency.png)

Here we see that while 14% of our contributors are pretty much working on RDO all the time, the majority of contributors only touch it a few times per release - probably updating a single package, or addressing a single bug, for that particular cycle.

This, too, is mostly in line with what we expected. With most of the RDO pipeline being automated, there's little that most participants would need to do beyond a handful of updates each release. Meanwhile, a core team works on the infrastructure and the tools every week to keep it all moving.

We asked contributors where they participate:

![](/images/blog/2017ContributorSurvey/type.png)

Most of the contributors - 75% - indicate that they are involved in packaging. (Respondants could choose more than one area in which they participate.) Test day participation was a distant second place (35%), followed by documentation (25%) and end user support (25%)

I've personally seen way more people than that participate in end user support, on the IRC channel, mailing list, and ask.openstack.org. Possibly these people don't think of what they're doing as support, but it is still a very important way that we grow our user community.

The rest of the survey delves into deeper details about the contribution process.

![](/images/blog/2017ContributorSurvey/ease.png)

When asked about the ease of contribution, 80% said that it was ok, with just 10% saying that the contribution process was too hard.

When asked about difficulties encountered in the contribution process:

![](/images/blog/2017ContributorSurvey/difficulties.png)

Answers were split fairly evenly between "Confusing or outdated documentation", "Complexity of process", and "Lack of documentation". Encouragingly, "lack of community support" placed far behind these other responses.

It sounds like we have a need to update the documentation, and greatly clarify it. Having a first-time contributor's view of the documentation, and what unwarranted assumptions it makes, would be very beneficial in this area.

When asked how these difficulties were overcome, 60% responded that they got help on IRC, 15% indicated that they just kept at it until they figured it out, and another 15% indicated that they gave up and focused their attentions elsewhere.

Asked for general comments about the contribution process, almost all comments focused on the documentation - it's confusing, outdated, and lacks useful examples. A number of people complained about the way that the process seems to change almost every time they come to contribute. Remember: Most of our contributors only touch RDO once or twice a release, and they feel that they have to learn the process from scratch every time. Finally, two people complained that the review process for changes is too slow, perhaps due to the small number of reviewers.

I'll be sharing the full responses on the RDO-List mailing list later today.

Thank you to everyone who participated in the survey. Your insight is greatly appreciated, and we hope to use it to improve the contributor process in the future.
