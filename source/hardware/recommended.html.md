---
title: Recommended hardware
---

# Recommended hardware

Recommended hardware requirements for an RDO cloud:  

## TripleO - Production

Production deployments vary greatly but as a very brief guideline:  

3 x controllers (minimum for HA control plane)  
X number of compute nodes / hypervisors (can be scaled)  
3 x Ceph storage nodes (optional, depending on requirements)  
3 x Swift object storage nodes (optional, if not using RADOS)  

More information at http://tripleo.org/

## TripleO Quickstart - Development

Minimum 32GB of RAM  
Minimum 120GB free disk space  

## Packstack - PoC

Minimum of 1 node, additional nodes for additional hypervisors  
Minimum 16GB RAM for All In One deployment  
