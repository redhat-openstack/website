---
title: Kyle Mestery and the future of Neutron
date: 2015-09-02 16:30:09
author: rbowen
---

At LinuxCon two weeks ago I had the privilege of chatting with Kyle about the future of Neutron. Kyle was a delight to interview, because he's obviously so passionate about his project.

You can listen to the interview --> [HERE](http://drbacchus.com/podcasts/openstack/kyle_neutron.mp3) <-- and the transcript is below.

R: This is Rich Bowen. I'm the OpenStack community liaison at Red Hat.  This is a continuation of my series ... I'm talking with various Project Technical Leads (PTLs) at OpenStack about what's coming in the future. We've noticed ... ever since I've been involved with OpenStack I've noticed that networking is always the number one place where people have difficulties. I'm really excited to be taling with **Kyle Mestery**, who is the PTL of [**Neutron**](https://wiki.openstack.org/wiki/Neutron). Thanks so much for taking time to do this.

K: Absolutely, Rich. Thanks a lot. I'm definitely excited to talk about this, because networking is obviously important. You've got to have a network for your compute nodes.

R: We're doing this in person at LinuxCon. My other two interviews were online. So that's what all this background noise is. When I did the other two interviews, I focused mainly on what's new in Kilo and and what's coming in Liberty. But I'm particularly interested in looking a little bit further out with Neutron, because this seems to be a really difficult problem, but just in the last few years we've seen amazing progress here. Tell me what you see coming in Liberty, and in M and N and O and P and ...

K: I guess what I'd like to start talking about is maybe a little bit less about the technology, and more about the project itself.

Neutron, if you look at all the metrics, whether it's code reviews, bugs, blueprints, everything ... it's in the top four for everything usually. So it's a really large project. And we're also the project that has the most plugins and drivers. So we've kind of had this problem in the history of ... we implemented a platform, for networking, an API and a platform layer, but we also have a reference implementation, and then we have this huge grouping of implementations of the API, whether they're from vendors or other Open Source projects, like [OpenDaylight](https://www.opendaylight.org/) or [OpenContrail](http://www.opencontrail.org/) or something like that.

And there's been this perception problem of, what is Neutron? Is it a platform? Or is it Neutron, the OVS + ML2 implementation? And so I think, over the years, that's been a concern. People who had issues with Neutron, maybe had issues with this OVS + ML2 implementation.

What we've done over the last year - Juno and Kilo - the team's done a lot of work on that implementation - the built-in agent implementation. We've really made that a lot better, and Kilo should be a pretty solid release for people. And we're still doing improvements in Liberty for this.

In parallel, we've helped to enable the platform so things like OpenDaylight, OpenContrails, [Midonet](http://www.midokura.com/midonet/), all of these new projects, OVN, they can also enable and implement the APIs as well, because there's a lot of groups working there.

It's a challenging thing when you're trying to build this platform, and you have your own implementation of it, and you're trying to enable these other groups, too. But I think we've learned a lot over the last year, and the team has done a good job.

R: When I first started hearing about OpenDaylight, it was this magical thing where you could draw lines between blobs and networking would just happen. It feels like maybe that's a long way away, but is there going to be a time when I don't have to be a networking scholar to use OpenStack?

K: Yes, that ultimately is the goal. We're definitely working to get there. So that you as an operator can provide this scalable tenant networking to your tenants, and you as a tenant can just consume it.  And I think we're getting there. I'm hopeful that it's going to be soon.

So, speaking of the future, one of the things that we're looking at beyond Liberty that we've actually spent a lot of Liberty talking about has been this concept of an L3 network as well. So right now the API specifies networks of L2 broadcast domains, and we have subnets and ports and routers and things. It turns out that a lot of operators, especially operators at scale, like GoDaddy and RackSpace and Yahoo, they're very interested in breaking up what a network means, perhaps introducing the concept of an L3 network. They might want to do L3 just per-rack, for example.

This has been a great cycle because we've spent a lot of time with these operators understanding their use case, and we've really refined this. In fact I just literally got out of a meeting. I dialed in remotely to the ops midcycle for this. I think we have this nailed down so that we can get the spec done now and get it approved, and then in [Mitaka](http://superuser.openstack.org/articles/openstack-pins-down-next-release-name-mitaka) we can implement this. This will really help these large deployers, and these large operators, and I think it's going to be a good change.

R: Before we started talking on mic, you were talking about the next cycle, and how Neutron will be tagged in that. Tell us more about that.

K: There were a couple of big developments. The community as a whole has really been working to bring Neutron in, because ... The quick back-story is Nova networking has been around for a long time.  Neutron's been around for 4 years now. We're getting close to the point where hopefully we can finally deprecate Nova network. We're not quite there. But the community as a whole has done a couple of great things.

Number one, there was recently, as part of the tag process with new governance changes, someone proposed a [starter-kit:compute](http://governance.openstack.org/reference/tags/compute_starter_kit.html) tag, that was summarized as what services in OpenStack you need to bring up a small compute cluster. Initially that had Nova network. Now the interesting thing was, we as the Neutron team, we really pushed for Neutron on there, and it emerged with Nova network, but Monty Taylor actually proposed a patch to change it to Neutron, with the logic being, if you put someone in and start this cloud with Nova network, you can't really grow it and expand to Neutron.

So, it was great. The community came together and we all merged it, and so now Neutron is recommended.

Now, in parallel, I was just at the OpenStack board meeting, and I dialed into the [Defcore](https://wiki.openstack.org/wiki/Governance/DefCoreCommittee) midcycle. The current cycle that they're starting for Defcore, they're going to focus on Neutron as the default networking there as well.

R: Great!

K: Yeah. So it's been really great to see the community come together and rally around Neutron.

R: The project's only five years old. Looking forward another five years, what do you envision for Neutron?

K: I really think that we're kind of evolving it to be this platform - to be a platform layer at this point. So the hope is that one of these great Open Source networking projects like OpenDaylight, for example, could maybe come in and become the default networking, or something like that - could become this rock-solid awesome thing.

R: That seemed to be their goal when they started out.

K: Yeah, and they're doing a great job. I've been involved with OpenDaylight, and there's a great team from Red Hat, amongst other companies, HP, Cisco, Brocade, a really good team up there that's working really hard, and doing a lot of great stuff, and making progress. It's been fun to see that.

So that's the goal, to make it a platform. One of the things we were looking at doing was spinning out the reference implementation into its own Gerrit repository, so it could be on equal footing with some of these other things that are out there. And I think we'll do that in Mitaka. We didn't quite do that in Liberty, but maybe then.

R: When I was doing a little research before we talked, I was looking at the Neutron Git repository. It seems that it's got more than any other project - just dozens of subprojects. If somebody wanted to get involved with Neutron, as a developer, is there an easy place - is there an easy in?

K: My recommendation would be, reach out in #openstack-neutron on Freenode. There's a lot of us core reviewers and other community members who are there are willing to help out. We have a lot of bugs in Launchpad, and we try to tag a bunch as low-hanging fruit, which hopefully are easy for initial developers, which also helps. And we've done a lot to enhance our DevRef - http://docs.openstack.org/developer/neutron/devref/ - documentation to hopefully make it easier for new developers to pull the tree and then go and look at what's there and say all this is documented better.  We've really focused on that so hopefully it's easier for new people to get involved. and contribute.

The documentation team in Openstack has been great. This cycle we had some members of that team along with some Neutron people really enhance the install guide. One of the things we did was we came up with a comparable install mode to what Nova network had. You could always do it in Neutron, it turns out it wasn't documented well. So we documented that. And the other thing is we had some of the documentation people ... it turns out we have a lot of documentation in DevRef, around installation and configuration, that probably should live in the install or networking guide, and so that's moving there too. We're doing a lot of work there.

I'm really excited about, and it's really hard to believe Liberty is in two weeks. We're two weeks out, and I'm at LinuxCon. I was just in the cross-project meeting. At this point, we're really trying to focus on finishing Liberty. Then we'll take a small break, and ramp up for Mitaka again.

R: Thanks so much for your time.

K: Absolutely. Thanks, Rich.