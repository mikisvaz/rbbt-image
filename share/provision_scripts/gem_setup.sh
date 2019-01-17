#!/bin/bash -x

# RUBY GEMS and RBBT
# =================

. /etc/rbbt_environment

echo "* Updating RubyGem"
export REALLY_GEM_UPDATE_SYSTEM=true
env REALLY_GEM_UPDATE_SYSTEM=true gem update --no-document --system

echo "* Installing difficult gems: ZenTest, RubyInline, rsruby and rjb"
gem install --force --no-document ZenTest
gem install --force --no-document RubyInline

# R (extra config in gem)
export R_INCLUDE="$(echo "$R_HOME" | sed 's@/usr/lib\(32\|64\)*@/usr/share@')/include"
gem install --conservative --no-document rsruby -- --with-R-dir="$R_HOME" --with-R-include="$R_INCLUDE" \
  --with_cflags="-fPIC -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wall -fno-strict-aliasing"

# Java (extra config in gem)
export JAVA_HOME=$(echo /usr/lib/jvm/java-?-openjdk-*)
gem install --conservative --force --no-document rjb

echo "* Installing bulk gems and Rbbt"
# Rbbt and some optional gems
gem install --no-document --force \
    tokyocabinet \
    ruby-prof \
    rbbt-util rbbt-rest rbbt-dm rbbt-text rbbt-sources rbbt-phgx rbbt-GE \
    rserve-client \
    uglifier therubyracer kramdown\
    puma prawn prawn-svg

# Get good version of lockfile
#wget http://ubio.bioinfo.cnio.es/people/mvazquezg/lockfile-2.1.4.gem -O /tmp/lockfile-2.1.4.gem
echo "* Installing our version of lockfile"
wget http://github.com/mikisvaz/lockfile/raw/master/lockfile-2.1.5.gem -O /tmp/lockfile-2.1.5.gem
gem install --no-document /tmp/lockfile-2.1.5.gem

# Extra things for web interface
gem install --no-document bio-svgenes mimemagic
