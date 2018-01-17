---
title: Edit RDO events
---

# Editing the RDO events calendar

The RDO events calendar is maintained as part of the
[community.redhat.com](https://www.community.redhat.com) events site. To edit or add
an RDO-related meetup, [edit this file](https://github.com/OSAS/rh-events/edit/master/2017/RDO-Meetups.yml) and send a pull request. If your event is some other
community event, such as a mini-conference, [put it in this file
instead](https://github.com/OSAS/rh-events/edit/master/2017/RDO-Community.yml).

A few words of caution:

* The yml calendar format is very finicky. If you are planning to edit a lot of
  events, consider cloning [the entire
  repository](https://github.com/OSAS/rh-events) and running the
  `validate.rb` script in the top level directory before you send pull
  requests, to ensure that there are no syntax errors.

* The events in the meetups file are refreshed from meetup.com every Monday
  morning. So while we'll try to be careful not to overwrite your
  event, it does occasionally happen.

* The weekly mailing to
  [rdo-list](https://www.redhat.com/mailman/listinfo/rdo-list) contains
  only the upcoming 7 days of events, while the update to the events
  page is the upcoming 14 days. Check [the events page](/events) before
  deciding that your event is not on the list.
