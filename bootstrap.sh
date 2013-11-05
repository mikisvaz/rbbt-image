#!/usr/bin/env bash

# INSTALL
# =======

# Basic system requirements
sudo apt-get update
sudo apt-get install -y curl bison git autoconf zlib1g-dev libbz2-dev libreadline6 libreadline6-dev libxslt1-dev g++ libyaml-0-2 libyaml-dev openssl make

# Ruby
sudo apt-get install -y ruby1.9.1 ruby1.9.1-dev

# R (extra config in gem)
sudo apt-get install -y r-base-core r-base-dev
sudo gem install --no-ri --no-rdoc rsruby -- --with-R-dir=/usr/lib/R --with-R-include=/usr/share/R/include 

# Java (extra config in gem)
sudo apt-get install -y openjdk-7-jdk 
sudo env JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386 gem install --no-ri --no-rdoc rjb

# Rbbt
sudo gem install --no-ri --no-rdoc rbbt-util rbbt-rest rbbt-study rbbt-dm rbbt-text rbbt-sources rbbt-phgx

# Extra gems (reason they are not installed by default)
    # JS compression (slow to compile)
sudo gem install --no-ri --no-rdoc uglifier therubyracer
    # Tokyocabinet (problematic sometimes)
sudo apt-get install -y libtokyocabinet-dev tokyocabinet-bin
sudo gem install --no-ri --no-rdoc tokyocabinet
    # Ruby-prof (problematic sometimes)
sudo gem install --no-ri --no-rdoc ruby-prof

# CONFIG
# ======

mkdir -p ~/.rbbt/etc

# File servers: to speed up the production of some resources
echo "Organism: http://se.bioinfo.cnio.es/" > ~/.rbbt/etc/file_servers

