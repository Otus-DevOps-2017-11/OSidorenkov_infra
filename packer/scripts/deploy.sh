#!/bin/bash
set -e

# Download app, install dependencies
cd /home/appuser && git clone https://github.com/Otus-DevOps-2017-11/reddit.git && cd reddit && bundle install
cp /tmp/puma.service /etc/systemd/system/puma.service
systemctl enable puma.service

