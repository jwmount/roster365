#require 'debugger'
ActiveAdmin.register Project do

  menu label: "Projects"
  
  # NOT OPTIONAL, effect is to scope projects to companies.
  belongs_to :company

  scope :all, :default => true 

  scope :active do |projects|
    projects.where ({active: true})
  end
  scope :in_active do |projects|
    projects.where ({active: false})
  end
  scope :intend_to_bid do |projects|
    projects.where ({intend_to_bid: true})
  end
  scope :submitted_bid do |projects| 
    projects.where ({submitted_bid: true})
  end

  filter :name
  filter :description
  filter :company
#
# C A L L  B A C K S
#
# Warn user if project work site has not been entered.  Fires on #new only.
  before_build do |project|
    flash[:warning] = AdminConstants::ADMIN_COMPANY_INACTIVE unless project.company.active
  end
  
  index do
    selectable_column

    column "Name (click for details)" do |project|
      link_to project.name, admin_company_project_path( project.company, project )
    end

    column :description

    column :company

    column "Work Site Address" do |project|
      @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Project').limit(1)
      render @address #project.addresses
    end

    # Project may have no rep, or some rep (one); multiple reps not supported so far.
    # Rep is a person who is 'us', that is not from the company.project set.  Hence not clear how to link to it.
    column "Rep" do |project|
      flash[:WARNING] = nil
      begin
        @person  = Person.find project.rep_id
        render @person
        @identifiers = @person.identifiers.order(:rank)
        render @identifiers
      rescue ActiveRecord::RecordNotFound
        flash[:WARNING] = highlight(t(:project_missing_rep), "WARNING:")
        'None'
      end
    end

    column "Requirements" do |project|
      @requirements = project.requirements
      render @requirements
    end

    column 'Start Date' do |project|
      project.project_start_on.strftime("%m %b, %Y")
    end
        
    column :intend_to_bid do |project|
      status_tag (project.intend_to_bid ? "YES" : "No"), (project.intend_to_bid ? :ok : :error)      
    end     

    column :submitted_bid do |project|
      status_tag (project.submitted_bid ? "YES" : "No"), (project.submitted_bid ? :ok : :error)      
    end     

    column :active do |project|
      status_tag (project.active ? "YES" : "No"), (project.active ? :ok : :error)      
    end     
    
  end
  
  form do |f|
    error_panel f
    
    f.inputs "#{company.name}" do

      f.input :name, 
              :required       => true, 
              :label          => AdminConstants::ADMIN_PROJECT_NAME_LABEL, 
              :hint           => AdminConstants::ADMIN_PROJECT_NAME_HINT,
              :placeholder    => AdminConstants::ADMIN_PROJECT_NAME_PLACEHOLDER

      # Scope this collection to LICENSEE company employees with title 'Rep'
      f.input :rep_id, 
              :as             => :select,
              :collection     => list_of_reps,
              :hint           => AdminConstants::ADMIN_PROJECT_REP_LABEL,
              include_blank: false

      f.input :project_start_on, 
              :label          => AdminConstants::ADMIN_PROJECT_START_ON_LABEL,
              :as => :date_picker,
              :hint           => AdminConstants::ADMIN_PROJECT_START_ON_HINT

      f.input :description
      f.input :intend_to_bid
      f.input :submitted_bid
      f.input :active

    end

    # NOTE:  if project is active, work address becomes required or will raise an error later in solutions.
    f.inputs "Project Work Site Address" do
        f.has_many :addresses do |a|
          a.input :street_address
          a.input :city
          a.input :state
          a.input :post_code
          a.input :map_reference
        end
    end

=begin
    # NOTE:  Project requirements, e.g. 'Aluminum Body'
    f.inputs "Required Equipment Certificates and Characteristics" do

      f.has_many :requirements do |f|

        f.input :certificate, 
                :collection       => Certificate.where({for_equipment: true}),
                :include_blank    => false,
                :hint             => AdminConstants::ADMIN_SOLUTION_EQUIPMENT_CERTIFICATE_HINT
      end
    end
=end

    # NOTE:  Project OWNER expresses requirements, e.g. 'CA Drivers License', and 'Legal Resident'
    # for_*, * = [people, companies, locations, equipment]
    # It is not an error for there to be no requirements expressed.
    f.inputs "Required Certificates and Characteristics" do

      f.has_many :requirements do |f|

        f.input :certificate, 
                :collection       => project.requirements_list,
                :include_blank    => false,
                :hint             => AdminConstants::ADMIN_SOLUTION_EQUIPMENT_CERTIFICATE_HINT
        f.input :for_company
        f.input :for_equipment
        f.input :for_location
        f.input :for_person
        f.input :description
      end
    end
    
    f.actions
  end
  
  
  show title: 'Project' do
    panel project.name do
      attributes_table_for(project) do
        row :company_id
        row :project_start_on
        row("Project Rep") do |project|   #NOTE:  not DRY, same as for :index column.
          @rep  = Person.find project.rep_id
          render @rep 
          render @rep.identifiers
        end

      row "Work Site" do |project|
          render project.addresses
      end
      
      row :description

      row "Requirements" do |project|
        render project.requirements
      end

      row("Active") { status_tag (project.active ? "YES" : "No"), (project.active ? :ok : :error) }
    end
    active_admin_comments
    end
  end

#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Project list Context", only: [:index] do 
    ul
      li link_to "Companies", admin_companies_path
      hr
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Project Context", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      hr
      #li link_to 'Create a new Quote', new_admin_company_project_quote_path( project.company, project )     
      li link_to 'Do Quotes', admin_company_project_quotes_path( project.company, project )     
      hr
      status_tag('Other things you can do:')
      hr
      li link_to "Visit the Dashboard", admin_dashboard_path
      li link_to "Manage Conditions", admin_conditions_path
      li link_to "Manage Materials", admin_materials_path
      li link_to "Manage Tip Sites", admin_tips_path
  end

end
