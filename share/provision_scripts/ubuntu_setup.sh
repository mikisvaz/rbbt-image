#!/bin/bash -x

# INSTALL
# =======

#cat << 'EOF' > /etc/rbbt_environment 
#_var_content(){
#    var=$1
#    eval echo "$"$(echo $var)
#}
#
#_append_with_colon(){
#    var=$1
#    value=$2
#
#    current=`_var_content $var`
#
#    if ! echo $current | grep "\(^\|:\)$value\(:\|$\)" >/dev/null 2>&1; then
#        eval $(echo $var)="\"$current:$value\""
#    fi
#}
#
#_append_with_space(){
#    var=$1
#    value=$2
#
#    current=`_var_content $var`
#
#    if ! echo $current | grep "\(^\| \)$value\( \|$\)" >/dev/null 2>&1; then
#        eval $(echo $var)="\"$current:$value\""
#    fi
#}
#
#_prepend_with_colon(){
#    var=$1
#    value=$2
#
#    current=`_var_content $var`
#
#    if ! echo $current | grep "\(^\|:\)$value\(:\|$\)" >/dev/null 2>&1; then
#        eval $(echo $var)="\"$value:$current\""
#    fi
#}
#
#_prepend_with_space(){
#    var=$1
#    value=$2
#
#    current=`_var_content $var`
#
#    if ! echo $current | grep "\(^\| \)$value\( \|$\)" >/dev/null 2>&1; then
#        eval $(echo $var)="\"$value $current\""
#    fi
#}
#
#_add_path(){
#  _prepend_with_colon PATH "${1%/}"
#}
#
#_add_libpath(){
#  _prepend_with_colon LD_LIBRARY_PATH "${1%/}"
#  _prepend_with_colon LD_RUN_PATH "${1%/}"
#}
#EOF

# Basic system requirements
# -------------------------
apt-get -y update
apt-get -y install software-properties-common

apt-get -y update
apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install \
  vim \
  wget \
  libc6 \
  time numactl xvfb \
  bison autoconf g++ libxslt1-dev make \
  zlib1g-dev libbz2-dev libreadline-dev \
  rsync wget curl git openssl libyaml-0-2 libyaml-dev \
  openjdk-8-jdk \
  libcairo2 libcairo2-dev r-base-core r-base-dev r-cran-rserve liblzma5 liblzma-dev libcurl4-openssl-dev \
  build-essential zlib1g-dev libssl-dev libyaml-dev libffi-dev \
  python3 python libtorch \
  tcsh gawk \
  ansible \
  pandoc \
  libtbb-dev

#add-apt-repository ppa:george-edison55/cmake-3.x
apt-get -y update
apt-get -y update
apt-get -y install cmake

# For paradigm/libdai
apt-get -y install \
  libgmp-dev libboost-all-dev 

# This link was broken for some reason
rm /usr/lib/R/bin/Rserve
ln -s /usr/lib/R/site-library/Rserve/libs/Rserve /usr/lib/R/bin/Rserve

echo "export R_HOME='/usr/lib/R' # For Ruby's RSRuby gem" >> /etc/rbbt_environment
echo '_add_path "$R_HOME/bin/" # Rserver' >> /etc/rbbt_environment
echo 'export R_LIBS_USER="~/container_R/lib" # Avoid collision with host system' >> /etc/rbbt_environment

[ -d /opt/bin ] || mkdir -p /opt/bin
echo '_add_path "/opt/bin/"' >> /etc/rbbt_environment

[ -d /usr/local/bin ] || mkdir -p /usr/local/bin
echo '_add_path "/usr/local/bin/"' >> /etc/rbbt_environment

echo 'export LC_ALL=C.UTF-8' >> /etc/rbbt_environment


apt-get clean
rm -rf /var/lib/apt/lists/* 

echo "[ -f ~/.rbbt/etc/environment ] && . ~/.rbbt/etc/environment" >> "/etc/rbbt_environment"
echo "source /etc/rbbt_environment" >> /etc/profile
