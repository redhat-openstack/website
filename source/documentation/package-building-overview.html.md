---
author: kkula
title: Package building - overview
---

# Package building process – overview

In the RDO Project, we maintain two kinds of repos: RDO Trunk repositories and RDO CloudSIG repositories.
RDO Trunk repositories have no-deps Openstack packages, which contain client, core, libs, puppet and tempest packages, while
CloudSIG packages are a set of packages built by CentOS Community Build System.
For Centos9 Stream master Trunk (DLRN) packages are stored in [trunks](https://trunk.rdoproject.org/centos9-master/) and
CloudSIG packages ends up in [CentOS mirror](http://mirror.stream.centos.org/SIGs/9-stream/cloud/x86_64/).

## What is DLRN?
In simplest words, DLRN is a tool which builds packages. In automated way DLRN is building package every time when new
commit is merged in observed upstream repos, creating individual, separated environment basing on code, distgit and
[rdoinfo](https://review.rdoproject.org/r/q/project:rdoinfo) repo. DLRN can be also used to manually debug failing
packages.

### FTBFS
If build succeeds, package appears in [trunk]( https://trunk.rdoproject.org/). If fails, automatic
FTBFS (Fail To Build From Source) review is created in [gerrit](https://review.rdoproject.org/r/), providing building
logs and information which commit caused FTBFS, like in [example](https://review.rdoproject.org/r/c/openstack/tacker-distgit/+/42687).
All FTBFS’ have to be reviewed and fixed. Current FTBFS can be easily spotted on [RDO dashboard](https://dashboards.rdoproject.org/rdo-dev).
Other way to check statuses of last builds is checking [Latest Build Reports](https://trunk.rdoproject.org/centos9-master/report.html), for example for Centos 9 master.

### Trunk packages – branching and debugging
Each trunk distgit has multiple branches. Under development one is rpm-master and the stable ones are named
\<release\>-rdo. The rpm-master branch has `Version:` and `Release:` fields filled with XXX, which are automatically
replaced with proper values during the DLRN building process. In \<release\>-rdo branch, those values are filled while
cutting the branch:  master -> stable/\<release\> during the release process.
Having such situation, a different procedure of bug/FTBFS reproduction is needed.

### Debugging with DLRN
Most reliable way to create a debugging or testing environment is Centos 9 container or vm usage.
Steps to reproduce FTBFS:

1. Clone DLRN repo:
```bash
        git clone https://github.com/softwarefactory-project/DLRN.git
```
2. Follow setup procedure from [README](https://github.com/softwarefactory-project/DLRN/blob/master/README.rst).

3. Clone rdoinfo repository:
```bash
        git clone "https://review.rdoproject.org/r/rdoinfo"
```

4. Edit `projects.ini` files with desired data. If you don’t know how to reproduce a remote DLRN build, check logs from
building in FTBFS review. Below you can see example of `projects.ini` preparation for Centos 9 master.
```bash
        sed -i 's%target=.*%target=centos9-stream%' projects.ini
        sed -i 's%source=.*%source=master%' projects.ini
        sed -i 's%baseurl=.*%baseurl=https://trunk.rdoproject.org/centos9/%' projects.ini
        sed -i 's%tags=.*%tags=%' projects.ini
```

5. Run DLRN command (example package name):
```bash
        dlrn --head-only --dev --local --verbose-build --package-name openstack-tacker --info-repo ../rdoinfo
```
You can find more information and explanation of DLRN usage in the [documentation](https://dlrn.readthedocs.io/en/latest/).

6. Edit the package distgit or package code directly if needed. Both of them are now created inside DLRN directory,
like data/openstack-tacker_distro for distgit and data/openstack-tacker for code.

7. Run dlrn command once again. You should now be able to see reproduced error.

## Dependencies
CloudSIG packages have different workflow of creating, maintaining and storing. They are finally placed in this [repo](http://mirror.stream.centos.org/SIGs/9-stream/cloud/).
Describing CloudSIG packages, it is crucial to explain two packages building systems taking part in whole process.
DLRN is for trunk packages, while for CloudSIG ones there are [Koji](https://koji.fedoraproject.org/koji/) and [CBS](https://cbs.centos.org/koji/).
Whole package process building starts in Fedora. The packages exist in Fedora Package Sources [repository](https://src.fedoraproject.org/),
maintained by packagers an builded by [Koji](https://koji.fedoraproject.org/koji/).
If the package is needed in RDO project, it has to be rebuild for RDO. Process of building Fedora package for RDO
using repo [gating_script](https://review.rdoproject.org/r/q/project:gating_scripts) is well described in this [document](https://www.rdoproject.org/documentation/requirements/#adding-a-new-requirement-to-rdo).
Creating such review will effect with rebuilding package in [CentOS Build System](https://cbs.centos.org/koji/).
On this level, there may occur some errors or misconfigurations, caused by different environment.

### Debugging package building failures
### Logs
After pushing your change to code review system, CI will trigger a bunch of tests on it and give results as vote
or/and logs. If +1 is given by Zuul, everything went well. If -1 appears, it means that tests didn’t pass,
so debugging is needed.

### Find CBS task number in your Zuul job output
First step is to check job logs. They are available after clicking on job name in Gerrit. Depending on which point of
building failure happens, the true cause of it may be found in this job output or has to be found directly in CBS
building job. In this [example](https://logserver.rdoproject.org/28/42728/3/check/deps-cbs-validate/b837f69/job-output.txt) build failure reason can be found in Zuul job output,
but in [this one](https://logserver.rdoproject.org/23/42723/1/check/deps-cbs-validate/7a4055b/job-output.txt), the real reason has to be looked for in CBS logs,
because Zuul jobs one doesn’t provide anything useful. This is happening when the error doesn’t refers to spec file,
but the building process itself. The easiest way to find proper link to CBS build is to find “taskID” word
in **job_output.txt**, the result should looks like: Task console is: [https://cbs.centos.org/koji/taskinfo?taskID=2800330](https://cbs.centos.org/koji/taskinfo?taskID=2800330).
Note, that each job and each patchset has its own individual build number.

### How to read CBS build logs?
After going to the provided URL, general information about build will appear. The logs can be find by clicking on red
hyperlink “buildArch“. Provided output is placed in following files:
* build.log
* hw_info.log
* mock_output.log
* root.log
* state.log

If the error refers to dependencies, it will be placed in **root.log**.
Also some errors may occur in other files, especially in **build.log**.

### Common package building issues
* Missing dependency

In a root.log file:  
*DEBUG util.py:444: No matching package to install: 'python3dist(xxx)'  
DEBUG util.py:444: Not all dependencies satisfied*

**Solution:** The dependency is not tagged yet in our repo or not available.
Contact RDO maintainers to discuss adding a new dependency.

* SPEC file syntax error

* Infra issue (timeout)

**Solution:** If there are timeouts in refreshing repo metadata or other steps, it’s good idea to recheck tests,
by typing comment “recheck” in Gerrit review.

* failing `%check` phase  
Some unit tests failed during package building, like in [example](https://logserver.rdoproject.org/60/42260/8/check/DLRN-rpmbuild-centos9/a145af7/job-output.txt).

**Solution:** Create testing environment and try to reproduce the error. Then, try to figure out and fix failing reason.
It is possible to exclude failing test(s), but we only use that solution if it’s strongly
justified (like issue created in bugzilla or other bug tracker).

* missing macro

in build.log file:  
*RPM build errors:
/var/tmp/rpm-tmp.s6H1EG: line 32: fg: no job control  
error: Bad exit status from /var/tmp/rpm-tmp.s6H1EG (%generate_buildrequires)  
Bad exit status from /var/tmp/rpm-tmp.s6H1EG (%generate_buildrequires)  
Child return code was: 1*

**Solution:**
 add `BuildRequires: pyproject-rpm-macros` to build requirements.
