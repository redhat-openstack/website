#!/bin/bash
# install everything in a docker container which should
# permit us to have the same env on any system.

# clone events submodule
git submodule init
git submodule update

# set SElinux context to allow docker to read the source directory
chcon -Rt svirt_sandbox_file_t source/
chcon -Rt svirt_sandbox_file_t data/

# requires docker and being in the right group
docker build -t middleman .
docker run --rm -p 4567:4567 -v "$(pwd)"/source:/tmp/source:ro -v "$(pwd)"/data:/tmp/data middleman
