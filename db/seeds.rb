# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Works best with rake db:reset
#
roles_list = %w[ admin demo staff support operations sales ]

roles_list.each do |role|
  Role.create!(name: role)
end

# Create users (roles not implemented yet, MUST be chosen from roles_list)

user_list = [
  ["admin@example.com", 'demo'],
  ['staff@example.com', 'staff_role'], 
  ['john@venuesoftware.com', 'vendor_support'],
  ['peta.forbes@roster365.com.au', 'management']
  #['tgodino@me.com', 'vendor_support']
  ]
user_list.each do |email, role|  
  AdminUser.create!( email: email, password: 'roster365', password_confirmation: 'roster365')
end

# load certificates
certificate_list = [
  [ 'Commercial Driving License', 'Initialized default, Must be verified.', true, false, false, false, true ],
  [ 'ISO 9000', 'May be required.', false, true, false, false, true ],
  [ 'Insurance', 'Must be current & Must be verified.', false, false, true, true, true ]
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
    when certificate[0].for_place
      Cert.create!( certifiable_id: certificate[0].id, certificate_id: certificate[0].id, certifiable_type: 'Place', expires_on: Date.today, serial_number: '000000', permanent: 1, active: 1)
  end
end

# load companies
# Companies and People
# First one is licensee, this admittedly fragile rule, is/was? used next to determine this status.
# Two methods here, names list and completely specified attributes.
companies_list = [
  "American Debris Box Service Inc.",
  "Roster365", 
  'Projects-r-us',
  'Trucks-r-us'
]
companies_list.each do |name|
  Company.create!( name: name)
end


# now put some people in each company
company_relation = Company.where ({name: "American Debris Box Service Inc."})
@company = company_relation[0]
@person_1 = Person.create!(company_id: @company.id, first_name: 'John', last_name: 'Doe', title: 'Rep', available_on: Date.today)
@person_2 = Person.create!(company_id: @company.id, first_name: 'Jane', last_name: 'Doe', title: 'Ms.', available_on: Date.today)
@equipment = Equipment.new({name: 'Crane', company_id: @company.id})
@equipment.save!

company_relation = Company.where ({name: 'Projects-r-us'})
@company_1 = company_relation[0]
@person_3 = Person.create!(company_id: @company_1.id, first_name: 'William', last_name: 'Wellsmore', title: 'Mr.', available_on: Date.today)
@person_4 = Person.create!(company_id: @company_1.id, first_name: 'Peter', last_name: 'Petersen', title: 'Project Mgr', available_on: Date.today)

company_relation = Company.where ({name: 'Trucks-r-us'})
@company_2 = company_relation[0]
@person_5 = Person.create!(company_id: @company_2.id, first_name: 'Vance', last_name: 'Smith', title: 'Owner', available_on: Date.today)
@person_6 = Person.create!(company_id: @company_2.id, first_name: 'Sam', last_name: 'Jones', title: 'Driver', available_on: Date.today)

Address.create!( addressable_id: @company.id, addressable_type: 'Company', street_address: '7 Strathaird Road',
                 city: 'Bundall', state: 'QLD', post_code: '4217' )



Identifier.create!( :identifiable_id => @company.id, :identifiable_type => 'Company', :name => "Office", :value => '07-55-047-100', :rank => 1)
Identifier.create!( :identifiable_id => @company.id, :identifiable_type => 'Company', :name => "eMail", :value => 'info@roster365.com.au', :rank => 2)
Identifier.create!( :identifiable_id => @company.id, :identifiable_type => 'Company', :name => "FAX", :value => '07-55-047-133', :rank => 3)

Identifier.create!( :identifiable_id => @person_1.id, :identifiable_type => 'Person', :name => "Phone", :value => '07-55-047-100', :rank => 1)
Identifier.create!( :identifiable_id => @person_1.id, :identifiable_type => 'Person', :name => "Mobile", :value => '07-55-047-100', :rank => 2)

Identifier.create!( :identifiable_id => @person_2.id, :identifiable_type => 'Person', :name => "Phone", :value => '07-55-047-100', :rank => 1)
Identifier.create!( :identifiable_id => @person_2.id, :identifiable_type => 'Person', :name => "Mobile", :value => '07-55-047-100', :rank => 2)
Identifier.create!( :identifiable_id => @person_2.id, :identifiable_type => 'Person', :name => "Blackberry", :value => '07-55-047-100', :rank => 3)

Identifier.create!( :identifiable_id => @person_3.id, :identifiable_type => 'Person', :name => "Phone", :value => 'unknown', :rank => 1)
Identifier.create!( :identifiable_id => @person_3.id, :identifiable_type => 'Person', :name => "Mobile", :value => 'unknown', :rank => 2)

Identifier.create!( :identifiable_id => @person_4.id, :identifiable_type => 'Person', :name => "Phone", :value => 'unknown', :rank => 1)
Identifier.create!( :identifiable_id => @person_4.id, :identifiable_type => 'Person', :name => "Mobile", :value => 'unknown', :rank => 2)

# OPERATIONS models
# Projects
#   Quotes
#     Solutions
#       Jobs
# Two RISKY values are used here, Project.rep_id and Quote.quote_to_id both set to 1
project_list = [
  'Project One', 'Project Two', 'Project Three'
]
solution_options = [
      'Export', 'Import', 'Hourly Hire', 'Load, Cart and Dispose', 'Cart Only', 'Budget Price', 
      'Machine Hire - Wet', 'Machine Hire - Dry, Uninsured', 'Machine Hire - Dry, Insured',
      'Free Tip - Private Customers', 'COD, Credit Card Accounts'
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
# now retrieve the first quote and create some solutions for it, one for each contract type
@quote = Quote.first
  solution_options.each do |contract|
    solution = Solution.new( quote_id: @quote.id, equipment_id: 1, total_material: 1, solution_type: contract )
    solution.name = "S#{Solution.count+1}"
    solution.material_id = 1
    solution.kms_one_way = 1
    solution.save!
  end

# Tip Sites
Tip.create!( name: 'ABC Tip', company_id: @company_1.id, fee: 10.00, fire_ant_risk_level: 'High')
Tip.create!( name: 'XYZ Tip', company_id: @company_2.id, fee: 5.00, fire_ant_risk_level: 'Low')



# Material types  
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
   "Note:  A REPRESENTATIVE FROM CLIENT CONTRACTORS IS REQUIRED TO SIGN ALL THINK360 DOCKETS.",
   "Required"
 ],
 [
   "Standard Contract Terms for Load Cart and Dispose",
   "Load, Cart and Dispose Conditions: 9 hr working day. Minimum delays on site to facilitate quick entry and exit. Should delays occur due to no fault of the subcontractor, the charge will revert to current hourly hire rates. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually. The Client agrees to provide exclusive access to the total volume of materials on site as quoted above. The Client is responsible for all supervision, direction and project management on the site. roster365 (AUST) Pty Ltd will provide a 20-30T Excavator to load only, under the supervision and direction of the Client or their authorised representative. The client agrees to indemnify roster365 (AUST) Pty Ltd from any damage claims in respect to injury of person/s or damage to property and/or utilities resultant from all excavation and cartage works provided. The client is responsible for all sediment control, traffic control & dust suppression as required. All material rates are quoted in loose cubic meters or tonnes. All quotes are subject to material acceptance by Import Site. All prices are based on statutory legal loads. Material to be in accordance with EPA/DPI guidelines. Quotation is valid for 30 days.",
   "Load, Cart and Dispose"
 ],
 [
   "Standard Contract Terms for Export",
   "9 hr working day. Minimum delays on site to facilitate quick entry, loading (minimum 20 tonne excavator loading) and exit. Should delays occur due to no fault of the subcontractor, the charge will revert to current hourly hire rates. Any subsequent charges e.g. tip fees, tolls, etc will be charged individually. The quoted price is based on a maximum of five (5) minutes to load each Tandem, Truck & Trailer or Semi Tipper. All material rates are quoted in loose cubic meters or tonnes. All quotes are subject to material acceptance by Import Site. All prices are based on statutory legal loads. Material to be in accordance with EPA/DPI guidelines. Quotation is valid for 30 days.",
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
