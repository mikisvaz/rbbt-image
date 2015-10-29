#!/usr/bin/env ruby

require 'rbbt-util'
require 'rbbt/util/simpleopt'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

options = SOPT.setup <<EOF

Runs a docker image from an infrastructure definition file

$ #{ $0 } [options] <infrastructure.yaml> <command> <args> -- <extra docker options>

Infrastruture definition comes in YAML

-h--help Print this help
--log* Log level

EOF

Log.severity = options[:log].to_i if options[:log]

module Log
  def self.log(msg,level)
    msg = "" if msg.nil?
    puts msg
  end
end

infrastructure_file, cmd, *args = ARGV


if options[:help] or infrastructure_file.nil?
  if defined? rbbt_usage
    rbbt_usage 
  else
    puts SOPT.usage
  end
  exit 0
end

cmd_args = []
while args[0] != '--'
  cmd_args << args.shift
end

docker_args = args[1..-1]

cmd_args.collect!{|a| '"' << a << '"' }
docker_args.collect!{|a| '"' << a << '"' }

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
      FileUtils.mkdir_p source unless File.directory? source
      FileUtils.chmod 0777, source
      mount_conf << " -v #{File.expand_path(source)}:#{target}"
    end
  end
end

if infrastructure[:workflow_autoinstall] and infrastructure[:workflow_autoinstall].to_s == 'true' and cmd =~ /rbbt/
  cmd = "env RBBT_WORKFLOW_AUTOINSTALL=true " + cmd
end

cmd_str = "docker run #{mount_conf} #{user_conf} #{docker_args*" "} #{image} /bin/bash --login -c '#{cmd} #{cmd_args*" "}"
cmd_str += " --log #{Log.severity} " if cmd =~  / rbbt$/
cmd_str += "'" 

Log.info "Docker: \n" << cmd_str
io = CMD.cmd(cmd_str, :pipe => true, :log => true, :stderr => 0)

while line = io.gets
  puts line
end

