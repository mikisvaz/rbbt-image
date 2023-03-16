#!/bin/bash -x

test -z $RBBT_SERVER               && export RBBT_SERVER=http://rbbt.bsc.es/
test -z $RBBT_FILE_SERVER          && export RBBT_FILE_SERVER="$RBBT_SERVER"
test -z $RBBT_WORKFLOW_SERVER      && export RBBT_WORKFLOW_SERVER="$RBBT_SERVER"

test -z $REMOTE_RESOURCES          && export REMOTE_RESOURCES="Organism ICGC COSMIC KEGG InterPro Signor"
test -z $REMOTE_WORFLOWS           && export REMOTE_WORFLOWS=""

test -z $RBBT_WORKFLOW_AUTOINSTALL && export RBBT_WORKFLOW_AUTOINSTALL="true"

test -z $WORKFLOWS                 && export WORKFLOWS=""

test -z $BOOTSTRAP_WORKFLOWS       && export BOOTSTRAP_WORKFLOWS=""
test -z $BOOTSTRAP_CPUS            && export BOOTSTRAP_CPUS="2"

test -z $RBBT_LOG                  && export RBBT_LOG="LOW"
