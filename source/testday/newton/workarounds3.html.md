# All
- You need to edit file /etc/yum.repos.d/rdo-qemu-ev.repo, provided by the rdo-release package, and make sure the gpgkey lines read as follows:

`gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization-RDO`

# TripleO

# Packstack
- During the test days, make sure you set CONFIG_ENABLE_RDO_TESTING=y in your answer file, or that you use the --enable-rdo-testing=y command-line argument.
