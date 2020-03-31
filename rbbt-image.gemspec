# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: rbbt-image 0.1.37 ruby lib

Gem::Specification.new do |s|
  s.name = "rbbt-image".freeze
  s.version = "0.1.37"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Miguel Vazquez".freeze]
  s.date = "2020-03-31"
  s.description = "Builds provision files for docker and Vagrant and helps run them".freeze
  s.email = "miguel.vazquez@cnio.es".freeze
  s.executables = ["build_rbbt_provision_sh.rb".freeze, "run_rbbt_docker.rb".freeze]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Dockerfile",
    "Vagrantfile",
    "lib/rbbt/docker.rb",
    "share/provision_scripts/Dockerfile.R-packages",
    "share/provision_scripts/R_packages.sh",
    "share/provision_scripts/R_setup.sh",
    "share/provision_scripts/bootstrap.sh",
    "share/provision_scripts/gem_setup.sh",
    "share/provision_scripts/hacks.sh",
    "share/provision_scripts/perl_setup.sh",
    "share/provision_scripts/python_setup.sh",
    "share/provision_scripts/ruby_setup.sh",
    "share/provision_scripts/tokyocabinet_setup.sh",
    "share/provision_scripts/ubuntu_setup.sh",
    "share/provision_scripts/user_setup.sh",
    "share/provision_scripts/variables.sh"
  ]
  s.homepage = "http://github.com/mikisvaz/rbbt-image".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Build docker and Vagrant (VM) images".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rbbt-util>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rbbt-util>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rbbt-util>.freeze, [">= 0"])
  end
end

