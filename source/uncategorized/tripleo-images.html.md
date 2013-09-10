---
title: TripleO images
authors: derekh, vaneldik
wiki_title: TripleO images
wiki_revision_count: 4
wiki_last_updated: 2013-09-11
---

# TripleO images

## Overview

Follow the instructions for tripleo setup <https://github.com/openstack/tripleo-incubator/blob/master/devtest.md>

But swap out the trippleo-image-element for this fork <https://github.com/agroup/tripleo-puppet-elements> which uses puppet modules to install the RDO packages

this is an experimental setup and should probably only be attempted if your already familiar with tripleo, expect problems unrelated to the packages

## Workarounds

## Current Status

overcloud wont boot because of <https://bugs.launchpad.net/nova/+bug/1221620>
