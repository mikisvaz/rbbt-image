#!/bin/bash -x

# R INSTALL
# ============

cd /tmp

apt-get remove r-base-core

wget https://cran.r-project.org/src/base/R-4/R-4.2.1.tar.gz -O R.tar.gz
tar -xvzf R.tar.gz

cd R-*/
./configure --prefix=/usr/local --enable-R-shlib
make && make install

echo "# For RSRuby gem " >> /etc/rbbt_environment
echo 'export R_HOME="/usr/local/lib/R"' >> /etc/rbbt_environment
echo '_add_path "$R_HOME/bin/" # Rserver' >> /etc/rbbt_environment
echo '_add_lib_path "$R_HOME/lib/" # Rserver' >> /etc/rbbt_environment

. /etc/rbbt_environment
