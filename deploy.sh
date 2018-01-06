#!/bin/bash

# Download app, install dependencies and start app
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install && puma -d