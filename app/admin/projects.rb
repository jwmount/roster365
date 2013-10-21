#require 'debugger'
ActiveAdmin.register Project do

  menu label: "Projects", :parent => "Sales"
  
  #  Next statement causes nesting correctly but cannot list all projects!  Put that in Dashboard(s)
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

  filter :company
  filter :name
  filter :project_start_on
  filter :intend_to_bid
  filter :submitted_bid
  filter :active

  index do

    column "Name" do |project|
      link_to project.name, admin_company_project_path( project.company, project )
    end
    #column 'Project Name' do |project|
    #  link_to project.name, admin_project_path(project)
    #end

    column :company

    column "Work Site Address" do |project|
      @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Project').limit(1)
      render project.addresses
    end

    # Project may have no rep, or some rep (one); multiple reps not supported so far.
    # Rep is 'us', that is not from the company.project set.  Hence not clear how to link to it.
    column "Rep" do |project|
      flash[:WARNING] = nil
      begin
        @rep  = Person.find project.rep_id
        render :partial => 'person', :locals => {:rep => @rep }
        @identifiers = @rep.identifiers.order(:rank)
        render :partial => 'identifier', :collection => @identifiers
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
              :required => true, 
              :label => 'Project Name', 
              :hint => "Working name of project. NOTE:  if you change a project name, existing resources such as quotes, solutions, jobs etc., continue to use the old name.",
              :placeholder => "Project Name"

      # Scope this collection to employees with title 'Rep'
      # Roster365 is company = Company.where({:name => 'Roster365'})
      # Cleanup:  need a scheme to identify primary company, here 'Roster365' -- in a config file?
      f.input :rep_id, 
              :as => :select,
              collection: Person.alphabetically.where({:company_id => Company.where({:name => 'Roster365'})} && {:title => 'Rep'}), 
              hint: "Our Rep on this project.",
              placeholder: "Person",
              include_blank: false

      f.input :project_start_on, 
              :label => 'Expected start date',
              :as => :string, 
              :input_html => {:class => 'datepicker'},
              :hint => 'Best estimate of when project will start.'

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

    f.inputs "Requirements -- trucks have, people have, sites have" do 
      f.has_many :requirements do |r|
        r.input :requireable_type, 
                :as => :check_boxes,
                :collection => %w[Company Person Equipment Location]
        r.input :certificate
        r.input :description
      end
    end
    
    f.buttons
  end
  
  
  show title: 'Project' do
    panel project.name do
      attributes_table_for(project) do
        rows :company_id,  :project_start_on
        row("Project Rep") do |project|
          begin
            rep = Person.find project.rep_id
            link_to rep.full_name, admin_person_path(rep)
          rescue
            flash["Error:  No Rep assigned to this project."]
          end
        end

      row "Work Site" do |project|
          render project.addresses
      end
      

      row("Active") { status_tag (project.active ? "YES" : "No"), (project.active ? :ok : :error) }
    end
    active_admin_comments
    end
  end

#
# C O N T E X T  -  GIVE USER WAY BACK
#
  sidebar :context do
    link_to "Dashboard", admin_dashboard_path
  end

#
# P U S H B U T T O N S
#
  action_item do |project|
    link_to 'Parent Company', admin_company_path( project.company ) 
  end

  action_item :only => [:show] do
    link_to "Quotes", admin_project_quotes_path( project )
  end

#
# W H I T E L I S T  M A N A G E M E N T
#
  controller do

    def create
      params.permit!
      super
    end

    def update
      params.permit!
      super
    end

    def project_params
      params.require(:project).permit( 
                                       :id,
                                       :active,
                                       :commit, 
                                       :name, 
                                       :rep_id, 
                                       :company_id,
                                       :project_start_on,
                                       :intend_to_bid,
                                       :addresses_attributes [
                                                              :city,
                                                              :state,
                                                              :post_code,
                                                              :map_reference,
                                                              :updated_at
                                                              ],
                                       :requirements_attributes [
                                                              :id,
                                                              :requireable_type,
                                                              :certificate_id,
                                                              :description,
                                                              :updated_at
                                                            ]
                                     )
    end
  end


end
