---
title: What did you do in Mitaka? Chandan Kumar
author: rbowen
date: 2016-04-20 13:41:34 UTC
comments: true
published: true
---

Next in our series of "What Did You Do In Mitaka" articles, I spoke with Chandan Kumar, who works on packaging for RDO, and also is active on the mailing list and on IRC.

**See also**, [Ivan Chavero](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-ivan-chavero/) and [Ihar Hrachyshka](https://www.rdoproject.org/blog/2016/04/what-did-you-do-in-mitaka-ihar-hrachyshka-talks-about-neutron/)'s interviews.



<iframe id='audio_iframe' src='https://www.podbean.com/media/player/8wg55-5e987c?from=yiiadmin' data-link='http://www.podbean.com/media/player/8wg55-5e987c?from=yiiadmin' height='100' width='100%' frameborder='0' scrolling='no' data-name='pb-iframe-player' ></iframe>

(If the above player doesn't work for you, you can download the podcast recording [HERE](https://rdocommunity.podbean.com/mf/play/94gwty/chandan-kumar-mitaka.mp3/).)

**Rich**: RDO Mitaka was released [a little over a week ago](https://www.rdoproject.org/blog/2016/04/rdo-mitaka-released/). I'm speaking with
Chandan Kumar, who is one of the people who is very active in the RDO
community. Thanks for taking time to speak with me.

Could you tell me what you did during the Mitaka cycle?

**Chandan**: Thank you Rich.

Well, this release, I was packaging and reviewing RDO packages,
mostly. In the start of the Mitaka release I was tracking upstream
global requirements, and found some of the packages missing from the
RDO packages. So I maintained and packaged them.

In the list of packages are: python-wsgi_intercept, python-reno,
python-tosca-parser, python-weakrefmethod,
python-XStatic-roboto-fontface and many more in which
Python reno is most popular because it was used for adding and
deleting release notes to upstream OpenStack projects.

In the midcycle, I got a chance to work with Matthew from CERN. And at
the same time I had just completed packaging Python Magum client, and
helped in packaging Magnum for RDO

I also worked with Javier, Alan, and Haikel, in porting spec files of
Oslo libraries and its dependencies to Python 2 and Python 3 packages.
At that time there is a need of RDO specific spec templates for client
OpenStack test and Oslo libraries. That we have added.

Let's now come to the end of the Mitaka release. We have created
Python OpenStack services tests sub -package for all OpenStack
packages present in RDO. That was consumed by Puppet OpenStack CI,
and that was a great achievement for me.

And lastly, I have done code contributions and documentation changes
for [DLRN](https://www.rdoproject.org/blog/2016/04/naming-is-hard-or-who-let-the-vowels-out/).

That was an exciting release in RDO land.

**R**: Do you expect to continue participating at the same level in the
Newton cycle?

**C**: Yes. Since the Newton cycle has just started, Magnum trunk DLRN
builds got failed because of missing packages Python k8sclient. That I
have packaged, and imported, with the help of Alan, do DLRN. Now
it's working fine.

I will continue to do packaging and code contributions to rdopkg and
DLRN. Apart from that, I will continue to contribute to packstack
OpenStack module, and try to add new OpenStack services to RDO
ecosystem.

**R**: Thank you very much for taking time to speak with me.

**C**: Thanks, Rich.