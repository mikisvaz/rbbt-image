#!/bin/bash -x

# INSTALL
# =======

# Basic system requirements
# -------------------------
DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install --no-install-recommends \
  bison autoconf libxslt1-dev make \
  zlib1g-dev libbz2-dev libreadline6-dev \
  wget curl git openssl libyaml-dev \
  openjdk-7-jdk \
  libxt-dev libcairo2-dev r-base-dev r-cran-rserve liblzma-dev libcurl4-openssl-dev \
  libtokyocabinet-dev tokyocabinet-bin \
  build-essential libssl-dev libffi-dev gfortran unzip

# This link was broken for some reason
rm /usr/lib/R/bin/Rserve
ln -s /usr/lib/R/site-library/Rserve/libs/Rserve /usr/lib/R/bin/Rserve

grep R_HOME /etc/profile || echo "export R_HOME='/usr/lib/R' # For Ruby's RSRuby gem" >> /etc/profile
. /etc/profile
