---
title: TestedSetups Liberty 1
authors: rbowen
wiki_warnings: table
---

# TestedSetups 2015 01

Tested Setups for [rdo-test-day-liberty](RDO_test_day_Liberty). 
Tests should be executed against
the Liberty RDO not Kilo, some steps from the official Quickstart guide
do not apply to Liberty; make sure to follow the steps described in the
[rdo-test-day-liberty#How_To_Test](How_To_Test) page instead.

## Example Entry

Here's how you might fill out an entry once you've tested it. Mark a given test "Good" or "Fail", as appropriate, and link to any tickets that you've opened as a result, and to any place where you've written up your test notes. Mark as Workaround if you have a failure but can get past it. Link to your writeup of the workaround.

| Config Name                                                    | Release          | BaseOS    | Status                                       | HOWTO                                               | Who    | Date       | BZ/LP                                                              | Notes Page |
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One w/ Quantum OVS (no tunnels, fake bridge) Networking | Grizzly 2013.1.3 | RHEL 6.4  | <span style="background:#00ff00">Good</span> | [Neutron-Quickstart](Neutron-Quickstart) | pmyers | 2013-09-08 | None                                                               | None       |
|                                                                |                  | Fedora 19 | <span style="background:#ff0000">FAIL</span> | [Neutron-Quickstart](Neutron-Quickstart) | rbowen | 2013-10-09 | ~~[1017421](https://bugzilla.redhat.com/show_bug.cgi?id=1017421)~~ | None       |


## Packstack Based Installation (Neutron Networking)

Please make sure to use the steps described in the [[ RDO_test_day_Liberty#How_To_Test ]]  when installing the base RDO system. Do not go through the Quickstart steps unmodified which will instead give you an RDO kilo deployment. 

| Config Name | Release | BaseOS | Status | HOWTO | Who | Date | BZ/LP | Notes Page
|----------------------------------------------------------------|------------------|-----------|----------------------------------------------|-----------------------------------------------------|--------|------------|--------------------------------------------------------------------|------------|
| All-in-One - Sanity |  | CentOS 7 |   | [/QuickStart](Quickstart) |  |    |    | 

| |   | |  F22 |  | [[QuickStart]] |  |  |  | 


| | |  | RHEL7.1 |    | [[QuickStart]] | |  |  | 
! Distributed -IPv6-Deployment- Sanity | CentOS 7 |  | [[QuickStart]] |  |   |  | 

| | | F22|  | [[QuickStart]] |  |   |  | 

| | | RHEL7.1|    | [[QuickStart]] |   |     |   |
| Distributed -ML2- OVS-VXLAN –  LbaaS | | CentOS 7.1 |  | [[QuickStart]] |  |   |  | 

| | | F22 |  | [[QuickStart]] |  |   |  | 

| | | RHEL7.1 |  | [[QuickStart]] |  |   |   | 
| Distributed -ML2- OVS-VXLAN-VRRP | | CentOS 7.1| | [[QuickStart]] |  |  |  | 

| | | F22 |  | [[QuickStart]] |  |   | | 

| | | RHEL7.1 | | [[QuickStart]] |  |   | | 
| Distributed -ML2-OVS- VXLAN-IPv6 – VPNaaS | | CentOS 7.1 |  | [[QuickStart]] |  |  |  | 

| | | F22 |  | [[QuickStart]] |  |   |  | 

| | | RHEL7.1 |  | [[QuickStart]] | |  |  | 
| Distributed -ML2-OVS- VXLAN Security Groups | | CentOS 7.1 |  | [[QuickStart]] |  |   |  | 

| | | F22 | | [[QuickStart]] |  |  |  | 

| | | RHEL7.1 | | [[QuickStart]] |  |   | | 
| Distributed -ML2-OVS- VXLAN DVR | | RHEL 7.1 | | [[QuickStart]] | |   |  | 
| 3,node  -ML2-OVS- VXLAN |  | CentOS 7.1 |    | |   |   |  | 
| 3,node  -ML2-OVS- GRE |  | CentOS 7.1 |   |  |   |   |  | 
| 3,node  -ML2-OVS- VLAN |  | CentOS 7.1 |  | |  |  |  | 



