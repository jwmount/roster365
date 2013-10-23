#require 'debugger'
ActiveAdmin.register Company do

  menu parent: "Customers"
    
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
  filter :MYOB_number
  
  sidebar "Company Details", only: [:show, :edit] do 
    ul do
      li link_to( "Equipment", admin_company_equipment_index_path( company ) )
      li link_to( "People", admin_company_people_path( company ) )
      li link_to( "Projects", admin_company_projects_path( company ) )
    end
  end

  index do
    column "Name (click for details)", :sortable => 'name' do |company|
      h5 link_to company.name, admin_company_path(company)
      if company.identifiers.count > 0
        @identifiers = company.identifiers
        render @identifiers 
      end
      if company.certs.count > 0
        @certs = company.certs
        @certs.each { |cert| render cert.certificate }
      end
    end

    column :projects do |company|
      if company.projects.size > 0
        render company.projects
      else
        link_to "New Project", new_admin_company_project_path( company )
      end
    end

    column :equipment do |company|
      if company.equipment.size > 0 
        render company.equipment
      else
        link_to "Assign", new_admin_company_equipment_path(company)
      end
    end
    
    column :people do |company|
      if company.people.count > 0
        @people = company.people
        render @people
      else
        link_to "Assign", new_admin_company_person_path(company)
      end
    end
    
    column "Bookkeeping No." do |company|
      company.MYOB_number
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
      f.input :MYOB_number,  
              :as => :string, 
              :hint => "Roster365 unique 5 digit account number, or '00000'.",
              :placeholder => "MYOB number"
      f.input :PO_required,  
              :as => :radio, 
              :label => 'Purchase Order Required'
      f.input :credit_terms, 
              :label => 'Credit Terms (Days)', 
              :hint => 'Number of days we will extend credit, if any.',
              :placeholder => 'Days'
      f.input :active, :as => :radio
    end

=begin  doing this based on belongs_to :company statement in Equipment now.
    f.inputs "Equipment" do
      if company.equipment.all.empty?
        "NONE.  Use the Equipment menu to identify it."
      else
        f.input :equipment, :as => :select, 
                            :collection => company.equipment.alphabetically.all.map {|u| [u.name, u.id]}, 
                            :include_blank => false
      end
    end

  #Assign people to companies using People, this way is confusing.
    f.inputs "People" do
      if company.people.empty?
        "NOTE:  Company has no people.  Use the People menu to identify them."
      else
        f.input :people, :as => :select, 
                           :collection => Person.alphabetically.all.map {|u| [u.full_name, u.id]}, 
                           :include_blank => false
      end
    end
=end

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
          f.input :name, :collection => %w[Mobile Office Truck Pager FAX Skype SMS Twitter],
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
        f.input :certificate
        f.input :expires_on, 
                :as => :date_picker,
                :hint => "Expiration date."
        f.input :serial_number, :hint => "Value that makes the certificate unique.  For example, License Number, Rego, etc."
        f.input :permanent
        f.input :active
      end
    end
    f.buttons
  end
    
  show :title => :display_name do
    attributes_table do
      row :name
      row :credit_terms
      row("PO_required") { status_tag (company.PO_required ? "YES" : "No"), (company.PO_required ? :ok : :error) }        
      row("active") { status_tag (company.active ? "YES" : "No"), (company.active ? :ok : :error) }
      row :MYOB_number
      row ("People") {render company.people}
      row ("Projects") { render company.projects}
      row ("Equipment") { render company.equipment}
      row ("Address") { render company.addresses}
      row ("Certifications") { render company.certs}
      row ("Rollodex") { render company.identifiers}
    end

