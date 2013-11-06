#!/bin/bash -x

# INSTALL
# =======

# Basic system requirements
# -------------------------
sudo apt-get update
sudo apt-get install -y \
  bison autoconf g++ libxslt1-dev make \
  zlib1g-dev libbz2-dev libreadline6 libreadline6-dev \
  curl git openssl libyaml-0-2 libyaml-dev \
  ruby1.9.1 ruby1.9.1-dev \
  r-base-core r-base-dev \
  openjdk-7-jdk \
  libtokyocabinet-dev tokyocabinet-bin

# Ruby gems and Rbbt
# -------------------------

# R (extra config in gem)
sudo gem install --conservative --no-ri --no-rdoc rsruby -- --with-R-dir=/usr/lib/R --with-R-include=/usr/share/R/include 

# Java (extra config in gem)
sudo env JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386 gem install --conservative --no-ri --no-rdoc rjb

# Rbbt and some optional gems
sudo gem install --conservative --no-ri --no-rdoc \
    rbbt-util rbbt-rest rbbt-study rbbt-dm rbbt-text rbbt-sources rbbt-phgx rbbt-GE \
    tokyocabinet \
    uglifier therubyracer kramdown \
    ruby-prof




#{{{ CONFIG
# ======
cat > config.sh <<EOF


# GENERAL
# -------
mkdir -p ~/.rbbt/etc

# File servers: to speed up the production of some resources
echo "Organism: http://se.bioinfo.cnio.es/" > ~/.rbbt/etc/file_servers


# APP
# ---
mkdir -p ~/.rbbt/studies/
cd ~/.rbbt/studies/

export RBBT_WORKFLOW_AUTOINSTALL=true
export RBBT_LOG=0

rbbt workflow task ICGC datasets|grep -v "#" |cut -f 1 | while read p; do (rbbt workflow task ICGC prepare_study -o "\$p" -d "\$p" --jobname "\$p"); sleep 2;  done

rbbt app install ICGCScout
ln -s ~/.rbbt/studies/ ~/.rbbt/app/ICGCScout/studies

rbbt app start ICGCScout -e production -p 2887 --log=0


EOF
su -l -c "bash config.sh" vagrant
#}}}
