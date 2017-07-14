---
title: What did you do in Mitaka? Adam Young
author: rbowen
date: 2016-05-06 20:08:42 UTC
comments: true
published: true
---

In this installment of our "What did you do in Mitaka" series, I speak to Adam Young about Keystone.


<iframe src='https://www.podbean.com/media/player/jf485-5f1716?from=yiiadmin' data-link='https://www.podbean.com/media/player/jf485-5f1716?from=yiiadmin' height='100' width='100%' frameborder='0' scrolling='no' data-name='pb-iframe-player' ></iframe>

(If the above player doesn't work for you, please download the audio [HERE](https://rdocommunity.podbean.com/mf/play/uq6sgx/adam-young-mitaka.mp3).)

**Rich**: I'm speaking with [Adam Young](http://adam.younglogic.com/) , who's been working on the [Keystone](http://docs.openstack.org/developer/keystone/)
project for the last 4 years or so.

So, Adam, what did you do in Mitaka?

**Adam**: This release, I finally got a couple key features into Keystone
for dealing with some security issues that have bothered me for a
while. The biggest one is the ability to deal with admin - the fact
that if you're admin somewhere you end up being admin everywhere. 

This is bug [968696](https://bugs.launchpad.net/keystone/+bug/968696). Yes, I have the number [memorized]. I even had
tshirts made up for it. We're finally closing that bug. Although
closing it properly will take several releases.

The issue with bug 968696 is that we have no way of splitting out what
certain APIs are that are supposed to be admin-specific. Like, you can
see that there's a difference between adding a new hypervisor, and
going into a project and creating a virtual machine. They are
different levels of administration. There are certain APIs that need
to have admin, that are really project-scope things. Things like
adding a user to a project - role assignment - that's admin level at
the project, as opposed to admin level at the overall service.

So what we did is we put a config option in Keystone which lets you
say that a certain project is the adminstrative project. Tokens that
are issued for a user that are scoped to that project have an
additional field on them. is_admin_project. This can be enforced in
policy across OpenStack. It does mean that we need to rewrite the
policy files. We knew this was going to be a long slog.

There's a way of now being able to say on a given policy rule, this is
not just that they have to have the admin role, but that they have to
have the admin role on a project that's considered the admin project.

It also allows you to say, if I have admin on the admin project, I can
go into a non-admin project, and do these administrative type things.
But somebody who is admin on some other common project, some other
regular project, does not have the ability to do that. So the projects
continue to be the main scoping for access control, but we have this
level of defining things to be cloud- or service-level administration.

So that was one of the big ones. We'll continue to drive on with using
that - making that policy change throughout Nova, Glance, and the
rest, because if they're not enforcing it, then it is still a global
admin. So there's more work to be done there.

The other big feature falls into a similar type of problem-set, which
is, roles are very, very coarse grained. If you look at the early days
of OpenStack, there really was only one role, which was admin. And
then everybody else was a member of a project.

By the time I started, which was four years ago, there already was the
idea that a role assignment was for a role on a project. Role
assignments were no longer global, even though they had been in the
past. A lot of people still kept treating them like they were global
things, but the mechanism scoped it to a project. What we wanted to be
able to is say, I want to be able to have a different role for
different operations - different workflows. So that I can assign small
things, and I can delegate smaller pieces of what I need to do to a
user.

A good example is that I might not want somebody to be able to create
a virtual machine, or some offline service to be able to create a
virtual machine on by behalf, but I want them to be able to reboot one
of mine. They can monitor, and if it locks up they should be able to
reboot that virtual machine.

So what we have is this concept of an implied role, or role inference
rule.

The first one, and the example that everyone kind of gets is, if I'm
an admin on a project, I should be a member on that project. So now,
when I have a token and I reqest admin on there, I will see both the
admin role and the member role inside that project, even if I don't
have the member role explicitly assigned to me.

Now in the API I could specify, you only need the member role to do
this. So now we've just made it easier to roll up finer-grained
permissions to a more coarse-grained role assignment.

This, it turned out, was a feature that somebody else could use to
implement something they were talking about doing. [Henry Nash](http://stackalytics.com/report/users/henry-nash), who
works at IBM, had this proposal for domain-specific roles. He wanted
to be able to have somebody who's in some organization, specify what
the name of the role was that they gave to people, and it also
included a subset of what the person could do there.

I said, that really sounds like a role inference rule, but one where
a) the top-level name is assigned by somebody who's not a global cloud
administrator, the domain administrator, and b) it doesn't show up in
the token. I don't want domain-specific roles to be something that
people are enforcing policy on. I want it to be [only enforce on] the global roles.

So we worked together and came up with this idea that we get implied
roles in first, and then we would build the domain-specific roles on
top of that.

It took a lot of collaboration - a lot of arguing and a lot of
understanding ... to explain to the other person what our problems
were, and coming to the idea that a very elegant mechanism here could
be the baseline for both features.

So we're presenting on both of those things together, actually, on
Tuesday at Summit. (OpenStack Summit, Austin - [video here](https://www.openstack.org/videos/video/advances-in-keystones-role-based-access-control) ) The Nash and Young
reunion tour. We couldn't get either [Stills or Crosby](https://en.wikipedia.org/wiki/Crosby,_Stills,_Nash_%26_Young) to show up.

Beyond that, Keystone is, as somebody once described it, performance
art. Getting Keystone features in requires a lot of discussion. It's
really fundamental to OpenStack that Keystone just work.

A lot of people will file bugs against Keystone, because it's the
first thing that reports a failure. Or someone reports a failure
trying to talk to Keystone. So a lot of time has been spent in
troubleshooting other people's problems, connectivity problems,
configuration problems, and getting it so that they understand, yes,
you can't talk to Keystone, but it's because you have not configured
your service to talk to Keystone. 

And one of the big victories that we had is that a whole class of
errors that we had were due to threading issues in eventlet, and
eventlet is dead. Eventlet has been deprecated for a while. In
TripleO we have it so that Keystone is not being deployed in eventlet
any more. This means that we don't have the threading issues there.

A big lesson that we've learned is that the cloud deployer does not
necessarily own the user database. And for large organizations, there
already is a well-established user database, and so we want to reuse
... a lot of people point to stuff like Facebook, and Google, and
LinkedIn, as public authentication services now. OpenID, OAuth, and
all those, are protocols that make it possible to consume these big
databases of identity, and then you can use your same credentials that
you use to talk to Facebook, to talk to your apps.

Well, this same pattern happens a lot inside the enterprise, and in
fact it's the norm. It's called Single Sign On, and a lot of people
want it. And pushing Single Sign On technologies, and making those
work within Keystone has been a long-running task.

There's been a lot of LDAP debugging. It's still one of the main pain
points for people. LDAP is a primary tool for most large organizations
for managing the users. The D in there stands for Directory and it's
user directory for large organizations. A lot of people have to make
it work with Active Directory, Microsoft being so dominant in the
enterprise, and Active Directory being their solution for that has
made it a pain point. So one of the big things we've been trying to do
is make that integrate in better with existing deployments.

Over multiple releases we had this idea that first you had one
monolithic identity back-end. And then we split that out into two
pieces, one which was the identity, the users and the groups, and the
other which was the assignment - what roles you had on each project.

Now that we can vary those two things differently, what we started
doing is saying, how about having multiple things on that identity
side? Federation kind of works in there but before that we actually
said you could have SQL back your user database, and that would be your
basic install. All the service users for Keystone, and Nova and so on
would be put in there, and then let's make a separate domain and put
LDAP in there. So the big push has been to do that.

Well it turns out that in order to do that we need everybody to use
the Keystone V3 API, because they need domain support. Specifically
internally, the different services need to do this.

A lot of people have helped make this happen. This has been a
multi-project effort because not only do we need to solve it within
all the Keystone components, but then there are places where one
service calls into another and needs to authenticate with Keystone and
those calls there are calling through client network access.

So we're finally at a place where V3 Keystone API everywhere is a
reality, or can be a reality, and so getting the pain of LDAP into its
own domain has been an ongoing theme here. I really feel it's going to
make things work the way people want them to work.

One of the nice benefits of this, especially for new deployments, is
they no longer have to put service users into LDAP. This was a
dealbreaker for a lot of people. LDAP is a read-only resource. If,
say, the OpenStack user does not own the user database, that includes
service users. So being able to have service users in a small database
inside Keystone, and have consume the rest of the identity from LDAP
has always been the dream.

Keystone moves very slowly. It's a very cautious project, and it has
to be.

**Rich**: Because it has to just work.

Adam: It has to just work, and it's the target for security. If you
can hack Keystone, then you have access to the entire cloud. And if
you're using LDAP, you have the potential to provide access to things
beyond the cloud.

**R**: Tell me about some things that are coming in upcoming releases.

**A**: One that I'm looking forward to in Newton is the ability to unify
all the delegation mechanisms. What we're doing with [trusts](https://wiki.openstack.org/wiki/Keystone/Trusts), which is
something I built specifically for Heat a couple of releases ago, and
have taken on this way of a user being able to delegate another user a
subset of their permissions, and to be able to delegate the ability
to delegate. You don't have to be an admin in order to create some
sort of delegation, but you can be an everyday user and hand off, to
maybe a scheduled task, to do something on your behalf, at midnight
when you're on vacation. 

The other one that I'm really looking forward to trying to drive on is
the adoption of [Fernet](http://dolphm.com/openstack-keystone-fernet-tokens/). We were hoping to get that into the Mitaka
release. Fernet is in there, but trying to make it the default.

Fernet is an ephemeral token. The way that tokens work with Keystone
now ... it's a UUID. It's a claim check that you can hand to somebody
and they can go back to Keystone, assuming they have authority to do
this, and say, what data is associated with this token?

Well, Keystone has to record that.

If you have two different Keystone servers, and they're both issuing
out tokens, they have to talk to the same database. Because I might
get one issued from one, and go to a different one to validate it.

This is a scalability issue.

PKI tokens, which I wrote many releases ago, were a first attempt to
deal with this, because you could have different signers. But PKI
tokens had a lot of problems. [Dolph and
Lance](https://www.youtube.com/watch?v=702SRZHdNW8), who are
Rackspacers, who have been long-term contributors, came up with this
implementation called Fernet tokens. The idea is that you use
symmetric cryptography. You take the absolute minimal amount of data
you need to reconstitute the token and you sign it. Now, the Keystone
server is the only thing that has this key. So that means it's the
only thing that can decrypt it. So you still need to pass the token
back to Keystone to validate it, but Keystone no longer has to go to a
database to look this up. It can now take the Fernet token itself, and
say here's what it means. And if you have two different Keystone
servers, and they share keys, you can get one issued from one, and
have the other one validate it for you.

**R**: Well, thank you again for taking the time to do this.

**A**: My pleasure.
