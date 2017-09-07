#!/bin/bash -x

# INSTALL
# =======

# Basic system requirements
# -------------------------
apt-get -y update
apt-get -y update
apt-get -y install \
  bison autoconf g++ libxslt1-dev make \
  zlib1g-dev libbz2-dev libreadline6 libreadline6-dev \
  wget curl git openssl libyaml-0-2 libyaml-dev \
  openjdk-8-jdk \
  libcairo2 libcairo2-dev r-base-core r-base-dev r-cran-rserve liblzma5 liblzma-dev libcurl4-openssl-dev \
  libtokyocabinet-dev tokyocabinet-bin \
  build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libffi-dev

# This link was broken for some reason
rm /usr/lib/R/bin/Rserve
ln -s /usr/lib/R/site-library/Rserve/libs/Rserve /usr/lib/R/bin/Rserve

grep R_HOME /etc/profile || echo "export R_HOME='/usr/lib/R' # For Ruby's RSRuby gem" >> /etc/profile
. /etc/profile

apt-get clean
rm -rf /var/lib/apt/lists/* 



