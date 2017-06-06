---
title: Home lab
---

# What are you running at home?

{:.no_toc}

Want to run a small OpenStack cloud for personal use, with
whatever old hardware you have laying around? Here's what some of our
community are running at home.

See also the [RDO minicluster](/hardware/minicluster) for an example of
what you can do.

Are you running RDO at home? Write it up and [tell us about
it](mailto:rdo-list@redhat.com) and we'll add you to the list.

|---|---|
| [ ![](/images/documentation/dmsimard_home_lab.png) ](https://twitter.com/dmsimard/status/778646409293733888) |  |
| [David Moreau Simard's home lab](https://twitter.com/dmsimard/status/778646409293733888) | |

### Javier Pena's home lab

**Creating a home OpenStack lab with RDO and a couple spare laptops**

Since part of my daily job is related to maintaining the Packstack
codebase, I routinely run OpenStack installations every day… in a single
VM, in my laptop, just to delete them a couple hours later. But
sometimes I need to test some script or code over a live OpenStack
installation, and I’d like to have a more stable environment to play
with. Sure, there are public environments like TryStack, but I had a
couple old laptops lying around, so why not play with them?

![environment](http://www.jpena.net/wp-content/uploads/2016/02/2nodesetup-1.png)

... Read the rest [here](http://www.jpena.net/?p=31).


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

Points to consider:

*   make sure the processor is Virtualization Enabled
*   probably want to make sure Mobo has PCIe slot available for additional NICs

<!-- -->

    egrep 'vmx|svm' /proc/cpuinfo

### HP Micro servers

Several people have suggested Gen8 or N54L HP Proliant servers.

*   Max RAM is 16GB (N54L)
*   4 drive bays allow for lots of (potentially noisy) storage. 8 drive possible in 2.5".
*   Start at about $180 (more if you want more RAM)

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<Category:Hardware>
