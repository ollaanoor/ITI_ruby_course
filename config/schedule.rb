# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron.log"
set :environment, "development"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# This cron job runs every 5 minutes to delete articles with 6 or more reports.  
every 5.minutes do
    # rake "articles:remove_reported"
    command %Q{cd #{path} && RAILS_ENV=#{environment} /home/olla/.rbenv/shims/bundle exec rake articles:remove_reported >> log/cron.log 2>&1}
end