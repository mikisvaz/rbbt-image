#!/bin/bash -x

# INSTALL
# =======


export R_HOME=$(R RHOME)
export R_INCLUDE="$R_HOME/../../include/R"
gem install rsruby -- --with-R-dir=$R_HOME --with-R-include=$R_INCLUDE || gem install rsruby -- --with-R-dir=$R_HOME --with-R-include=/usr/share/R/include/

echo 'install.packages("Rserve", repos="http://www.rforge.net/")' | R --vanilla --quiet
gem install rserve-client
