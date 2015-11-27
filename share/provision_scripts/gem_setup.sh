#!/bin/bash -x

# Ruby gems and Rbbt
# -------------------------
export REALLY_GEM_UPDATE_SYSTEM=true
env REALLY_GEM_UPDATE_SYSTEM=true gem update --system
gem install --force ZenTest
gem install --force RubyInline

# R (extra config in gem)
gem install --conservative --no-ri --no-rdoc rsruby -- --with-R-dir=/usr/lib/R --with-R-include=/usr/share/R/include --with_cflags="-fPIC -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wall -fno-strict-aliasing"

# Java (extra config in gem)
export JAVA_HOME=$(echo /usr/lib/jvm/java-7-openjdk-*)
gem install --conservative --force --no-ri --no-rdoc rjb

# Rbbt and some optional gems
gem install --no-ri --no-rdoc --force \
    rbbt-util rbbt-rest rbbt-dm rbbt-text rbbt-sources rbbt-phgx rbbt-GE \
    tokyocabinet \
    rserve-client \
    uglifier therubyracer kramdown\
    ruby-prof

# Get good version of lockfile
wget http://ubio.bioinfo.cnio.es/people/mvazquezg/lockfile-2.1.4.gem -O /tmp/lockfile-2.1.4.gem
gem install /tmp/lockfile-2.1.4.gem

