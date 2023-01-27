#!/bin/sh

if [ ! -e data/events/.git ]; then
    echo "Please initialize your repository first with setup.sh" >&2
    exit 1
fi

bundle install --verbose && bundle exec middleman $@
