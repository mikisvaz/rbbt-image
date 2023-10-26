#!/bin/bash -x

# INSTALL
# =======

# R packages
# ----------

R_install_packages(){
  pkgs="'$1'"
  shift
  for p in $@; do
    pkgs="$pkgs, '$p'"
  done
  echo "install.packages(c($pkgs), repos='http://cran.us.r-project.org')" | R --vanilla --quiet
}

R_biocLite(){
  pkgs="'$1'"
  shift
  for p in $@; do
    echo "BiocManager::install(c('$p'))" | R --vanilla --quiet
  done
}

R_CMD_install(){
  url=$1
  name=$2
  wget "$url" -O /tmp/R-pkg-"$name".tar.gz
  R CMD INSTALL /tmp/R-pkg-"$name".tar.gz
}

R_install_packages 'tidyverse'

R_install_packages 'RJSONIO' 'XML' 'digest' 'gtable' 'reshape2' 'scales' 'proto'

R_install_packages 'BiocManager'
R_biocLite Biobase

R_install_packages NMF Cairo drc gridSVG ggthemes mclust randomForest viper

R_install_packages pheatmap VennDiagram Hmisc pls gridSVG

R_install_packages UpSetR

R_biocLite limma viper

R_install_packages pROC txtplot

rm /tmp/R-pkg-*.tar.gz

