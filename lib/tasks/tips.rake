namespace :tips do

  desc "Socal"
  task :socal => :environment do
	  Rake::Task['load'].invoke
  end

  desc "Norcal"
  task :norcal => :environment do
  	Rake::Task['load'].invoke
  end

  desc "Load all tips."
  task :all => [:norcal, :socal]

  desc "Unload tips."
  task unload: :environment do
    Tip.delete_all
    puts "Tips unloaded."
  end
  
end #tips namespace