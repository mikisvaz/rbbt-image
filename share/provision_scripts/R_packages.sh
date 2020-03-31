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
  echo "install.packages(c($pkgs), repos='http://cran.us.r-project.org')" | R --vanilla
}

function R_biocLite(){
  pkgs="'$1'"
  shift
  for p in $@; do
    echo "source('http://bioconductor.org/biocLite.R'); biocLite('$p')" | R --vanilla
  done
}

function R_CMD_install(){
  url=$1
  name=$2
  wget "$url" -O /tmp/R-pkg-"$name".tar.gz
  R CMD INSTALL /tmp/R-pkg-"$name".tar.gz
}

R_install_packages Rcpp RJSONIO XML
R_CMD_install 'https://cran.r-project.org/src/contrib/Archive/plyr/plyr_1.8.1.tar.gz' plyr
R_CMD_install 'https://cran.r-project.org/src/contrib/Archive/car/car_2.0-22.tar.gz' car
R_install_packages 'digest' 'gtable' 'reshape2' 'scales' 'proto'

R_CMD_install 'https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_1.0.0.tar.gz' ggplot2

R_install_packages NMF Cairo drc Rserve gridSVG ggthemes mclust randomForest viper
R_install_packages pheatmap VennDiagram Hmisc pls gridSVG
R_install_packages tidyverse

R_biocLite limma viper

R_install_packages pROC txtplot

rm /tmp/R-pkg-*.tar.gz
