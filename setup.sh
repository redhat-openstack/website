#!/usr/bin/env sh
git submodule init && git submodule update
sudo yum install -y ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch zlib-devel ImageMagick
bundle install --path vendor/bundle
