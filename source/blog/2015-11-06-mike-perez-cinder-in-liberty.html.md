---
title: 'Mike Perez: Cinder in Liberty'
author: rbowen
date: 2015-11-06 18:59:15 UTC
tags: openstack, cinder, ptl
comments: true
published: true
---

Before OpenStack Summit, I interviewed Mike Perez about 
what's new in Cinder in the LIberty release, and what's coming in Mitaka. Unfortunately, 
life got a little busy and I didn't get it posted before Summit. However, with Liberty still 
fresh, this is still very timely content.

In this interview, Mike talks about the awesome new features that have gone into [Cinder](https://wiki.openstack.org/wiki/Cinder) for Liberty, and what we can expect to see in April.

If the audio player below doesn't work for you, you can download the full audio [HERE](http://drbacchus.com/podcasts/openstack/mike_perez_cinder.mp3). See also the complete transcript below.

<audio controls>
  <source src="http://drbacchus.com/podcasts/openstack/mike_perez_cinder.mp3" type="audio/mpeg">
</audio>

**Rich**: Today I'm speaking with Mike Perez, who is the PTL of the Cinder
project. Cinder has been around for ...

**Mike**: Since the Folsom release.

**R**: So, quite a while. Thanks for taking time to talk with me.

I wonder if you could start by giving us a real quick definition of
Cinder. I know that people who are new to OpenStack are frequently a
little bit confused as to what it is, and how it differs from Swift
and various other storage type things that are part of OpenStack.

**M**: Cinder, just like a variety of other OpenStack projects, is just an
API layer. So unlike other projects like [Swift](https://wiki.openstack.org/wiki/Swift), for example, which is
an actual implementation of a type of storage, that's where there
would be a little bit of a difference right there.

In particular, Cinder is more interested in providing block storage,
as opposed to object storage. They have differences in terms of how
exactly you interact with retrieving the data, as well as adding data
to it, and then they also support different types of use cases. In
particular, just without Cinder or Swift in the picture, if you just
have your OpenStack cloud with Nova and Neutron, you just have
ephemeral storage that you're using with your instances. Typically,
with those type of setups, your storage goes away as soon as the
instance goes away. Adding Cinder into the picture, though, you are
given the ability to have persistent storage, so that the storage
itself becomes completely independent of the actual virtual machine
instance. So when you terminate your virtual machine instance on the
Nova side, there will be a detach of that block storage volume, and
then you can later on attach it to another virtual machine instance.

**R**: Tell us about Liberty. What's new in Cinder?

**M**: Inside of the Liberty release we have 16 new volume drivers.
They're all backed with Cinder continuous integration testing that we
adopt from Tempest. Cinder has one of the most - I would say - the
most drivers out of the OpenStack projects. We're just shy of around
60 volume drivers now. Some of them are from multiple vendors. As I
mentioned before, they are all backed behind the continuous
integration, so we know for a fact, as we are going through a
development cycle in Liberty, these volume drivers, the actual
back-ends themselves, are being tested. Every single vendor is
expected to have a CI system in their own lab, hooked up to a real
storage solution that they are trying to support inside of Cinder.
That patch will bring us - they're expected for their CI to bring up a
CI instance that connects to that storage back-end and runs their
Tempest tests, and verify that that patch doesn't break their
integration with their volume driver. That came back in the Kilo
release. The story's in a lot of different places. It was a lot of fun
getting us to that point. It's been nice talking to other projects,
because I know a lot of other projects are interested in going down
the same path, and it's been great having discussions with a variety
of other PTLs on it. 

And along with that we added in support for image caching. You have an
image inside of Glance that you want to boot up a VM with that image.
And with Cinder in particular, since the storage itself is in some
other remote location from that virtual machine, because we're
attaching over something like ISCSI or fibrechannel, grabbing the
image from wherever Glance is at, whatever Glance store is set up with
Glance itself - could be inside of Swift for example, you have an
image inside of Swift - and you want to put that image onto a newly
allocated space volume inside of Cinder, in order to do that, it has
to go across the network to whatever storage solution Cinder is set up
with, and that can be really time consuming, especially for some of
our users that are using 20-40Gb images. It can take a lot of time to
boot up that VM. Cinder itself has a very generic image caching
solution that we added in for the Liberty release, that allows for the
most popular images inside of your cloud to be cached within the
back-end storage solution. So what that means is, for that cache we
can do some really smart things with the different storage solution.
Instead of doing copy of the actual image, we can do copy-on-writes,
for example. So it's pretty much a zero copy, you're just pointing a
reference to that image that's already allocated on that storage
solution. And then create a new volume off of that reference pointer.
Bam! You have a new volume that is set up with that image, and there's
zero copies that had to happen. I think that's going to take care of a
really popular problem, that comes up, and should make users really
happy for this release.

Some of the other things that we added support for that are kind of
general things is nested quota support, for example. Keystone has this
ability with having projects within projects. Users and operators want
to be able to have the ability to set quotas based on having a
hierarchy for quotas. I'm not sure about other projects, but Cinder
has added this in now for the Liberty release, so you will be able to
add that with your different volume allocation, as well as your
gigabyte allocation as well, for project hierarchy.

The third piece I would add in is the non-disruptive backups. Cinder
has this ability for doing backups. These are different from
snapshots. Snapshots, you're typically doing the actual volume itself.
You're copying the entire allocation of that volume. So, let's say you
have a 100G volume, and you're only using 5G of it, it's still doing a
snapshot of 100G, even unused parts. The difference with a backup is
you have the ability to do a backup of just the contents, what you're
actually using. And on top of it you're also able to have the volume
backed up to another location, let's say you could set up a Cinder
backup service that is able to talk to Swift. For your Cinder side,
you have Ceph set up. So you have completely two separate storage
solutions, and if something were to happen to the Ceph storage
solution, everything would still be backed up on this other Swift
cluster that's completely independent.

The problem with doing backups, though, typically was - and this is
just with block storage in general - is you would have to detach the
volume from it being used by the VM, and then you would have to
initiate a backup, and then reattach that volume to the Cinder backup
solution which would then go ahead and put it into the Swift cluster.
That could be disruptive. The new solution that now we have is, some
of the different back-end solutions that we're using for the Cinder
backups will give you the ability to keep the volume attached, and
actively being used, but we can go ahead and initiate a backup, and it
will keep copying over the bits, and hopefully eventually catch up to
where the volume is at, to a point where it can stop the backups, and
your volume can continue being used in production.

I would say those are the most interesting for the Liberty release.

**R**: What's your vision, looking forward, for Mitaka and on, for Cinder.

**M**: I sort of talked about this in the previous Liberty release, and
unfortunately we weren't exactly able to finish everything up in time.
My apologies to everyone. But for the operator side, we have been
working on trying to make rolling upgrades a real thing, instead of
just talking about it. Initially, for the Kilo release, we worked on a
solution inside of Oslo that gives you the ability to have the
OpenStack services themselves be written in a way to be independent
from the actual database solution that's being used. Typically when
you do upgrade you have to bring down - whatever services you're going
to upgrade, you have bring down those services, and then you have to
do a database upgrade. And for real OpenStack users, that can be very
time consuming because of all the different column changes that have
to happen for all of the different rows of data that they have.
During that time, you have down time of those services. So, for the
Kilo release we ended up working on a solution that made those
services where they could continue running, and you could run the
database upgrade and there would be no disruption. And when you found
it convenient to do it, you can restart those services so that they
could take advantage of the new database changes. But they could
continue to run even with the database changes happening underneath.
So that was added in Oslo, and we made that available for all
OpenStack projects, not just Cinder, to take advantage of. 

What we're working on for the M release, and what we were working on for Liberty
as well, is the ability to have the services be independent of each
other. The way that they communicate with each other is with RPC. For
example, if you have, in the Cinder case, typical setup is you have a
Cinder API server, you have a Cinder scheduler, and you have a Cinder
volume manager. And as soon as you upgrade one of those services, they
can no longer talk to each other. So, having the ability, as an
operator, to roll out the updates to, say, all of my Cinder APIs, and
verify that everything looks good, and then to make the decision, ok,
now I want to update the Cinder scheduler. So it's all about being
comfortable, and having things be convenient for the operator. So the
RPC compatibility layer will allow the operator to do those upgrades
at their own pace. 

And, just like what we did with the Cinder database
upgrade case, we're trying to make this a generic solution so that we
can allow all OpenStack projects to take advantage of this same
solution.

Very likely, just like what we did before, it will be something that
will surface up into the Oslo library as well.

One feature that I know in particular that will be coming out, that
has already finished in the Liberty release, but we just didn't have
any of our volume drivers take advantage of it yet, is just some basic
replication ability. To be able to say that I have this volume, which
is the primary, and have other volumes that for that particular volume
will be replicated over. And if anything was to happen to the primary
volume, it would fail over to the secondary volume. So, really basic
replication, and we're not trying to do all the bells and whistles out
of the box right now, so it is a manual failover case. From what we've
got in previous summit discussions, people were kind of OK anyways
with doing manual failover. Weren't completely comfortable with
trusting software to do auto-failover. Eventually we'll get over
there, but I think getting all volume drivers over to supporting
replication is a big win.

And then for the rest of the M release, I would say is a lot of
catchup with some of the other projects in terms of the ability - this
is not really something for the users, or the actual operators
themselves - but the support of microversions. Just having the ability
for us to progress forward in the API while still preserving some
backward compatibility.

And then, the last part that I would say that may still not be
something noticeable to users and operators, but we are working a lot
more closely with the Nova team. In previous times there hasn't been a
lot of interactions between the two teams, and Nova uses the Cinder
API pretty heavily in the cases where persistent storage is needed.
And I would say that currently, today, we have quite a number of
issues that we're trying to work through in terms of how they're
expecting to use our API, and how well we defined our API to them
initially. So, I wouldn't really say it's a fault in anybody that's
been using our API, but more us trying to figure out how to define to
people that want to use our API how it should be used properly.  
And now we're trying to clean that up as we go.

So, basically, we should see in the M release is better interaction
between Nova and Cinder and, if there are any issues that happen in
those interactions, that they'll be able to recover from those issues.
So any time that Nova wants to create a volume and attach it, and
something were fail in between there, there would be some sort of
recovery that would happen, that the user can understand what just
happened, and could take action from there. Because currently, today,
there's really not much information for the user to go by to know what
to do next.

**R**: Thank you very much for taking the time to do this.

**M**: No problem.