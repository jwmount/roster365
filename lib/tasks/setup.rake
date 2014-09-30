require 'rake'

namespace :setup do

  desc "Create California"
  task :California => :environment do
    puts "California loaded"
  end

  desc "Setup Conditions"
  task :conditions => :environment do
  	puts Condition.all.inspect
    puts "Done.  #{Condition.count} conditions."
  end

  desc "Setup Customers"
  task companies: :environment do
  	puts "Customers"
  	co = Company.new( name: "Smalzz Bros.", url: "www.wsj.com" )
  	co.save
  	co.errors.each{|e|p e}
  	puts Company.all.inspect
  	puts "Done.  #{Company.count} companies."
  end

  desc "Setup Equipment"
  task equipment: :environment do
  end

  desc "Setup People"
  task people: :environment do
  end

  desc "Setup Projects"
  task projects: :environment do
  end

  
end
