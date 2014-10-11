#
# C E R T I F I C A T E S
#

desc "load_muni: load local or municipal certificates"
task load: :environment do
  puts "loading municipal certificates..."

  # name, description, for_person, for_company, for_equipment, for_location, active
  [
    [ "Marin County Tax Stamp", 'Marin County, CA', false, false, true, false, true]
  ].each do |c|
    Certificate.create!( :name => c[0], :description => c[1], :for_person => c[2],
       :for_company => c[3], :for_equipment => c[4], :for_location => c[5], :active => c[6]  )
    certificate = Certificate.where(name: c[0])
    
    case 
   
      when certificate[0].for_person
        Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, 
                    certifiable_type: 'Person', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)

      when certificate[0].for_company     
        Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, 
                    certifiable_type: 'Company', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)

      when certificate[0].for_equipment
        Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, 
          certifiable_type: 'Equipment', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)

      when certificate[0].for_location
        Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, 
          certifiable_type: 'Place', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
    end #case

  end  #iterator
  puts "loaded county certificates..."
  puts "#{Certificate.count.to_s} Certificates loaded."

end #task
