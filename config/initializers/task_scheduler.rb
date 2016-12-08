require 'rubygems'
require 'rufus/scheduler'

# to start scheduler
scheduler = Rufus::Scheduler.new

if Rails.env.downcase == "production"
  #Run rake jobs for ppaperclip style and transcoder
  scheduler.every "1m" do
    Rails.logger.warn "---------------------Production Mode-------------"
    `rake jobs:workoff RAILS_ENV=production`
    `rake jobs:work RAILS_ENV=production`
  end

else
  Rails.logger.warn "---------------------Development Mode-------------"
end

