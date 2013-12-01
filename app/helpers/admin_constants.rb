# If these values are changed, re-run migrations or reload schema
# $ bundle exec rake db:drop db:create db:schema:load db:seed
# Internationalization, see http://stackoverflow.com/questions/3629894/internationalization-for-constants-hashes-in-rails-3
module AdminConstants

#
# Company
#
  ADMIN_COMPANY_NAME_HINT                = "Company name.  Must be unique."
  ADMIN_COMPANY_NAME_PLACEHOLDER         = "Company name"

  ADMIN_COMPANY_LINE_OF_BUSINESS_HINT    = "What the company does."

  ADMIN_COMPANY_URL_LABEL                = "Web Site"
  ADMIN_COMPANY_URL_PLACEHOLDER          = "www.company_name.com"
  ADMIN_COMPANY_URL_HINT                 = "Web site, URL."

  ADMIN_COMPANY_BOOKEEPING_NO_BASE       = '10000'
  ADMIN_COMPANY_BOOKEEPING_NO_MAX        = '99999'
  ADMIN_COMPANY_BOOKEEPING_NO_DEFAULT    = '00000'
  ADMIN_COMPANY_BOOKEEPING_NO_HINT       = "Bookeeping account number for this company; unique, five digits."

  ADMIN_COMPANY_CREDIT_TERMS_DEFAULT     = 30
  ADMIN_C0MPANY_CREDIT_TERMS_LABEL       = "Credit Terms (Days)", 
  ADMIN_C0MPANY_CREDIT_TERMS_HINT        = "Number of days we will extend credit, if any."
  ADMIN_C0MPANY_CREDIT_TERMS_PLACEHOLDER = "Days"
              
  ADMIN_C0MPANY_PO_REQUIRED_LABEL        = "Purchase Order Required"

#
# Certs
#
  ADMIN_CERT_EXPIRES_ON_HINT             = "Expriation date."
  ADMIN_CERT_SERIAL_NUMBER_HINT          = "Value that makes the certificate unique.  For example, License Number, Rego, etc."

#
# Conditions
#
  ADMIN_CONDITIONS_NAME_PLACEHOLDER        = "Our name for this contract provision."
  ADMIN_CONDITIONS_VERBIAGE_PLACEHOLDER    = "Approved description of this condition."
  ADMIN_CONDITIONS_INDICATION_PLACEHOLDER  = "How, When or Why Condition applies."

  
#
# Dockets
#
  ADMIN_DOCKETS_NUMBER_HINT              = "Unique Booking number provided by subbie entered by operations to complete the engagement."
  ADMIN_DOCKETS_NUMBER_PLACEHOLDER       = "12345"

  ADMIN_DOCKETS_PERSON_HINT              = "Who is submitting this docket, or payee."
  ADMIN_DOCKETS_DATE_WORKED_HINT         = "Day the work was performed."
  ADMIN_DOCKETS_ENGAGEMENT_HINT          = "Engagement associated with this docket."
  ADMIN_DOCKETS_DATED_HINT               = "Date docket was marked completed."
  ADMIN_DOCKETS_RECEIVED_ON_HINT         = "Date docket was received."

  ADMIN_DOCKETS_A_INV_PAY_LABEL          = "First Party Invoice Pay Amount ($)."
  ADMIN_DOCKETS_A_INV_PAY_HINT           = "Amount we'll pay to first party, if any."
  ADMIN_DOCKETS_A_INV_PAY_PLACEHOLDER    = "000.00"

  ADMIN_DOCKETS_B_INV_PAY_LABEL          = "Second Party Invoice Pay Amount ($)."
  ADMIN_DOCKETS_B_INV_PAY_HINT           = "Amount we'll pay to second party, if any."
  ADMIN_DOCKETS_B_INV_PAY_PLACEHOLDER    = "000.00"

  ADMIN_DOCKETS_SUPPLIER_INV_PAY_LABEL   = "Supplier Invoice Pay Amount ($)"
  ADMIN_DOCKETS_SUPPLIER_INV_PAY_HINT    = "Amount we'll pay to a supplier party, if any."
  ADMIN_DOCKETS_SUPPLIER_INV_PAY_PLACEHOLDER  =  "000.00"

#
# Engagements
#
  ADMIN_ENGAGEMENT_PERSON_HINT           = "Person you are engaging to work.  Must work for company with "
  ADMIN_ENGAGEMENT_DOCKET_NUMBER_HINT    = "Docket number from docket provided by driver. GET THIS FROM THE DRIVER AS EARLY IN THE DAY AS POSSIBLE.",
  ADMIN_ENGAGEMENT_ONSITE_AT_HINT        = "Driver expects to be onsite in 10-15 minutes or less."

