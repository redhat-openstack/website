FROM quay.io/centos/centos:7
MAINTAINER jberkus@redhat.com
WORKDIR /tmp
RUN yum update -y && yum install -y tar libcurl-devel zlib-devel patch rubygem-bundler ruby-devel git make gcc gcc-c++ redhat-rpm-config && yum clean all

ADD config.rb /tmp/config.rb
#ADD data /tmp/data
ADD Gemfile  /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
ADD lib /tmp/lib
#ADD source /tmp/source

RUN bundle install

EXPOSE 4567
ENTRYPOINT [ "bundle", "exec" ]
CMD [ "middleman", "server" ]
