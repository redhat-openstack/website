---
title: Running (and recording) fully automated GUI tests in the cloud
author: Matthieu Huin
tags: openstack, CI, continuous-integration, software-factory, selenium, GUI, ffmpeg
date: 2017-05-08 09:05:31 EST
---

## The problem

[Software Factory](https://github.com/softwarefactory-project/software-factory) is a
full-stack software development platform: it hosts repositories, a bug tracker and
CI/CD pipelines. It is the engine behind [RDO's CI pipeline](https://review.rdoproject.org),
but it is also very versatile and suited for all kinds of software projects. Also,
I happen to be one of Software Factory's main contributors. :)

Software Factory has [many cool features that I won't list here](https://softwarefactory-project.io/docs/index.html), but among these
is a unified web interface that helps navigating through its components. Obviously
we want this interface thoroughly tested; ideally within Software Factory's
own CI system, which runs on test nodes being provisioned on demand on an OpenStack
cloud (If you have read [Tristan's previous article](/blog/2017/03/standalone-nodepool/),
you might already know that Software Factory's nodes are managed and built
by [Nodepool](https://docs.openstack.org/infra/system-config/nodepool.html)).

When it comes to testing web GUIs, [Selenium](http://www.seleniumhq.org) is
quite ubiquitous because of its many features, among which:

- it works with most major browsers, on every operating system
- it has bindings for every major language, making it easy to write GUI tests
  in your language of choice.¹

¹ Our language of choice, today, will be python.

Due to the very nature of GUI tests, however, it is not easy to fully automate
Selenium tests into a CI pipeline:

- usually these tests are run on dedicated physical machines for each operating
  system to test, making them choke points and sacrificing resources that could be
  used somewhere else.
- a failing test usually means that there is a problem of a graphical nature;
  if the developer or the QA engineer does not see what happens it is difficult
  to qualify and solve the problem. Therefore human eyes and validation are still
  needed to an extent.

Legal issues preventing running [Mac OS-based virtual machines on non-Apple
hardware](http://images.apple.com/legal/sla/docs/macOS1012.pdf) aside, it is
possible to run Selenium tests on virtual machines without need for a physical
display (aka "headless") and also capture what is going on during these tests for
later human analysis.

This article will explain how to achieve this on linux-based distributions,
more specifically on CentOS.

## Running headless (or "Look Ma! No screen!")

The secret here is to install __Xvfb__ (X virtual framebuffer) to emulate a display
in memory on our headless machine ...

My fellow Software Factory dev team and I have configured Nodepool to provide us
with customized images based on CentOS on which to run any kind of
jobs. This makes sure that our test nodes are always "fresh", in other words that
our test environments are well defined, reproducible at will and not tainted by
repeated tests.

The customization occurs through post-install scripts: if you look at our
[configuration repository](https://softwarefactory-project.io/r/gitweb?p=config.git;a=tree;f=nodepool;),
you will find the image we use for our CI tests is __sfstack-centos-7__ and its
customization script is __sfstack_centos_setup.sh__.

We added the following commands to this script in order to install
the dependencies we need:

```bash
sudo yum install -y firefox Xvfb libXfont Xorg jre
sudo mkdir /usr/lib/selenium /var/log/selenium /var/log/Xvfb
sudo wget -O /usr/lib/selenium/selenium-server.jar http://selenium-release.storage.googleapis.com/3.4/selenium-server-standalone-3.4.0.jar
sudo pip install selenium
```

The dependencies are:

* __Firefox__, the browser on which we will run the GUI tests
* __libXfont__ and __Xorg__ to manage displays
* __Xvfb__
* __JRE__ to run the __selenium server__
* the __python selenium bindings__

Then when the test environment is set up, we start the selenium server and Xvfb
in the background:

```bash
/usr/bin/java -jar /usr/lib/selenium/selenium-server.jar -host 127.0.0.1 >/var/log/selenium/selenium.log 2>/var/log/selenium/error.log
Xvfb :99 -ac -screen 0 1920x1080x24 >/var/log/Xvfb/Xvfb.log 2>/var/log/Xvfb/error.log
```

Finally, set the display environment variable to :99 (the Xvfb display) and run your tests:

```bash
export DISPLAY=:99
./path/to/seleniumtests
```

The tests will run as if the VM was plugged to a display.

## Taking screenshots

With this headless setup, we can now run GUI tests on virtual machines within our
automated CI; but we need a way to visualize what happens in the GUI if a test
fails.

It turns out that the selenium bindings have a screenshot feature that we can use
for that. Here is how to define a decorator in python that will save a screenshot
if a test fails.

```python
import functools
import os
import unittest
from selenium import webdriver

[...]

def snapshot_if_failure(func):
    @functools.wraps(func)
    def f(self, *args, **kwargs):
        try:
            func(self, *args, **kwargs)
        except Exception as e:
            path = '/tmp/gui/'
            if not os.path.isdir(path):
                os.makedirs(path)
            screenshot = os.path.join(path, '%s.png' % func.__name__)
            self.driver.save_screenshot(screenshot)
            raise e
    return f


class MyGUITests(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.maximize_window()
        self.driver.implicitly_wait(20)

    @snapshot_if_failure
    def test_login_page(self):
        ...
```

If test_login_page fails, a screenshot of the browser at the time of the exception
will be saved under __/tmp/gui/test_login_page.png__.

## Video recording

We can go even further and record a video of the whole testing session, as it
turns out that __ffmpeg__ can capture X sessions with the "x11grab" option. This
is interesting beyond simply test debugging, as the video can be used to illustrate
the use cases that you are testing, for demos or fancy video documentations.

In order to have ffmpeg on your test node, you can either add
[compilation steps](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos) to the
node's post-install script or go the easy way and use an external repository:

```bash
# install ffmpeg
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
sudo yum update
sudo yum install -y ffmpeg
```

To record the Xfvb buffer, you'd simply run
```bash
export FFREPORT=file=/tmp/gui/ffmpeg-$(date +%Y%m%s).log && ffmpeg -f x11grab -video_size 1920x1080 -i 127.0.0.1$DISPLAY -codec:v mpeg4 -r 16 -vtag xvid -q:v 8 /tmp/gui/tests.avi
```

The catch is that ffmpeg expects the user to press __q__ to stop the recording
and save the video (killing the process will corrupt the video). We can use
[tmux](https://tmux.github.io/) to save the day; run your GUI tests like so:

```bash
export DISPLAY=:99
tmux new-session -d -s guiTestRecording 'export FFREPORT=file=/tmp/gui/ffmpeg-$(date +%Y%m%s).log && ffmpeg -f x11grab -video_size 1920x1080 -i 127.0.0.1'$DISPLAY' -codec:v mpeg4 -r 16 -vtag xvid -q:v 8 /tmp/gui/tests.avi && sleep 5'
./path/to/seleniumtests
tmux send-keys -t guiTestRecording q
```

## Accessing the artifacts

Nodepool destroys VMs when their job is done in order to free resources (that is,
after all, the spirit of the cloud). That means that our pictures and videos will
be lost unless they're uploaded to an external storage.

Fortunately Software Factory handles this: predefined publishers can be appended
to our jobs definitions; [one of
which](https://softwarefactory-project.io/r/gitweb?p=config.git;a=blob;f=jobs/_default_jobs.yaml;h=abedee1d8899afbea7cc1fb31e5b5ee959fba154;hb=04f4d5aa6887f63155ceef38231399a077aa0040)
allows to push any artifact to a Swift object store. We can then retrieve our
videos and screenshots easily.

## Conclusion

With little effort, you can now run your selenium tests on virtual hardware as
well to further automate your CI pipeline, while still ensuring human supervision.

## Further reading

* [This article](http://afterdesign.net/2016/02/07/recording-headless-selenium-tests-to-mp4.html)
helped a lot in setting up our selenium environment.
* If you want to run your tests on docker containers rather than VMs, [this article
explains how to configure Xvfb for
that](https://linuxmeerkat.wordpress.com/2014/10/17/running-a-gui-application-in-a-docker-container/).
* Apparently [Selenium can run on headless Windows VMs as well](https://github.com/kybu/headless-selenium-for-win),
although I have not tested this.
