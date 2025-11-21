#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :


require 'rbbt-util'
require 'rbbt/util/simpleopt'
require 'rbbt/util/cmd'

$0 = "rbbt #{$previous_commands*""} #{ File.basename(__FILE__) }" if $previous_commands

orig_argv = ARGV.dup

all_steps = %w(functions base_system tokyocabinet ruby_custom gem custom_gems
java R_custom R R_packages perl_custom python_custom python user slurm_loopback
hacks micromamba miniconda3 conda)

options = SOPT.setup <<EOF

Build a provision script

$ #{$0} [options]

This is the list of steps you can 'do': #{all_steps*", "}

-h--help Print this help
-u--user* System user to bootstrap
-w--workflow* Workflows to bootstrap (has defaults specify 'none' to avoid them)
-lw--local_workflows* Workflows to copy from local
-s--server* Main Rbbt remote server (file-server and workflow server)
-fs--file_server* Rbbt remote file server
-ws--workflow_server* Rbbt remote workflow server
-rr--remote_resources* Remote resources to gather from file-server
-rw--remote_workflows* Remote workflows server from workflow-server
-bs--base_system* Version of base system initialization script to use (default: ubuntu)
-Rbv--ruby_version* Ruby version to use, using three numbers (defaults to 2.4.1)
-d--do* List of steps to do
-nd--not_do* List of steps to not do
-op--optimize Optimize files under ~/.rbbt
-dep--container_dependency* Use a different image in Dockerfile, Singularity and Virtualbox
-dt--docker* Build docker image using the provided name
-si--singularity* Build singularity image using the provided name
-sis--singularity_size* Singularity image size (default 2024)
-sd--sudo Use sudo to run singularity container
-vb--virtualbox Build virtualbox image
-df--docker_file* Use a Dockerfile different than the default
-dv--docker_volumnes* List of volumes to set-up in Docker
--nocolor Prevent rbbt from using colors and control sequences in the logs while provisioning
--nobar Prevent rbbt from using progress bars while provisioning
-g--gems* Custom gems to install
-p--pip* Custom pip packages to install
-c--conda* Custom conda packages to install
-sp--system_packages* Custom system packages
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

#if options[:singularity]
#  options[:skip_user_setup] = true
#  options[:skip_bootstrap] = true
#end

do_steps = options.include?("do")? options[:do].split(",") : all_steps
not_do_steps = options.include?(:not_do)? options[:not_do].split(",") : all_steps - do_steps

do_steps << 'base_system' if options[:base_system]
do_steps << 'user' if options[:workflow]

OPTIMIZE    = options[:optimize] 
USER        = options[:user] || 'rbbt'
CONTAINER_DEP = options[:container_dependency] ||  'ubuntu'
BASE_SYSTEM = options[:base_system] || CONTAINER_DEP

VARIABLES={
  :RBBT_LOG => 0,
  :BOOTSTRAP_WORKFLOWS => (options[:workflow] || "").split(/[\s,]+/)*" ",
  :REMOTE_RESOURCES => (options[:remote_resources] || "").split(/[\s,]+/)*" "
}

VARIABLES[:RBBT_SERVER] = options[:server] if options[:server]
VARIABLES[:RBBT_FILE_SERVER] = options[:file_server] if options[:file_server]
VARIABLES[:RBBT_WORKFLOW_SERVER] = options[:workflow_server] if options[:workflow_server]
VARIABLES[:REMOTE_WORKFLOWS] = options[:remote_workflows].split(/[\s,]+/)*" " if options[:remote_workflows]
VARIABLES[:RBBT_NOCOLOR] = "true" if options[:nocolor]
VARIABLES[:RBBT_NO_PROGRESS] = "true" if options[:nobar]

VARIABLES[:RUBY_VERSION] = options[:ruby_version] ||= "2.6.4"
VARIABLES[:CUSTOM_GEMS] = options[:gems]
VARIABLES[:CUSTOM_PIP] = options[:pip]
VARIABLES[:CUSTOM_CONDA] = options[:conda]
VARIABLES[:CUSTOM_SYSTEM_PACKAGES] = options[:system_packages]

do_steps << 'custom_gems' if options[:gems]

Log.debug 'Doing: ' + do_steps * ", "
Log.debug 'Not doing: ' + not_do_steps * ", "

provision_script =<<-EOF
#!/bin/bash -x

# PROVISION FILE
echo "CMD: #{File.basename($0) + " " + orig_argv.collect{|a| a =~ /\s/ ? "\'#{a}\'" : a }.join(" ")}"

test -f /etc/profile && . /etc/profile
test -f /etc/rbbt_environment && . /etc/rbbt_environment

