#!/bin/bash -x

# RUBY INSTALL
# ============

_small_version=`echo $RUBY_VERSION | cut -f 1,2 -d.`
cd /tmp
wget https://cache.ruby-lang.org/pub/ruby/$_small_version/ruby-${RUBY_VERSION}.tar.gz -O "ruby.tar.gz"
tar -xvzf ruby.tar.gz
cd ruby-*/
./configure --prefix=/usr/local
make && make install

unset _small_version

echo 'export PATH="/usr/local/bin:/opt/bin:$PATH" #Ruby2' >> /etc/rbbt_environment
. /etc/rbbt_environment

#\curl -sSL https://get.rvm.io | bash -s stable
#source /etc/profile.d/rvm.sh
#rvm install $RUBY_VERSION
