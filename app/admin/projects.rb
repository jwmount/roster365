ActiveAdmin.register Project do

  menu parent: "Sales"  
  #menu :parent => "Sales", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Company.all.empty? &&
  #  !Person.all.empty?
  #}
  
  
#  Causes nesting correctly but cannot list all projects!
#  belongs_to :company, :optional=>false

  scope :all, :default => true 
  scope :active do |projects|
    projects.where ({active: true})
  end
  scope :in_active do |projects|
    projects.where ({active: false})
  end


  index do
    column 'Project Name' do |project|
      link_to project.name, admin_project_path(project)
    end

    column "Address" do |project|
      @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Project').limit(1)
      render project.addresses
    end

    column :company_id do |project|
      link_to project.company.name, admin_company_path(project.company)
    end

    column "Rep" do |project|
      begin
        flash[:WARNING] = nil
        rep = Person.find project.rep_id
        link_to rep.full_name, admin_person_path(rep.id)
      rescue ActiveRecord::RecordNotFound
        flash[:WARNING] = highlight(t(:project_missing_rep), "WARNING:")
      end
    end

    column 'Quotes(#)' do |project|
      quote_count = project.quotes.size
      link_to "Quotes (#{quote_count})", admin_project_quotes_path(project.id)
    end

    column 'Start Date' do |project|
      project.project_start_on.strftime("%m %b, %Y")
    end
        
    column :active do |project|
      status_tag (project.active ? "YES" : "No"), (project.active ? :ok : :error)      
    end     
    
  end
  
  form do |f|
    error_panel f
    
    f.inputs do
      f.input :name, 
              :required => true, 
              :label => 'Project Name', 
              :hint => "Working name of project. NOTE:  if you change a project name, existing resources such as quotes, solutions, jobs etc., continue to use the old name.",
              :placeholder => "Project Name"

      # Scope this collection to employees with title 'Rep'
      # Roster365 is company = Company.where({:name => 'Roster365'})
      # Cleanup:  need a scheme to identify primary company, here 'Roster365' -- in a config file?
      f.input :rep_id, :as => :select,
              collection: Person.alphabetically.where({:company_id => Company.where({:name => 'Roster365'})} && {:title => 'Rep'}), 
              hint: "Our Rep on this project.",
              placeholder: "Person",
              include_blank: true

      f.input :company, 
              :required => true,
              :hint => "Our customer name as it appears on our statements. If the name does not appear in this list, create the company and then define the project.", 
              :input_html => {"data-placeholder" => "Select a Company...", :style=> "width:500px", 
              :class => "chzn-select"},
              :placeholder => "Company"
 
      f.input :project_start_on, 
              :label => 'Expected start date',
              :as => :string, 
              :input_html => {:class => 'datepicker'},
              :hint => 'Best estimate of when project will start.'

      f.has_many :addresses do |a|
        a.input :street_address
        a.input :city
        a.input :state
        a.input :post_code
        a.input :map_reference
      end

      f.input :active, :as => :radio, :hint => "Check if the customer has given us a definite start work order."
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
          rescue ActiveRecord::RecordNotFound
            flash["Error:  No Rep assigned to this project."]
          end
        end

    #panel "Address" do
      attributes_table_for project do
        row "Address" do |project|
          @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Project').limit(1)
          render project.addresses
        end
     end
        row("Active") { status_tag (project.active ? "YES" : "No"), (project.active ? :ok : :error) }
      end
      active_admin_comments
    end
  end

#  Incompatible with nesting via belongs_to :company
  sidebar :context do
    h4 link_to "Projects", admin_projects_path
  end

  action_item :only => [:edit, :show] do
    link_to "Quotes", admin_project_quotes_path( project.id )
  end

end
