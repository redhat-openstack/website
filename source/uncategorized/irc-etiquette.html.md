---
title: IRC etiquette
authors: kashyap, larsks
wiki_title: IRC etiquette
wiki_revision_count: 11
wiki_last_updated: 2014-07-08
---

# IRC etiquette

## IRC communication guidelines and etiquette

### Guidelines

These are just some guidelines so you get a perspective of IRC culture, communication:

*   Try to ask smart questions, let us try to think for ourselves first and not let some poor, good-intentioned soul to do all the thinking for us. [Pro-tip: Eric S. Raymond's guide referred in the **Resources** section]
*   Try (as humanly as possible) to be: clear, concrete, specific and *complete* with your statements/questions. People cannot read your minds.
*   Be patient: do not expect people will devote time for extreme hand-holding. If a URL is pointed, please try things yourself, do your home-work, use Google *effectively*.
*   Try to maintain a balance of *taking* vs *giving* from the community. Do not demand excessive attention.
*   IRC is a DIY environment, not a paid-support forum. If someone responds to you, that is a bonus.
*   Be reminded: respect people's time, always answering IRC questions isn't developers first priority. Someone could be knee deep in gdb/pdb investigating that time-critical bug.
*   When in a community environment, just post the question to the channel, you do not have to ping a specific person just because he/she answered your question before. Nor do you have to ask questions like "Anyone alive on this channel?" "Are you using ABC?" Stay channel topic related!
*   It is an international channel: you may get better responses in certain time-zones, be patient - don't count on instant reactions.

All of the above look dead obvious, but doesn't instantly come to mind when asking questions in a public IRC. And, sure - we also understand we are all human, already overwhelmed and sometimes, we *Just Need* that answer and not want to follow any heavy instructions. If you're lucky, you might even have the bonus of getting it answered instantly.

### Pinging for attention (please avoid a 'naked ping')

A simple guideline if you want to raise some specific person's attention on IRC, and do it *effectively*.

#### Do:

To save everyone's time, please try to ping with a specific request/question/comment.

Preferred:

    <Bob> Alice: Ping,  re:  a certain topic (or a specific question)

Even better: if possible, a fully **self-contained** question requesting a clear action, so the person you pinged may come back 3 hours later and respond at her/his own pace:

    <Bob> Alice: Ping, re: bug#1456234. Don't you think the reporter 
                 should retest with that specific version of openstack-nova
                 mentioned in comment#4? It fixes the bug.

        [3 HOURS LATER. . .]

    <Alice> Bob: Hi, you were right with that bug. I had an incorrect assumption. 
                 I just closed the bug, adding a relevant rationale.

(Agreed -- not all questions can be *that* self-contained, but you get the drift.)

#### Don't:

In short: please avoid -- a-ping-followed-by-permission-to-ask-a-question-followed-by-long-silence. Or any similar variants.

i.e. do not do a naked ping with no request for any information or any question:

    <Bob> Alice: Ping

        [LONG SILENCE. . .]

nor this:

    <Bob> Alice: Ping
    <Alice> Bob: Pong?
    <Bob> Alice: Can I talk to you now? I have a technical question to discuss

        [LONG SILENCE. . .]

    <Alice> Bob: Sure.    (Inside Alice's head -- 'Sigh, will you already ask the question please?!')

        [Again, in some cases, this interrupt is  followed by a long SILENCE. . . ]

    <Bob> Alice: A vague question with not so clear details.

You see what a time drain the above has become which has not led to any meaningful exchange? At this point, I'm sure you can clearly imagine what a test of mental sanity it'll be for Alice to have 10 to 12 pings like that each day. Let's not do that.

### Resources

*   A fantastic resource from Eric S. Raymond [on how to ask smart questions](http://www.catb.org/~esr/faqs/smart-questions.html)
*   Freenode's guide on [how to become a catalyst for problem solving](http://freenode.net/catalysts.shtml)
*   Other communities (Fedora project) IRC communication [guidelines](https://fedoraproject.org/wiki/How_to_communicate_using_IRC)
*   Bonus: [Email guidelines/posting-style](https://fedorahosted.org/rhevm-api/wiki/Email_Guidelines) when communicating in open source projects.
