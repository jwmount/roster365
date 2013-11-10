#require 'debugger'
ActiveAdmin.register Company do

  menu label: "Customers", parent: "Companies"
  
#
# W H I T E   L I S T   M A N A G E M E N T
# 
  scope :all, :default => true 
  scope :active do |companies|
    companies.where ({active: true})
  end
  scope :inactive do |companies|
    companies.where ({active: false})
  end
  scope :po_required do |companies|
    companies.where ({PO_required: true})
  end
  scope :po_not_required do |companies|
    companies.where ({PO_required: false})
  end

  filter :name
  filter :projects
  filter :people
  filter :equipment
  filter :bookeeping_number
  
#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Companies Context", only: [:index] do 
    ul
      li link_to "Dashboard", admin_dashboard_path
  end

  sidebar "Company Details", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      li link_to 'Do Projects', admin_company_projects_path( project.company )           
      hr
      status_tag('Work on Company Details:')
      li link_to( "Equipment", admin_company_equipment_index_path( company ) )
      li link_to( "People", admin_company_people_path( company ) )
      li link_to( "Projects", admin_company_projects_path( company ) )
      hr
      li link_to "Dashboard", admin_dashboard_path
  end

  index do
    selectable_column

    column "Name (click for details)", :sortable => 'name' do |company|
      render company
      if company.certs.count > 0
        @certs = company.certs
        render @certs
      end
    end

    column :projects do |company|
      if company.projects.count > 0
        link_to "Projects (#{company.projects.count.to_s})", admin_company_projects_path( company )
      else
        link_to "New Project", new_admin_company_project_path( company )
      end
    end

    column :equipment do |company|
      if company.equipment.size > 0 
        link_to "Equipment (#{company.equipment.count.to_s})", admin_company_equipment_index_path( company )
      else
        link_to "New equipment", new_admin_company_equipment_path(company)
      end
    end
    
    column :people do |company|
      if company.people.count > 0
        link_to "People (#{company.people.count.to_s})", admin_company_people_path( company )
      else
        link_to "New person", new_admin_company_person_path(company)
      end
    end
    
    column "Bookkeeping No." do |company|
      company.bookeeping_number
    end

    column :credit_terms
    
    column :PO_required do |company|
      status_tag (company.PO_required ? "YES" : "No"), (company.PO_required ? :ok : :error)
    end      
    column :active do |company|
      status_tag (company.active ? "YES" : "No"), (company.active ? :ok : :error)
    end      
  end
  
  form do |f|
    error_panel f

    f.inputs "Company Details" do
      f.input :name, 
              :hint => 'Company names are unique.', 
              :wrapper_html => { :class => "important" },
              :placeholder => "Company name..."
      f.input :line_of_business,
              :hint => "Short statement of company's market focus."
      f.input :url,
              :hint => "Web site or URL"
      f.input :bookeeping_number,  
              :as => :string, 
              :hint => "Roster365 unique 5 digit account number, or '00000'.",
              :placeholder => "bookeeping_number number"
      f.input :PO_required,  
              :as => :radio, 
              :label => 'Purchase Order Required'
      f.input :credit_terms, 
              :label => 'Credit Terms (Days)', 
              :hint => 'Number of days we will extend credit, if any.',
              :placeholder => 'Days'
      f.input :active, :as => :radio
    end

    f.inputs "Addresses" do
      f.has_many :addresses do |a|
          a.input :street_address
          a.input :city
          a.input :state
          a.input :post_code
          a.input :map_reference
      end
    end
    
    f.inputs "Rollodex Items for Company (formerly Identifiers)" do
      f.has_many :identifiers do |f|
          f.input :name, :collection => %w[Mobile Office Truck Pager FAX Email Skype SMS Twitter URL],
                  :label => 'Type or kind*',
                  :hint => 'Kind of device or way to communicate with this Person.  Cannot be blank.'
          f.input :value,
                  :label => 'Phone Number, address, etc.',
                  :hint => 'Number, address, etc.  For example, 514 509-8381, or info@somecompany.com.',
                  :placeholder => 'Phone number, email address, ...'
          f.input :rank, :collection => %w[1 2 3 4 5 6 7 8 9],
                  :label => 'Priority',
                  :hint => 'Order prefered.',
                  :placeholder => '1..9'
      end
    end
    
    f.inputs do
      f.has_many :certs do |f|
        f.input :certificate,
                :collection => Certificate.where({:for_company => true}),
                :include_blank => false
        f.input :active
        f.input :expires_on, 
                :as => :date_picker,
                :hint => "Expiration date."
        f.input :permanent
        f.input :serial_number, 
                :hint => "Value that makes the certificate unique.  For example, License Number, Rego, etc."
      end
    end
    f.buttons
  end
    
  show :title => :display_name do
    attributes_table do
      row :name
      row :line_of_business
      row ("Web Site") { link_to "#{company.url}", href="http://#{company.url}", target: '_blank' }
      row :credit_terms
      row("PO_required") { status_tag (company.PO_required ? "YES" : "No"), (company.PO_required ? :ok : :error) }        
      row("active") { status_tag (company.active ? "YES" : "No"), (company.active ? :ok : :error) }
      row :bookeeping_number
      row ("People") {render company.people}
      row ("Projects") { render company.projects}
      row ("Equipment") { render company.equipment}
      row ("Address") { render company.addresses}
      row ("Certifications") { render company.certs}
      row ("Rollodex") { render company.identifiers}
    end

    active_admin_comments

  end

#
# P U S H  B U T T O N S
#

end
