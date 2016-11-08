# Ironic OverCloud Test

## Instructions


* Install the undercloud as usual: https://www.rdoproject.org/tripleo/.
	* You can try it on both virtual and real bare metal environment.
		* For virt (running on virthost) make sure you can `ssh root@127.0.0.2` without password then:
		* `git clone https://github.com/openstack/tripleo-quickstart`
		* bash tripleo-quickstart/quickstart.sh --no-clone --clean --config tripleo-quickstart/config/general_config/minimal.yml --teardown all --release stable/newton  127.0.0.2
		* This will stop after installing the undercloud, and we can continue with later steps on the undercloud with:
			* `ssh -F ~/.quickstart/ssh.config.ansible undercloud`
		* We need to upload images to glance before continuing though:
			* `source stackrc; openstack overcloud image upload`
	* Do not enroll all nodes you have in the undercloud, leave something for overcloud Ironic!
		* In order to split the nodes up we need a slightly modified version of instructions so we get just one node in each group:
			* `jq '.nodes[0:1] | {nodes: .}' instackenv.json > undercloud.json`
			* `jq '.nodes[1:2] | {nodes: map({driver: .pm_type, name: .name, driver_info: {ssh_username: .pm_user, ssh_address: .pm_addr, ssh_key_contents: .pm_password, ssh_virt_type: "virsh"}, properties: {cpus: .cpu, cpu_arch: .arch, local_gb: .disk, memory_mb: .memory}, ports: .mac | map({address: .})})}' instackenv.json > overcloud-nodes.yaml`
		* Then we only register the undercloud.json on the undercloud:
			* `source stackrc; openstack baremetal import undercloud.json`
* Then follow http://tripleo.org/advanced_deployment/baremetal_overcloud.html
	* It has an example deployment test procedure in the end
	* Sample ironic-config.yaml provided below, but note that they don't allow virtual compute nodes!
		* looks like a tripleoclient bug, but even with below configs we need to pass '--compute-scale 0' if we only have one node registered
* Join #openstack-ironic on Freenode, if you have problems with Ironic specifically (feel free to ping dtantsur there)
* Document known issues and workarounds in https://etherpad.openstack.org/p/rdo-newton-ga-testday-workarounds

## Simplest ironic-config.yaml (bare metal)

	parameter_defaults:
		IronicEnabledDrivers:
			- pxe_ipmitool
			- pxe_drac
			- pxe_ilo
		IronicCleaningDiskErase: 'metadata'
		ControllerCount: 1
		ComputeCount: 0

Note: feel free to remove IronicCleaningDiskErase if your machine supports ATA secure erase, or if you're fine with waiting for the disks to get shredded (the latter may take hours).

## Simplest ironic-config.yaml (instack-virt-setup)

	parameter_defaults:
		IronicEnabledDrivers:
			- pxe_ssh
		IronicCleaningDiskErase: 'metadata'
		ControllerCount: 1
		ComputeCount: 0

## Simplest ironic-config.yaml (tripleo-quickstart)

	parameter_defaults:
		IronicEnabledDrivers:
			- pxe_ssh
		IronicCleaningDiskErase: 'metadata'
		ControllerCount: 1
		ComputeCount: 0
		ControllerExtraConfig:
			ironic::drivers::ssh::libvirt_uri: 'qemu:///session'
