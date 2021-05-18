#!/bin/bash

# user data script to use in test environments for installing redis on Ubuntu 18.04 or 20.04.
apt update -y && apt upgrade -y
apt install gcc
wget http://download.redis.io/redis-stable.tar.gz
cp redis-stable.tar.gz ~/ubuntu/
tar xvzf ~/ubuntu/redis-stable.tar.gz
cd ~/ubuntu/redis-stable
make distclean
make
cp src/redis-server /usr/local/bin
cp src/redis-cli /usr/local/bin
