# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Works best with rake db:reset
#
#require 'debugger'

#
# T I P  S I T E S
#
# Revise this, done as part of Company declaration now.

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
  [ 'Green Flag', "No toxic or bad stuff", false, false, false, false, true ],
  [ "WBE", "CA Womman Owned Business", false, true, false, false, false],
  [ "SDB", "State & Federal Small Disadvantaged Business", false, true, false, false, false]
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

@licensee = "Valley Farm Transport"
@lob = "Farm transport"
@url = "www.ValleyTransport.com"

companies_list = [
# LICENSEE - This cannot be DRY with config/boots.rb, at least until we figure out how to use the 
# ENV[] attributes.
  { "company"    => { licensee: true, 
                      name: @licensee, line_of_business: @lob, url: @url},
    "address"    => { street_address: "t.b.d.", city: "Dixon", state: "CA", post_code: ""},
    "person"     => { first_name: "Account", last_name: "Representative", title: "Rep"},
    "identifier" => { name: "Office", value: "415 555-1212"}
    }, 
# COMPANIES IN MARKET AREA
  { "company"    => { name: "1st Logistics", line_of_business: "Over-the-road transportation services", url: "www.truckcompaniesin.com/dot/1175905/"},
    "address"    => { street_address: "2001 Meyer Way", city: "Fairfield", state: "CA", post_code: "94533" },
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "(707) 853-6712"}
    }, 
  { "company"    => { name: "American Debris Box Service Inc.", line_of_business: "Containers delivered and removed", url: "americandebrisbox.com/"},
    "address"    => { street_address: "PO Box 3187", city: "Half Moon Bay", state: "CA", post_code: "94019" },
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "866-332-7471"}
    }, 
  { "company"    => { name: "Blue Line Transfer", line_of_business: "Cartage, waste removal & recycling service", url: ""},
    "address"    => { street_address: "500 E. James Court", city: "South San Francisco", state: "CA", post_code: "94080"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."},
    "tip"        => { name: "Blue Line Transfer", fee: 15.00, fire_ant_risk_level: "none"}
    }, 
  { "company"    => { name: "Lawson Drayage, Inc.", line_of_business: "Machinery Moving, Rigging, & Heavy Transportation for any Industry",
                      url: "lawsoninc.com"},
    "address"    => { street_address: "3402 Enterprise Avenue", city: "Hayward", state: "CA", post_code: "94545"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "510-785-5100 "}
    }, 
  { "company"    => { name: "Waste Management, Inc.", line_of_business: "Waste Disposal & Removal Service", url: "www.wm.com"},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Reliable Crane & Rigging", line_of_business: "Carting, Hoist Service & Rental, Machinery Moving & Erecting Service", url: " www.reliablecrane.com"},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "800 222-7263"}
    }, 
  { "company"    => { name: "Foothill Disposal Co. Inc.", line_of_business: "Cartage Service", url: "www.norcalwaste.com"},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "BWRS", line_of_business: "Debris box, compactors, recycling", url: "www.bwrs.com/"},
    "address"    => {},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "t.b.d."}
    }, 
  { "company"    => { name: "Pleasanton Garbage Serivice, Inc.", line_of_business: "Waste Transport Service", url: "www.pleasantongarbageservices.com"},
    "address"    => { street_address: "3110 Busch Road", city: "Pleasanton", state: "CA", post_code: "94566"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "(925) 846-2042"}
    }, 
  { "company"    => { name: "Dillard Trucking, Inc.", line_of_business: "Hazardous Waste Transport", url: "dillardenv.com"},
    "address"    => { street_address: "3120 Camino Diablo Road, PO Box 579", city: "Byron", state: "CA", post_code: "94514"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "925 634-6850"}
    }, 
  { "company"    => { name: "Gan-Trans Ltd.", line_of_business: "Cartage Services (not local)", url: ""},
    "address"    => { street_address: "800 Carden St.", city: "San Leandro", state: "CA", post_code: "94577"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "510 357-3100"}
    }, 
  { "company"    => { name: "Precision Crane Service", line_of_business: "Crane & Freight Carrier Service", url: ""},
    "address"    => { street_address: "", city: "San Rafael", state: "CA", post_code: "94901"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "415 457-0702"}
    }, 
  { "company"    => { name: "East Bay Sanitary Co., Inc.", line_of_business: "Cartage, Waste Disposal & Removing Service", url: "www.ebsan.com"},
    "address"    => { street_address: "PO Box 1316, 1432 Kearny St.", city: "El Cerrito", state: "CA", post_code: "94530"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "510.237.4321"}
    }, 
  { "company"    => { name: "Vallejo Garbage Service", line_of_business: "Cartages Service", url: ""},
    "address"    => { street_address: "2021 Broadway St.", city: "Vallejo", state: "CA", post_code: "94589"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "707 552-3110"}
    }, 
  { "company"    => { name: "Fred Haines & Company", line_of_business: "Cartage Service", url: "hainesinc.com"},
    "address"    => { street_address: "40434 Brickyard Dr", city: "Madera", state: "CA", post_code: "93636"},
    "person"     => { first_name: "Jason", last_name: "Haines", title: "Dispatcher"},
    "identifier" => { name: "Main Office", value: "(559) 451-0100"}
    }, 
  { "company"    => { name: "Specialty Solid Waste & Recycling", line_of_business: "Waste Handling, Cartage, Waste Disposal Service", url: "www.sswr.com"},
    "address"    => { street_address: "3355 Thomas Road", city: "Santa Clara", state: "CA", post_code: "95054"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "408.565.9900"}
    }, 
  { "company"    => { name: "Tight Access Excavation", line_of_business: "Residential - Commercial", url: ""},
    "address"    => { street_address: "8140 SE 51ST AVE", city: "Portland", state: "OR", post_code: "97206"},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "(503) 287-4836"}
    }, 
  { "company"    => { name: "Hazel Construction", line_of_business: "Residential Construction", url: "hazel-construction.hub.biz/"},
    "address"    => { street_address: "70 Greenfield Ave.", city: "San Anselmo", state: "CA", post_code: ""},
    "person"     => { last_name: "t.b.d."},
    "identifier" => { name: "Main Office", value: "415 457-2086"}
    }, 
  { "company"    => { name: "TMT Industries", line_of_business: "Residential Construction", url: ""},
    "address"    => { street_address: "14859 Whittram Ave.", city: "Fontana", state: "CA", post_code: "92335"},
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

# 
# Create Rep once licensee company exists
#
companies_list.each do |model| 
  puts
  @company = Company.create!( model["company"] )
  @company.addresses.create!( model["address"] )
  model["person"]["title"] = "Rep" if @company.licensee
  @company.people.create!( model["person"] )
  @company.identifiers.create!( model["identifier"] )
  @company.tips.create!( model["tip"] ) unless model["tip"].nil?
 puts "#{model} -- CREATED"
end

#
# Licensee rep
#

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

demo_list = [
  { "company"    => { name: "Demo Company", line_of_business: "General resource contractor", url: "www.wsj.com"},
    "address"    => { street_address: "9 Alder Court", city: "Fairfax", state: "CA", post_code: "94935"},
    "person"     => { first_name: "Demo", last_name: "Demosthenes"},
    "identifier" => { name: "Main Number", value: "415-478-1121"},
    "equipment"  => { name: "Truck" },
    "project"    => { name: 'DemoProject', project_start_on: Date.today },
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

  @project = @company.projects.new( model["project"])
  @project.rep_id = 1
  @project.save!

  @project.addresses.create!( model["projAddr"])
  @projmgr = @company.people.first

  @quote = @project.quotes.new( model["quote"])
  @quote.quote_to_id = @projmgr.id
  @quote.rep_id = 1
  @quote.expected_start = Date.today + 1
  @quote.fire_ants_verified_by = 1
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

  #@docket = @engagement.dockets.create!( person_id: 1, number: "00001")
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
 # puts
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
def rep
  rep ||= Person.where("title = ?", "Rep")[0].id
end
projects_list = [
 { "company"     => { name: "McCarthy Building Cos. Inc.", line_of_business: "Construction", url: "www.mccarthy.com"},
    "address"    => { street_address: "343 Sansome St., 14th Floor", city: "San Francisco", state: "CA", post_code: "94104"},
    "identifier" => { name: "Main Number", value: "415 397-5151"},
    "project"    => { name: 'Kaiser Hospital Replacement Project Phase II', 
                      rep_id: rep, 
                      project_start_on: "01-04-2010",
                      description: "879,000 square foot hospital and medical office building."},
    "projAddr"   => { street_address: "280 W. MacArthur Blvd.", city: "Oakland", state: "CA", post_code: "94611"}
  },
 { "company"     => { name: "Rudolph and Sletten Inc.", line_of_business: "Construction", url: "www.rsconstruction.com"},
    "address"    => { street_address: "1600 Seaport Blvd., Ste. 350", city: "Redwood City", state: "CA", post_code: "94063"},
    "identifier" => { name: "Main Number", value: "650 216-3600"},
    "project"    => { name: "Kaiser Permanente San Leandro Medical Center", rep_id: rep, project_start_on: "01-01-2010",
                      description: "Hospital with 264 acute care beds."},
    "projAddr"   => { street_address: "1755 Fairway Drive", city: "San Leandro", state: "CA", post_code: "94577"}
  },
 { "company"     => { name: "Clark Construction Group - California LLP", line_of_business: "Construction", url: "www.clarkconstruction.com"},
    "address"    => { street_address: "7677 Oakport St., Ste. 1040", city: "Oakland", state: "CA", post_code: "94621"},
    "identifier" => { name: "Main Number", value: "510 430-6000"},
    "project"    => { name: "Highland Hospital - Alameda Country Medical Center", rep_id: rep, project_start_on: "01-01-2010",
                      description: "169-bed acute care tower, 78,000-square-foot satellite building."},
    "projAddr"   => { street_address: "1411 E. 32st St.", city: "Oakland", state: "CA", post_code: "94602"}
  },
 { "company"     => { name: "Flatiron Construction Corp.", line_of_business: "Construction", url: "www.flatironcorp.com"},
    "address"    => { street_address: "2100 Goodyear Road", city: "Benicia", state: "CA", post_code: "94510"},
    "identifier" => { name: "Main Number", value: "707 742-6000"},
    "project"    => { name: "BART Oakland Airport Connector", rep_id: rep, project_start_on: "11-11-2013",
                      description: "3.2 mile connection between Coliseum and airport."},
    "projAddr"   => { street_address: "1100 Airport Drive", city: "Oakland", state: "CA", post_code: "94621"}
  },
 { "company"     => { name: "Webcor Builders", line_of_business: "Construction", url: "www.webcor.com"},
    "address"    => { street_address: "207 King St., Ste. 300", city: "San Francisco", state: "CA", post_code: "94107"},
    "identifier" => { name: "Main Number", value: "415 978-1000"},
    "project"    => { name: "California Memorial Stadium Seismic Improvements", rep_id: rep, project_start_on: "06-10-2013",
                      description: "Reconstruction and revovation of historic stadium"},
    "projAddr"   => { street_address: "Rimway Road and Canyon Road", city: "Berkeley", state: "CA", post_code: "94704"}
  },
 { "company"     => { name: "DPR Construction", line_of_business: "Construction", url: "www.dpr.com"},
    "address"    => { street_address: "1450-Veterans Blvd.", city: "Redwood City", state: "CA", post_code: "94063"},
    "identifier" => { name: "Main Number", value: "650 474-1450"},
    "project"    => { name: "Alta Bates Oakland Campus, Patient Care Pavilion", rep_id: rep, project_start_on: "08-10-2013",
                      description: "250,000-square-foot, 13-story hospital including 238 beds."},
    "projAddr"   => { street_address: "350 Hawthorne Ave.", city: "Oakland", state: "CA", post_code: "94609"}
  },
 { "company"     => { name: "Top Grade Construction Inc.", line_of_business: "Construction", url: "www.topgradeconstruction.com"},
    "address"    => { street_address: "50 Contractors St.", city: "Livermore", state: "CA", post_code: "94551"},
    "identifier" => { name: "Main Number", value: "925 449-5764"},
    "project"    => { name: "Stoneridge Creek", rep_id: rep, project_start_on: "01-01-2010",
                      description: "Senior living community with 479 units."},
    "projAddr"   => { street_address: "5698 Stoneridge Drive", city: "Pleasanton", state: "CA", post_code: "94588"}
  },
 { "company"     => { name: "S.D. Deacon Corp.", line_of_business: "Construction", url: "www.deacon.com"},
    "address"    => { street_address: "7745 Greenback Lane, Ste. 250", city: "Citrus Heights", state: "CA", post_code: "95610"},
    "identifier" => { name: "Main Number", value: "916 969-0900"},
    "project"    => { name: "Paragon Outlet Mall", rep_id: rep, 
                      project_start_on: "08-11-2013",
                      description: "543,000 square foot outlet mall."},
    "projAddr"   => { street_address: "El Charro Road and Interstate 580", city: "Livermore", state: "CA", post_code: "94588"}
  },
 { "company"     => { name: "Skanska", line_of_business: "Construction", url: "www.skanska.com"},
    "address"    => { street_address: "1999 Harrison St.", city: "Oakland", state: "CA", post_code: "94612"},
    "identifier" => { name: "Main Number", value: "510 285-1800"},
    "project"    => { name: "BART Warm Springs Extension Phase I", rep_id: rep, 
                      project_start_on: "08-09-2013",
                      description: "New alignment for BART extension to Warm Springs"},
    "projAddr"   => { street_address: "1320 Stevenson Blvd.", city: "Fremont", state: "CA", post_code: "94538"}
  },
 { "company"     => { name: "Turner Construction Co.", line_of_business: "Construction", url: "www.turnerconstruction.com/oakland"},
    "address"    => { street_address: "1111 Broadway, Ste. 2100", city: "Oakland", state: "CA", post_code: "94607"},
    "identifier" => { name: "Main Number", value: "510 267-8100"},
    "project"    => { name: "Oakland International Airport Terminal 1", rep_id: rep, 
                      project_start_on: "12-07-2013",
                      description: "300,000 square foot renovation including central utility plant."},
    "projAddr"   => { street_address: "1100 Airport Drive", city: "Oakland", state: "CA", post_code: "94621"}
  },
 { "company"     => { name: "Rudolph and Sletten Inc.", line_of_business: "Construction", url: "www.turnerconstruction.com/oakland"},
    "address"    => { street_address: "1111 Broadway, Ste. 2100", city: "Oakland", state: "CA", post_code: "94607"},
    "identifier" => { name: "Main Number", value: "510 267-8100"},
    "project"    => { name: "UC Berkeley Energy Biosciences Building", rep_id: rep, 
                      project_start_on: "03-10-2013",
                      description: "112,600 square foot multi-story lab and office building."},
    "projAddr"   => { street_address: "2151 Berkeley Way", city: "Berkeley", state: "CA", post_code: "94709"}
  },
 { "company"     => { name: "SCM Construction Management Services Inc.", line_of_business: "Construction", url: "www.scmcms.com"},
    "address"    => { street_address: "1920 Standiford Ave., Ste 1", city: "Modesto", state: "CA", post_code: "95350"},
    "identifier" => { name: "Main Number", value: "209 338-0157"},
    "project"    => { name: "Linc (formerly West Dublin Apartments)", rep_id: rep, 
                      project_start_on: "01-01-2011",
                      description: "309-unit transit-oriented apartment complex."},
    "projAddr"   => { street_address: "6600 Golden Gate Drive", city: "Dublin", state: "CA", post_code: "94588"}
  },
 { "company"     => { name: "Vance Brown Builders", line_of_business: "Construction", url: "www.vancebrown.com"},
    "address"    => { street_address: "3197 Park Blvd.,", city: "Palo Alto", state: "CA", post_code: "94306"},
    "identifier" => { name: "Main Number", value: "650 849-9900"},
    "project"    => { name: "Martinez Commons", rep_id: rep, 
                      project_start_on: "01-09-2010",
                      description: "416-bed student dormitory."},
    "projAddr"   => { street_address: "2520 Channing Way", city: "Berkeley", state: "CA", post_code: "94720"}
  },
 { "company"     => { name: "AvalonBay Communities Inc.", line_of_business: "Construction", url: "www.avalonbay.com"},
    "address"    => { street_address: "455 Market St., Ste 1650", city: "San Francisco", state: "CA", post_code: "94105"},
    "identifier" => { name: "Main Number", value: "415 284-9087"},
    "project"    => { name: "Avalon Dublin Station II", rep_id: rep, 
                      project_start_on: "04-01-2012",
                      description: "255 units, 4-story wooden frame structure."},
    "projAddr"   => { street_address: "5200 Iron Horse Pkwy.", city: "Dublin", state: "CA", post_code: "94568"}
  },
 { "company"     => { name: "O.C. Jones & Sons Inc." },
    "project"    => { name: "State Route 4 Widening-Loverige Interchange", rep_id: rep, 
                      project_start_on: "09-01-2010",
                      description: "Freeway bridge widenings and adjacent ramps."},
    "projAddr"   => { street_address: "Hwy. 4, Loveridge Road", city: "Pittsburg", state: "CA", post_code: "94565"}
  },
 { "company"     => { name: "Webcor Builders" },
    "project"    => { name: "Lawrence Berkeley National Laboratory Phase II", rep_id: rep, 
                      project_start_on: "03-01-2010",
                      description: "43,000-square-foot construction and modernization."},
    "projAddr"   => { street_address: "One Cyclotron Road", city: "Berkeley", state: "CA", post_code: "94720"}
  },
 { "company"     => { name: "SCM Construction Management Services Inc." },
    "project"    => { name: "Public Market Emeryville Apartments", rep_id: rep, 
                      project_start_on: "05-01-2012",
                      description: "190-unit Apartment complex."},
    "projAddr"   => { street_address: "5959 Shellmound St.", city: "Emeryville", state: "CA", post_code: "94608"}
  },
 { "company"     => { name: "Balfour Beatty", line_of_business: "Construction", url: "www.howardswright.com" },
    "address"    => { street_address: "5858 Horton St., Ste. 170", city: "Emeryville", state: "CA", post_code: "94608"},
    "identifier" => { name: "Main Number", value: "510 903-2054"},
    "project"    => { name: "MacArthur Transit Village Phase I", rep_id: rep, 
                      project_start_on: "07-01-2012",
                      description: "Infrastructure and 170,333-square-foot parking garage." },
    "projAddr"   => { street_address: "550 W. MacArthur Blvd.", city: "Oakland", state: "CA", post_code: "94609" }
  },
 { "company"     => { name: "Top Grade Construction Inc." },
    "project"    => { name: "Route 238 Corridor Improvement", rep_id: rep, 
                      project_start_on: "09-01-2010",
                      description: "Loop system, landscaping and spot widening."},
    "projAddr"   => { street_address: "Mission Blvd.", city: "Hayward", state: "CA", post_code: "94536"}
  },
 { "company"     => { name: "Johnstone Moyer Inc.", line_of_business: "Construction", url: "www.johnstonemoyer.com" },
    "address"    => { street_address: "1720 S. Amphlett Blvd., Ste. 250", city: "San Mateo", state: "CA", post_code: "94402"},
    "identifier" => { name: "Main Number", value: "650 570-6161"},
    "project"    => { name: "Brio", rep_id: rep, 
                      project_start_on: "10-01-2012",
                      description: "300-unit, 5-acre apartment complex."},
    "projAddr"   => { street_address: "141 N. Civic Drive", city: "Walnut Creek", state: "CA", post_code: "94596"}
  },
 { "company"     => { name: "J.R. Roberts/Deacon Inc.", line_of_business: "Construction", url: "www.jrrobertsdeacon.com" },
    "address"    => { street_address: "6140 Stoneridge Mall Road, Ste. 370", city: "unknown", state: "CA", post_code: "00000"},
    "identifier" => { name: "Main Number", value: "916 729-5600"},
    "project"    => { name: "Paragon", rep_id: rep, 
                      project_start_on: "10-01-2012",
                      description: "301-unit mixed-use apartment community and retail."},
    "projAddr"   => { street_address: "3700 Beacon Ave.", city: "Fremont", state: "CA", post_code: ""}
  },
 { "company"     => { name: "UC Construction", line_of_business: "Construction", url: "www.ucconstruct.com" },
    "address"    => { street_address: "4216 Kiernan Ave.", city: "Modesto", state: "CA", post_code: "95356"},
    "identifier" => { name: "Main Number", value: "209 543-1608"},
    "project"    => { name: "Foothill Square Redevelopment Project", rep_id: rep, 
                      project_start_on: "06-01-2012",
                      description: "201,900-square-foot shopping center redevelopment."},
    "projAddr"   => { street_address: "10700 MacArthur Blvd.", city: "Oakland", state: "CA", post_code: "94605"}
  },
 { "company"     => { name: "Build Group Inc.", line_of_business: "Construction", url: "www.buildgc.com" },
    "address"    => { street_address: "457 Minna St., Ste. 100", city: "Modesto", state: "CA", post_code: "94103"},
    "identifier" => { name: "Main Number", value: "415 367-9399"},
    "project"    => { name: "Archstone Parkside", rep_id: rep, 
                      project_start_on: "05-01-2012",
                      description: "175 luxury live/work units and ground-level retail."},
    "projAddr"   => { street_address: "1225 Powell St.", city: "Emeryville", state: "CA", post_code: "94608"}
  },
 { "company"     => { name: "McCarthy Building Cos. Inc." },
    "project"    => { name: "LBNL Solar Energy Research Center", rep_id: rep, 
                      project_start_on: "08-01-2012",
                      description: "40,000-square-foot laboratory to house solar reserch."},
    "projAddr"   => { street_address: "One Cyclotron Road", city: "Berkeley", state: "CA", post_code: "94720"}
  },
 { "company"     => { name: "McCarthy Building Cos. Inc." },
    "project"    => { name: "La Escuelita Educational Center Phase I", rep_id: rep, 
                      project_start_on: "08-01-2012",
                      description: "Two new buildings totaling 55,655 square feet."},
    "projAddr"   => { street_address: "314 E. 10th St.", city: "Oakley", state: "CA", post_code: "94606"}
  }

]


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