#
# Equipment
#
  ADMIN_EQUIPMENT_NAME_HINT              = "Select one."
  ADMIN_EQUIPMENT_EXPIRES_ON_HINT        = "Expiration date."
  ADMIN_EQUIPMENT_SERIAL_NUMBER_HINT       = "Value that makes the certificate unique.  For example, License Number, Rego, etc."
#
# Identifiers
#
  ADMIN_IDENTIFIER_NAME_COLLECTION       = %w[Mobile Email Office Truck Pager FAX Skype SMS Twitter Home URL]
  ADMIN_IDENTIFIER_NAME_LABEL            = "Type or kind of device or mode."
  ADMIN_IDENTIFIER_NAME_HINT             = "Kind of device or way to communicate with this Person.  Cannot be blank. E.g. person@company.com."

  ADMIN_IDENTIFIER_VALUE_LABEL           = "Phone Number, address, etc."            
  ADMIN_IDENTIFIER_VALUE_HINT            = "Number, address, etc.  For example, 514 509-8381, or info@somecompany.com."
  ADMIN_IDENTIFIER_VALUE_PLACEHOLDER     = "Phone number, email address, ..."

  ADMIN_IDENTIFIER_RANK_LABEL            = "Priority of use."
  ADMIN_IDENTIFIER_RANK_HINT             = "Order prefered."
  ADMIN_IDENTIFIER_RANK_PLACEHOLDER      = "1..9"

#
# Jobs
#
  ADMIN_JOB_NAME_LABEL                   = "Job Name"
  ADMIN_JOB_NAME_HINT                    = "Job Name is generated for you."
  ADMIN_JOB_NAME_PLACEHOLDER             = "Job Name"
  ADMIN_JOB_PURCHASE_ORDER_PLACEHOLDER   = "Purchase Order"
  ADMIN_JOB_FINISHED_ON_HINT             = "Expected finish date.  Quote estimated days was "
#
# Materials
#
  ADMIN_MATERIAL_NAME_PLACEHOLDER        = "Name"
  ADMIN_MATERIAL_DESCRIPTION_PLACEHOLDER = "Description"
#
# Person
#
  ADMIN_PERSON_FIRST_NAME_LABEL          = ""
  ADMIN_PERSON_FIRST_NAME_HINT           = ""
  ADMIN_PERSON_FIRST_NAME_PLACEHOLDER    = "First name"

  ADMIN_PERSON_LAST_NAME_LABEL           = ""
  ADMIN_PERSON_LAST_NAME_HINT            = ""
  ADMIN_PERSON_LAST_NAME_PLACEHOLDER     = "Last name"

  ADMIN_PERSON_TITLE_LABEL               = ""
  ADMIN_PERSON_TITLE_HINT                = ""
  ADMIN_PERSION_TITLE_PLACEHOLDER        = "Title"

#
# Project
# 
  ADMIN_PROJECT_NAME_LABEL               = 'Project Name'
  ADMIN_PROJECT_NAME_HINT                = "Working name of project. NOTE:  if you change a project name, existing resources such as quotes, solutions, jobs etc., continue to use the old name."
  ADMIN_PROJECT_NAME_PLACEHOLDER         = "Required, if no name has been given, make one up and change it later."

  ADMIN_PROJECT_REP_LABEL                = "Rep on this project, who's running it."
  ADMIN_PROJECT_REP_PLACEHOLDER          = "Person"

  ADMIN_PROJECT_START_ON_LABEL           = "Expected start date"
  ADMIN_PROJECT_START_ON_HINT            = "Best estimate of when project will start."
  ADMIN_PROJECT_START_ON_PLACEHOLDER     = "mm-dd-yyyy"

#
# Quotes
#
  ADMIN_QUOTE_NAME_HINT                  = "Name is automatically assigned and not edited."

  ADMIN_QUOTE_REP_ID_LABEL               = "Quote Rep"
  ADMIN_QUOTE_REP_ID_HINT                = "Quote and Project Reps may be same person."

  ADMIN_QUOTE_QUOTE_TO_ID_LABEL          = "Quote to"
  ADMIN_QUOTE_QUOTE_TO_ID_HINT           = "Deliver quote to "

#
# Requirements
#
# none

#
# Roles
#
# none

#
# Schedules
#
  ADMIN_SCHEDULE_DAY_LABEL              = "Day"
  ADMIN_SCHEDULE_DAY_HINT               = "Day you are scheduling to have the equipment on site."
  ADMIN_SCHEDULE_DAY_PLACEHOLDER        = "Date."

  ADMIN_SCHEDULE_EQUIPMENT_UNITS_TODAY_PLACEHOLDER  = "Date."
  ADMIN_SCHEDULE_EQUIPMENT_UNITS_TODAY_HINT         = "Number of "
