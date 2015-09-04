---
title: Tools
authors: rbowen
wiki_title: Tools
wiki_revision_count: 5
wiki_last_updated: 2013-07-22
---

# Tools

## Neutron (Quantum) Cleanup Tools

The following shell functions can be added to your ~/.bashrc to provide some tools to clean up Neutron (Quantum) objects:

    function purge_port()
    {
        for port in `quantum port-list -c id | egrep -v '\-\-|id' | awk '{print $2}'`
        do
            quantum port-delete ${port}
        done
    }

    function purge_router()
    {
        for router in `quantum router-list -c id | egrep -v '\-\-|id' | awk '{print $2}'`
        do
            for subnet in `quantum router-port-list ${router} -c fixed_ips -f csv | egrep -o '[0-9a-z\-]{36}'`
            do
                quantum router-interface-delete ${router} ${subnet}        
            done
            quantum router-gateway-clear ${router}
            quantum router-delete ${router}
        done
    }

    function purge_subnet()
    {
        for subnet in `quantum subnet-list -c id | egrep -v '\-\-|id' | awk '{print $2}'`
        do
            quantum subnet-delete ${subnet}
        done
    }

    function purge_net()
    {
        for net in `quantum net-list -c id | egrep -v '\-\-|id' | awk '{print $2}'`
        do
            quantum net-delete ${net}
        done
    }

## Uninstall

See [Uninstalling_RDO](Uninstalling_RDO)

## Reinstalling

Installing RDO all at one go, from the [Quickstart](http://openstack.redhat.com/Quickstart) instructions:

    #!/bin/sh
    sudo yum install -y http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm
    sudo yum install -y openstack-packstack
    packstack --allinone --os-quantum-install=n
