#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :


require 'rbbt-util'
require 'rbbt/util/simpleopt'
require 'rbbt/util/cmd'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

orig_argv = ARGV.dup

options = SOPT.setup <<EOF

Build a provision script

$ #{$0} [options]

-h--help Print this help
-u--user* System user to bootstrap
-w--workflow* Workflows to bootstrap (has defaults specify 'none' to avoid them)
-s--server* Main Rbbt remote server (file-server and workflow server)
-fs--file_server* Rbbt remote file server
-ws--workflow_server* Rbbt remote workflow server
-rr--remote_resources* Remote resources to gather from file-server
-rw--remote_workflows* Remote workflows server from workflow-server
-ss--skip_base_system Skip base system installation
-st--skip_tokyocabinet Skip tokyocabinet setup installation
-sr--skip_ruby Skip ruby setup installation
-sg--skip_gem Skip ruby gem installation
-su--skip_user_setup Skip user setup
-sb--skip_bootstrap Skip user bootstrap
-Rc--R_custom Install a custom installation of R
-Rp--R_packages Install basic R packages
-c--concurrent Prepare system for high-concurrency
-Rbv--ruby_version* Ruby version to use, using three numbers (defaults to 2.4.2)
-op--optimize Optimize files under ~/.rbbt
-dt--docker* Build docker image using the provided name
-df--docker_file* Use a Dockerfile different than the default
-dd--docker_dependency* Use a different image in the Dockerfile FROM
-si--singularity* Build singularity image using the provided name
-v--volumnes* List of volumes to set-up
--nocolor Prevent rbbt from using colors and control sequences in the logs while provisioning
--nobar Prevent rbbt from using progress bars while provisioning
EOF

if options[:help]
  if defined? rbbt_usage
    rbbt_usage and exit 0 
  else
    puts SOPT.doc
    exit
  end
end

root_dir = File.dirname(File.dirname(File.expand_path(__FILE__)))
script_dir = File.join(root_dir, "share/provision_scripts/")

if options[:singularity]
  options[:skip_user_setup] = true
  options[:skip_bootstrap] = true
end

USER = options[:user] || 'rbbt'
SKIP_BASE_SYSTEM = options[:skip_base_system]
SKIP_TOKYOCABINET= options[:skip_tokyocabinet]
SKIP_RUBY = options[:skip_ruby]
R_CUSTOM = options[:R_custom]
SKIP_BOOT = options[:skip_bootstrap]
SKIP_USER = options[:skip_user_setup]
SKIP_GEM = options[:skip_gem]
OPTIMIZE = options[:optimize]

VARIABLES={
 :RBBT_LOG => 0,
 :BOOTSTRAP_WORKFLOWS => (options[:workflow] || "Enrichment Translation Sequence MutationEnrichment").split(/[\s,]+/)*" ",
 :REMOTE_RESOURCES => (options[:remote_resources] || "KEGG").split(/[\s,]+/)*" "
}

VARIABLES[:BOOTSTRAP_WORKFLOWS] = "" if VARIABLES[:BOOTSTRAP_WORKFLOWS] == 'none'

VARIABLES[:RBBT_NO_LOCKFILE_ID] = "true" if options[:concurrent]
VARIABLES[:RBBT_SERVER] = options[:server] if options[:server]
VARIABLES[:RBBT_FILE_SERVER] = options[:file_server] if options[:file_server]
VARIABLES[:RBBT_WORKFLOW_SERVER] = options[:workflow_server] if options[:workflow_server]
VARIABLES[:REMOTE_WORKFLOWS] = options[:remote_workflows].split(/[\s,]+/)*" " if options[:remote_workflows]
VARIABLES[:RBBT_NOCOLOR] = "true" if options[:nocolor]
VARIABLES[:RBBT_NO_PROGRESS] = "true" if options[:nobar]

options[:ruby_version] ||= "2.4.2"


provision_script =<<-EOF
#!/bin/bash -x

echo "RUNNING PROVISION"
echo
echo "CMD: #{File.basename($0) + " " + orig_argv.collect{|a| a =~ /\s/ ? "\'#{a}\'" : a }.join(" ")}"
echo
echo -n "Starting: "
date

EOF

provision_script +=<<-EOF
echo "1. Provisioning base system"
#{
if not SKIP_BASE_SYSTEM
  File.read(script_dir + 'ubuntu_setup.sh') 
else
  "echo SKIPPED\necho"
end 
}

#{
if not SKIP_BASE_SYSTEM and R_CUSTOM
  "echo 1.1 Setting custom R"
  File.read(script_dir + 'R_setup.sh') 
end 
}

echo "2. Setting up tokyocabinet"
#{
if not SKIP_TOKYOCABINET
  File.read(script_dir + 'tokyocabinet_setup.sh')
else
  "echo SKIPPED\necho"
end
}

echo "3. Setting up ruby"
#{
if not SKIP_RUBY
  "export RUBY_VERSION='#{options[:ruby_version]}'\n" << File.read(script_dir + 'ruby_setup.sh') 
else
  "echo SKIPPED\necho"
end 
}

echo "3.1. Setting up gems"
#{
if not SKIP_GEM
  File.read(script_dir + 'gem_setup.sh') 
else
  "echo SKIPPED\necho"
end 
}

EOF

provision_script +=<<-EOF
echo "4. Configuring user"
EOF

