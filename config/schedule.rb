rails_env = ENV["RAILS_ENV"] || :development
set :environment, rails_env
set :output, "log/crontab.log"

every 1.day, at: "0:00 am" do
  runner "SavePageViewsJob.perform_now"
end
