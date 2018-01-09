#!/bin/bash

# Update system and install ruby dependencies
apt update
apt install -y ruby-full ruby-bundler build-essential

# Install mongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update
apt install -y mongodb-org

# Enable autostart and start service
systemctl enable mongod
systemctl start mongod

# Download app, install dependencies and start app
cd /home/appuser && git clone https://github.com/Otus-DevOps-2017-11/reddit.git && cd reddit && bundle install && puma -d
