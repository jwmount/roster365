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
# Certs
#
  ADMIN_CERT_EXPIRES_ON_HINT             = "Expriation date."
  ADMIN_CERT_SERIAL_NUMBER_HINT          = "Value that makes the certificate unique.  For example, License Number, Rego, etc."

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

end
