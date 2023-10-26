#!/bin/bash -x

# RUBY GEMS and RBBT
# =================

echo "* Updating RubyGem"
export REALLY_GEM_UPDATE_SYSTEM=true
env REALLY_GEM_UPDATE_SYSTEM=true gem update --no-document --system

#echo "* Installing difficult gems: ZenTest, RubyInline, rsruby and rjb"
#gem install --force --no-document RubyInline
gem install --force --no-document ZenTest

## R (extra config in gem)
#export R_INCLUDE="$(echo "$R_HOME" | sed 's@/usr/lib\(32\|64\)*@/usr/share@')/include"
#gem install --conservative --no-document rsruby -- --with-R-dir="$R_HOME" --with-R-include="$R_INCLUDE" \
#  --with_cflags="-fPIC -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wall -fno-strict-aliasing"

# Java (extra config in gem)
#export JAVA_HOME=$(echo /usr/lib/jvm/java-?-openjdk-*)
#gem install --conservative --force --no-document rjb

echo "* Installing all rbbt gems"
# Rbbt and some optional gems
gem install --no-document --force \
    tokyocabinet \
    ruby-prof \
    rbbt-util rbbt-sources rbbt-dm rbbt-text rbbt-rest

echo "* Installing extra gems for web stuff"
# Extra things for web interface
gem install --no-document \
    sinatra puma rack \
    rest-client \
    kramdown pandoc pandoc-ruby \
    spreadsheet rubyXL \
    prawn prawn-svg mimemagic \
    prime mechanize

gem install --no-document mini_racer uglifier

gem cleanup
