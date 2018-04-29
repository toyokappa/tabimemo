current_path = "/var/www/tabimemo/current"
shared_path = "/var/www/tabimemo/shared"
working_directory current_path
worker_process = 2
timeout = 30

# logs
stderr_path File.expand_path("log/unicorn_stderr.log", shared_path)
stdout_path File.expand_path("log/unicorn_stdout.log", shared_path)

listen File.expand_path("tmp/sockets/.unicorn.sock", shared_path)
pid File.expand_path("tmp/pids/unicorn.pid", shared_path)

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  ENV["BUNDLE_GEMFILE"] = File.expand_path("Gemfile", current_path)
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
