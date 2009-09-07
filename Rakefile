require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

PLUGIN_ROOT = File.dirname(__FILE__)

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "easy_mailer"
    gem.summary = %Q{Makes using ActionMailer suck less.}
    gem.description = File.read('DESCRIPTION.txt')
    gem.email = "george.ogata@gmail.com"
    gem.homepage = "http://github.com/oggy/easy_mailer"
    gem.authors = ["George Ogata"]
    gem.add_development_dependency "rspec", '= 1.2.8'
    gem.add_development_dependency "mocha", '= 0.9.7'
    gem.add_dependency "actionmailer"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

desc 'Generate documentation for the easy_mailer plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "EasyMailer #{version}"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Spec::Rake::SpecTask.new(:spec => :check_dependencies) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', "\"#{PLUGIN_ROOT}/spec/spec.opts\""]
end

namespace :spec do
  desc "Run integration specs."
  task :integration do
    sh "rm -rf spec_integration/tmp"
    begin
      # We need to keep the files outside of spec/, since otherwise
      # the other spec tasks will pick up the spec files inside the
      # test application.
      sh [
        "ROOT=\"#{PLUGIN_ROOT}\" rails --quiet --template spec_integration/application_template.rb spec_integration/tmp",
        "cd spec_integration/tmp",
        "rake spec:integration",
        "cd -",
        "rm -rf spec_integration/tmp"
      ].join(' && ')
    end
  end
end

desc "Run all specs in spec directory with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib' << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.spec_opts = ['--options', "\"#{PLUGIN_ROOT}/spec/spec.opts\""]
  t.rcov = true
  t.rcov_opts = lambda do
    IO.readlines("#{PLUGIN_ROOT}/spec/rcov.opts").map{|l| l.chomp.split " "}.flatten
  end
end

task :default => :spec
