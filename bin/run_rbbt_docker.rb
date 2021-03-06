#!/usr/bin/env ruby

require 'rbbt-util'
require 'rbbt/util/simpleopt'
require 'rbbt/docker'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

options = SOPT.setup <<EOF

Runs a docker image from an infrastructure definition file

$ #{ $0 } [<options>] <infrastructure.yaml> <command> <args> [-- <extra docker options>]

Infrastruture definition comes in YAML. Note that the options listed here will
be consumed and thus not passed to the container command, with the exception of
'--log' which applies to both. To get help from the container command use '-ch'
or '--chelp' which will append the '--help' options to the container command.
The other options have been named to avoid clashes.

-h--help Print this help
-ch--chelp Print help on the container command 
--log* Log level (both this command and the container command)
--docker_dry_run Dry run. Just output docker command line
--container_name* Container name
--extra_mounts* Extra mounts separated by ','
EOF


Log.severity = options[:log].to_i if options[:log]

module Log
  def self.log(msg,level)
    msg = "" if msg.nil?
    puts msg if level >= Log.severity
  end
end

infrastructure_file, cmd, *args = ARGV


if options[:help] or infrastructure_file.nil?
  puts SOPT.doc
  puts
  puts Log.color(:magenta, "## Example infrastructure.yaml")
  puts Rbbt.example["infrastructure.yaml"].read
  if options[:help]
    exit 0
  else
    exit -1
  end
end

cmd_args = []
while args.any? and args[0] != '--'
  cmd_args << args.shift
end

if options[:chelp]
  cmd_args << '--help'
end

docker_args = args[1..-1] || []

if not File.exists? infrastructure_file
  name = infrastructure_file
  infrastructure_file = Rbbt.root.etc.infrastructure[name+'.yaml'].find
  if not File.exists? infrastructure_file
    docker_dir = Path.setup("~/Docker").find
    infrastructure_file = docker_dir.infrastructure[name + '.yaml'].find
    raise "Not found: #{name}" unless infrastructure_file.exists?
    directory = docker_dir[name].find
    FileUtils.mkdir_p directory unless File.directory? directory
    FileUtils.cd directory 
  end
end

infrastructure = File.open(infrastructure_file){|io| YAML.load io }

IndiferentHash.setup(infrastructure)

if options[:extra_mounts]
  options[:extra_mounts].split(',').each do |pair|
    target, _sep, source = pair.partition(":")
    mounts = infrastructure[:mounts] || {}
    mounts[target] = source
    infrastructure[:mounts] = mounts
  end
end

RbbtDocker.load_infrastructure(infrastructure, cmd, cmd_args, docker_args, options)
