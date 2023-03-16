#!/bin/bash -x

# TOKYOCABINET INSTALL
# ===================

mkdir -p /opt/src/
cd /opt/src/
wget http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz -O "tokyocabinet.tar.gz"
tar -xvzf tokyocabinet.tar.gz
cd tokyocabinet-1.4.48
./configure --prefix=/usr/local
make > /tc_make.log
make install > /tc_make_install.log
gem install tokyocabinet
cd /
rm -Rf /opt/src/
