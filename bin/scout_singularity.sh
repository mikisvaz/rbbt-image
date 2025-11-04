#!/bin/bash
build_rbbt_provision_sh.rb  -si scout-basic.sif -bs alpine -dep alpine --do functions,base_system,tokyocabinet,custom_gem -g scout-gear,scout-ai,scout-camp,sinatra,rack,puma,slim,haml,sass,kramdown,listen -sp npm --sudo
