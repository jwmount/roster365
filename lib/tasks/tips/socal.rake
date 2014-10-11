desc "Socal"
task :load => :environment do
  puts "Loaded socal tips..."
  puts "#{Tip.count.to_s} Socal tips loaded."

end