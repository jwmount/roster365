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
# T I P  S I T E S
#
[
  [ "ABC Tip", 1, 10.00, 'High'],
  [ "Marin Recycling Center", 2, 15.00, 'None'],
  [ "XYC Tip", 2, 15.00, 'Low']
].each do |t|
  Tip.create!( :name => t[0], :company_id => t[1], :fee => t[2], :fire_ant_risk_level => t[3]  )
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
# LICENSEE
  { "company"    => { name: "#{ENV['LICENSEE']}", line_of_business: "#{ENV['LICENSEE_LOB']}", url: "#{ENV['LICENSEE_URL']}"},
    "address"    => {},
    "person"     => { first_name: "Account", last_name: "Representative", title: "Rep"},
    "identifier" => { name: "Office", value: "415 555-1212"}
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
    "person"     => { first_name: "Ben", last_name: "Rodrigues Jr.", title: "President" },
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
    "address"    => { street_address: "1017 MacDonald Ave.", city: "Richmond", state: "CA", post_code: "94801"},
    "person"     => { first_name: "Karla", last_name: "Deshon"},
    "identifier" => { name: "Main Number", value: "510-478-1121"}
  }
]

companies_list.each do |model| 
  puts
  @company = Company.create!( model["company"] )
  @company.addresses.create!( model["address"] )
  @company.people.create!( model["person"] )
  @company.identifiers.create!( model["identifier"] )
  puts "#{model} -- CREATED"
end

#
# D E M O  P R O J E C T  A N D  D E P E N D E N T S
#
#  company
#    project
#      quote
#        solutions
#          jobs
#            schedules
#              engagements
#
@licensee = Company.where("name = ?", ["#{ENV['LICENSEE']}"] )
@rep = Person.where("company_id = ? AND title = ?", @licensee[0].id, "Rep")

demo_list = [
  { "company"    => { name: "Demo Company", line_of_business: "General resource contractor", url: "www.wsj.com"},
    "address"    => { street_address: "9 Alder Court", city: "Fairfax", state: "CA", post_code: "94935"},
    "person"     => { first_name: "Demo", last_name: "Demosthenes"},
    "identifier" => { name: "Main Number", value: "415-478-1121"},
    "equipment"  => { name: "Truck"},
    "project"    => { name: 'DemoProject', rep_id: @rep[0].id, project_start_on: Date.today},
    "projAddr"   => { street_address: "1017 MacDonald Ave.", city: "Richmond", state: "CA", post_code: "94801"},
    "quote"      => { name: "Q001", expected_start: Date.today + 1 },
    "solution"   => { name: "S01" },
    "job"        => { name: "JDemo", start_on: Date.today + 1, finished_on: Date.today + 2  },
    "schedule"   => { day: Date.today + 1 },
    "engagement" => {}
  }
]

demo_list.each do |model| 
  @company = Company.create!( model["company"] )
  @company.addresses.create!( model["address"] )
  @company.people.create!( model["person"] )
  @company.identifiers.create!( model["identifier"] )
  @company.equipment.create!( model["equipment"])
  @project = @company.projects.create!( model["project"])
  @project.addresses.create!( model["projAddr"])
  @projmgr = @company.people.first

  @quote = @project.quotes.new( model["quote"])
  @quote.quote_to_id = @projmgr.id
  @quote.rep_id = @rep[0].id
  @quote.expected_start = Date.today + 1
  @quote.fire_ants_verified_by = @rep[0].id
  @quote.save! 

  @solution = @quote.solutions.new( model ["solution"] )
  @solution.material_id = 1
  @solution.equipment_name = "Truck"
  @solution.save!

  @job = @solution.jobs.create!( model ["job"] )
  @schedule = @job.schedules.create!( model ["schedule"] )

  @engagement = @schedule.engagements.new( model ["engagement"] )
  @engagement.person_id = 1
  @engagement.save!

end

