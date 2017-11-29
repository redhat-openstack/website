# Test day &ndash; Suggested tests

Scenarios to test. If you test something that someone else has already made notes on, make a new results line for your comments.

Copy this outline to a public etherpad for each test day. Please update
this template if tests are added or modified.

* See the [old test matrix](https://www.rdoproject.org/testday/newton/testedsetups_rc/).

## "Does it work" tests

If you're using the test cloud ([details
here](https://etherpad.openstack.org/p/rdo-queens-m2-cloud)) you are
encouraged to perform some of the following test scenarios.

* Launch VM
* Log into VM
* ...

## Packstack-Based Installation (Neutron Networking)

### Packstack All-in-One

* CentOS 7
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### Packstack All-in-One

* CentOS 7
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### Packstack All-in-One
* RHEL
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### Packstack 3 node
* CentOS 7
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who: 
* Results: 
* Tickets:

### Packstack 3 node
* RHEL
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

## Packstack-Based Installation (Storage Components)

### All-in-One        Glance=localfs, Cinder=lvm
* CentOS 7
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### All-in-One        Glance=localfs, Cinder=lvm
* RHEL
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### All-in-One        Glance=localfs, Cinder=glusterfs
* CentOS 7
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### All-in-One        Glance=localfs, Cinder=glusterfs
* RHEL
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### All-in-One        Glance=localfs, Cinder=ceph
* CentOS 7
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

### All-in-One        Glance=localfs, Cinder=ceph
* RHEL
* Instructions: https://www.rdoproject.org/testday/newton/final/#how-to-test
* Who:
* Results:
* Tickets:

## Packstack-Based Installation (Other Components)

### All-in-One        Glance=localfs, Cinder=lvm, heat=y
* CentOS 7
* Instructions: https://etherpad.openstack.org/p/amoralej-testday-newton-ga
* Who:
* Results: 
* Tickets:


## TripleO-Based Installation

### TripleO
* CentOS 7
* Instruction: https://www.rdoproject.org/tripleo/
* Who:
* Results:
* Tickets:

### TripleO
* RHEL
* Instruction: https://www.rdoproject.org/tripleo/
* Who:
* Results:
* Tickets:


### TripleO Baremetal 
* CentOS
* Instructions: http://images.rdoproject.org/docs/baremetal/
* Results: 
* Tickets:


### TripleO Baremetal 
* RHEL
* Instructions: http://images.rdoproject.org/docs/baremetal/
* Who:
* Results: 
* Tickets: 


### TripleO Minimal virt deployment
* CentOS
* Instructions: http://images.rdoproject.org/docs/virt/
* Results:
* Tickets:

### TripleO Minimal virt deployment
* RHEL
* Instructions: http://images.rdoproject.org/docs/virt/
* Results:
* Tickets:

### TripleO + Ironic in overcloud
* CentOS
* Instructions: http://rdoproject.org/testday/tests/ironic-overcloud
* Results:
* Who:
* Tickets:

### TripleO + Ironic in overcloud
* RHEL
* Instructions: http://rdoproject.org/testday/tests/ironic-overcloud
* Results:
* Tickets:

## Upstream Installation Tutorial

Work through the [upstream installation
tutorial](https://docs.openstack.org/draft/install-guide-rdo/) while
keeping notes on the following points:

* Did you know what the document assumed that you'd know?
* Did the steps work as described?
* What error conditions did you encounter? Could you work around them?
  If so, how?
* When you were done, did it work as expected? If not, what happened, and
  how did it differ from what you expected to happen?

## Post Installation Tests &ndash; does it work?

### Post Installation
* CentOS 7
* Instructions: [Post Installation Tests](/testday/tests/post-installation-tests)
* Results:
* Tickets:

### Post Installation
* RHEL
* Instructions: [Post Installation Tests](/testday/tests/post-installation-tests)
* Results:
* Tickets:
