#require 'debugger'
ActiveAdmin.register Company do

  before_action :check_permissions, :only => [:new, :create, :cancel]  
#
# W H I T E   L I S T   M A N A G E M E N T
# 
  # Rails 5.2.2 scope definitions
=begin
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :po_required, -> { where(PO_required: true) }
  scope :po_not_required, -> { where(PO_required: false) }

=begin
  Rails 3.x, remove
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
=end
  filter :name
  filter :projects
  filter :people
  filter :equipment
  filter :bookeeping_number
  filter :addresses
  filter :licensee

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
      li link_to 'Do Projects', admin_company_projects_path( company )           
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
      render company.identifiers unless company.identifiers.empty?
      render company.addresses unless company.addresses.empty?
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

    column "Credit Terms" do |company|
      company.credit_terms
    end

    column "PO required" do |company|
      status_tag (company.PO_required ? "YES" : "No"), (company.PO_required ? :ok : :error)
    end      
    column :active do |company|
      status_tag (company.active ? "YES" : "No"), (company.active ? :ok : :error)
    end      
  end
  
  form do |f|
    f.semantic_errors *f.object.errors.keys
    error_panel f

    f.inputs "Company Details" do

      f.input :name, 
              :hint         => AdminConstants::ADMIN_COMPANY_NAME_HINT,
              :placeholder  => AdminConstants::ADMIN_COMPANY_NAME_PLACEHOLDER

      f.input :line_of_business,
              :hint         => AdminConstants::ADMIN_COMPANY_LINE_OF_BUSINESS_HINT

      f.input :url,
              :label        => AdminConstants::ADMIN_COMPANY_URL_LABEL,
              :placeholder  => AdminConstants::ADMIN_COMPANY_URL_PLACEHOLDER,
              :hint         => AdminConstants::ADMIN_COMPANY_URL_HINT

      f.input :bookeeping_number,  
              :as          => :string, 
              :hint        => AdminConstants::ADMIN_COMPANY_BOOKEEPING_NO_HINT,
              :placeholder => AdminConstants::ADMIN_COMPANY_BOOKEEPING_NO_DEFAULT

      f.input :PO_required,  
              :as          => :radio, 
              :label       => AdminConstants::ADMIN_C0MPANY_PO_REQUIRED_LABEL

      f.input :credit_terms, 
              :label       => AdminConstants::ADMIN_C0MPANY_CREDIT_TERMS_LABEL,
              :hint        => AdminConstants::ADMIN_C0MPANY_CREDIT_TERMS_HINT,
              :placeholder => AdminConstants::ADMIN_C0MPANY_CREDIT_TERMS_PLACEHOLDER

      f.input :active, 
              :as => :radio
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
    
    f.inputs "Rollodex Items for Company" do
      f.has_many :identifiers do |f|

          f.input :name, 
                  :collection  => %w[Mobile Office Truck Pager FAX Email Skype SMS Twitter URL],
                  :label       => AdminConstants::ADMIN_IDENTIFIER_NAME_LABEL,
                  :hint        => AdminConstants::ADMIN_IDENTIFIER_NAME_HINT

          f.input :value,
                  :label       => AdminConstants::ADMIN_IDENTIFIER_VALUE_LABEL,
                  :hint        => AdminConstants::ADMIN_IDENTIFIER_VALUE_HINT,
                  :placeholder => AdminConstants::ADMIN_IDENTIFIER_VALUE_PLACEHOLDER

          f.input :rank, 
                  :collection  => %w[1 2 3 4 5 6 7 8 9],
                  :label       => AdminConstants::ADMIN_IDENTIFIER_RANK_LABEL,
                  :hint        => AdminConstants::ADMIN_IDENTIFIER_RANK_HINT,
                  :placeholder => AdminConstants::ADMIN_IDENTIFIER_RANK_PLACEHOLDER
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
                :hint => AdminConstants::ADMIN_CERT_EXPIRES_ON_HINT

        f.input :permanent

        f.input :serial_number, 
                :hint => AdminConstants::ADMIN_CERT_SERIAL_NUMBER_HINT

      end
    end
    f.actions
  end
    
  show :title => :display_name do
    attributes_table do
      row :name
      row :line_of_business
      row ("Rollodex") { render company.identifiers}
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
    end

    active_admin_comments

  end


# 
# P U S H  B U T T O N S
#
  # ACTIVATE
  # Activate sets the company status to Active (true).  Does not toggle.
  # 
  action_item :only => [:edit, :show] do
    link_to 'Activate', activate_admin_company_path( company )
  end

  member_action :activate, :method => :get do
    company = Company.find(params[:id])
    company.active = true
    company.save!
    flash[:notice] = AdminConstants::ADMIN_COMPANY_ACTIVE
    redirect_to admin_company_path( company )
  end

end #companies
