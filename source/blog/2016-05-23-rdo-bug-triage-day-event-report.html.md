---
title: '[Event Report] RDO Bug Triage Day on 18th and 19th May, 2016'
date: 2016-05-23 23:47:00
author: chandankumar
tags: blogs, openstack
---

As the RDO development continues to grow, the numbers of bugs also grow. 
To make the community robust and heavy, it is also necessary to triage and fix the existing bugs so that product will be more valuable.

We had hosted RDO Bug Triage Day on 18th and 19th May, 2016.

The main aim of the triage day was :

* Mass Closing of "End of Life" Bugs through automation with proper EOL statement.
  On 19th May, 2016 RDO meeting, after evaluating the Fedora EOL statement, we came up with this :
  **"This bug is against a Version which has reached End of Life. If it's still present in supported release (http://releases.openstack.org), please update Version and reopen."**
  Thanks to Rich Bowen for proposing it,
* Analysis the bug and assign proper component, target-release and ask for more information if the bug is incomplete
* Close the Bug if it is already fixed in the current release
* Provide patches to the existing Bugs.

Those 2 days was awesome for RDO. 

Here is some of the stats of RDO Bug Triage Day:
 
* 433 Bugs affected on Bug Triage Day.
* 398 Bugs closed on Bug Triage Day out of which 365 EOL Bugs closed by [automation script](https://gist.github.com/chkumar246/23237abe5203d963054092fd989a2b88).
* 35 Bugs triaged on Bug Triage Day and most of the EOL triaged bugs closed due to EOL automation script
* 22 people participated in the RDO Bug Triage Day.

Thanks to Pradeep Kilambi, Peter Nordquist, Javier Pena, Ivan Chavero, Matthias Runge, Suraj Narwade, Christopher Brown, Dan Prince, Mike Burns, Dmitry Tantsur, Alfredo Moralejo,
Alan Pevec, Miroslav Suchy, Masanari Matsuoka, Garth Mollett, Giulio Fidente, David Moreau Simard,  Chandan Kumar and Emilien Macchi for participating and making the RDO Bug 
triage day successful.

The above stats is generated using [bztraigeday_stats.py script](https://gist.github.com/chkumar246/22ecfa8f5de4d98fb2a289904910dc4f).

