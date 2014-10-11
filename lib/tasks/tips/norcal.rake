#
# T I P  S I T E S
#

desc "Norcal"
task :load => :environment do

  [
    [ "ABC Tip", 1, 10.00, 'High'],
    [ "Marin Recycling Center", 2, 15.00, 'None'],
    [ "XYC Tip", 2, 15.00, 'Low']
  ].each do |t|
    Tip.create!( :name => t[0], :company_id => t[1], :fee => t[2], :fire_ant_risk_level => t[3]  )
  end
  
  puts "#{Tip.count.to_s} Norcal tips loaded."

  
end