#{
VARIABLES.collect do |variable,value|
  "export " << ([variable,'"' << value.to_s << '"'] * "=")
end * "\n"
}
EOF

all_steps.each_with_index do |step,i|
  if ! do_steps.include?(step)
    provision_script += "#" + "NOT DO #{step}\n"
    next
  end

  provision_script += "#" + "DO #{step}\n"
  provision_script += case step
                      when 'base_system'
                        File.read(script_dir + "#{BASE_SYSTEM}_setup.sh") 
                      when 'user'
                        user_script =<<~EOF
                          . /etc/profile
                          . /etc/rbbt_environment

                          echo "6.1. Loading custom variables"
                          #{
                          VARIABLES.collect do |variable,value|
                            "export " << ([variable,'"' << value.to_s << '"'] * "=")
                          end * "\n"
                          }

                          echo "6.2. Loading default variables"
                          #{File.read(script_dir + 'variables.sh')}

                          echo "6.3. Configuring rbbt"
                          #{File.read(script_dir + 'user.sh')}
                          
                          echo "6.4. Install and bootstrap"
                          #{File.read(script_dir + "bootstrap.sh")}
                          #
                          echo "6.5. Migrate shared files"
                          #{File.read(script_dir + "migrate.sh")}
                          
                          rm -Rf ~/.rbbt/tmp/
                        EOF

                        <<~EOF
                          if [[ '#{ USER }' == 'root' ]] ; then
                            home_dir='/root'
                          else
                            adduser --disabled-password --gecos "" #{USER}
                            #groupadd rbbt
                            #useradd -g rbbt -m -s /bin/bash rbbt

                            home_dir='/home/#{USER}'
                            chown -R #{USER} $home_dir/
                          fi

                          mkdir -p $home_dir/.rbbt/bin/
                          user_script=$home_dir/.rbbt/bin/bootstrap
                          chown -R #{USER} $home_dir/

                          for d in /usr/local/var/rbbt /usr/local/share/rbbt /usr/local/workflows/rbbt /usr/local/software/rbbt; do
                            mkdir -p $d
                            chgrp rbbt $d
                            chown rbbt $d
                            chmod g+w $d
                          done

                          cat > $user_script <<'EUSER'
                          #{user_script}
                          EUSER

                          chmod 777 -R /usr/local/
                          su -l -c "bash $user_script" #{USER}

                        EOF
                      else
                        File.read(script_dir + "#{step}.sh") 
                      end
end

if docker_image = options[:docker] 
  container_dependency = CONTAINER_DEP
  dockerfile = options[:dockerfile] || File.join(root_dir, 'Dockerfile')
  dockerfile_text = Open.read(dockerfile)
  dockerfile_text.sub!(/^FROM.*/,'FROM ' + container_dependency) if container_dependency
  dockerfile_text.sub!(/^USER rbbt/,'USER ' + USER) if USER != 'rbbt'
  dockerfile_text.sub!(/^ENV HOME \/home\/rbbt/,'ENV HOME /home/' + USER) if USER != 'rbbt'
  if options[:docker_volumnes]
    volumnes = options[:docker_volumnes].split(/\s*[,|]\s*/).collect{|d| "VOLUME " << d} * "\n"
    dockerfile_text.sub!(/^RUN/, volumnes + "\nRUN")
  end
  
  # NOTE: Not used like this now. Used in provision script
  #
  #if options[:R_packages]
  #  dockerfile_text.sub!(/^(# END PROVISION)/, '\1' + "\n" + Open.read(File.join(script_dir, 'Dockerfile.R-packages')) + "\n" )
  #end

  local_workflows = (options[:local_workflows] || "").split(",")
  TmpFile.with_file(nil, false) do |dir|
    FileUtils.mkdir_p dir
    Path.setup(dir)

    if local_workflows.any?
      dockerfile_lines = dockerfile_text.split("\n")

      run_line = dockerfile_lines.select{|line| line =~ /^RUN/ }.last
      dockerfile_lines.delete run_line

      local_workflows.each do |workflow|
        if File.exists?(workflow)
          workflow_dir = workflow
          workflow = File.basename workflow
        else
          workflow_dir = Path.setup("workflows/#{workflow}").find
        end
        next unless Open.exists?(workflow_dir)
        Open.cp workflow_dir, dir[workflow].find
        dockerfile_lines.push "COPY #{workflow} /usr/local/workflows/rbbt/#{workflow}"
      end

      dockerfile_lines.push run_line

      dockerfile_text = dockerfile_lines * "\n"
    end

    Open.write(dir["Dockerfile"].find, dockerfile_text)
    Open.write(dir['provision.sh'], provision_script)

    puts "RUN"
    puts "==="
    puts "docker build -t #{docker_image} '#{dir}'"
    io = CMD.cmd("docker build -t #{docker_image} '#{dir}'", :pipe => true, :log => true)
    while line = io.gets
      puts line
    end
  end
