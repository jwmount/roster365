#require 'debugger'
ActiveAdmin.register Company do
  
  menu parent: "Admin"
  
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

  
  index do
    column :name do |company|
      h5 link_to company.name, admin_company_path(company)
      if company.certs.count > 0
        @certs = company.certs
        @certs.each {|cert| render cert.certificate}
      end
      if company.people.count > 0
        @people = company.people
        render @people
      end
    end

    column :projects do |company|
      project_count = company.projects.size
      if project_count == 0
        nil
      else
#        link_to "Projects (#{project_count})", admin_company_projects_path(company)
         project_count.to_s
      end
    end
    
    column :people do |company|
      person_count = company.people.size
      if person_count == 0
        nil
      else
#        link_to "People (#{person_count})", admin_company_people_path(company)
        person_count.to_s
      end
    end
    column :MYOB_number
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

    f.inputs "Equipment" do
      if company.equipment.all.empty?
        "NOTE:  Company has no Equipment.  Use the Equipment menu to identify it."
      else
        f.input :equipment, :as => :select, 
                            :collection => company.equipment.alphabetically.all.map {|u| [u.name, u.id]}, 
                            :include_blank => false
      end
    end

    f.inputs "People" do
      if company.people.empty?
        "NOTE:  Company has no people.  Use the People menu to identify them."
      else
        f.input :people, :as => :select, 
                           :collection => Person.alphabetically.all.map {|u| [u.full_name, u.id]}, 
                           :include_blank => false
      end
    end
    
    f.inputs "Address" do
      f.has_many :addresses do |a|
        a.inputs do
          a.input :street_address
          a.input :city
          a.input :state
          a.input :post_code
          a.input :map_reference
        end
      end
    end
    
    f.inputs "Rollodex Items for Company" do
      f.has_many :identifiers do |f|
          f.input :name, :collection => %w[Mobile Office Truck Pager FAX Skype SMS Twitter],
                  :label => 'Type or kind*',
                  :hint => 'Kind of device or way to communicate with this Person.  Cannot be blank.'
          f.input :value,
                  :label => 'Number, address, etc.',
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
        f.input :expires_on, :input_html => {:class => 'datepicker'},
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
    end

    panel "People" do
      attributes_table_for( company ) do
        unless company.people.any?
          h4 'WARNING:  No people defined for this company.  You must create at least one contact before you create the company.'
        else
          company.people.alphabetically.all.each do |contact|
            row ('Name') {link_to (contact.first_name + ' ' + contact.last_name + ', ' + contact.title),
              admin_person_path(contact)}
          end
        end
      end
    end

    panel 'Projects' do
      attributes_table_for(company) do
        unless company.projects.any?
          h4 'There are no projects'
        else
          company.projects.alphabetically.all.each do |project|
            row ('Name') {link_to (project.name), admin_project_path(project)}
          end
        end
      end
    end
    panel "Address" do
      attributes_table_for company do
        row :address
     end
   end

    # Cert model is polymorphic
    # certifiable_id == who owns it, e.g. Person, Company, Vehicle...
    # certificate_id == what is it, e.g. Driving License, Birth Certificate...
    panel "Certifications" do
      attributes_table_for(company) do
        unless company.certs.any?
          h4 'Empty'
        else
          certs = company.certs.all.each do |cert|
            row("#{cert.certificate.name}") {cert.certificate.description}
          end
        end
      end
    end

    panel "Rollodex" do
      attributes_table_for( company ) do
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
        
    panel "Equipment" do
      attributes_table_for( company ) do
        if company.equipment.empty?
          h4 'There is no equipment for this company.'
        else
          company.equipment.alphabetically.all.each do |equipment|
            certs = []
            equipment.certs.each do |cert|
              certs << cert.certificate.name
            end
            certs_list = certs.join(", ")
            row ("#{equipment.name}") {certs_list}
          end
        end
      end
    end
                  

  end

  action_item :only => [:edit, :show] do
    link_to "New Project", new_admin_company_project_path( company )
  end
  
  member_action :print, :method => :get do
    @company = Company.find(params[:id])
    @revision = params    render "print", :layout => "print"
  end  

  sidebar :context do
    h4 link_to "Projects", admin_projects_path
  end

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 controller do
   def create_company_params
     debugger
     params.require(:company).permit( :name, :MYOB_number, :PO_required, :credit_terms, :active )
   end

   def update_company_params
     params.require(:company).permit(:name, :MYOB_number, :PO_required, :credit_terms, :active )
   end
   
  end
     
end
