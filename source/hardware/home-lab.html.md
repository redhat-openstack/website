---
title: Home lab
category: hardware
authors: crashradtke, dneary, lbrigman124, madko
wiki_category: Hardware
wiki_title: Home lab
wiki_revision_count: 12
wiki_last_updated: 2015-03-09
---

# Home lab

__NOTOC__

## Hardware for a home lab

A frequent request is: how can I install and configure a small OpenStack cloud for personal use, with cheap, quiet PCs I can keep in a home office. A typical hardware configuration would be three or more hosts, with one host serving as control node, and the others as compute nodes.

This page is for community hardware recommendations - if you have a home lab you're happy with, list hardware specs here and share prices.

### Micro-ATX hosts

*Credit: Kodiak Firesmith*

Doing a lab with Micro-ATX instead of the Shuttle form factor saves money, at the cost of heat.

*   Micro-ATX case & motherboard
*   Quad core 2 GHz AMD Athlon processor
*   8GB SDRAM
*   1TB 7200 RPM SATA hard drive
*   2 Gb ethernet cards

Estimated cost per node: $275

### 3 node home lab

*Credit: James Radtke*

By adding SSDs, the price goes up, but the noise and heat go down.

| Component    | Manufacturer                                                 | Cost (approx) |
|--------------|--------------------------------------------------------------|---------------|
| Case         | Cooler Master RC-120A-KKN1 Elite 120 Advanced Mini-ITX Tower | 42            |
| Mother Board | ASRock Z77E-ITX                                              | 120           |
| Processor    | i5-3570K                                                     | 225           |
| Memory       | Crucial BLS8G3D1609DS1S00 (2x8GB)                            | 150           |
| Disk         | M4-CT256M4SSD2                                               | 170           |
| PCIe         | Intel I350 Quad-NIC                                          | 310           |
| Total        |                                                              | 1017          |
|              |                                                              |               |
| Case         | Cooler Master RC-120A-KKN1 Elite 120 Advanced Mini-ITX Tower | 42            |
| Mother Board | Intel DH61DL                                                 | 75            |
| Processor    | CPU G620                                                     | 70            |
| Memory       | Crucial CMX4GX3M1A1333C9 (2x4GB)                             | 100           |
| Disk         | SAMSUNG SSD PM83                                             | 150           |
| PCIe         | Intel 82574L dual-NIC                                        | 55            |
| Total        |                                                              | 492           |

    egrep 'vmx|svm' /proc/cpuinfo

### HP Micro servers

Several people have suggested Gen8 or N54L HP Proliant servers.

*   Max RAM is 16GB (N54L)
*   4 drive pays allow for lots of (potentially noisy) storage. 8 drive possible in 2.5".
*   Start at about $180 (more if you want more RAM)

<Category:Hardware>
