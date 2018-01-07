#!/bin/bash
set -e

# Update system and install ruby dependencies
apt update
apt install -y ruby-full ruby-bundler build-essential
