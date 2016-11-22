---
title: Running an instance
authors: amansuri, dneary, garrett, holms, iwienand, jasonbrooks, kallies, mattdm,
  pmyers, rbowen, sdevries, strider
wiki_title: Running an instance
wiki_revision_count: 33
wiki_last_updated: 2015-07-22
---

# Running an Instance

## Step 1: Visit the Dashboard

Log in to the Openstack dashboard at <http://CONTROL_NODE/dashboard> with the user name **demo**. The password can be found in the file `keystonerc_demo` in the `/root/` directory of the control node.

**Note:** Make sure that you use the `demo` user name.

## Step 2: Enable SSH on your default security group

Once logged in to the OpenStack dashboard, click the **Project** tab in the left-side navigation menu, and then click **Access & Security** under the heading **Compute**.

[//]: #  "![](Runninganinstance-step2-1.png "Running an instance - step2-1.png")"

Under the **Security Groups** heading, click the **Manage Rules** button for the **default** security group. Click the **Add Rule** button, and in the resulting dialog, enter **22** in the **Port** field, and then click the **Add** button.

[//]: # "![](Runninganinstance-step2-2.png "Running an instance - step2-2.png")"

## Step 3: Create or import a key pair

In the left-side navigation menu, click **Access & Security** under the heading **Compute**. In the main portion of the screen, click the tab labeled **Key Pairs**, and choose either to **Create Key Pair** or **Import Key Pair**. The **Create Key Pair** dialog will prompt you to supply a key pair name before downloading a private key to your client.

[//]: # "![](Runninganinstance-step3-1.png "Running an instance - step3-1.png")"

The **Import Key Pair** option will prompt you to provide a name and a public key to use with an existing private key on your client. For name, choose something to identify that key (like your user name, for example) and for key, use the contents of your public key file, found usually in `~/.ssh/id_rsa.pub` or `~/.ssh/id_dsa.pub` on the machine from which you will be connecting through SSH.

[//]: # "![](Runninganinstance-step3-2.png "Running an instance - step3-2.png")"

## Step 4: Add an image

In the left-side navigation menu, click **Images** under the heading **Compute**. Click the **Create Image** button, located in the upper-right portion of the screen. In the resulting dialog box, enter **Fedora22** in the **Image Name** field, **[https://download.fedoraproject.org/pub/fedora/linux/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2](https://download.fedoraproject.org/pub/fedora/linux/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2)** in the **Image Location** field, choose **QCOW2 - QUEMU Emulator** from the **Format** drop-down menu, leave the **Minimum Disk (GB)** and **Minimum RAM (MB)** fields blank, check the **Private** box, and click the **Create Image** button.

**Note:** Under certain circumstances, adding an image may not be possbile due to a known issue: [https://bugs.launchpad.net/horizon/+bug/1632383](https://bugs.launchpad.net/horizon/+bug/1632383).

[//]: # "![](Runninganinstance-step4.png "Running an instance - step4.png")"

For a collection of links to alternative cloud-ready images, check out [image resources](/resources/image-resources/).

## Step 5: Launch the instance

In the main portion of the screen, under the **Images** heading, click the **Launch Instance** button for the **Fedora22** image. In the resulting dialog, provide a name in the **Instance Name** field and click the **Flavor** tab. There, click the **+** button next to **m1.small**. Click **Launch Instance**.

[//]: # "![](Runninganinstance-step5-1.png "Running an instance - step5-1.png")"

[//]: # "You now have to assign a network. In the left-side navigation menu, click **Networks** under the heading **Network**. There, either click on the **+** next to **private** or drag & drop the **private** box from **Available networks** to **Selected networks**. Finally, click the **Launch** button."

[//]: # "![](Runninganinstance-step5-2.png "Running an instance - step5-2.png")"

## Step 6: Associate Floating IP

In the main portion of the screen, click **Instances**  under the heading **Compute**. There, click the down arrow button under **Actions** column for your instance you just launched, followed by the **Associate Floating IP**. Click on **+** next to **IP Address** and select the **public** Pool in the **Allocate Floating IP** dialog, continue by clicking **Allocate IP**. Being back in the **Manage Floating IP Associations** dialog, you can select the allocated IP Address and click **Associate**.

[//]: # "![](Runninganinstance-step6.png "Running an instance - step6.png")"

The associated Floating IPs can be spotted in the **IP Address** for each instance.

For additional details, please read [how to set a floating IP range](/networking/floating-ip-range/).

## Step 7: SSH to Your Instance

Using the key pair file from step 3, connect through SSH to the running VM, using its floating IP address:

    $ ssh -i my_key_pair.pem fedora@floating_ip_address