# Pick up personal identifiers not captured so far.  These people exist already.
personal_identifiers_list = [
  {first_name: "Kelly", last_name: "Kolander", name: "email", value: "pat@osisoft.com"},
  {first_name: "Ben", last_name: "Rodrigues Jr.", name: "email", value: "jpetersen@petersendean.com"},
  {first_name: "Michael", last_name: "Hester", name: "email", value: "pres@mandhcorp.com"},
  {first_name: "Cynthia", last_name: "Liu", name: "email", value: "cindy.liu@errg.com"},
  {first_name: "Karla", last_name: "Deshon", name: "email", value: "karla@paradigmgc.com"}
]
personal_identifiers_list.each do |model|
  puts
  @people = Person.where( "first_name = ? AND last_name = ?", model[:first_name], model[:last_name] )
  puts "*-*-*-*-* WARNING:  Person not found: #{model}" if @people.empty?
  @people.each do |person| 
    person.identifiers.create!( name: model[:name], value: model[:value], rank: person.identifiers.count + 1 )
    puts "#{@person} -- CREATED"
  end
end

#
# Construction Projects in the East Bay from Business Times Lists published December 6-12, 2013
# Equipment, employee names not known as not in BT List
#
projects_list = [
 { "company"     => { name: "McCarthy Building Cos. Inc.", line_of_business: "Construction", url: "www.mccarthy.com"},
    "address"    => { street_address: "343 Sansome St., 14th Floor", city: "San Francisco", state: "CA", post_code: "94104"},
    "identifier" => { name: "Main Number", value: "415 397-5151"},
    "project"    => { name: 'Kaiser Hospital Replacement Project Phase II', rep_id: @rep[0].id, project_start_on: "01-04-2010",
                      description: "879,000 square foot hospital and medical office building."},
    "projAddr"   => { street_address: "280 W. MacArthur Blvd.", city: "Oakland", state: "CA", post_code: "94611"}
  },
 { "company"     => { name: "Rudolph and Sletten Inc.", line_of_business: "Construction", url: "www.rsconstruction.com"},
    "address"    => { street_address: "1600 Seaport Blvd., Ste. 350", city: "Redwood City", state: "CA", post_code: "94063"},
    "identifier" => { name: "Main Number", value: "650 216-3600"},
    "project"    => { name: "Kaiser Permanente San Leandro Medical Center", rep_id: @rep[0].id, project_start_on: "01-01-2010",
                      description: "Hospital with 264 acute care beds."},
    "projAddr"   => { street_address: "1755 Fairway Drive", city: "San Leandro", state: "CA", post_code: "94577"}
  },
 { "company"     => { name: "Clark Construction Group - California LLP", line_of_business: "Construction", url: "www.clarkconstruction.com"},
    "address"    => { street_address: "7677 Oakport St., Ste. 1040", city: "Oakland", state: "CA", post_code: "94621"},
    "identifier" => { name: "Main Number", value: "510 430-6000"},
    "project"    => { name: "Highland Hospital - Alameda Country Medical Center", rep_id: @rep[0].id, project_start_on: "01-01-2010",
                      description: "169-bed acute care tower, 78,000-square-foot satellite building."},
    "projAddr"   => { street_address: "1411 E. 32st St.", city: "Oakland", state: "CA", post_code: "94602"}
  },
 { "company"     => { name: "Flatiron Construction Corp.", line_of_business: "Construction", url: "www.flatironcorp.com"},
    "address"    => { street_address: "2100 Goodyear Road", city: "Benicia", state: "CA", post_code: "94510"},
    "identifier" => { name: "Main Number", value: "707 742-6000"},
    "project"    => { name: "BART Oakland Airport Connector", rep_id: @rep[0].id, project_start_on: "11-11-2013",
                      description: "3.2 mile connection between Coliseum and airport."},
    "projAddr"   => { street_address: "1100 Airport Drive", city: "Oakland", state: "CA", post_code: "94621"}
  },
 { "company"     => { name: "Webcor Builders", line_of_business: "Construction", url: "www.webcor.com"},
    "address"    => { street_address: "207 King St., Ste. 300", city: "San Francisco", state: "CA", post_code: "94107"},
    "identifier" => { name: "Main Number", value: "415 978-1000"},
    "project"    => { name: "California Memorial Stadium Seismic Improvements", rep_id: @rep[0].id, project_start_on: "06-10-2013",
                      description: "Reconstruction and revovation of historic stadium"},
    "projAddr"   => { street_address: "Rimway Road and Canyon Road", city: "Berkeley", state: "CA", post_code: "94704"}
  },
 { "company"     => { name: "DPR Construction", line_of_business: "Construction", url: "www.dpr.com"},
    "address"    => { street_address: "1450-Veterans Blvd.", city: "Redwood City", state: "CA", post_code: "94063"},
    "identifier" => { name: "Main Number", value: "650 474-1450"},
    "project"    => { name: "Alta Bates Oakland Campus, Patient Care Pavilion", rep_id: @rep[0].id, project_start_on: "08-10-2013",
                      description: "250,000-square-foot, 13-story hospital including 238 beds."},
    "projAddr"   => { street_address: "350 Hawthorne Ave.", city: "Oakland", state: "CA", post_code: "94609"}
  },
 { "company"     => { name: "Top Grade Construction Inc.", line_of_business: "Construction", url: "www.topgradeconstruction.com"},
    "address"    => { street_address: "50 Contractors St.", city: "Livermore", state: "CA", post_code: "94551"},
    "identifier" => { name: "Main Number", value: "925 449-5764"},
    "project"    => { name: "Stoneridge Creek", rep_id: @rep[0].id, project_start_on: "01-01-2010",
                      description: "Senior living community with 479 units."},
    "projAddr"   => { street_address: "5698 Stoneridge Drive", city: "Pleasanton", state: "CA", post_code: "94588"}
  },
 { "company"     => { name: "S.D. Deacon Corp.", line_of_business: "Construction", url: "www.deacon.com"},
    "address"    => { street_address: "7745 Greenback Lane, Ste. 250", city: "Citrus Heights", state: "CA", post_code: "95610"},
    "identifier" => { name: "Main Number", value: "916 969-0900"},
    "project"    => { name: "Paragon Outlet Mall", rep_id: @rep[0].id, 
                      project_start_on: "08-11-2013",
                      description: "543,000 square foot outlet mall."},
    "projAddr"   => { street_address: "El Charro Road and Interstate 580", city: "Livermore", state: "CA", post_code: "94588"}
  },
 { "company"     => { name: "Skanska", line_of_business: "Construction", url: "www.skanska.com"},
    "address"    => { street_address: "1999 Harrison St.", city: "Oakland", state: "CA", post_code: "94612"},
    "identifier" => { name: "Main Number", value: "510 285-1800"},
    "project"    => { name: "BART Warm Springs Extension Phase I", rep_id: @rep[0].id, 
                      project_start_on: "08-09-2013",
                      description: "New alignment for BART extension to Warm Springs"},
    "projAddr"   => { street_address: "1320 Stevenson Blvd.", city: "Fremont", state: "CA", post_code: "94538"}
  },
 { "company"     => { name: "Turner Construction Co.", line_of_business: "Construction", url: "www.turnerconstruction.com/oakland"},
    "address"    => { street_address: "1111 Broadway, Ste. 2100", city: "Oakland", state: "CA", post_code: "94607"},
    "identifier" => { name: "Main Number", value: "510 267-8100"},
    "project"    => { name: "Oakland International Airport Terminal 1", rep_id: @rep[0].id, 
                      project_start_on: "12-07-2013",
                      description: "300,000 square foot renovation including central utility plant."},
    "projAddr"   => { street_address: "1100 Airport Drive", city: "Oakland", state: "CA", post_code: "94621"}
  },
 { "company"     => { name: "Rudolph and Sletten Inc.", line_of_business: "Construction", url: "www.turnerconstruction.com/oakland"},
    "address"    => { street_address: "1111 Broadway, Ste. 2100", city: "Oakland", state: "CA", post_code: "94607"},
    "identifier" => { name: "Main Number", value: "510 267-8100"},
    "project"    => { name: "UC Berkeley Energy Biosciences Building", rep_id: @rep[0].id, 
                      project_start_on: "03-10-2013",
                      description: "112,600 square foot multi-story lab and office building."},
    "projAddr"   => { street_address: "2151 Berkeley Way", city: "Berkeley", state: "CA", post_code: "94709"}
  },
 { "company"     => { name: "SCM Construction Management Services Inc.", line_of_business: "Construction", url: "www.scmcms.com"},
    "address"    => { street_address: "1920 Standiford Ave., Ste 1", city: "Modesto", state: "CA", post_code: "95350"},
    "identifier" => { name: "Main Number", value: "209 338-0157"},
    "project"    => { name: "Linc (formerly West Dublin Apartments)", rep_id: @rep[0].id, 
                      project_start_on: "01-01-2011",
                      description: "309-unit transit-oriented apartment complex."},
    "projAddr"   => { street_address: "6600 Golden Gate Drive", city: "Dublin", state: "CA", post_code: "94588"}
  },
 { "company"     => { name: "Vance Brown Builders", line_of_business: "Construction", url: "www.vancebrown.com"},
    "address"    => { street_address: "3197 Park Blvd.,", city: "Palo Alto", state: "CA", post_code: "94306"},
    "identifier" => { name: "Main Number", value: "650 849-9900"},
    "project"    => { name: "Martinez Commons", rep_id: @rep[0].id, 
                      project_start_on: "01-09-2010",
                      description: "416-bed student dormitory."},
    "projAddr"   => { street_address: "2520 Channing Way", city: "Berkeley", state: "CA", post_code: "94720"}
  },
 { "company"     => { name: "AvalonBay Communities Inc.", line_of_business: "Construction", url: "www.avalonbay.com"},
    "address"    => { street_address: "455 Market St., Ste 1650", city: "San Francisco", state: "CA", post_code: "94105"},
    "identifier" => { name: "Main Number", value: "415 284-9087"},
    "project"    => { name: "Avalon Dublin Station II", rep_id: @rep[0].id, 
                      project_start_on: "04-01-2012",
                      description: "255 units, 4-story wooden frame structure."},
    "projAddr"   => { street_address: "5200 Iron Horse Pkwy.", city: "Dublin", state: "CA", post_code: "94568"}
  },
 { "company"     => { name: "O.C. Jones & Sons Inc." },
    "project"    => { name: "State Route 4 Widening-Loverige Interchange", rep_id: @rep[0].id, 
                      project_start_on: "09-01-2010",
                      description: "Freeway bridge widenings and adjacent ramps."},
    "projAddr"   => { street_address: "Hwy. 4, Loveridge Road", city: "Pittsburg", state: "CA", post_code: "94565"}
  },
 { "company"     => { name: "Webcor Builders" },
    "project"    => { name: "Lawrence Berkeley National Laboratory Phase II", rep_id: @rep[0].id, 
                      project_start_on: "03-01-2010",
                      description: "43,000-square-foot construction and modernization."},
    "projAddr"   => { street_address: "One Cyclotron Road", city: "Berkeley", state: "CA", post_code: "94720"}
  },
 { "company"     => { name: "SCM Construction Management Services Inc." },
    "project"    => { name: "Public Market Emeryville Apartments", rep_id: @rep[0].id, 
                      project_start_on: "05-01-2012",
                      description: "190-unit Apartment complex."},
    "projAddr"   => { street_address: "5959 Shellmound St.", city: "Emeryville", state: "CA", post_code: "94608"}
  },
 { "company"     => { name: "Balfour Beatty", line_of_business: "Construction", url: "www.howardswright.com" },
    "address"    => { street_address: "5858 Horton St., Ste. 170", city: "Emeryville", state: "CA", post_code: "94608"},
    "identifier" => { name: "Main Number", value: "510 903-2054"},
    "project"    => { name: "MacArthur Transit Village Phase I", rep_id: @rep[0].id, 
                      project_start_on: "07-01-2012",
                      description: "Infrastructure and 170,333-square-foot parking garage." },
    "projAddr"   => { street_address: "550 W. MacArthur Blvd.", city: "Oakland", state: "CA", post_code: "94609" }
  },
 { "company"     => { name: "Top Grade Construction Inc." },
    "project"    => { name: "Route 238 Corridor Improvement", rep_id: @rep[0].id, 
                      project_start_on: "09-01-2010",
                      description: "Loop system, landscaping and spot widening."},
    "projAddr"   => { street_address: "Mission Blvd.", city: "Hayward", state: "CA", post_code: "94536"}
  },
 { "company"     => { name: "Johnstone Moyer Inc.", line_of_business: "Construction", url: "www.johnstonemoyer.com" },
    "address"    => { street_address: "1720 S. Amphlett Blvd., Ste. 250", city: "San Mateo", state: "CA", post_code: "94402"},
    "identifier" => { name: "Main Number", value: "650 570-6161"},
    "project"    => { name: "Brio", rep_id: @rep[0].id, 
                      project_start_on: "10-01-2012",
                      description: "300-unit, 5-acre apartment complex."},
    "projAddr"   => { street_address: "141 N. Civic Drive", city: "Walnut Creek", state: "CA", post_code: "94596"}
  },
 { "company"     => { name: "J.R. Roberts/Deacon Inc.", line_of_business: "Construction", url: "www.jrrobertsdeacon.com" },
    "address"    => { street_address: "6140 Stoneridge Mall Road, Ste. 370", city: "unknown", state: "CA", post_code: "00000"},
    "identifier" => { name: "Main Number", value: "916 729-5600"},
    "project"    => { name: "Paragon", rep_id: @rep[0].id, 
                      project_start_on: "10-01-2012",
                      description: "301-unit mixed-use apartment community and retail."},
    "projAddr"   => { street_address: "3700 Beacon Ave.", city: "Fremont", state: "CA", post_code: ""}
  },
 { "company"     => { name: "UC Construction", line_of_business: "Construction", url: "www.ucconstruct.com" },
    "address"    => { street_address: "4216 Kiernan Ave.", city: "Modesto", state: "CA", post_code: "95356"},
    "identifier" => { name: "Main Number", value: "209 543-1608"},
    "project"    => { name: "Foothill Square Redevelopment Project", rep_id: @rep[0].id, 
                      project_start_on: "06-01-2012",
                      description: "201,900-square-foot shopping center redevelopment."},
    "projAddr"   => { street_address: "10700 MacArthur Blvd.", city: "Oakland", state: "CA", post_code: "94605"}
  },
 { "company"     => { name: "Build Group Inc.", line_of_business: "Construction", url: "www.buildgc.com" },
    "address"    => { street_address: "457 Minna St., Ste. 100", city: "Modesto", state: "CA", post_code: "94103"},
    "identifier" => { name: "Main Number", value: "415 367-9399"},
    "project"    => { name: "Archstone Parkside", rep_id: @rep[0].id, 
                      project_start_on: "05-01-2012",
                      description: "175 luxury live/work units and ground-level retail."},
    "projAddr"   => { street_address: "1225 Powell St.", city: "Emeryville", state: "CA", post_code: "94608"}
  },
 { "company"     => { name: "McCarthy Building Cos. Inc." },
    "project"    => { name: "LBNL Solar Energy Research Center", rep_id: @rep[0].id, 
                      project_start_on: "08-01-2012",
                      description: "40,000-square-foot laboratory to house solar reserch."},
    "projAddr"   => { street_address: "One Cyclotron Road", city: "Berkeley", state: "CA", post_code: "94720"}
  },
 { "company"     => { name: "McCarthy Building Cos. Inc." },
    "project"    => { name: "La Escuelita Educational Center Phase I", rep_id: @rep[0].id, 
                      project_start_on: "08-01-2012",
                      description: "Two new buildings totaling 55,655 square feet."},
    "projAddr"   => { street_address: "314 E. 10th St.", city: "Oakley", state: "CA", post_code: "94606"}
  }

]

projects_list.each do |model| 
  begin
    @company = Company.create!( model["company"] )
    @company.addresses.create!( model["address"] )
    @company.identifiers.create!( model["identifier"] )
  rescue
    company_association = Company.where( name: model["company"][:name])
    @company = company_association[0]
  end
  @project = @company.projects.create!( model["project"])
  @project.addresses.create!( model["projAddr"])
  @projmgr = @company.people.first
  puts
  puts model
end


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


