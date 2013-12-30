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

# load certificates
# name, description, for_person, for_company, for_equipment, for_location, active
certificate_list = [
  [ 'Commercial Driving License', 'Initialized default, Must be verified.', true, false, false, false, true ],
  [ 'ISO 9000', 'May be required.', false, true, false, false, true ],
  [ 'Insurance', 'Must be current & Must be verified.', false, false, true, true, true ],
  [ 'CA DOT', 'As displayed.', false, false, true, false, false ],
  [ 'US DOT', 'As displayed.', false, false, true, false, false ],
  [ 'Registration', 'License plate or rego.', false, false, true, false, false ],
  [ 'VIN', 'By inspection.', false, false, true, false, false ],
  [ 'Aluminum body', '', false, false, true, false, false ],
  [ 'Mud flaps', '', false, false, true, false, false ],
  [ 'Green Flag', "No toxic or bad stuff", false, false, false, false, true ]
]
certificate_list.each do |name, description, for_person, for_company, for_equipment, for_location, active |
  Certificate.create!( name: name, description: description, for_person: for_person, for_company: for_company, 
                       for_equipment: for_equipment, for_location: for_location, active: active )
  certificate = Certificate.where(name: name)
  case 
    when certificate[0].for_person
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Person', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
    when certificate[0].for_company     
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Company', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
    when certificate[0].for_equipment
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Equipment', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
    when certificate[0].for_location
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Place', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
  end
end

