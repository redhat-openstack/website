---
title: Summary of rdopkg development in 2017

author: jruzicka
tags: rdopkg, packaging
date: 2018-01-11 13:37:00 CET
---

During the year of 2017, **10 contributors** managed to merge
**146 commits** into `rdopkg`.

**3771 lines** of code were added and **1975 lines** deleted
across **107 files**.

**54 unit tests** were added on top of existing **32 tests** - an increase
of **169 %** to **total of 86 unit tests**.

**33 scenarios** for **5 core rdopkg features** were added in **new feature
tests** spanning total of **228 test steps**.

**3 minor releases** increased version from `0.42` to `0.45.0`.

Let's talk about the most significant improvements.


## Stabilisation

`rdopkg` started as a developers' tool, basically a central repository to
accumulate RPM packaging automation in a reusable manner. Quickly adding new
features was easy, but making sure existing functionality works consistently
as code is added and changed proved to be much greater challenge.

As `rdopkg` started shifting from developers' powertool to a module used in
other automation systems, unevitable breakages started to become a problem and
prompted me to adapt development accordingly. As a first step, I tried to practice
[Test-Driven Development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)
as opposed to writing tests after a breakage to prevent specific case. Unit
tests helped discover and prevent various bugs introduced by new code, but
testing complex behaviors was a frustrating experience where most of
development time was spent on writing units tests for cases they weren't meant
to cover.

