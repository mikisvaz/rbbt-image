#!/usr/bin/env ruby

require 'rbbt-util'
require 'rbbt/util/simpleopt'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

options = SOPT.setup <<EOF

Runs a docker image from an infrastructure definition file

$ #{ $0 } [options] <infrastructure.yaml> <command> <args>

Infrastruture definition comes in YAML

-h--help Print this help

EOF
infrastructure_file, cmd, *cmd_args = ARGV

cmd_args.collect!{|a| "'" << a << "'" }

if options[:help] or infrastructure_file.nil?
  if defined? rbbt_usage
    rbbt_usage 
  else
    puts SOPT.usage
  end
  exit 0
end


infrastructure = File.open(infrastructure_file){|io| YAML.load io }
IndiferentHash.setup(infrastructure)

image = infrastructure[:image]

if user = infrastructure[:user]
  user_conf = "-u #{user} -e HOME=/home/#{user}/ "
else
  user_conf = ""
end

mount_conf = ""
if infrastructure[:mounts]
  infrastructure[:mounts].each do |target,source|
    target = target.gsub("USER", user)
    if source.nil? or source.empty?
      mount_conf << " -v #{target}"
    else
      mount_conf << " -v #{File.expand_path(source)}:#{target}"
    end
  end
end

if infrastructure[:workflow_autoinstall] and infrastructure[:workflow_autoinstall].to_s == 'true'
  cmd = "env RBBT_WORKFLOW_AUTOINSTALL=true " + cmd
end

cmd_str = "docker run #{mount_conf} #{user_conf} #{image} #{cmd} #{cmd_args*" "} "
Log.info "Running docker: \n" << cmd_str
Log.severity = 0
io = CMD.cmd(cmd_str, :pipe => true, :log => true, :stderr => 0)

while line = io.gets
  puts line
end

