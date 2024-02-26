---
author: jruzicka,chandankumar
title: Getting started at RDO
---

# Let's Contribute to the RDO Project!

Welcome on board! As a new contributor there are some things you'll want to do
to get ready:

## Let's get prerequisites ready.
* [Join the RDO Mailing List](#join-mailing-list)
* [Join the IRC channel `#rdo` on OFTC](#join-irc-channel)
* [Create a GitHub account](#github-account)
* [Sign up to `review.rdoproject.org`](#sign-in)
* [Add an SSH key to `review.rdoproject.org`](#add-ssh)
* [Create a RDO Jira Board account](#jira-account)
* [Configure `git` and `git review`](#git-review)
* [Install the `rdopkg` tool](#rdopkg)

## What's Next!
* [Make your first contribution](#first-contribution)
* [How to fix git Merge conflicts](#merge-conflict)
* [Review RDO patches](#review-rdo)
* [Become an RDO package maintainer.](#pkg-maintainer)

<a name="join-mailing-list"/>

### Join the RDO Mailing List
* Go to [RDO mailing list](https://www.rdoproject.org/contribute/mailing-lists/)
  and enter your email address and password and click on *subscribe*. Once
  done, open your mailbox, you will get a confirmation email, click on the
  verification link and you are subscribed to the RDO List.
* You can introduce yourself by sending a mail to the mailing list. Tell us
  what your interests are and how you plan to participate.

<a name="join-irc-channel"/>

### Join the IRC channel `#rdo` on OFTC
* All the development and communication related to the RDO Project happens on
  the `#rdo` IRC channel on OFTC. Click [this link](http://webchat.oftc.net/?channels=#rdo)
  to join the channel and feel free to say Hello! We are always there to help.
* Feel free to check out the [IRC etiquette](https://www.rdoproject.org/contribute/irc-etiquette/)
  guide.

 <a name="github-account"/>

### Create a GitHub account
Go to the [GitHub Sign Up](https://github.com/join) page and enter your
username, email address, and password, and you are done. If you already have a
GitHub account, you can skip this step.

<a name="sign-in"/>

### Sign up to `review.rdoproject.org`
Sign-in to [review.rdoproject.org](https://review.rdoproject.org/auth/login)
using your GitHub account.

<a name="add-ssh"/>

### Add an SSH key to `review.rdoproject.org`
* Generate an SSH key, if you don't have one you already use. Follow these
  instructions on [Generating a new SSH key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key)
  if necessary.
* Then, go to [ssh-key](https://review.rdoproject.org/r/#/settings/ssh-keys)
  and click on the "Add Key" button and copy the contents of `id_rsa.pub` (your
  SSH public key) and paste it there, and then click on the 'Add' button and
  you are done.

<a name="jira-account"/>

### Create a RDO Jira board account
All the bugs related to RDO packages are tracked on Red Hat Jira under the
*RDO* project. OpenStack project bugs are tracked on
[Launchpad](https://launchpad.net/openstack).

* You can create a RDO Board account by clicking on "Log In" button in the
  [RDO Board page](https://issues.redhat.com/projects/RDO) and follow the 
  "Register for a Red Hat account" link.

<a name="git-review"/>

### Configure `git` and `git review`
* Run these steps to let `git` know your email address:

```
$ git config --global user.name "Firstname Lastname"
$ git config --global user.email "your_email@youremail.com"
```
* To check your `git` configuration:

```
$ git config --list
```

* Install the `git-review` tool

RHEL-based systems (e.g. CentOS Steam 8+ with EPEL repo enabled)
```
$ sudo dnf install git-review
```

Fedora-based systems (after F24)
```
$ sudo dnf install git-review
```

<a name="rdopkg"/>

### Install the `rdopkg` tool
Follow this link to install
[rdopkg](https://www.rdoproject.org/documentation/intro-packaging/#rdopkg), and
you are set for making contributions to the RDO Project.

<a name="first-contribution"/>

### Make your first contribution
* The RDO Project has lots of easy fixes. Check out the
  [RDO easyfix](https://github.com/redhat-openstack/easyfix/issues) page, pick
  an issue, and feel free to move ahead.
* Feel free to familiarize yourself with [RDO Packaging](https://www.rdoproject.org/documentation/rdo-packaging/) documentation.
* Clone the project.

For example, cloning `keystone-distgit`, we need to pass the source code URL.

```
$ git clone https://review.rdoproject.org/r/openstack/keystone-distgit
```

You can also use `rdopkg` to clone an RDO package.

```
$ rdopkg clone package-name
```
* Go inside the project directory, create, and checkout a new branch.
  _Note_: Always create a new branch to work on any issue.

```
$ cd <project_name>
$ git checkout -b <issue name>
```
* Make changes in the code and add the changed files to git.

```
$ git add <changed files>
```
* Commit the changes

```
$ git commit -m "Add the commit message"
```
You can check this link on how to write
[proper commit messages](https://wiki.openstack.org/wiki/GitCommitMessages).

* If something went wrong in the commit message, or you need to adjust it, run
  the following command:

```
$ git commit --amend
```
* Now push the changes for review using `git-review`.

```
$ git review
```

Running `git review` will create an RDO Gerrit review link, and someone from
RDO project will review the changes. Once everything looks fine, and is
approved, your changes will get merged, and you'll have made your first
contribution. Thanks!

<a name="merge-conflict"/>

### How to fix git Merge conflicts?
You have submitted a patch and got merge conflict on your patch.
You can check this link on how to [resolving merge conflicts][conflict].

[conflict]: https://docs.openstack.org/contributor-guide/additional-git-workflow/rebase.html

<a name="review-rdo"/>

### Review RDO patches
* Reviewing other peoples patches is a good way to learn things.
* You can start getting familiar with RDO by reviewing patches in the
  [RDO Gerrit instance](https://review.rdoproject.org/r/) or by sending your
  own patches for existing packages.

<a name="pkg-maintainer">

### Become an RDO package maintainer
If you want to become a maintainer for one or more packages, you can request to
be added to the core group for them by sending a review to
[rdoinfo](https://github.com/redhat-openstack/rdoinfo/) as in
[this example](https://review.rdoproject.org/r/#/c/7102/).

Being a maintainer for a package provides the ability to approve reviews for it
(grants `+2` and `+W` in Gerrit terms).