Sounds like using a wrong tool for the job, right? And so I opened a rather
urgent `rdopkg` [RFE: test actions in a way that doesn't
suck](https://github.com/softwarefactory-project/rdopkg/issues/123) and
started researching what cool kids use to develop and test python software
without suffering.

### Behavior-Driven Development

It would seem that `cucumber` started quite a revolution of
[Behavior-Driven Development (BDD)](https://en.wikipedia.org/wiki/Behavior-driven_development)
and I really like
[Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin),
the _Business Readable, Domain Specific Language that lets you describe
software's behaviour without detailing how that behaviour is implemented.
Gherkin serves two purposes — documentation and automated tests._

After some more research on python BDD tools, I liked
[behave](http://pythonhosted.org/behave/)'s implementation, documentation
and community the most so I integrated it into `rdopkg` and started using
feature tests. They make it easy to describe and define expected behavior before
writing code. New features now start with feature scenario which can be
reviewed before writing any code. Covering existing behavior with
feature tests helps ensuring they are both preserved and well
defined/explained/documented. Big thanks goes to Jon Schlueter who
contributed huge number of initial feature tests for core `rdopkg` features.

Here is an example of `rdopkg fix` scenario:

```gherkin
    Scenario: rdopkg fix
        Given a distgit
        When I run rdopkg fix
        When I add description to .spec changelog
        When I run rdopkg --continue
        Then spec file contains new changelog entry with 1 lines
        Then new commit was created
        Then rdopkg state file is not present
        Then last commit message is:
            """
            foo-bar-1.2.3-3

            Changelog:
            - Description of a change
            """
```

### Proper CI/gating

Thanks to
[Software Factory](https://softwarefactory-project.io/dashboard/project_rdopkg),
`zuul` and `gerrit`, every `rdopkg` change now needs to pass following
automatic gate tests before it can be merged:

* unit tests (python 2, python 3, Fedora, EPEL, CentOS)
* feature tests (python 2, python 3, Fedora, EPEL, CentOS)
* integration tests
* code style check

In other words, `master` is now **significantly harder to break!**

Tests are managed as individual `tox` targets for convenience.


### Paying back the Technical Debt

I tried to write `rdopkg` code with reusability and future extension in mind,
yet in one point of development with big influx of new
features/modifications, `rdopkg` approached critical mass of technical debt
where it got into spiral of new functionality breaking existing functionality
and with each fix two new bugs surfaced. This kept happening so I stopped
adding new stuff and focused on ensuring `rdopkg` keeps doing what people use
it for before extending(breaking) it further. This required quite a few core
code refactors, proper integration of features that were hacked in on the
clock, as well as leveraging new tools like
[software factory CI pipeline](https://softwarefactory-project.io/repoxplorer/project.html?pid=rdopkg),
and `behave` described above. But I think it was a success and `rdopkg` paid
its technical debt in 2017 and is ready to face whatever community throws at
it in near and far future.


## Integration

### Join Software Factory project

`rdopkg` became a part of [Software Factory project](https://softwarefactory-project.io/)
and found a
[new home](https://softwarefactory-project.io/dashboard/project_rdopkg)
alongside
[DLRN](https://softwarefactory-project.io/repoxplorer/project.html?pid=DLRN).

Software Factory is an open source, software development forge with an
emphasis on collaboration and ensuring code quality through Continuous
Integration (CI). It is inspired by OpenStack's development workflow that has
proven to be reliable for fast-changing, interdependent projects driven by
large communities. Read more in
[Introducing Software Factory](https://www.rdoproject.org//blog/2017/06/introducing-Software-Factory-part-1/).

Specifically, `rdopkg` leverages following Software Factory features:

 * `git`
   [repository mangement](https://softwarefactory-project.io/r/gitweb?p=rdopkg.git;a=summary)
 * code reviews:
   [gerrit](https://softwarefactory-project.io/r/#/q/project:rdopkg)
 * Continuous Integration:
   [zuulV3](https://www.rdoproject.org/blog/2017/11/getting-started-with-software-factory-and-zuul3/) (bye Jenkins)
 * code metricts:
   [repoXplorer](https://softwarefactory-project.io/repoxplorer/project.html?pid=rdopkg&inc_repos=rdopkg:master)

`rdopkg` repo is still mirrored to [github](https://github.com/softwarefactory-project/rdopkg)
and bugs are kept in [Issues
tracker](https://github.com/softwarefactory-project/rdopkg/issues) there as
well because github is accessible public open space.

Did I meantion you can login to Software Factory using github account?

Finally, big thanks to Javier Peña, who paved the way towards Software Factory
with `DLRN`.


### Continuous Integration

`rdopkg` has been using human
[code reviews](https://softwarefactory-project.io/r/#/q/project:rdopkg)
for quite some time, and it proved very useful even though I often +2/+1 my
own reviews due to lack of reviewers. However, people unevitably make
mistakes. There are decent unit and feature tests now
to detect mistakes, so we fight human error with computing power and
automation.

Each review and thus each code change to `rdopkg` is gated - all unit tests,
feature tests, integration tests and code style checks need to pass before
human reviewers consider accepting the change.

Instead of setting up machines and testing environments and installing
requirements and waiting for tests to pass, this boring process is now
automated on supported distributions and humans can focus on the changes
themselves.


### Integration with Fedora, EPEL and CentOS

`rdopkg` is now finally available directly from Fedora/EPEL repositories, so
install instructions on Fedora 25+ systems boiled down to:

    dnf install rdopkg

On CentOS 7+, EPEL is needed:

    yum install epel-release
    yum install rdopkg

Fun fact: to update Fedora `rdopkg` package, I use `rdopkg`:

    fedpkg clone rdopkg
    cd rdopkg
    rdopkg new-version -bN
    fedpkg mockbuild
    # testing
    fedpkg push
    fedpkg build
    fedpkg update

So `rdopkg` is officially packaging itself while also being packaged by
itself.

Please nuke `jruzicka/rdopkg` copr if you were using it previously, it is now
**obsolete**.


### Documentation

`rdopkg` documentation was cleand up, proof-read, extended with more details
and updated with latest information and links.

Feature scenarios are now available as man pages thanks to `mhu`.


## Packaging and Distribution

### Python 3 compatibility

By popular demand, `rdopkg` now supports Python 3. There are Python 3 unit
tests and `python3-rdopkg` RPM package.

### Adopt pbr for Versioning

Most of initial patches `rdopkg` was handling in the very beginning were
related to `distutils` and `pbr`, the OpenStack packaging meta-library,
specifically making it work on a distribution with integrated package
management and old conservative packages.

Amusingly, `pbr` was integrated into `rdopkg` (well, it actually does solve
some problems aside from creating new ones) and in order to release the new
`rdopkg` version with `pbr` on CentOS/EPEL 7, I had to disable hardcoded
`pbr>=2.1.0` checks on update of `python-pymod2pkg` because older version of
`pbr` is available from EPEL 7. I removed the check (in two different places)
as I did so many times before and it works fine.

As a tribute to all the fun I had with `pbr` and `distutils`, here is a link
to my first
[nuke bogus requirements patch](https://src.fedoraproject.org/cgit/rpms/python-pymod2pkg.git/commit/?h=epel7&id=a761c87165ce470c6)
of 2018.

Aside from being consistent with OpenStack related projects, `rdopkg` adopted
strict sematic versioning that `pbr` uses, which means that releases are
always going to have 3 version numbers from now on:

    0.45 -> 0.45.0
    1.0  -> 1.0.0


## And More!

Aside from the big changes mentioned above, large amount of new feature
tests and numerous not-so-exciting fixes, here is a list of changes might be
worth mentioning:

* unify `rdopkg patch` and `rdopkg update-patches` and use alias
* `rdopkg pkgenv` shows more information and better color coding for easy
  telling of a distgit state and branches setup
* preserve Change-Id when amending a commit
* allow fully unattended runs of core actions.
* commit messages created by all `rdopkg` actions are now clearer, more
  consistent and can be overriden using `-H/--commit-header-file`.
* better error messages on missing patches in all actions
* git config can be used to override patches remote, pranch, user name and
  email
* improved handling of `patches_base` and `patches_ignore` including tests
* improved handling of %changelog
* improved new/old patcehs detection
* improved packaging as suggested in Fedora review
* improved naming in `git` and `specfile` modules
* properly handle state files
* linting cleanup and better code style checks
* python 3 support
* improve unicode support
* handle VX.Y.Z tags
* split bloated `utils.cmd` into `utils.git` module
* merge legacy `rdopkg.utils.exception` so there is only single module for
  exceptions now
* refactor unreasonable default `atomic=False` affecting action definitions
* remove legacy `rdopkg coprbuild` action


## Thank you, rdopkg community!
