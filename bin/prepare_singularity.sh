#!/bin/bash

export SINGULARITY_TMPDIR=/bulk/img/singularity/rbbt/.build-tmp/

#rm rbbt-basic.sif
#rm rbbt-util.sif
#rm rbbt-python.sif
#rm rbbt-full.sif

# Alpine
test -f rbbt-basic.sif || build_rbbt_provision_sh.rb --dep alpine -si rbbt-basic.sif --base_system alpine_basic --do base_system,tokyocabinet,slurm_loopback
test -f rbbt-util.sif || build_rbbt_provision_sh.rb --dep rbbt-basic.sif -si rbbt-util.sif --base_system alpine --do base_system,gem 
test -f rbbt-python.sif || build_rbbt_provision_sh.rb --dep rbbt-util.sif -si rbbt-python.sif --base_system alpine_extended --do functions,base_system,python,java
test -f rbbt-full.sif || build_rbbt_provision_sh.rb --dep rbbt-python.sif -si rbbt-full.sif --base_system alpine_extended --do functions,base_system,R,java

# Ubuntu
test -f rbbt-ubuntu.sif || build_rbbt_provision_sh.rb --dep ubuntu:latest -si rbbt-ubuntu.sif --base_system ubuntu_basic --do base_system,tokyocabinet,slurm_loopback,gems,R,python_custom,python
