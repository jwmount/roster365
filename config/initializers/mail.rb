# FIXME -- mail.rb: Not setup for Ninefold, thinks it's all Heroku	
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  #:domain         => 'heroku.com' 
  :domain         => 'ninefold.apps.com'
}
ActionMailer::Base.delivery_method = :smtp