if not SKIP_USER
  provision_script +=<<-EOF
####################
# USER CONFIGURATION

if [[ '#{ USER }' == 'root' ]] ; then
  home_dir='/root'
else
  useradd -ms /bin/bash #{USER}
  home_dir='/home/#{USER}'
fi

user_script=$home_dir/.rbbt/bin/config_user
mkdir -p $(dirname $user_script)
chown -R #{USER} /home/#{USER}/.rbbt/


# set user configuration script
cat > $user_script <<'EUSER'

. /etc/profile

echo "4.1. Loading custom variables"
#{
  VARIABLES.collect do |variable,value|
    "export " << ([variable,'"' << value.to_s << '"'] * "=")
  end * "\n"
}

echo "4.2. Loading default variables"
#{File.read(script_dir + 'variables.sh')}

echo "4.3. Configuring rbbt"
#{File.read(script_dir + 'user_setup.sh')}
EUSER

echo "4.4. Running user configuration as '#{USER}'"
chown #{USER} $user_script;
su -l -c "bash $user_script" #{USER}

  EOF
else
  provision_script += "echo SKIPPED\necho\n\n"
end

provision_script +=<<-EOF
echo "5. Bootstrapping workflows as '#{USER}'"
echo
EOF

if not SKIP_BOOT
  provision_script +=<<-EOF

if [[ '#{ USER }' == 'root' ]] ; then
  home_dir='/root'
else
  home_dir='/home/#{USER}'
fi

user_script=$home_dir/.rbbt/bin/bootstrap

cat > $user_script <<'EUSER'

. /etc/profile

echo "5.1. Loading custom variables"
#{
  VARIABLES.collect do |variable,value|
    "export " << ([variable,'"' << value.to_s << '"'] * "=")
  end * "\n"
}

echo "5.2. Loading default variables"
#{File.read(script_dir + 'variables.sh')}

echo "5.3. Configuring rbbt"
#{File.read(script_dir + 'user_setup.sh')}
#
echo "5.4. Install and bootstrap"
#{File.read(script_dir + "bootstrap.sh")}
EUSER

chown #{USER} $user_script;
su -l -c "bash $user_script" #{USER}

  EOF
else
  provision_script += "echo SKIPPED\necho\n\n"
end

provision_script +=<<-EOF
# CODA
# ====

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man /usr/local/share/ri

#{ "su -l -c 'rbbt system optimize /home/#{USER}/.rbbt ' #{USER}" if OPTIMIZE}

echo
echo "Installation done."
date

EOF

docker_dependency = options[:docker_dependency]

if options[:docker]
  dockerfile = options[:dockerfile] || File.join(root_dir, 'Dockerfile')
  dockerfile_text = Open.read(dockerfile)
  dockerfile_text.sub!(/^FROM.*/,'FROM ' + docker_dependency) if docker_dependency
  dockerfile_text.sub!(/^USER rbbt/,'USER ' + USER) if USER != 'rbbt'
  dockerfile_text.sub!(/^ENV HOME \/home\/rbbt/,'ENV HOME /home/' + USER) if USER != 'rbbt'
  if options[:volumnes]
    volumnes = options[:volumnes].split(/\s*[,|]\s*/).collect{|d| "VOLUME " << d} * "\n"
    dockerfile_text.sub!(/^RUN/, volumnes + "\nRUN")
  end
  if options[:R_packages]
    dockerfile_text.sub!(/^(# END PROVISION)/, '\1' + "\n" + Open.read(File.join(script_dir, 'Dockerfile.R-packages')) + "\n" )
  end
  TmpFile.with_file(nil, false) do |dir|
    FileUtils.mkdir_p dir
    Path.setup(dir)
    Open.write(dir["Dockerfile"].find, dockerfile_text)
    Open.write(dir['provision.sh'], provision_script)

    puts "RUN"
    puts "==="
    puts "docker build -t #{options[:docker]} '#{dir}'"
    io = CMD.cmd("docker build -t #{options[:docker]} '#{dir}'", :pipe => true, :log => true)
    while line = io.gets
      puts line
    end
  end
else
  puts provision_script
end

if singularity_image = options[:singularity]
  docker_dep = options[:docker_dependency] || 'ubuntu'

  TmpFile.with_file(nil, false) do |dir|
    Path.setup(dir)

    provision_file = dir['provision.sh']

    bootstrap_text=<<-EOF
Bootstrap: docker
From: #{docker_dep}

%post
  cat > /tmp/rbbt_provision.sh <<"EOS"
  #{provision_script}
EOS
  bash /tmp/rbbt_provision.sh
EOF
    FileUtils.mkdir_p dir
    Open.write(dir["singularity_bootstrap"].find, bootstrap_text)
    Open.write(provision_file, provision_script)

    puts "RUN"
    puts "==="
    cmd_create =  "singularity create -s 2048 #{singularity_image}"
    cmd_boot =  "singularity bootstrap #{singularity_image} '#{dir["singularity_bootstrap"]}'"
    puts cmd_create
    io = CMD.cmd(cmd_create, :pipe => true, :log => true)
    while line = io.gets
      puts line
    end

    puts cmd_boot
    io = CMD.cmd(cmd_boot, :pipe => true, :log => true)
    while line = io.gets
      puts line
    end
  end

end

