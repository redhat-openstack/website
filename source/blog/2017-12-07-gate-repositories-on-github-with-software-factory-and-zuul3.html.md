---
title: Gate repositories on Github with Software Factory and Zuul3
author: fboucher
tags:
date: 2017-12-07 15:10:00 CEST
---

# Introduction

Software Factory is an easy to deploy software development forge. It provides,
among others features, code review and continuous integration (CI). The latest
Software Factory release features Zuul V3 that provides integration with Github.

In this blog post I will explain how to configure a Software Factory instance, so
that you can experiment with gating Github repositories with Zuul.

First we will setup a **Github application** to define the Software Factory instance
as a third party application and we will configure this instance to act
as a CI system for Github.

Secondly, we will prepare a Github test repository by:

- Installing the application on it
- configuring its *master* branch protection policy
- providing Zuul job description files

Finally, we will configure the Software Factory instance to test and gate
Pull Requests for this repository, and we will validate this CI
by opening a first Pull Request on the test repository.

Note that Zuul V3 is not yet released upstream however it is already
in production, acting as the CI system of OpenStack.

# Pre-requisite

A Software Factory instance is required to execute the instructions given in this blog post.
If you need an instance, you can follow the quick deployment guide [in this previous article](https://www.rdoproject.org/blog/2017/11/getting-started-with-software-factory-and-zuul3/).
Make sure the instance has a public IP address and TCP/443 is open so that Github can reach
Software Factory via HTTPS.

# Application creation and Software Factory configuration

Let's create a Github application named *myorg-zuulapp* and register it on the instance.
To do so, follow this [section](https://softwarefactory-project.io/docs/operator/zuul3_operator.html#create-a-github-app)
from Software Factory's documentation.

But make sure to:

- Replace *fqdn* in the instructions by the public IP address of your Software Factory
  instance. Indeed the default *sftests.com* hostname won't be resolved by Github.
- Check "Disable SSL verification" as the Software Factory instance is by default
  configured with a self-signed certificate.
- Check "Only on this account" for the question "Where can this Github app be installed".

![Configuration of the app part 1](images/app1.png)
![Configuration of the app part 2](images/app2.png)
![Configuration of the app part 3](images/app3.png)

After adding the github app settings in */etc/software-factory/sfconfig.yaml*, run:

```bash
sudo sfconfig --enable-insecure-slaves --disable-fqdn-redirection
```

Finally, make sure Github.com can contact the Software Factory instance by clicking
on "Redeliver" in the advanced tab of the application. Having the green tick is the
pre-requisite to go further. If you cannot get it, the rest of the article will not
be able to be accomplished successfuly.

![Configuration of the app part 4](images/app4.png)

## Define Zuul3 specific Github pipelines

On the Software Factory instance, as *root*, create the file config/zuul.d/gh_pipelines.yaml.

```bash
cd /root/config
cat <<EOF > zuul.d/gh_pipelines.yaml
---
- pipeline:
    name: check-github.com
    description: |
      Newly uploaded patchsets enter this pipeline to receive an
      initial +/-1 Verified vote.
    manager: independent
    trigger:
      github.com:
        - event: pull_request
          action:
            - opened
            - changed
            - reopened
        - event: pull_request
          action: comment
          comment: (?i)^\s*recheck\s*$
    start:
      github.com:
        status: 'pending'
        status-url: "https://sftests.com/zuul3/{tenant.name}/status.html"
        comment: false
    success:
      github.com:
        status: 'success'
      sqlreporter:
    failure:
      github.com:
        status: 'failure'
      sqlreporter:

- pipeline:
    name: gate-github.com
    description: |
      Changes that have been approved by core developers are enqueued
      in order in this pipeline, and if they pass tests, will be
      merged.
    success-message: Build succeeded (gate pipeline).
    failure-message: Build failed (gate pipeline).
    manager: dependent
    precedence: high
    require:
      github.com:
        review:
          - permission: write
        status: "myorg-zuulapp[bot]:local/check-github.com:success"
        open: True
        current-patchset: True
    trigger:
      github.com:
        - event: pull_request_review
          action: submitted
          state: approved
        - event: pull_request
          action: status
          status: "myorg-zuulapp[bot]:local/check-github.com:success"
    start:
      github.com:
        status: 'pending'
        status-url: "https://sftests.com/zuul3/{tenant.name}/status.html"
        comment: false
    success:
      github.com:
        status: 'success'
        merge: true
      sqlreporter:
    failure:
      github.com:
        status: 'failure'
      sqlreporter:
EOF
sed -i s/myorg/myorgname/ zuul.d/gh_pipelines.yaml
```

Make sure to replace "myorgname" by the organization name.

```bash
git add -A .
git commit -m"Add github.com pipelines"
git push git+ssh://gerrit/config master
```

# Setup a test repository on Github

Create a repository called *ztestrepo*, initialize it with an empty *README.md*.

## Install the Github application

Then follow the process below to add the application *myorg-zuulapp* to *ztestrepo*.

2. Visit your application page, e.g.: https://github.com/settings/apps/myorg-zuulapp/installations
3. Click “Install”
4. Select *ztestrepo* to install the application on
5. Click “Install”

Then you should be redirected on the application setup page. This can
be safely ignored for the moment.

## Define master branch protection

We will setup the branch protection policy for the *master* branch of *ztestrepo*.
We want a Pull Request to have, at least, one code review approval and all CI checks
passed with success before a PR become mergeable.

You will see, later in this article, that the final job run and the merging phase
of the Pull Request are ensured by Zuul.

1. Go to https://github.com/myorg/ztestrepo/settings/branches
2. Choose the *master* branch
3. Check "Protect this branch"
4. Check "Require pull request reviews before merging"
5. Check "Dismiss stale pull request approvals when new commits are pushed"
6. Check "Require status checks to pass before merging"
7. Click "Save changes"

![Attach the application](images/policy.png)

## Add a collaborator

A second account on Github is needed to act as collaborator of the repository
*ztestrepo*. Select one in https://github.com/myorg/ztestrepo/settings/collaboration.
This collaborator will act as the PR reviewer later in this article.

## Define a Zuul job

Create the file *.zuul.yaml* at the root of *ztestrepo*.

```bash
git clone https://github.com/myorg/ztestrepo.git
cd ztestrepo
cat <<EOF > .zuul.yaml
---
- job:
    name: myjob-noop
    parent: base
    description: This a noop job
    run: playbooks/noop.yaml
    nodeset:
      nodes:
        - name: test-node
          label: centos-oci

- project:
    name: myorg/ztestrepo
    check-github.com:
      jobs:
        - myjob-noop
    gate-github.com:
      jobs:
        - myjob-noop
EOF
sed -i s/myorg/myorgname/ .zuul.yaml
```

Make sure to replace "myorgname" by the organization name.

Create *playbooks/noop.yaml*.

```bash
mkdir playbooks
cat <<EOF > playbooks/noop.yaml
- hosts: test-node
  tasks:
    - name: Success
      command: "true"
EOF
```

Push the changes directly on the master branch of *ztestrepo*.

```bash
git add -A .
git commit -m"Add zuulv3 job definition"
git push origin master
```

# Register the repository on Zuul

At this point, the Software Factory instance is ready to receive events
from Github and the Github repository is properly configured. Now we will
tell Software Factory to consider events for the repository.

On the Software Factory instance, as *root*, create the file myorg.yaml.

```bash
cd /root/config
cat <<EOF > zuulV3/myorg.yaml
---
- tenant:
    name: 'local'
    source:
      github.com:
        untrusted-projects:
          - myorg/ztestrepo
EOF
sed -i s/myorg/myorgname/ zuulV3/myorg.yaml
```

Make sure to replace "myorgname" by the organization name.

```bash
git add zuulV3/myorg.yaml && git commit -m"Add ztestrepo to zuul" && git push git+ssh://gerrit/config master
```

# Create a Pull Request and see Zuul in action

1. Create a Pull Request via the Github UI
2. Wait the for *check-github.com* pipeline to finish with success

![Check test](images/CI1.png)

3. Ask the collaborator to set his approval on the Pull request

![Approval](images/approval.png)

4. Wait for Zuul to detect the approval
5. Wait the for *gate-github.com* pipeline to finish with success

![Gate test](images/CI2.png)

6. Wait for for the Pull Request to be merged by Zuul

![Merged](images/CI3.png)

As you can see, after the run of the check job and the reviewer's approval, Zuul has
detected that the state of the Pull Request was ready to enter the gating
pipeline. During the gate run, Zuul has executed the job against the Pull Request code
change rebased on the current master then made Github merge the Pull Request as
the job ended with a success.

Other powerful Zuul features such as cross-repository testing or Pull Request
dependencies between repositories are supported but beyond the scope of this
article. Do not hesitate to refer to the [upstream documentation](https://docs.openstack.org/infra/zuul/)
to learn more about Zuul.

# Next steps to go further

To learn more about Software Factory please refer to [the upstream documentation](https://softwarefactory-project.io/docs/).
You can reach the Software Factory team on IRC freenode channel #softwarefactory
or by email at the softwarefactory-dev@redhat.com mailing list.
