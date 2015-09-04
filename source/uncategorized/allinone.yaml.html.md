---
title: Allinone.yaml
authors: adrahon
wiki_title: Allinone.yaml
wiki_revision_count: 1
wiki_last_updated: 2015-08-07
---

# Allinone.yaml

    ---
      KeystoneBasic.create_update_and_delete_tenant:
        -
          args:
            name_length: 10
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          sla:
            failure_rate:
              max: 0.0

      KeystoneBasic.create_delete_user:
        -
          args:
            name_length: 10
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          sla:
            failure_rate:
             max: 0.0

      Authenticate.keystone:
        -
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
             max: 0.0

      Authenticate.validate_cinder:
        -
          args:
            repetitions: 2
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
             max: 0.0

      Authenticate.validate_glance:
        -
          args:
            repetitions: 2
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
             max: 0.0

      Authenticate.validate_neutron:
        -
          args:
            repetitions: 2
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
             max: 0.0

      Authenticate.validate_nova:
        -
          args:
            repetitions: 2
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
             max: 0.0

      GlanceImages.create_and_delete_image:
        -
          args:
            image_location: "/opt/rally-tests/images/CentOS-7-x86_64-GenericCloud-20150628_01.qcow2"
            container_format: "bare"
            disk_format: "qcow2"
          runner:
            type: "constant"
            times: 4
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      CinderVolumes.create_and_extend_volume:
        -
          args:
            size: 8
            new_size: 16
            volume_type: 'VOLUME_TYPE'
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 1
              users_per_tenant: 1
          sla:
            failure_rate:
              max: 0.0

      CinderVolumes.create_and_delete_volume:
        -
          args:
            size: 8
            min_sleep: 15
            max_sleep: 20
            volume_type: 'VOLUME_TYPE'
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      CinderVolumes.create_and_upload_volume_to_image:
        -
          args:
            size: 8
            force: false
            container_format: "bare"
            disk_format: "raw"
            do_delete: true
            volume_type: 'VOLUME_TYPE'
          runner:
            type: "constant"
            times: 5
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      NeutronNetworks.create_and_delete_networks:
        -
          args:
            network_create_args: {}
          runner:
            type: "serial"
            times: 2
          context:
            users:
              tenants: 1
              users_per_tenant: 1
            quotas:
              neutron:
                network: -1
          sla:
            failure_rate:
              max: 0.0

      NeutronNetworks.create_and_delete_ports:
        -
          args:
            network_create_args: {}
            port_create_args: {}
            ports_per_network: 10
          runner:
            type: "serial"
            times: 2
          context:
            users:
              tenants: 1
              users_per_tenant: 1
            quotas:
              neutron:
                network: -1
                port: -1
                subnet: -1
          sla:
            failure_rate:
              max: 0.0

      NeutronNetworks.create_and_delete_routers:
        -
          args:
            network_create_args: {}
            subnet_create_args: {}
            subnet_cidr_start: "10.0.0.0/24"
            subnets_per_network: 1
            router_create_args: {}
          runner:
            type: "serial"
            times: 2
          context:
            users:
              tenants: 1
              users_per_tenant: 1
            quotas:
              neutron:
                network: -1
                subnet: -1
                router: -1
          sla:
            failure_rate:
              max: 0.0

      NeutronNetworks.create_and_delete_subnets:
        -
          args:
            network_create_args: {}
            subnet_create_args: {}
            subnet_cidr_start: "10.1.0.0/24"
            subnets_per_network: 1
          runner:
            type: "serial"
            times: 2
          context:
            users:
              tenants: 1
              users_per_tenant: 1
            quotas:
              neutron:
                network: -1
                subnet: -1
          sla:
            failure_rate:
              max: 0.0

      NovaKeypair.boot_and_delete_server_with_keypair:
        -
          args:
            flavor:
                name: "m1.medium"
            image:
                name: "rhel7"
          runner:
            type: "constant"
            times: 5
            concurrency: 2
          context:
            users:
              tenants: 2
              users_per_tenant: 1
          sla:
            failure_rate:
              max: 0.0

      NovaKeypair.create_and_delete_keypair:
        -
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      NovaServers.boot_and_delete_server:
        -
          args:
            flavor:
                name: "m1.medium"
            image:
                name: "rhel7"
            force_delete: false
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      NovaServers.boot_and_rebuild_server:
       - 
          args:
           flavor:
               name: "m1.medium"
           from_image:
               name: "rhel7"
           to_image:
               name: "rhel7"
          runner:
            type: "constant"
            times: 6
            concurrency: 2
          context:
            users:
              tenants: 1
              users_per_tenant: 1
          sla:
            failure_rate:
              max: 0.0

      NovaServers.boot_server_from_volume_and_delete:
        -
          args:
            flavor:
                name: "m1.medium"
            image:
                name: "rhel7"
            volume_size: 10
            force_delete: false
          runner:
            type: "constant"
            times: 6
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      NovaServers.pause_and_unpause_server:
        -
          args:
            flavor:
                name: "m1.medium"
            image:
                name: "rhel7"
            force_delete: false
          runner:
            type: "constant"
            times: 6
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      NovaServers.snapshot_server:
        -
          args:
            flavor:
                name: "m1.medium"
            image:
                name: "rhel7"
            force_delete: false
          runner:
            type: "constant"
            times: 6
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      NovaServers.suspend_and_resume_server:
        -
          args:
            flavor:
                name: "m1.medium"
            image:
                name: "rhel7"
            force_delete: false
          runner:
            type: "constant"
            times: 6
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      Quotas.cinder_update_and_delete:
        -
          args:
            max_quota: 1024
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0

      Quotas.nova_update_and_delete:
        -
          args:
            max_quota: 1024
          runner:
            type: "constant"
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2
          sla:
            failure_rate:
              max: 0.0
