---
title: Testing RDO with Rally
authors: adrahon
wiki_title: Testing RDO with Rally
wiki_revision_count: 1
wiki_last_updated: 2015-08-07
---

When it comes to testing RDO deployments, a lot of us rely on manual test plans and don't necessary know where to begin with tools like Tempest and Rally. The goal of this article is to quickly get you started with Rally, it should only take you a few minutes and the benefits are huge.

[Rally](https://wiki.openstack.org/wiki/Rally) is an official OpenStack project dedicated to benchmarking and testing OpenStack deployments. Rally presents itself as a benchmarking tool, but you can use it for simple tests too, and its benchmarking features are relevant to testing a complex distributed system like OpenStack.

I’ll consider that you have a working Rally environment, if that's not the case look at the [install doc](http://rally.readthedocs.org/en/latest/install.html#install).

# Getting started with Rally

Rally uses the OpenStack APIs, the only requirement is that you have access to the endpoints. You will need credentials of course, and sufficient quotas to run the tests.

The easiest way to define an Openstack deployment and storing your credentials in Rally is to use a keystonerc file:

    source keystonerc_admin
    rally deployment create --fromenv --name=rhelosp-lab1
    rally deployment check

The last command will output the status of the OpenStack services. Now you can run a simple test, test scenarios in Rally are defined in a YAML file (or JSON), there’s plenty of examples to get you started in RALLY_DIR/samples/tasks/scenarios/… Let’s run `boot-and-delete.yaml`:

    ---
      NovaServers.boot_and_delete_server:
        -
          args:
            flavor:
                name: &quot;m1.tiny&quot;
            image:
                name: &quot;^cirros.*uec$&quot;
            force_delete: false
          runner:
            type: &quot;constant&quot;
            times: 10
            concurrency: 2
          context:
            users:
              tenants: 3
              users_per_tenant: 2

Before you run this scenario, you have to check that the parameters, eg. the image name, are correct. You can do this using Rally itself:

    rally show images

Edit the file and make sure the flavor and image names are correct, then run it with:

    rally task start /opt/rally/samples/tasks/scenarios/nova/boot-and-delete.yaml

Rally gives you all kind of information about the test run and will output a nice table with min/max/avg time for each test, and more. We’ll discuss these numbers later, for now we have a simple command that allows us to quickly prove that our services are running (in that case Keystone, Glance and Nova).

# How to use Rally

In the software development world, it’s common practice to have systematic testing every time you change something, for example having Jenkins run a complete test suite every time someone pushes to a source code repository. Most sane people agree that it helps build confidence in the state of the system, by detecting issues early, enabling more granular changes, reducing conflict between concurrent work.

First we want a general test suite with reasonable functional coverage, ie. we want to be able to run one command that validates that all components of our system work from a user point of view, from basic functionality (authenticate to Keystone) to the more specific (booting from a Cinder volume). I encourage you to start with the [allinone.yaml](allinone.yaml) file provided, which is quite complete. You’ll have to replace parameters in upper case (eg **VOLUME_TYPE**) with actual values and possibly change the image name to one that exists in your environment. I encourage you to either use an image that is going to be used in the environment or at least the **CentOS7** cloud image, testing with **cirros** can be misleading because it is so lightweight.

Now you have a general test suite, when should you test? As often as possible, having a simple command to run the tests should encourage you to do so. I’m not going to consider production environments here (though I believe they should be tested too), but in my experience real-world deployments (ie. not on your laptop) are iterative processes that involve a lot of decisions, backtracking, etc. I think you should test every time you change something, even one small change in a configuration file, just to make sure everything is still running. Don’t forget to run the test suite after a change in the environment even if it’s not in OpenStack itself: router configuration change, new OS build...

Once you get the habit of systematically testing your environment, you can refine the test suite, add more test, break it down by service, by test level (quick basic test, detailed tests) or user story. If you fix an issue in the environment, even if it’s a corner case, it’s a good idea to write a test for it to avoid regressions. As is the case for software development projects, your test suite becomes part of the system’s documentation and is a good entry point for new joiners.

# Going forward, better testing

I really encourage you to try Rally now, part of its value is that it’s really easy to get started. Any test is better than no test and you can always improve your process later. That said there’s a lot more that can be done with Rally.

### Continuous testing

Having a test suite that you can run with a simple command is a big step forward from the usual “let’s log into Horizon and launch a cirros instance”. Testing is about building confidence and trust in the system, so it’s a good idea to share the results.

Rally can generate HTML reports from test results. You can generate a report for the last task that was run with

    rally task report --out task-report.html

or generate a report for a specific task ID (the ID is given in the output of the command)

    rally task report TASKID --out TASKID-report.html

The resulting HTML document is self contained, you can just open it in a web browser. You might want to make it accessible to everyone, an easy way to do that is to install and run a web server on the Rally machine (and yes, it’s a good idea to have a dedicated Rally machine somewhere with a stable FQDN). You can then run tasks and generate HTML reports with a simple script like

    #!/bin/bash

    NOW=`date +&quot;%Y%m%d-%H%M%S&quot;`

    rally --log-file /opt/rally-tests/logs/rally_$date.log task start --task /opt/rally-tests/tasks/allinone.yaml

    # Create rally report
    TASKID=`rally task status | awk '{print $2}' | tr -d :`
    rally task report $TASKID --out /var/www/html/rally-tests/$NOW.html
    rally task report $TASKID --out /var/www/html/index.html

You can then access the last report at <http://rally.example.com/> and time-sorted reports at <http://rally.example.com/rally-tests/>.

Of course this is just a starting point, you can parse the `rally task status` output to collect tests results automatically, build a dashboard...

The next logical improvement is to run this script automatically, whether it’s with a simple cron job or something like Jenkins (in that case you can add logic to the process, eg. trigger on configuration change). In an ongoing deployment, where change is constant, having the tests running continuously, or near continuously, can help stabilising the system. In a way it’s like having users, you can’t cheat, you have to keep your system functional. Using Rally parameters like test runner concurrency you can progressively increase the load on your environment and do some stress-testing on the different components.

Concurrency is also something that is rarely tested in manual scenarios. Having 10 concurrent runners for a test can help you discover some interesting issues.

### Metrics and SLAs

We’ve discussed using Rally as a functional testing tool, only looking at binary answers: is it working or not. Rally offers a lot more functionality than that, and it’s first designed as a benchmarking tool. I’m not going to discuss in-depth benchmarking of OpenStack environments, but Rally benchmarking features give us information that is relevant to functional testing too, like iteration time for a test and failure rate.

In complex like OpenStack, there is always going to be an amount of failed operations. It doesn’t mean that the system is broken, just that there was a glitch and the user has to retry. As someone said, in distributed systems failure isn’t an option, it’s inevitable. If you start stress testing your environment and simulating real user behaviour, you’ll start seeing instance that fail to get provisioned, or operations plainly not getting executed. Even launching 100 instances sequentially could result in 1-2 failures in a healthy environment. It doesn’t mean you should consider this test has failed.

On the flip side, faults in complex systems don’t necessarily result in immediate failure. For example they can manifest themselves as a performance issue. Let’s say you introduce a change in a service, and your test pass with a 100% success rate, but operations take 40% longer to complete. Tests pass, so everyone works on the next task. Now another change in another service results in a similar loss of performance and suddenly the compounded increase in operation time means that user requests time out and suddenly everything is broken.

Binary “works/doesn’t work” testing is not very useful to prevent these issues. In a sense, most testing in a distributed testing should be “benchmarking”: collecting metrics, timing operations, looking at averages, distribution, outliers… but most importantly tracking change in these values. If a configuration change introduces an important variation in those values, it should be noticed and understood.

Rally uses the concept of SLA to make this part of your tests. Defining SLAs for an OpenStack environment is a complex task, and we might not be in a position to do that, but we want to track variation in those numbers. As an example, we might not be able to say if a 2% failure rate for instance provisioning is acceptable, but if it’s the current failure rate, we might want to be alerted if it raises to 5%.

To add SLAs to your test, just add a `sla` section at the same level of your `args` or `runner` section:

          sla:
            max_seconds_per_iteration: 4.0
            failure_rate:
              max: 1
            max_avg_duration: 3.0
            outliers:
              max: 1
              min_iterations: 10
              sigmas: 10

If the test pass but the SLAs are not met, it will be considered a failure. Of course you can have different test suites with different SLAs, it’s good practice to have even very lax SLAs so you can detect abnormal behaviour.

To get the most out of the test run data, you can get a report in JSON format with

    rally task results TASKID

Of course you'll have to import it somewhere to make use of it.

# Conclusion

To reiterate, testing is critical to any OpenStack deployment. Thankfully it is not difficult to start testing with Rally. I’ve discussed more advanced topics, but just running Rally with the provided `allinone.yaml` test suite regularly will get you a long way. Operational visibility in OpenStack is a neglected topic, we are often running blind and have to resort to guessing when facing issues.
