#!/bin/bash -x

# RUBY INSTALL
# ============

_small_version=`echo $RUBY_VERSION | cut -f 1,2 -d.`

[ -d /usr/local/scr/ruby-install ] || mkdir -p /usr/local/src/ruby-install

_prewd="$(pwd)"
cd /usr/local/scr/ruby-install

gem list --no-versions > gem.list

wget https://cache.ruby-lang.org/pub/ruby/$_small_version/ruby-${RUBY_VERSION}.tar.gz -O "ruby.tar.gz"
tar -xvzf ruby.tar.gz
cd ruby-*/
./configure --prefix=/usr/local --enable-shared
make && make install

cd ..

for p in `cat gem.list`; do
 /usr/local/bin/gem install $p
done

unset _small_version

cd "$_prewd"
#rm -Rf /tmp/ruby-install

#\curl -sSL https://get.rvm.io | bash -s stable
#source /etc/profile.d/rvm.sh
#rvm install $RUBY_VERSION
