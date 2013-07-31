---
title: Running an instance with Neutron
category: networking
authors: jonar, mangelajo, otherwiseguy, rbowen
wiki_category: Networking
wiki_title: Running an instance with Neutron
wiki_revision_count: 14
wiki_last_updated: 2013-12-18
---

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8 pull-s">
# Running an Instance

### Step 1: Visit the Dashboard

Log in to the Openstack dashboard at <http://CONTROL_NODE/dashboard> - the username is "demo". The password can be found in the file keystonerc_demo in the /root/ directory of the control node.

### Step 2: Enable SSH and ICMP on your default security group.

Once logged in to the OpenStack dashboard, click the "Project" tab in the left-side navigation menu, and then click "Access & Security" under the heading "Manage Compute." Under the "Security Groups" heading, click the "Edit Rules" button for the "default" security group. Click the "Add Rule" button, and in the resulting dialog, enter "22" in the "Port" field, and then click the "Add" button. Add another rule selecting ICMP as the protocol and entering -1 for both the type and code fields.

### Step 3: Create or import a key pair.

In the left-side navigation menu, click "Access & Security" under the heading "Manage Compute." In the main portion of the screen, click the tab labeled "Keypairs," and choose either to "Create Keypair" or "Import Keypair." The "Create Keypair" dialog will prompt you to supply a keypair name before downloading a private key to your client.

The "Import Keypair" option will prompt you to provide a name and a public key to use with an existing private key on your client. For name, choose something to identify that key (like your username, for example) and for key, use the contents of your public key file, usually in ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.pub on the machine from which you will be ssh-ing in.

### Step 4: Launch the instance.

In the main portion of the screen, under the "Images" heading, click the "Launch" button for the "cirros" image. In the resulting dialog, provide a name in the "Instance Name" field. Under the "Network" tab, add the "private" network and click the "Launch" button.

### Step 5: Associate Floating IP

In the main portion of the screen, under the "Instances" heading, click the "More" button, followed by the "Associate Floating IP" link for the instance you just launched. Click the "+" by the "IP Address" field. Select "Allocate IP". Now, select "Associate". You should see both public and private IP addresses listed in the "IP Address" column for your instance.

For additional details, please read [how to set a floating IP range](Floating IP range).

### Step 6: SSH to Your Instance

Using the key pair file from step 3, ssh into the running vm using its floating ip address:

    $ ssh -l cirros -i my_key_pair.pem floating_ip_address