#
# Solutions
#
  ADMIN_SOLUTION_APPROVED_HINT                    = "Once approved solutions cannot be changed."
  ADMIN_SOLUTION_CLIENT_APPROVED_HINT             = "Once approved solutions cannot be changed."
  ADMIN_SOLUTION_NAME_HINT                        = "Name is pre-assigned.  Fully qualified name will be used for scheduling."
  ADMIN_SOLUTION_SOLUTION_SOLUTION_TYPE_LABEL     = "Contract type"
  ADMIN_SOLUTION_SOLUTION_TYPE_LABEL              = "Solution type"
  ADMIN_SOLUTION_SOLUTION_TYPE_HINT               = "Solution type, e.g. 'Export' or 'Hourly'."
  ADMIN_SOLUTION_SOLUTION_TYPE_PLACEHOLDER        = "Type"
  ADMIN_SOLUTION_MATERIAL_ID_LABEL                = "Material"
  ADMIN_SOLUTION_MATERIAL_ID_HINT                 = "What kind material will be moved."
  ADMIN_SOLUTION_UNIT_OF_MATERIAL_LABEL           = "Unit of Material"
  ADMIN_SOLUTION_UNIT_OF_MATERIAL_HINT            = "Unit that is basis for our price."
  ADMIN_SOLUTION_UNIT_OF_MATERIAL_COLLECTION      = %w[m3 tonne 'hourly hire' loads pounds]
  ADMIN_SOLUTION_TOTAL_MATERIAL_HINT              = "How much material will be moved in this solution."

  ADMIN_SOLUTION_KMS_ONE_WAY_PLACEHOLDER                 = "Distance"    
  ADMIN_SOLUTION_LOADS_PER_DAY_PLACEHOLDER               = "Number of loads"    
  ADMIN_SOLUTION_DRIVE_TIME_INTO_SITE_PLACEHOLDER        = "Minutes" 
  ADMIN_SOLUTION_LOAD_TIME_PLACEHOLDER                   = "Minutes"
  ADMIN_SOLUTION_DRIVE_TIME_OUT_OF_SITE_PLACEHOLDER      = "Minutes"
  ADMIN_SOLUTION_DRIVE_TIME_FROM_LOAD_TO_TIP_PLACEHOLDER = "minutes"
  ADMIN_SOLUTION_DRIVE_TIME_TIP_TO_LOAD_PLACEHOLDER      = "minutes"
  ADMIN_SOLUTION_DRIVE_TIME_INTO_TIP_PLACEHOLDER         = "minutes"
  ADMIN_SOLUTION_UNLOAD_TIME_PLACEHOLDER                 = "minutes"
  ADMIN_SOLUTION_DRIVE_TIME_OUT_OF_TIP_SITE_PLACEHOLDER  = "minutes"

  ADMIN_SOLUTION_EQUIPMENT_CERTIFICATE_HINT            = "What certifications are required."
  ADMIN_SOLUTION_EQUIPMENT_NAME_HINT                   = "Select one type of equipment for this solution.  If you need more than a single type, do a solution for each one."
  ADMIN_SOLUTION_PURCHASE_ORDER_REQUIRED_HINT          = "PO Required."
  ADMIN_SOLUTION_EQUIPMENT_UNITS_REQUIRED_PER_DAY_HINT = "ALERT:  May require a purchase order before a job is activated."
  ADMIN_SOLUTION_EQUIPMENT_DOLLARS_PER_DAY_HINT        = "Total daily payment target amount."

#  
# Tips
#
  ADMIN_TIP_NAME_HINT                  = "Commonly known name, ususally not same as Company name."
  ADMIN_TIP_NAME_PLACEHOLDER           = "Your local tip site name"

  ADMIN_TIP_COMPANY_HINT               = "Company owner or DBA name.",
  ADMIN_TIP_COMPANY_PLACEHOLDER        = "Company name"

  ADMIN_TIP_FEE_HINT                   = "Customary tip fee.  May be negotiated by reps."
  ADMIN_TIP_FEE_PLACEHOLDER            = "0.00"

  ADMIN_TIP_FIRE_ANT_RISK_LEVEL_COLLECTION = %w[ High Medium Low None]
  ADMIN_TIP_FIRE_ANT_RISK_LEVEL_HINT   = "High, Medium, Low or none.  Do not move material from high to medium or none, or from medium to none."

  ADMIN_TIP_EXPIRES_ON_HINT            = "High, Medium, Low or none.  Do not move material from high to medium or none, or from medium to none."

end
