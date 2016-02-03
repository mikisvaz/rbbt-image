#!/bin/bash -x

# RUBY INSTALL
# ============

cd /tmp
wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz
tar -xvzf ruby-2.3.0.tar.gz
cd ruby-2.3.0/
./configure --prefix=/usr/local
make && make install

grep "#Ruby2" /etc/profile || echo 'export PATH="/usr/local/bin:$PATH" #Ruby2' >> /etc/profile
. /etc/profile

