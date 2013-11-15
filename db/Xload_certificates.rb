
# load_certificates.rb

# Compliance
# Person
# Company
# Equipment
certificate_list = [
  [ 'Commercial Driving License', 'Initialized default, Must be verified.', true, false, false, true ],
  [ 'ISO 9000', 'May be required.', false, true, false, true ],
  [ 'Insurance', 'Must be current & Must be verified.', false, false, true, true ]
]
certificate_list.each do |name, description, for_person, for_company, for_equipment, active |
  Certificate.create!( name: name, description: description, for_person: for_person, for_company: for_company, 
                       for_equipment: for_equipment, active: active )
  certificate = Certificate.where(name: name)
  case 
    when certificate[0].for_person
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Person', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
    when certificate[0].for_company     
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Company', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
    when certificate[0].for_equipment
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Equipment', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
  end
end
