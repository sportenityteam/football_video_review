require 'rubygems'
require 'rufus/scheduler'

# to start scheduler
scheduler = Rufus::Scheduler.new

if Rails.env.downcase == "production"
  #Run rake jobs for ppaperclip style and transcoder
  scheduler.every "1m" do
    Rails.logger.warn "---------------------Production Mode-------------"
    `bin/delayed_job stop RAILS_ENV=production`
    `bin/delayed_job start --exit-on-complete RAILS_ENV=production`
  end

else
  scheduler.every "1m" do
    Rails.logger.warn "---------------------Development Mode-------------"
    `bin/delayed_job stop`
    `bin/delayed_job start --exit-on-complete`
  end
  Rails.logger.warn "---------------------Development Mode-------------"
end

