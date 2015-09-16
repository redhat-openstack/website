---
title: Floating IPs on the Lab Network
authors: beagles
wiki_title: Floating IPs on the Lab Network
wiki_revision_count: 1
wiki_last_updated: 2013-08-26
---

# Floating IPs on the Lab Network

{:.no_toc}

<div class="alert">
Draft in progress

</div>
The occasional sampling of the RDO forums and OpenStack mailing lists suggests that something that people are keen to do is to get direct access to VMs from computers elsewhere on their "work" network (lab, office, basement, etc). There are several reasons why someone might want to do this, but we will ignore them for the moment. Let us assume that you have a valid, logical reason for doing so and go from there.

The Broad Strokes

Basically the idea is to establish a bridged connection between your VM's private network and the "public network". Let us call it the "lab" because the whole notion of private and public is relative. If you are savvy with Linux bridging and/or Open vSwitch and have an idea of how this would work if OpenStack was not in the picture, then relax, you already know what to do. There is nothing particularly magical about what OpenStack does, you just need to familiarize yourself with the details.

There are two general approaches you can use, the floating IP mechanism in OpenStack or configuring a provider network. As alluded to already, each approach involves bridging to the lab network; they only differ in where and how the bridge is established and what features of OpenStack are involved.

Floating IPs

Bridging with the Router's External Interface

Using Linux Bridge

Using Open vSwitch

Provider Network

br-int VLANs to a non-VLAN network

br-int VLANs to VLAN enabled networks
