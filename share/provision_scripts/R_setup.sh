#!/bin/bash -x

# R INSTALL
# ============

cd /tmp

apt-get remove r-base-core

wget https://cran.r-project.org/src/base/R-3/R-3.3.2.tar.gz
tar -xvzf R-3.3.2.tar.gz

cd R-3.3.2/
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
