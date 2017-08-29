#!/bin/bash -x

# RUBY GEMS and RBBT
# =================

export REALLY_GEM_UPDATE_SYSTEM=true
env REALLY_GEM_UPDATE_SYSTEM=true gem update --no-ri --no-rdoc --system
gem install --force --no-ri --no-rdoc ZenTest
gem install --force --no-ri --no-rdoc RubyInline

# R (extra config in gem)
. /etc/profile
export R_INCLUDE="$(echo "$R_HOME" | sed 's@/usr/lib\(32\|64\)*@/usr/share@')/include"
gem install --conservative --no-ri --no-rdoc rsruby -- --with-R-dir="$R_HOME" --with-R-include="$R_INCLUDE" \
  --with_cflags="-fPIC -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wall -fno-strict-aliasing"

# Java (extra config in gem)
export JAVA_HOME=$(echo /usr/lib/jvm/java-7-openjdk-*)
gem install --conservative --force --no-ri --no-rdoc rjb

# Rbbt and some optional gems
gem install --no-ri --no-rdoc --force \
    tokyocabinet \
    ruby-prof \
    rbbt-util rbbt-rest rbbt-dm rbbt-text rbbt-sources rbbt-phgx rbbt-GE \
    rserve-client \
    uglifier therubyracer kramdown\
    puma

# Get good version of lockfile
wget http://ubio.bioinfo.cnio.es/people/mvazquezg/lockfile-2.1.4.gem -O /tmp/lockfile-2.1.4.gem
gem install --no-ri --no-rdoc /tmp/lockfile-2.1.4.gem

# Extra things for web interface
gem install --no-ri --no-rdoc bio-svgenes mimemagic
