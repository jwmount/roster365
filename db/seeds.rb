# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Works best with rake db:reset
#
#require 'debugger'

roles_list = %w[ admin bookeeper driver guest management operations sales superadmin ]
roles_list.each do |role|
  Role.create!(name: role)
end

# Create users (roles not implemented yet, MUST be chosen from roles_list)
user_list = [
  ['admin@venuesoftware.com', 'roster365', 1],
  ['bookeeper@venuesoftware.com', 'bookeeper', 2],
  ['driver@venuesoftware.com', 'driver', 3],
  ['guest@venuesoftware.com', 'roster365', 4],
  ['manager@venuesoftware.com', 'manager', 5],
  ['dispatcher@venuesoftware.com', "dispatcher", 6],
  ['Sales@venuesoftware.com', 'roster365', 7],
  ['john@venuesoftware.com', 'roster365', 8]
  ]
user_list.each do |email, password, role|  
  AdminUser.create!( email: email, password: password, password_confirmation: password, role_id: role)
  Rails::logger.info( "*-*-*-*-* Created user #{email}, pswd: #{password.slice(0..2)}, role: #{role}" )
end



#
# W R A P U P
#
puts "\n\nLICENSEE: \t#{@licensee}"
puts "Addresses:    \t#{Address.count.to_s}"
puts "Certificates: \t#{Certificate.count.to_s}"
puts "Cert:         \t#{Cert.count.to_s}"
puts "Companies:    \t#{Company.count.to_s}"
puts "Conditions:   \t#{Condition.count.to_s}"
puts "Dockets:      \t#{Docket.count.to_s}"
puts "Engagements:  \t#{Engagement.count.to_s}"
puts "Equipment:    \t#{Equipment.count.to_s}"
puts "Identifiers:  \t#{Identifier.count.to_s}"
puts "Jobs:         \t#{Job.count.to_s}"
puts "People:       \t#{Person.count.to_s}"
puts "Projects:     \t#{Project.count.to_s}"
puts "Quotes:       \t#{Quote.count.to_s}"
puts "Roles:        \t#{Role.count.to_s}"
puts "Schedules:    \t#{Schedule.count.to_s}"
puts "Solutions:    \t#{Solution.count.to_s}"
puts "Tips:         \t#{Tip.count.to_s}"
puts "Users:        \t#{AdminUser.count.to_s}"
puts "\n\n --Done"
