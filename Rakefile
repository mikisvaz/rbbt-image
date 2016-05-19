require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rbbt-image"
    gem.summary = %Q{Build docker and Vagrant (VM) images}
    gem.description = %Q{Builds provision files for docker and Vagrant and helps run them}
    gem.email = "miguel.vazquez@cnio.es"
    gem.homepage = "http://github.com/mikisvaz/rbbt-image"
    gem.authors = ["Miguel Vazquez"]
    gem.files = Dir['lib/.keep', 'share/provision_scripts/*', 'LICENSE']
    gem.executables = ['build_rbbt_provision_sh.rb', 'run_rbbt_docker.rb']
    gem.test_files = Dir['test/**/test_*.rb']

    
    gem.add_dependency('rbbt-util')
    gem.license = "MIT"
  end
  Jeweler::GemcutterTasks.new  
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test
