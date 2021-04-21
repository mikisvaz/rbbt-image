#!/bin/bash -x

# USER RBBT BOOTSTRAP
# ===================

for workflow in $BOOTSTRAP_WORKFLOWS; do
    rbbt workflow install $workflow 
done

export RBBT_WORKFLOW_AUTOINSTALL=true
export RBBT_LOG=0

for workflow in $BOOTSTRAP_WORKFLOWS; do
    echo "Bootstrapping $workflow on $BOOTSTRAP_CPUS CPUs"
    [ -d $HOME/.rbbt/tmp/ ] || mkdir -p $HOME/.rbbt/tmp/
    rbbt workflow cmd $workflow bootstrap --config_keys "cpus $BOOTSTRAP_CPUS bootstrap" > $HOME/.rbbt/tmp/${workflow}.bootstrap.log
done
