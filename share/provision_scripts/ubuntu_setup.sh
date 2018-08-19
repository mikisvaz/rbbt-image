#!/bin/bash -x

# INSTALL
# =======

# Basic system requirements
# -------------------------
apt-get -y install software-properties-common
add-apt-repository ppa:george-edison55/cmake-3.x
apt-get -y install cmake

apt-get -y update
apt-get -y update
apt-get -y install \
  vim \
  bison autoconf g++ libxslt1-dev make \
  zlib1g-dev libbz2-dev libreadline6 libreadline6-dev \
  wget curl git openssl libyaml-0-2 libyaml-dev \
  openjdk-8-jdk \
  libcairo2 libcairo2-dev r-base-core r-base-dev r-cran-rserve liblzma5 liblzma-dev libcurl4-openssl-dev \
  build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libffi-dev

# For paradigm/libdai
apt-get -y install \
  libgmp-dev libboost-dev libboost-program-options-dev libboost-test-dev

# This link was broken for some reason
rm /usr/lib/R/bin/Rserve
ln -s /usr/lib/R/site-library/Rserve/libs/Rserve /usr/lib/R/bin/Rserve

echo "export R_HOME='/usr/lib/R' # For Ruby's RSRuby gem" >> /etc/rbbt_environment
echo 'export PATH="$R_HOME/bin/:$PATH" # Rserver' >> /etc/rbbt_environment

. /etc/rbbt_environment

apt-get clean
rm -rf /var/lib/apt/lists/* 



