#!/bin/bash -x

# INSTALL
# =======

# R packages
# ----------

function R_install_packages(){
  pkgs="'$1'"
  shift
  for p in $@; do
    pkgs="$pkgs, '$p'"
  done
  echo "install.packages(c($pkgs), repos='http://cran.us.r-project.org')" | R --vanilla --quiet
}

function R_biocLite(){
  pkgs="'$1'"
  shift
  for p in $@; do
    echo "BiocManager::install(c('$p'))" | R --vanilla --quiet
  done
}

function R_CMD_install(){
  url=$1
  name=$2
  wget "$url" -O /tmp/R-pkg-"$name".tar.gz
  R CMD INSTALL /tmp/R-pkg-"$name".tar.gz
}


export R_HOME=$(R RHOME)
export R_INCLUDE="$R_HOME/../../include/R"
gem install rsruby -- --with-R-dir=$R_HOME --with-R-include=$R_INCLUDE

echo 'install.packages("Rserve", repos="http://www.rforge.net/")' | R --vanilla --quiet
gem install rserve-client

#R_install_packages 'Rcpp'
#R_CMD_install 'https://cran.r-project.org/src/contrib/Archive/plyr/plyr_1.8.1.tar.gz' plyr

#R_install_packages 'MASS' 'nnet'
#R_CMD_install 'https://cran.r-project.org/src/contrib/Archive/car/car_2.0-22.tar.gz' car

R_install_packages 'tidyverse'

R_install_packages 'RJSONIO' 'XML' 'digest' 'gtable' 'reshape2' 'scales' 'proto'
#R_CMD_install 'https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_1.0.0.tar.gz' ggplot2

R_install_packages 'BiocManager'
R_biocLite Biobase

R_install_packages NMF Cairo drc gridSVG ggthemes mclust randomForest viper

R_install_packages pheatmap VennDiagram Hmisc pls gridSVG

R_install_packages UpSetR

R_biocLite limma viper

R_install_packages pROC txtplot

rm /tmp/R-pkg-*.tar.gz

