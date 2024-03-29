---
title: Edit RDO events
---

# Editing the RDO events calendar

The RDO events calendar is maintained as part of the RDO website. To edit or add
an RDO-related meetup, edit this year's RDO-Meetups.yml file. If your event is
some other community event, such as a mini-conference, add it to this year's
RDO-Community.yml file.

A few words of caution:

* The yml calendar format is very finicky. If you are planning to edit a lot of
  events, consider cloning the RDO website and running the
  `validate.rb` script in the top level directory before you send pull
  requests, to ensure that there are no syntax errors.

* The events in the meetups file are refreshed from meetup.com every Monday
  morning. So while we'll try to be careful not to overwrite your
  event, it does occasionally happen.

* The weekly mailing to
  [the rdo lists](https://lists.rdoproject.org/mailman/listinfo) contains
  only the upcoming 7 days of events, while the update to the events
  page is the upcoming 14 days. Check [the events page](/events) before
  deciding that your event is not on the list.
