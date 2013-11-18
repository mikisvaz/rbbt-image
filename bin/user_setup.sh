#!/bin/bash -x

# GENERAL
# -------

# File servers: to speed up the production of some resources
for resource in $REMOTE_RESOURCES; do
    echo "Adding remote file server: $resource -- $RBBT_FILE_SERVER"
    rbbt file_server add $resource $RBBT_FILE_SERVER
done

# Remote workflows: avoid costly cache generation
for workflow in $REMOTE_WORKFLOWS; do
    echo "Adding remote workflow: $workflow -- $RBBT_WORKFLOW_SERVER"
    rbbt workflow remote add $workflow $RBBT_WORKFLOW_SERVER
done
