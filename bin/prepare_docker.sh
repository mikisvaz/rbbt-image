#!/bin/bash

# Alpine
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep public.ecr.aws/docker/library/alpine:latest -dt rbbt-basic --base_system alpine_basic --do base_system,tokyocabinet,slurm_loopback
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-basic -dt rbbt-util --base_system alpine --do base_system,gems 
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-util -dt rbbt-python --base_system alpine_extended --do functions,base_system,python,java
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-python -dt rbbt-full --base_system alpine_extended --do functions,base_system,R,java

# Ubuntu
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep ubuntu:mantic -dt rbbt-ubuntu --base_system ubuntu_basic --do base_system,tokyocabinet,slurm_loopback,gems,R,python_custom,python

# Workflows
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-basic -dt rbbt-variantconsensus --do user -w VariantConsensus  -rr Organism,DbSNP,Appris,Genomes1000,COSMIC -s rbbt.bsc.es
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep ubuntu:mantic -dt rbbt-syntheticrdna --base_system ubuntu_basic --do base_system,tokyocabinet,slurm_loopback,user -w SyntheticRDNA --gems priority_queue_cxx17
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-ubuntu -dt rbbt-predig --do user -w PredIG
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-ubuntu -dt rbbt-fujitsuproteomics --do user -w FujitsuProteomics
