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
echo 'PATH="$R_HOME/bin/:$PATH" # Rserver' >> /etc/rbbt_environment
echo 'LD_LIBRARY_PATH="$R_HOME/lib/:$LD_LIBRARY_PATH" # Rserver' >> /etc/rbbt_environment
echo 'LD_RUN_PATH="$R_HOME/lib/:$LD_RUN_PATH" # Rserver' >> /etc/rbbt_environment

. /etc/rbbt_environment