#
# D I R E C T O R Y   C O M P A N I E S
# 
# Format here works well for company listings in Directories.   
# Array of hashes, each contains four hashes "company", "address", "person", and "identifier".
# First company is our licensee, this admittedly fragile rule, is/was? used next to determine this status.
# Note:  hash values cannot be duplicates so cannot have two "Identifiers" for example.
#
companies_list = [
  { "company"    => { name: "#{LICENSEE}", line_of_business: "Farm Transport, Software Licensee", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "American Debris Box Service Inc.", line_of_business: "Containers delivered and removed", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Lawson Drayage, Inc.", line_of_business: "Cartage, Local Houl Freight Carrying Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Waste Management, Inc.", line_of_business: "Waste Disposal & Removal Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Reliable Crane & Rigging", line_of_business: "Carting, Hoist Service & Rental, Machinery Moving & Erecting Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Foothill Disposal Co. Inc.", line_of_business: "Cartage Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "BWRS", line_of_business: "Debris box, compactors, recycling", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Pleasanton Garbage Serivice, Inc.", line_of_business: "Waste Transport Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Dillard Trucking, Inc.", line_of_business: "Hazardous Waste Transport", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Blue Line Transfer", line_of_business: "Cartage, waste removal & recycling service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Gan-Tran Ltd.", line_of_business: "Cartage Services", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Precision Crane Service", line_of_business: "Crane & Freight Carrier Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "East Bay Sanitary Co., Inc.", line_of_business: "Cartage, Waste Disposal & Removing Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Vallejo Garbage Service", line_of_business: "Cartages Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Fred Haines & Company", line_of_business: "Cartage Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Specialty Solid Waste & Recycling", line_of_business: "Waste Handling, Cartage, Waste Disposal Service", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Tight Access Excavation", line_of_business: "Residential - Commercial", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Hazel Construction", line_of_business: "Residential Construction", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "TMT Industries", line_of_business: "Residential Construction", url: ""},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
# East Bay Book of Lists
  { "company"    => { name: "O.C. Jones & Sons Inc.", line_of_business:  "Heavy civil construction", url: "www.ocjones.com" },
    "address"    => { street_address: "1520 Fourth St.", city: "Berkeley", state: "CA", post_code: "94710" },
    "person"     => { first_name: "Kelly", last_name: "Kolander", title: "CEO" },
    "identifier" => { name: "Main Company", value: "510 526-3424", rank: 1 }
  },
  { "company"    => { name: "Bay Cities Paving & Grading Inc.", line_of_business:   "General engineering, heavy construction", url: "NR"},
    "address"    => { street_address: "5029 Forni Drive", city: "Concord", state: "CA", post_code: "94520" },
    "person"     => { first_name: "Ben", last_name: "Rodrigues Jr", title: "President" },
    "identifier" => { name: "Main Company", value: "925 687-6666", rank: 1 }
  },
  { "company"    => { name: "S&S Supplies and Solutions", line_of_business: "Industrial supplies and services", url: "www.supliesandsolutions.com"},
    "address"    => { street_address: "501 Shell Ave", city: "Martinez", state: "CA", post_code: "94553"},
    "person"     => { first_name: "Tracy", last_name: "Tomkovicz", title: "CEO" },
    "identifier" => { name: "Main Company", value: "925 687-6666", rank: 1 }
  },
  { "company"    => { name: "McGuire and Hester", line_of_business: "Heavy civi engineering and construction services", url: "www.mandhcorp.com"},
    "address"    => { street_address: "9009 Railroad Ave.", city: "San Ramon", state: "CA", post_code: "94583"},
    "person"     => { first_name: "Michael", last_name: "Hester", title: "President"},
    "identifier" => { name: "email", value: "pres@mandhcorp.com", rank: 1}
  },
  { "company"    => { name: "Shames Construction Co. Ltd.", line_of_business: "Commercial general contractor", url: "www.shames.com"},
    "address"    => { street_address: "5826 Brisa St.", city: "Livermore", state: "CA", post_code: "94550"},
    "person"     => { first_name: "Carolyn", last_name: "Shames", title: "President and CEO"},
    "identifier" => { name: "Main Number", value: "925 606-3000"}
  },
  { "company"    => { name: "James E. Roberts - Obayashi Corp.", line_of_business: "General construction", url: "www.robertsobayashi.com"},
    "address"    => { street_address: "20 Oak Court", city: "Danville", state: "CA", post_code: "94526"},
    "person"     => { first_name: "Scott", last_name: "Smith"},
    "identifier" => { name: "Main Number", value: "925 820-0600"}
    },
  { "company"    => { name: "Engineering/Remediation Resources Group Inc.", line_of_business: "Environmental construction and engineering", url: "www.errg.com"},
    "address"    => { street_address: "4585 Pacheco Blvd., Suite 200", city: "Martinez", state: "CA", post_code: "94553"},
    "person"     => { first_name: "Cynthia", last_name: "Liu"},
    "identifier" => { name: "Main Number", value: "925 969-0750"}
  },
  { "company"    => { name: "Paradigm General Contractors", line_of_business: "General contractor", url: "www.paradigmgc.com"},
    "address"    => { street_address: "1017 MaxDonald Ave.", city: "Richmod", state: "CA", post_code: "94801"},
    "person"     => { first_name: "Karla", last_name: "Deshon"},
    "identifier" => { name: "Main Number", value: "510-478-1121"}
  }
]

companies_list.each do |company| 
  @company = Company.create!( company["company"] )
  @company.addresses.create!( company["address"] )
  @company.people.create!( company["person"] )
  @company.identifiers.create!( company["identifier"] )
end

=begin
# Two RISKY values are used here, Project.rep_id and Quote.quote_to_id both set to 1
project_list = [
  'Project One', 'Project Two', 'Project Three'
]

project_list.each do |name|
  Project.create!( name: name, company_id: @company_1.id, 
                   rep_id: 1,
                   project_start_on: Date.today, 
                   active: false
                 )   
  project_relation = Project.where( name: name)
  @project = project_relation[0]

  10.times do 
    Quote.create!( project_id: @project.id, quote_to_id: 1, rep_id: 1, fire_ants_verified_by: 'No One' )
  end
end
=end

#
# Material types  
#
[
  "Clean Fill",
  "Clean Compactable Fill",
  "General Fill",
  "Shale",
  "Clay Fill",
  "Spoil",
  "Unsuitable Rocky Fill",
  "Unsuitable Clay Fill",
  "Unsuitable Fill",
  "Unsuitable Spoil",
  "Unsuitable Material",
  "Top Soil ",
  "Screened Top Soil",
  "Unscreened Top Soil",
  "Clay Topsoil",
  "Mulch Fine",
  "Mulch Coarse",
  "Mulch Dirty",
  "Green Waste",
  "Green Waste Tree Stumps, Palms or Root Balls",
  "C&D Waste",
  "C&D Waste 20%  and under Concrete",
  "C&D Waste 21% and over Concrete",
  "Timber ",
  "Steel ",
  "Rubbish",
  "Clean Concrete",
  "Dirty Concrete",
  "Concrete Light Grade",
  "Concrete Heavy Grade",
  "Contaminated Soil",
  "Contaminated Soil Heavy Metals",
  "Contaminated Soil Petroleum ",
  "Asbestos contaminated Soil",
  "Asbestos ",
  "Acid Sulphate Fill",
  "Acid Sulphate Fill Over Optimum",
  "Lime Treated Acid Sulphate Fill",
  "Sand",
  "Clean Sand Free of contaminates",
  "Coarse Sand",
  "Fine Sand",
  "White Sand",
  "Washed Sand",
  "Beach Sand",
  "Coal stone",
  "Over Optimum Fill",
  "Over Burden",
  "CBR 0 to 4 Material",
  "CBR 5 to 8 Material",
  "CBR 8 to 10 Material",
  "CBR 10+ Material",
  "CBR 15+ Material",
  "CBR 20+ Material",
  "CBR 30+ Material",
  "CBR 40+ Material",
  "Select Fill",
  "Select Fill ( Unscreened Deco)",
  "Select Fill ( Screened Deco)",
  "Select Fill ( Sandstone Product)",
  "Select Fill ( Coal Stone)",
  "Bitumen",
  "Cold Mix Asphalt",
  "Hot Mix Asphalt",
  "Road Base",
  "Crusher Dust, Concrete",
  "5mm Crushed Concrete",
  "10mm Crushed Concrete",
  "20mm Crushed Concrete",
  "40mm Crushed Concrete",
  "70mm Crushed Concrete",
  "Crusher Dust",
  "5mm Crushed Rock",
  "10mm Crushed Rock",
  "20mm Crushed Rock",
  "40mm Crushed Rock",
  "70mm Crushed Rock",
  "150mm Crushed Rock",
  "300mm Minus Crushed Rock",
  "Shot Rock",
  "Large Rock, Boulders",
  "2.5 Gravel ",
  "2.3 Gravel,CBR 45",
  "2.1 Gravel, CBR 80",
  "Potable Water",
  "Non Potable Water",
  "Recycled Water",
  "Indurated Sand",
  "Rock Institute",
  "As Directed",
  "Sandy Fill"
].each do |name|
  material = Material.create!( name: name)
end

# Conditions
# Fire Ants verbiage text is composed at run time.
[
 [
   "Fire Ants",
   "If fire ants are present this quote includes that cost.",
   "Required"
 ],
 [
   "Client Signature",
   "Note:  A REPRESENTATIVE FROM CLIENT CONTRACTORS IS REQUIRED TO SIGN ALL INVOICES.",
   "Required"
 ],
 [
   "Standard Contract Terms for Load Cart and Dispose",
   "Load, Cart and Dispose Conditions: 9 hr working day. Minimum delays on site to facilitate quick entry and exit. Should delays occur due to no fault of the subcontractor, the charge will revert to current hourly hire rates. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually. The Client agrees to provide exclusive access to the total volume of materials on site as quoted above. The Client is responsible for all supervision, direction and project management on the site. Roster365 (AUST) Pty Ltd will provide a 20-30T Excavator to load only, under the supervision and direction of the Client or their authorised representative. The client agrees to indemnify Roster365 (AUST) Pty Ltd from any damage claims in respect to injury of person/s or damage to property and/or utilities resultant from all excavation and cartage works provided. The client is responsible for all sediment control, traffic control & dust suppression as required. All material rates are quoted in loose cubic meters or tons. All quotes are subject to material acceptance by Import Site. All prices are based on statutory legal loads. Material to be in accordance with EPA/DPI guidelines. Quotation is valid for 30 days.",
   "Load, Cart and Dispose"
 ],
 [
   "Standard Contract Terms for Export",
   "9 hr working day. Minimum delays on site to facilitate quick entry, loading (minimum 20 ton excavator loading) and exit. Should delays occur due to no fault of the subcontractor, the charge will revert to current hourly hire rates. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually. The quoted price is based on a maximum of five (5) minutes to load each Tandem, Truck & Trailer or Semi Tipper. All material rates are quoted in loose cubic meters or tonnes. All quotes are subject to material acceptance by Import Site. All prices are based on statutory legal loads. Material to be in accordance with EPA/DPI guidelines. Quotation is valid for 30 days.",
   "Export"
 ],
 [
   "Standard Contract Terms for Import",
   "Import Conditions: 9 hr working day. Minimum delays on site to facilitate quick entry, unloading and exit. Should delays occur due to no fault of the subcontractor, the charge will revert to current hourly hire rates. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually. The quoted price is based on a maximum of five (5) minutes to unload each Tandem, Truck & Trailer or Semi Tipper. All material rates quoted in loose cubic meters or tonnes. All prices are based on statutory legal loads. Material to be in accordance with EPA & DPI guidelines. Quotation is valid for 30 days.",
   "Import"
 ],
 [
   "Standard Contract Terms for Cart Only",
   "Cart Only Conditions: 9 hr working day. Minimum delays on site to facilitate quick entry, loading (minimum 20 tonne excavator loading), unloading and exit. Should delays occur due to no fault of the subcontractor, the charge will revert to current hourly hire rates. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually. The quoted price is based on a maximum of five (5) minutes to load & unload each Tandem, Truck & Trailer or Semi Tipper. Material quantity quoted in loose cubic meters or tonnes. All prices are based on statutory legal loads. Material to be in accordance with EPA &DPI guidelines. Quotation is valid for 30 days.",
   "Cart Only"
 ],
 [
   "Budget Price Only",
   "This price has been prepared using current market options and conditions. The price, options and conditions may differ at the time of works.",
   "Budget Price"
 ],
 [
   "Hourly Hire",
   "Minimum 4 hours. 2 hour cancellation fee. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually.  All prices are based on statutory legal loads. Minimum of half an hour travel time will be charged on all trucks supplied. Night works will incur additional 20% surcharge. Material to be in accordance with EPA/DPI guidelines. Quotation is valid for 30 days.",
   "Hourly Hire"
 ],
 [
   "Machine Hire - Wet",
   "Machine Wet Hire Conditions: Minimum 4 hours. 2 hour cancellation fee. Any subsequent charges e.g. float fees, establishment costs etc will be charged individually. Night works will incur additional 20% surcharge. Material to be in accordance with EPA & DPI guidelines. Quotation is valid for 30 days. A two way float applies to machine hire 4 days and under. Ground engaging Tools (ripper boots, cutting edges etc) will be charged individually.",
   "Machine Hire - Wet"
 ],
 [
   "Machine Hire - Dry, Uninsured",
   "Maximum of 40hrs per week. The Hirer is responsible for theft, loss and damage to plant and its attached tools and accessories whilst on hire and the costs of replacement or repairs to such will be charged to the Hirer. No damage waiver insurance has been taken out by hirer with any damage costs to be paid by hirer. Stand down rates do not apply to Dry Hire unless agreed in writing. Float Fees, Tolls etc will be charged individually. A two way float applies to machine hire 4 days and under. Ground engaging Tools (ripper boots, cutting edges etc) will be charged individually.",
   "Machine Hire - Dry, Uninsured"
 ],
 [
   "Machine Hire - Dry, Insured",
   "Machine Dry Hire Conditions: Maximum of 40hrs per week.  Stand down rates do not apply to Dry Hire unless agreed in writing. Float Fees, Tolls etc will be charged individually. The Supplier offers protection against damage or malicious damage by third parties. This waiver is in the form of a 12% Surcharge on the invoiced hire. An Excess of $600.00 per item or 12% of quoted price, whichever is the higher will apply. This Property Damage Waiver does not cover Burglary or Theft of the Equipment. The Hirer is responsible for theft, loss and damage to plant and its attached tools and accessories whilst on hire and the costs of replacement or repairs to such will be charged to the Hirer. A two way float applies to machine hire 4 days and under. Ground engaging Tools (ripper boots, cutting edges etc) will be charged individually.",
   "Machine Hire - Dry, Insured"
 ],
 [
   "Free Tip - Private Customers",
   "Conditions: Material is to be supplied and placed as directed, at the time of tipping, by the property owner or their representative. If no representative is available, all effort will be made to ensure material is placed and spread in a previously designated, and owner directed, area. roster365 has been requested to arrange supply of material to the above address by the property owner or their representative. roster365 does not take responsibility for material tipped by others. The property owner confirms that this project has the relevant Government or Council approvals. ",
   "Free Tip - Private Customers"
 ],
 [
   "COD, Credit Card Accounts",
   "Credit Card Conditions: A 2% credit card surcharge applies to payments made by Visa or Mastercard. Roster365 does not accept American Express, Diners Club or Bankcard payments.",
   "COD, Credit Card Accounts"
 ],
].each do |condition|
  Condition.create!(:name => condition[0], :verbiage => condition[1], :indication => condition[2], change_approved_at: Date.today)
end

#
# T I P  S I T E S
#
[
  [ "ABC Tip", 1, 10.00, 'High'],
  [ "Marin Recycling Center", 2, 15.00, 'None'],
  [ "XYC Tip", 2, 15.00, 'Low']
].each do |t|
  Tip.create!( :name => t[0], :company_id => t[1], :fee => t[2], :fire_ant_risk_level => t[3]  )
end

