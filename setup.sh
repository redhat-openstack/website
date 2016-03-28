#!/usr/bin/env sh

git submodule init && git submodule update

sudo yum install -y ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch zlib-devel ImageMagick

bundle install --path vendor/bundle

# npm directory configuration is very linited, see: https://github.com/npm/npm/issues/775
[ -f vendor/package.json ] || ln -s ../package.json vendor/package.json
npm install --prefix ./vendor/

