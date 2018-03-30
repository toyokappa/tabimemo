# This file is used by Rack-based servers to start the application.

# Unicorn worker killer setting
if ENV["RAILS_ENV"] != "development"
  require "unicorn/worker_killer"
  use Unicorn::WorkerKiller::MaxRequests, 3072, 4096
  use Unicorn::WorkerKiller::Oom, (250*(1024**2)), (300*(1024**2)), 16

  require ::File.expand_path('../config/environment',  __FILE__)
  run Rails.application
end

require_relative "config/environment"

run Rails.application
