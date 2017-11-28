---
title: Anomaly Detection in CI logs
author: tristanC
date: 2017-11-14 10:00:00 UTC
tags: openstack, infra, zuul, CI
---

Continous Integration jobs can generate a lot of data and it can take a lot of
time to figure out what went wrong when a job fails.
This article demonstrates new strategies to assist with failure investigations
and to reduce the need to crawl boring log files.

First, I will introduce the challenge of anomaly detection in CI logs.
Second, I will present a workflow to automatically extract and report anomalies using
a tool called [LogReduce](https://softwarefactory-project.io/r/gitweb?p=logreduce.git;a=blob;f=README.rst).
Lastly, I will discuss the current limitations and how more advanced techniques
could be used.



# Introduction

Finding anomalies in CI logs using simple patterns such as "grep -i error" is
not enough because interesting log lines doesn't necessarly feature
obvious anomalous messages such as "error" or "failed". Sometime you
don't even know what you are looking for.

In comparaison to regular logs, such as system logs of a production service,
CI logs have a very interresting characteristic: they are reproducible.
Thus, it is possible to carefully look for new events that are not present in other
job execution logs. This article focuses on this particular characteristic
to detect anomalies.


## The challenge

For this article, baseline events are defined as the collection of log lines
produced by nominal jobs execution and target events are defined as
the collection of log lines produced by a failed job run.

Searching for anomalous events is challenging because:

* Events can be noisy: they often includes unique features such as timestamps,
  hostnames or uuid.
* Events can be scattered accross many differents files.
* False positives events may appear for various reasons,
  for example when a new test option has been introduced.
  However they often share a common semantic with some baseline events.

Moreover, there can be a very high number of events, for example,
more than 1 million lines for tripleo jobs.
Thus, we can not easily look for each target event not present
in baseline events.


## OpenStack Infra CRM114

It is worth noting that anomaly detection is already happening live in the
openstack-infra operated review system using [classify-log.crm](https://git.openstack.org/cgit/openstack-infra/puppet-log_processor/tree/files/classify-log.crm),
which is based on CRM114 bayesian filters.

However it is currently only used to classify global failures
in the context of the elastic-recheck process.
The main drawbacks to using this tool are:

* Events are processed per words without considering complete lines: it only
  computes the distances of up to a few words.
* Reports are hard to find for regular users, they would have to go to
  [elastic-recheck uncategorize](http://status.openstack.org/elastic-recheck/data/integrated_gate.html),
  and click the *crm114* links.
* It is written in an obscure language



# LogReduce

This part presents the techniques I used in [LogReduce](https://softwarefactory-project.io/r/gitweb?p=logreduce.git)
to overcome the challenges described above.

## Reduce noise with tokenization

The first step is to reduce the complexity of the events to simplify
further processing. Here is the line processor I used, see the [Tokenizer module](https://softwarefactory-project.io/r/gitweb?p=logreduce.git;a=blob;f=logreduce/tokenizer.py):

* Skip known bogus events such as ssh scan: "sshd.+[iI]nvalid user"
* Remove known words:
  * Hashes which are hexa decimal words that are 32, 64 or 128 characters long
  * UUID4
  * Date names
  * Random prefixes such as `(tmp|req-|qdhcp-)[^\s\/]+`
* Discard every character that is not `[a-z_\/]`

For example this line:
```
  2017-06-21 04:37:45,827 INFO [nodepool.builder.UploadWorker.0] Uploading DIB image build 0000000002 from /tmpxvLOTg/fake-image-0000000002.qcow2 to fake-provider
```
Is reduced to:
```
  INFO nodepool builder UploadWorker Uploading image build from /fake image fake provider
```

## Index events in a NearestNeighbors model

The next step is to index baseline events. I used a NearestNeighbors model
to query target events' distance from baseline events. This helps remove
false-postive events that are similar from known baseline events.
The model is fitted with all the baseline events transformed using
Term Frequency Inverse Document Frequency (tf-idf). See the
[SimpleNeighbors model](https://softwarefactory-project.io/r/gitweb?p=logreduce.git;a=blob;f=logreduce/models.py;h=0db862ff17182aa45ba59c605c64bcee04769ea1;hb=HEAD#l95)

```python
vectorizer = sklearn.feature_extraction.text.TfidfVectorizer(
    analyzer='word', lowercase=False, tokenizer=None,
    preprocessor=None, stop_words=None)
nn = sklearn.neighbors.NearestNeighbors(
    algorithm='brute',
    metric='cosine')
train_vectors = vectorizer.fit_transform(train_data)
nn.fit(train_vectors)
```

Instead of having a single model per job, I built a model per file
type. This requires some pre-processing work to figure out what model to
use per file. File names are converted to model names using another
Tokenization process to group similar files. See the
[filename2modelname function](https://softwarefactory-project.io/r/gitweb?p=logreduce.git;a=blob;f=logreduce/models.py;h=0db862ff17182aa45ba59c605c64bcee04769ea1;hb=HEAD#l256).

For example, the following files are grouped like so:
```
audit.clf: audit/audit.log audit/audit.log.1
merger.clf: zuul/merger.log zuul/merge.log.2017-11-12
journal.clf: undercloud/var/log/journal.log overcloud/var/log/journal.log
```

## Detect anomalies based on kneighbors distance

Once the NearestNeighbor model is fitted with baseline events, we can repeat the
process of Tokenization and tf-idf transformation of the target events. Then
using the kneighbors query we compute the distance of each target event.

```python
test_vectors = vectorizer.transform(test_data)
distances, _ = nn.kneighbors(test_vectors, n_neighbors=1)
```

Using a distance threshold, this technique can effectively detect anomalies in
CI logs.


## Automatic process

Instead of manually running the tool, I added a server mode that automatically
searches and reports anomalies found in failed CI jobs.
Here are the different components:

* *listener* connects to mqtt/gerrit event-stream/cistatus.tripleo.org and collects
  all success and failed job.

* *worker* processes jobs collected by the listener. For each failed job, it
  does the following in pseudo-code:

```
Build model if it doesn't exist or if it is too old:
	For each last 5 success jobs (baseline):
		Fetch logs
	For each baseline file group:
		Tokenize lines
		TF-IDF fit_transform
		Fit file group model
Fetch target logs
For each target file:
	Look for the file group model
	Tokenize lines
	TF-IDF transform
	file group model kneighbors search
	yield lines that have distance > 0.2
Write report
```

* *publisher* processes each report computed by the worker and notifies:
  * IRC channel
  * Review comment
  * Mail alert (e.g. periodic job which doesn't have a associated review)


## Reports example

Here are a couple of examples to illustrate LogReduce reporting.

In this [change](https://softwarefactory-project.io/r/10189) I broke a service
configuration (zuul gerrit port), and logreduce correctly found the anomaly in
the service logs (zuul-scheduler can't connect to gerrit):
[sf-ci-functional-minimal report](https://fedorapeople.org/~tdecacqu/logreduce-demo/2017-11-13-09-48-sf-ci-functional-minimal-master-Z0472c748dd534d609a3ffeb094a8cf51.html)

In this [tripleo-ci-centos-7-scenario001-multinode-oooq-container report](https://fedorapeople.org/~tdecacqu/logreduce-demo/2017-11-08-21-34-legacy-tripleo-ci-centos-7-scenario001-multinode-oooq-container-13841da.html),
logreduce found 572 anomalies out of a 1078248 lines. The interesting ones are:
* Non obvious new DEBUG statements in /var/log/containers/neutron/neutron-openvswitch-agent.log.txt.
* New setting of the firewall_driver=openvswitch in neutron was detected in:
  * /var/log/config-data/neutron/etc/neutron/plugins/ml2/ml2_conf.ini.txt
  * /var/log/extra/docker/docker_allinfo.log.txt
* New usage of cinder-backup was detected accross several files such as:
  * /var/log/journal contains new puppet statement
  * /var/log/cluster/corosync.log.txt
  * /var/log/pacemaker/bundles/rabbitmq-bundle-0/rabbitmq/rabbit@centos-7-rax-iad-0000787869.log.txt.gz
  * /etc/puppet/hieradata/service_names.json
  * /etc/sensu/conf.d/client.json.txt
  * pip2-freeze.txt
  * rpm-qa.txt


# Caveats and improvements

This part discusses the caveats and limitations of the current implementation
and suggests other improvements.

## Empty success logs

This method doesn't work when the debug events are only included in the failed logs.
To successfully detect anomalies, failure and success logs need to be similar,
otherwise all the extra information in failed logs will be considered anomalous.

This situation happens with testr results where success logs only contain 'SUCCESS'.


## Building good baseline model

Building a good baseline model with nominal job events is key to anomaly detection.
We could use periodic execution (with or without failed runs), or the gate pipeline.

Unfortunately Zuul currently lacks build reporting
and we have to scrap gerrit comments or status web pages, which is sub-optimal.
Hopefully the upcomming
[zuul-web builds API](https://review.openstack.org/466561) and
[zuul-scheduler MQTT reporter](https://review.openstack.org/518279) will make this
task easier to implement.


## Machine learning

I am by no means proficient at machine learning.
Logreduce happens to be useful as it is now. However here are some other
strategies that may be worth investigating.

The model is currently using a word dictionnary to build the features vector and
this may be improved by using different feature extraction techniques more suited
for log line events such as MinHash and/or Locality Sensitive Hash.

The NearestNeighbors kneighbors query tends to be slow for large samples
and this may be improved upon by using Self Organizing Map, RandomForest or OneClassSVM model.

When line sizes are not homogeneous in a file group, then the model doesn't
work well. For example, mistral/api.log line size varies between 10 and 8000 characters.
Using models per bins based on line size may be a great improvement.

CI logs analysis is a broad subject on its own, and I suspect someone good at machine
learning might be able to find other clever anomaly detection strategies.


## Further processing

Detected anomalies could be further processed by:

* Merging similar anomalies discovered accross different files.
* Looking for known anomalies in a system like elastic-recheck.
* Reporting new anomalies to elastic-recheck so that affected jobs could be grouped.



# Conclusion

CI log analysis is a powerful service to assist failure investigations.
The end goal would be to report anomalies instead of exhaustive job logs.

Early results of LogReduce models look promising and I hope we could setup
such services for any CI jobs in the future.
Please get in touch by [mail](mailto:tdecacqu@redhat.com)
or irc (tristanC on Freenode) if you are interrested.
