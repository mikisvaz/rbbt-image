#!/bin/bash -x

# USER RBBT BOOTSTRAP
# ===================

export RBBT_WORKFLOW_AUTOINSTALL=true
export RBBT_LOG=0
#export PIP_TARGET="/usr/local/python"

rbbt log DEBUG
for workflow in $BOOTSTRAP_WORKFLOWS; do
    rbbt workflow install $workflow 

    pip_requirements_file=$(rbbt_find.rb -w $workflow requirements.pip --nocolor)
    test -z $pip_requirements_file || pip install -r $pip_requirements_file || pip install --break-system-packages -r $pip_requirements_file
    unset pip_requirements_file

    pip_requirements_file2=$(rbbt_find.rb -w $workflow requirements.pip2 --nocolor)
    test -z $pip_requirements_file2 || pip install -r $pip_requirements_file2 || pip install --break-system-packages -r $pip_requirements_file2
    unset pip_requirements_file2

    pip_requirements_file3=$(rbbt_find.rb -w $workflow requirements.pip3 --nocolor)
    test -z $pip_requirements_file3 || pip install -r $pip_requirements_file3 || pip install --break-system-packages -r $pip_requirements_file3
    unset pip_requirements_file3

    gemfile_file=$(rbbt_find.rb -w $workflow Gemfile --nocolor)
    test -z $gemfile_file || (cd $(dirname $gemfile_file); bundle install)
done

for workflow in $BOOTSTRAP_WORKFLOWS; do
    echo "Bootstrapping $workflow on $BOOTSTRAP_CPUS CPUs"
    test -d $HOME/.rbbt/tmp/ || mkdir -p $HOME/.rbbt/tmp/
    rbbt workflow example $workflow --config_keys "cpus $BOOTSTRAP_CPUS bootstrap" > $HOME/.rbbt/tmp/${workflow}.examples.log
    rbbt workflow cmd $workflow bootstrap --config_keys "cpus $BOOTSTRAP_CPUS bootstrap" > $HOME/.rbbt/tmp/${workflow}.bootstrap.log
done
