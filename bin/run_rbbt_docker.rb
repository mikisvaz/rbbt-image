#!/usr/bin/env ruby

require 'rbbt-util'
require 'rbbt/util/simpleopt'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

options = SOPT.setup <<EOF

Runs a docker image from an infrastructure definition file

$ #{ $0 } [options] <infrastructure.yaml>

Infrastruture definition comes in YAML

-h--help Print this help

EOF
infrastructure_file = ARGV.shift

if options[:help] or infrastructure_file.nil?
  if defined? rbbt_usage
    rbbt_usage 
  else
    puts SOPT.usage
  end
  exit 0
end


infrastructure = YAML.load infrastructure_file

iii infrastructure

