#!/usr/bin/env ruby

require 'rbbt-util'
require 'rbbt/util/simpleopt'
require 'rbbt/docker'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

options = SOPT.setup <<EOF

Runs a docker image from an infrastructure definition file

$ #{ $0 } [<options>] <infrastructure.yaml> <command> <args> [-- <extra docker options>]

Infrastruture definition comes in YAML. 

-h--help Print this help
--log* Log level
-d--dry_run Dry run
-n--name* Container name
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
  if false and defined? rbbt_usage
    rbbt_usage 
    puts Log.color :magenta, "##Example infrastructure.yaml"
    puts DATA.read
  else
    puts SOPT.doc
    puts
    puts Log.color(:magenta, "##Example infrastructure.yaml")
    puts DATA.read
  end
  exit 0
end

cmd_args = []
while args.any? and args[0] != '--'
  cmd_args << args.shift
end

docker_args = args[1..-1] || []

cmd_args.collect!{|a| '"' << a << '"' }

infrastructure_file = Rbbt.etc.infrastructure[infrastructure_file+'.yaml'].find unless File.exists? infrastructure_file
infrastructure = File.open(infrastructure_file){|io| YAML.load io }

RbbtDocker.load_infrastructure(infrastructure, cmd, cmd_args, docker_args, options)

#docker_args.collect!{|a| '"' << a << '"' }
#
#infrastructure = File.open(infrastructure_file){|io| YAML.load io }
#IndiferentHash.setup(infrastructure)
#
#image = infrastructure[:image]
#
#if user = infrastructure[:user]
#  user_conf = "-u #{user} -e HOME=/home/#{user}/ -e USER=#{user}"
#  user_conf = "-e HOME=/home/#{user}/ -e USER=#{user}"
#else
#  user_conf = ""
#end
#
#mount_conf = ""
#seen_mounts = {}
#if infrastructure[:mounts]
#  infrastructure[:mounts].each do |target,source|
#    target = target.gsub("USER", user) if target.include? "USER"
#    if source.nil? or source.empty?
#      mount_conf << " -v #{target}"
#    else
#      matches = seen_mounts.select{|starget,ssource| Misc.path_relative_to starget, target }
#
#      if matches.any?
#        matches.each do |starget,ssource|
#          subdir = Misc.path_relative_to starget, target
#          dir = File.join(ssource, File.dirname(subdir))
#          if not File.directory? dir
#            FileUtils.mkdir_p dir 
#            FileUtils.chmod 0777, dir
#          end
#        end
#
#      end
#
#      if not File.directory? source
#        FileUtils.mkdir_p source 
#        FileUtils.chmod 0777, source
#      end
#      seen_mounts[target] = source
#      mount_conf << " -v #{File.expand_path(source)}:#{target}"
#    end
#  end
#end
#
#if infrastructure[:workflow_autoinstall] and infrastructure[:workflow_autoinstall].to_s == 'true' and cmd =~ /rbbt/
#  cmd = "env RBBT_WORKFLOW_AUTOINSTALL=true " + cmd
#end
#
#umask = infrastructure[:umask] ? 'umask 000; ' : ''
#cmd_str = "docker run #{mount_conf} #{user_conf} #{docker_args*" "} #{image} /bin/bash --login -c '#{umask}#{cmd} #{cmd_args*" "}"
#cmd_str += " --log #{Log.severity} " if cmd =~  /\brbbt$/
#cmd_str += "'" 
#
#Log.info "Docker: \n" << cmd_str
#exec(cmd_str) unless options[:dry_run]

__END__
image: mikisvaz/rbbt-basic
user: rbbt
umask: true
workflow_autoinstall: true
mounts:
    /home/USER/.rbbt/: ./.rbbt
    /home/USER/.rbbt/share/databases: /data3/rbbt/share/databases
    /home/USER/.rbbt/share/organisms: /data3/rbbt/share/organisms
    /home/USER/.rbbt/var/dbNSFP: /data3/rbbt/var/dbNSFP
    /home/USER/.rbbt/var/DbSNP: /data3/rbbt/var/DbSNP
