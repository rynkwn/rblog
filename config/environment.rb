# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Informs ActionMailer that I want to use the SMTP server.
# SMTP stands for Simple Mail Transfer Protocol. see
# http://www.serversmtp.com/en/what-is-smtp-server.
# Heroku Mailing Service: https://devcenter.heroku.com/articles/smtp
# https://addons.heroku.com/postmark?utm_campaign=category&utm_medium=dashboard&utm_source=addons#10k
# Above is a link to Postmark, which seems more than adequate for my purposes.
#ActionMailer::Base.delivery_method = :smtp

# Don't believe the above is necessary with my decision to use Postmark.