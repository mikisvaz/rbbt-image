#!/bin/bash -x

# R INSTALL
# ============

cd /tmp

apt-get remove r-base-core

wget https://ftp.gwdg.de/pub/misc/cran/src/base/R-3/R-3.4.2.tar.gz -O R.tar.gz
tar -xvzf R.tar.gz

cd R-*/
./configure --prefix=/usr/local --enable-R-shlib
make && make install

grep -v R_HOME /etc/profile > profile.tmp
echo >> profile.tmp
echo "# For RSRuby gem " >> profile.tmp
echo "export R_HOME='/usr/local/lib/R'" >> profile.tmp
echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:\$R_HOME/lib\"" >> profile.tmp
echo "export LD_RUN_PATH=\"\$LD_RUN_PATH:\$R_HOME/lib\"" >> profile.tmp
mv profile.tmp /etc/profile

. /etc/profile
