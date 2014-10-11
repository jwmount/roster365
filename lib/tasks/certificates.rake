namespace :certificates do

  desc "county"
  task :county => :environment do
  	Rake::Task['load'].invoke
  end

  desc "federal"
  task :federal => :environment do
    Rake::Task['load'].invoke
  end

  desc "muni"
  task :muni => :environment do
    Rake::Task['load'].invoke
  end

  desc "state"
  task :state => :environment do
  	Rake::Task['load'].invoke
  end

  desc "Load all certificates."
  task :all => [:county, :muni, :federal, :state]

  desc "Unload certificates"
  task unload: :environment do
    Certificate.delete_all
    puts "Certificates unloaded."
  end

end #namespace

