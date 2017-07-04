---
author: jruzicka,chandankumar
title: Getting started at RDO
---

# Let's Contribute to RDO Project

Welcome on board!. As new contributor there are some things that you must do to
get ready:

## Let's get prerequisites ready.
* [Join the RDO Mailing List](#join-mailing-list)
* [Join IRC channel #rdo on Freenode server](#join-irc-channel)
* [Create Github account](#github-account)
* [Sign to review.rdoproject.org](#sign-in)
* [Add SSH key to review.rdoproject.org](#add-ssh)
* [It would be good to have Red Hat Bugzilla account.](#bugzilla-account)
* [Configure your git and git review.](#git-review)
* [Install rdopkg tool](#rdopkg)

## What's Next!
* [Do your first contribution](#first-contribution)
* [Reviewing RDO Patches](#review-rdo)
* [Become a RDO package Maintainer.](#pkg-maintainer)

<a name="join-mailing-list"/>

### Join the RDO Mailing List
* Go to [RDO mailing list](https://www.redhat.com/mailman/listinfo/rdo-list) and enter your email
  address and password and click on *subscribe*. Once done, open your mailbox, you will get a
  confirmation email, click on the verification link and you are subscribed to the RDO List.
* You can introduce yourself sending a mail to the mailing list. Tell us what are your interests
  and how you will participate.

<a name="join-irc-channel"/>

### Join IRC channel #rdo on Freenode server
* All the development and communication related to RDO Project happens on #rdo IRC channel on
  Freenode server. Click [this link](http://webchat.freenode.net/?channels=#rdo) to join the same and feel free to say Hello!, we are always there to help.
* Feel free to check out the [IRC etiquette](https://www.rdoproject.org/community/irc-etiquette/)

 <a name="github-account"/>

### Create Github account
 Go to [Github Sign Up](https://github.com/join) and enter your username, email address and
 password and you are done. If you already have a GitHub account, you can skip this step.

<a name="sign-in"/>

### Sign to review.rdoproject.org
Sign-in to [review.rdoproject.org](https://review.rdoproject.org/auth/login) using github account.

<a name="add-ssh"/>

### Add SSH key to review.rdoproject.org
* Generate your SSH key, if you don't have.
  Follow these instructions on [Generating a new SSH key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key)
* Then, go to [ssh-key](https://review.rdoproject.org/r/#/settings/ssh-keys) and click on "Add Key" button and copy the contents of id_rsa.pub (SSH Key public key) and paste it there and then click on 'Add' button and you are done.

<a name="bugzilla-account"/>

### It would be good to have Red Hat Bugzilla account.
All the bugs related to RDO packages are tracked on Red Hat Bugzilla under *RDO* product. OpenStack projects bugs are tracked on [Launchpad](https://launchpad.net/openstack).
* You can create a Bugzilla account by clicking on [Create a new Red Hat Bugzilla account](https://bugzilla.redhat.com/createaccount.cgi)
  and enter your email id and click on "send" button and check your mailbox and you are done.

<a name="git-review"/>

### Configure your git and git-review.
* Run these steps to let git know about your email address:

```
$ git config --global user.the name "Firstname Lastname"
$ git config --global user.email "your_email@youremail.com"
```
* To check your git configuration:

```
$ git config --list
```

* Install git-review tool

```
$ sudo yum install git-review
```

<a name="rdopkg"/>

### Install rdopkg tool
Follow this link to install [rdopkg](https://www.rdoproject.org/documentation/intro-packaging/#rdopkg)
And you are set for making the contribution to RDO Project.

<a name="first-contribution"/>

### Do your first contribution
* RDO Project has lots of easy fixes. Check out the [RDO easyfix](https://github.com/redhat-openstack/easyfix/issues)
  and pick one issue and feel free to move ahead.
* Clone the project.
For example: for clonning keystone-distgit, we need to pass source code url.

```
$ git clone git clone https://review.rdoproject.org/r/openstack/keystone-distgit
```

You can also use rdopkg to clone an RDO package.

```
$ rdopkg clone package-name
```
* Go inside the project directory, create and checkout a new branch.
  Note: Always create a new branch to work on any issue.

```
$ cd <project_name>
$ git checkout -b <issue name>
```
* Make changes in the code and add the changed files to git

```
$ git add <chanaged files>
```
* Commit the changes

```
$ git commit -m "Add the commit message"
```
You can check this link on how to write [proper commit message](https://wiki.openstack.org/wiki/GitCommitMessages)

* Something went wrong in the commit message, run the following command to edit the commit message

```
$ git commit --amend
```
* Now push the changes for Review using git-review.

```
$ git review
```

It will create a RDO Gerrit review link and someone from RDO project will review the changes and once everything looks fine,
It will get merged and you made your first contribution.

<a name="review-rdo"/>

### Reviewing RDO Patches
* Reviewing other's patches is a good way to learn the stuff.
* You can start getting familiar with RDO by reviewing patches in [RDO Gerrit instance](https://review.rdoproject.org/r/)
  or by sending your own patches for existing packages.

<a name="pkg-maintainer">

### Become a RDO package Maintainer.
If you want to become maintainer for one or more packages, you can request to be added to the
core group for them by sending a review to [rdoinfo](https://github.com/redhat-openstack/rdoinfo/)
as in [this example](https://review.rdoproject.org/r/#/c/7102/).
Being a maintainer for a package provides the ability to approve reviews for it (grants +2 and +W in Gerrit terms).
