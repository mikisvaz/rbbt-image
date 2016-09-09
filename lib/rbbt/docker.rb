module RbbtDocker
  def self.load_infrastructure(infrastructure, cmd, cmd_args = [], docker_args = [], options = {})
    cmd_args.collect!{|a| '"' << a << '"' }
    docker_args.collect!{|a| '"' << a << '"' }


    IndiferentHash.setup(infrastructure)

    image = infrastructure[:image]

    if user = infrastructure[:user]
      user_conf = "-u #{user} -e HOME=/home/#{user}/ -e USER=#{user}"
      user_conf = "-e HOME=/home/#{user}/ -e USER=#{user}"
    else
      user_conf = ""
    end

    mount_conf = ""
    seen_mounts = {}
    if infrastructure[:mounts]
      infrastructure[:mounts].each do |target,source|
        target = target.gsub("USER", user) if target.include? "USER"
        if source.nil? or source.empty?
          mount_conf << " --volumes-from #{target}"
        else
          matches = seen_mounts.select{|starget,ssource| Misc.path_relative_to starget, target }

          if matches.any?
            matches.each do |starget,ssource|
              subdir = Misc.path_relative_to starget, target
              dir = File.join(ssource, File.dirname(subdir))
              if not File.directory? dir
                FileUtils.mkdir_p dir 
                FileUtils.chmod_R 0777, File.join(ssource,subdir.split("/").first)
              end
            end

          end

          if not File.directory? source
            FileUtils.mkdir_p source 
            FileUtils.chmod 0777, source
          end
          seen_mounts[target] = source
          mount_conf << " -v #{File.expand_path(source)}:#{target}"
        end
      end
    end

    if infrastructure[:workflow_autoinstall] and infrastructure[:workflow_autoinstall].to_s == 'true' and cmd =~ /rbbt/
      cmd = "env RBBT_WORKFLOW_AUTOINSTALL=true " + cmd
    end

    umask = infrastructure[:umask] ? 'umask 000; ' : ''
    name_conf = options[:name]
    name_conf = "--name " << name_conf if name_conf
    name_conf ||= ""

    container_command = "#{umask}#{cmd} #{cmd_args*" "}"
    container_command += " --log #{Log.severity} " if cmd =~  /\brbbt$/

    cmd_str = "docker run #{name_conf} #{mount_conf} #{user_conf} #{(docker_args - ["--"])*" "} #{Log.color(:green, image)} /bin/bash --login -c '#{Log.color :green, container_command}'"

    if options[:docker_dry_run]
      puts Log.color(:magenta, "#Docker CMD:") <<  "\n" << cmd_str << "\n"
    else
      Log.debug Log.color(:magenta, "#Docker CMD:") <<  "\n" << cmd_str << "\n\n"
    end

    exec(Log.uncolor(cmd_str)) unless options[:docker_dry_run]
  end
end
