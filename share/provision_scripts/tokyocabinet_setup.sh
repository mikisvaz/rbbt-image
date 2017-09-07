#!/bin/bash -x

# TOKYOCABINET INSTALL
# ===================

cd /tmp
wget http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz -O "tokyocabinet.tar.gz"
tar -xvzf tokyocabinet.tar.gz
cd tokyocabinet-1.4.48
./configure --prefix=/usr/local
make && make install
