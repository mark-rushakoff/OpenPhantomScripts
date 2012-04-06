#!/usr/bin/env rake

require 'rubygems'
require 'bundler'
Bundler.require
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.verbose = true
end

def start_server
  require 'spec_helper'
  OpsHelper::start_server_once
end

task :start_server_and_run_specs do
  start_server
  Rake::Task['spec'].execute
end

task :default => :start_server_and_run_specs
