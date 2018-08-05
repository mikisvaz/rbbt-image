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

echo "# For RSRuby gem " >> /etc/rbbt_environment
echo "export R_HOME='/usr/local/lib/R'" >> /etc/rbbt_environment
echo "export PATH=\"$R_HOME/bin:$PATH\"" >> /etc/rbbt_environment
echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:\$R_HOME/lib\"" >> /etc/rbbt_environment
echo "export LD_RUN_PATH=\"\$LD_RUN_PATH:\$R_HOME/lib\"" >> /etc/rbbt_environment

. /etc/rbbt_environment
