---
title: TripleO quickstart
authors: athomas, hewbrocca, jcoufal, jistr, cbrown2, trown
---

# <a name="qs">TripleO Quickstart</a>

TripleO is an OpenStack Deployment & Management tool. It is developed upstream as the [OpenStack TripleO](http://wiki.openstack.org/wiki/TripleO) project.

There is an [Ansible-based](https://www.ansible.com/) project called [tripleo-quickstart](https://github.com/openstack/tripleo-quickstart) whose main goal is to quickly stand up TripleO environments.

You will need a host machine (referred to as `$VIRTHOST`) with at least 16GB of RAM, preferably 32GB, and you must be able to ssh to the `$VIRTHOST` machine as root without a password from the machine running Ansible. The `$VIRTHOST` machine must be running a recent Red Hat-based Linux distribution (such as CentOS 7 or RHEL 7, but only CentOS 7 is currently tested).

A quick way to test that your `$VIRTHOST` machine is ready to rock is:

    $ ssh root@$VIRTHOST uname -a

The defaults are meant to *just work*, so it is as easy as downloading and running the `quickstart.sh` script.

    $ curl -O https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh

The `quickstart.sh` script will install this repo along with Ansible in a virtual environment and run the `quickstart` playbook. The script also has some dependencies that must be installed on the local system before it can run. You can install the necessary dependencies by running:

```
$ sudo bash quickstart.sh --install-deps
```

**Note:** The `quickstart` playbook will delete the ``stack`` user on the $VIRTHOST and recreate it:

    $ export VIRTHOST='my_test_machine.example.com'
    $ curl -O https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh
    # To check available options for quickstart.sh, run:-
    $ bash quickstart.sh --help
    # To setup master release using tripleo-quickstart, run:-
    $ bash quickstart.sh -R master --tags all $VIRTHOST

This script will output instructions at the end to access the deployed undercloud. If a release name is not given, newton release name is used. Further documentation about TripleO Quickstart is available from the [TripleO Quickstart Documentation](https://docs.openstack.org/developer/tripleo-quickstart/).

## <a name="reading">Further reading</a>

Upstream TripleO documentation:

* [http://docs.openstack.org/developer/tripleo-docs/](http://docs.openstack.org/developer/tripleo-docs/)

**Note:** Limit your environment-specific content in the menu on the left-hand side of the documentation page.

TripleO YouTube channel:

* [TripleO YouTube Channel](https://www.youtube.com/channel/UCNGDxZGwUELpgaBoLvABsTA/)

## <a name="presentations">Presentations</a>

tripleo-quickstart demo (March 9, 2016):

*   [tripleo-quickstart tag based breakpoint demo](https://www.youtube.com/watch?v=4O8KvC66eeU)

## Get in touch

*   IRC: **#tripleo** and **#rdo** channels on [Freenode](http://freenode.net).
*   Mailing list: [**rdo-list**](//www.redhat.com/mailman/listinfo/rdo-list), using **[TripleO]** tag in the subject of the email.
