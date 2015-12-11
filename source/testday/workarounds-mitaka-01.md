# All

* keystone.py for WSGI implementation is deprecated in Mitaka: https://bugzilla.redhat.com/show_bug.cgi?id=1289267

# RDO Manager
* Script to work around known issues: https://gist.github.com/trown/0660b60310483cc923e0
* Workarounds are also included in the [RDO-Manager Quickstart image](https://ci.centos.org/artifacts/rdo/images/mitaka/delorean/)

The quickstart image can be used with the [tripleo-quickstart ansible playbooks](https://github.com/trown/tripleo-quickstart).
There is a bash script there that will bootstrap the whole process including installing ansible 2.0 in a virtual environment.
It only requires a hostname or IP of a server which can be ssh'd to:

```bash    
export VIRTHOST='my_test_machine.example.com'
bash <(curl -s https://raw.githubusercontent.com/trown/tripleo-quickstart/master/quickstart.sh) mitaka
```

* [Failing to install undercloud due to ceilometer alarm not yet replaced by Aodh](https://bugs.launchpad.net/tripleo/+bug/1521922)

    * [instack-undercloud patch](https://review.openstack.org/#/c/253716/) - not merged waiting on upstream CI

    * [tripleo-heat-templates patch](https://review.openstack.org/#/c/253717/) - merged but not in delorean current-passed-ci repo

# Packstack
