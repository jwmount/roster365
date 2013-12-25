# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Roster365::Application.initialize!

=begin
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'ninefold.apps.com'
}
ActionMailer::Base.delivery_method = :smtp
=end