=begin
    
    panel "Address" do
      attributes_table_for company do
        row :address
     end
   end
    # Cert model is polymorphic
    # certifiable_id == who owns it, e.g. Person, Company, Vehicle...
    # certificate_id == what is it, e.g. Driving License, Birth Certificate...
    panel "Certifications & Qualification" do
      attributes_table_for(:company) do
        unless company.certs.any?
          h4 'None'
        else
          certs = company.certs.all.each do |cert|
            row("#{cert.certificate.name}") { cert.certificate.description  +
            (cert.active ? ' Current '  : ' Lapsed or pending').to_s + ', ' +
            (cert.permanent ? ' Permanent ' : ' Temporary ').to_s + ','     +  
            ' Serial_number: ' + cert.serial_number }
          end
        end
      end
    end

    panel "Rollodex" do
      attributes_table_for( :company ) do
        unless company.identifiers.any?
          h4 'Empty'
        else
          company.identifiers.order(:rank).each do |i|
            if i.name.include?("email")
              row("#{i.name} (#{i.rank.ordinalize})") {mail_to "#{i.value}"}
            else
              row("#{i.name} (#{i.rank.ordinalize})") {"#{i.value}"}      
            end
          end
        end
      end
    end
=end
    active_admin_comments

  end

# GOOD Down from here

#
# P U S H  B U T T O N S
#
=begin
  Removed to prefer to use Context definitions

  action_item :only => [:edit, :show] do
    link_to "Equipment", admin_company_equipment_index_path( company )
  end

  action_item :only => [:show] do
    link_to "Projects", admin_company_projects_path( company )
  end

  action_item :only => [:edit, :show] do
    link_to "People", admin_company_people_path( company )
  end
=end
#
# W H I T E  L I S T  M A N A G E M E N T
# 
# R E M O V E D, U N W O R K A B L E!  At least in 4.0.0
# http://stackoverflow.com/questions/13091011/how-to-get-activeadmin-to-work-with-strong-parameters/14511396#14511396
#
=begin
controller do
  
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(new_company_params)
    debugger
    unless Company.where(:name => @company.name).blank?
      if @company.save!
        respond_to do |format|
          format.html { redirect_to admin_companies_path, notice: "Company created successfully." }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_admin_company_path, notice: "Company with that name already exists." }  
      end
    end
  end

  # Update must manage updates to nested models now.  Not nice.  Is this really the way?
  # Need to generalize this to do each nested model as well:
  # -Addresses
  # -Certs
  # -Identifiers
  # -Requirements.
  def update
    unless params[:company][:addresses_attributes].nil?
      @address = Address.find   params[:company][:addresses_attributes]["0"][:id]
      @address.street_address = params[:company][:addresses_attributes]["0"][:street_address]
      @address.city           = params[:company][:addresses_attributes]["0"][:city]
      @address.state          = params[:company][:addresses_attributes]["0"][:state]
      @address.post_code      = params[:company][:addresses_attributes]["0"][:post_code]
      @address.map_reference  = params[:company][:addresses_attributes]["0"][:map_reference]
      @address.save!
    end

    @company = Company.find(params[:id])
    @company.PO_required = params[:company][:PO_required]
    if @company.save!
      respond_to do |format|
        format.html { redirect_to admin_company_path( @company ), notice: "Company edited successfully." }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_admin_company_path, notice: "Company was not updated." }  
      end
    end
  end


  private

  def new_company_params
    params.require(:company).permit( [
                                           :id,
                                           :name,
                                           :MYOB_number,
                                           :PO_required,
                                           :credit_terms,
                                           :active,
                                           :addresses_attributes [
                                                                  :street_address,
                                                                  :city,
                                                                  :state,
                                                                  :post_code,
                                                                  :map_reference
                                                                ]
                                      ]
                                    )
  end

  def company_params
    params.permit!
    return

    params.require(:company).permit(
                   :utf8, 
                   :authenticity_token, 
                   :commit,
                   :name,
                   :id,
                   :active,
                   :credit_terms, 
                   :MYOB_number, 
                   :name, 
                   :PO_required, 
                   :commit,
                                      :addresses_attributes [ 
                                                              :id,
                                                              :street_address,
                                                              :city,
                                                              :state,
                                                              :post_code,
                                                              :map_reference
                                                            ]
                 )
    end
  end
=end
end
