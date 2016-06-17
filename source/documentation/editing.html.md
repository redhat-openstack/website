---
title: Editing
category: documentation
authors: beni, dneary, kashyap, rbowen
wiki_category: Documentation
wiki_title: Help:Editing
wiki_revision_count: 4
wiki_last_updated: 2014-09-14
---

# Editing

For editing pages in this wiki, please use [MediaWiki syntax](https://www.mediawiki.org/wiki/Help:Formatting). In forum posts and comments, you can use [Markdown syntax](//daringfireball.net/projects/markdown/syntax).

More help pages on using MediaWiki are linked on [MediaWiki's help pages](https://meta.wikimedia.org/wiki/Help:Editing#Editing_help), for example:

*   [how to use the editor's toolbar](https://meta.wikimedia.org/wiki/Help:Edit_toolbar)
*   [when to mark an edit as “minor edit”](https://meta.wikimedia.org/wiki/Help:Minor_edit)
*   [answers to some frequently asked questions on editing](https://meta.wikimedia.org/wiki/Help:Editing_FAQ)
*   [some usage examples of MediaWiki's syntax](https://meta.wikimedia.org/wiki/Help:Wikitext_examples).

To post long lines, such as log output or script lines, wrap a block in

         <pre style="white-space: pre; overflow-x: auto; word-wrap: normal">
             ...
         </pre>

The site is set up to use Kramdown, which is a featureful version of
Markdown. It mirrors GitHub's settings and then a few
features on top. You can see the settings in [config.rb](https://github.com/redhat-openstack/website/blob/master/config.rb#L22-L32)

Basically, you get everything from GitHub's configuration, so preview
works, and you can also do special Kramdown stuff, like adding CSS, like
so: {:.foo} (for a class called foo, which can be applied to a block or
inline, based on its position). More info on the [kramdown site](http://kramdown.gettalong.org/syntax.html#attribute-list-definitions)

See also the [Quick reference for simple tables](http://kramdown.gettalong.org/quickref.html#tables) and the [full table docs](http://kramdown.gettalong.org/syntax.html#tables)

<Category:Documentation>