else
  puts provision_script
end

if singularity_image = options[:singularity]

  container_dependency = CONTAINER_DEP
  TmpFile.with_file(nil, false) do |dir|
    Path.setup(dir)

    provision_file = dir['provision.sh']

    if container_dependency.include? '.sif'
      bootstrap_text=<<-EOF
Bootstrap: localimage
From: #{container_dependency}
EOF
    else
      bootstrap_text=<<-EOF
Bootstrap: docker
From: #{container_dependency}
EOF
    end

    bootstrap_text+=<<-EOF
%post
  cat > /image_provision.sh <<"EOS"
  #{provision_script}
EOS
  sh -x /image_provision.sh 2>&1 | tee /image_provision.log
  bash -c '[ -f /.singularity.d/env/99-rbbt_environment.sh ] || ln -s /etc/rbbt_environment /.singularity.d/env/99-rbbt_environment.sh'
  chmod +x /.singularity.d/env/99-rbbt_environment.sh
  #bash -c '[ -d /home/#{USER}/.local/lib/ ] && (rsync -av /home/#{USER}/.local/lib/ /usr/lib/' && chmod 755 /usr/lib/python*/site-packages/ && chown -R root /usr/lib/python*/site-packages/ && rm /home/#{USER}/.local/lib/) || echo -n ""
  #bash -c '[ -d /usr/local/share ] || mkdir -p /usr/local/share' 
  #bash -c '[ -d /usr/local/share ] || mkdir -p /usr/local/share' 
  #bash -c '[ -d /usr/local/workflows ] || mkdir -p /usr/local/workflows' 
  #bash -c '[ -d /software/rbbt ] || mkdir -p /software/rbbt'
  #bash -c '[ -d /home/#{USER}/.rbbt/var/ ] && mv /home/#{USER}/.rbbt/var/ /var/rbbt' || echo -n ""
  #bash -c '[ -d /home/#{USER}/.rbbt/var/ ] && rm -Rf /home/#{USER}/.rbbt/var/' || echo -n ""
  #bash -c '[ -d /home/#{USER}/.rbbt/share/ ] && mv /home/#{USER}/.rbbt/share/ /usr/local/share/rbbt' || echo -n ""
  #bash -c '[ -d /home/#{USER}/.rbbt/workflows/ ] && mv /home/#{USER}/.rbbt/workflows/ /usr/local/workflows/rbbt' || echo -n ""
  #bash -c '[ -d /home/#{USER}/.rbbt/software/opt ] && mv /home/#{USER}/.rbbt/software/opt /software/rbbt/opt' || echo -n ""
  #bash -c '[ -d /home/#{USER}/.rbbt/software/src ] && mv /home/#{USER}/.rbbt/software/src /software/rbbt/src' || echo -n ""
  #bash -c '[ -d /home/#{USER}/.rbbt/software/scm ] && mv /home/#{USER}/.rbbt/software/scm /software/rbbt/scm' || echo -n ""
EOF
    FileUtils.mkdir_p dir
    Open.write(dir["singularity_bootstrap"].find, bootstrap_text)
    Open.write(provision_file, provision_script)

    singularity_size = options[:singularity_size] || 3072
    cmd_create =  "singularity create -s #{singularity_size} #{singularity_image}"
    cmd_boot =  "singularity build #{singularity_image} '#{dir["singularity_bootstrap"]}'"


    #puts "**************"
    #puts "CREATING IMAGE: #{dir["singularity_bootstrap"].find}"
    #puts "**************"
    #puts cmd_create
    #CMD.cmd_log(cmd_create, :log => 4)

    puts "**************"
    puts "BUILDING IMAGE: #{dir["singularity_bootstrap"].find}"
    puts "**************"
    puts cmd_boot
    CMD.cmd_log(cmd_boot, :log => 4, sudo: options[:sudo])
  end

end

if options[:virtualbox]
  container_dependency = CONTAINER_DEP
  TmpFile.with_file(nil, false) do |dir|
    Path.setup(dir)

    provision_file = dir['provision.sh']
    vagrant_file = dir['Vagrantfile']

    Open.write provision_file, provision_script
    Open.write vagrant_file, <<-EOF
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "#{container_dependency.sub(':','/')}64"

  config.vm.provision :shell, :path => "#{provision_file}"
  
  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true

     # Customize the amount of memory on the VM:
     vb.memory = "8192"
  end
end
    EOF

    Log.debug "Running vagrant on #{dir}"
    Misc.in_dir(dir) do
      CMD.cmd_log(:vagrant, "up")
    end
  end
end
