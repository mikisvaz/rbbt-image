#!/bin/bash -x

# APP
# ---

for workflow in $WORKFLOWS; do
    rbbt workflow install $workflow 
done

export RBBT_WORKFLOW_AUTOINSTALL
export RBBT_LOG

for workflow in $BOOTSTRAP_WORKFLOWS; do
    rbbt workflow cmd $workflow bootstrap $BOOTSTRAP_CPUS
done
