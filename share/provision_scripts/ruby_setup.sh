#!/bin/bash -x

# RUBY INSTALL
# ============

_small_version=`echo $RUBY_VERSION | cut -f 1,2 -d.`

[ -d /tmp/ruby-install ] || mkdir /tmp/ruby-install

_prewd="$(pwd)"
cd /tmp/ruby-install

wget https://cache.ruby-lang.org/pub/ruby/$_small_version/ruby-${RUBY_VERSION}.tar.gz -O "ruby.tar.gz"
tar -xvzf ruby.tar.gz
cd ruby-*/
./configure --prefix=/usr/local --enable-shared
make && make install

unset _small_version

cd "$_prewd"
rm -Rf /tmp/ruby-install

#\curl -sSL https://get.rvm.io | bash -s stable
#source /etc/profile.d/rvm.sh
#rvm install $RUBY_VERSION
