#!/bin/bash -x

# USER RBBT BOOTSTRAP
# ===================

for workflow in $WORKFLOWS; do
    rbbt workflow install $workflow 
done

export RBBT_WORKFLOW_AUTOINSTALL=true
export RBBT_LOG

for workflow in $BOOTSTRAP_WORKFLOWS; do
    echo "Bootstrapping $workflow on $BOOTSTRAP_CPUS CPUs"
    [ -d $HOME/.rbbt/tmp/ ] || mkdir -p $HOME/.rbbt/tmp/
    rbbt workflow cmd $workflow bootstrap --cpus $BOOTSTRAP_CPUS &> $HOME/.rbbt/tmp/${workflow}.bootstrap.log
done
