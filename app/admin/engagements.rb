#require 'debugger'
#require 'active_support/core_ext/object/include_blank.rb'
#require 'active_support/core_ext/string/filters'
require 'active_support/all'


ActiveAdmin.register Engagement do


  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Schedule.all.empty?
  #}
  
  belongs_to :person, :optional=>true
  belongs_to :schedule, :optional=>false

  scope :all, :default => true
  scope :onsite_now do |engagements|
    engagements.where ({onsite_now: true})
  end    
  scope :breakdown do |engagements|
    engagements.where ({breakdown: true})
  end    
  scope :no_show do |engagements|
    engagements.where ({no_show: true})
  end    
  scope :OK_tomorrow do |engagements|
    engagements.where ({OK_tomorrow: true})
  end    
  scope :engagement_declined do |engagements|
    engagements.where ({engagement_declined: true})
  end    

  index do 
   
    # http://stackoverflow.com/questions/1192843/grouped-select-in-rails
    # http://stackoverflow.com/questions/9579402/active-admin-refresh-second-drop-down-based-on-first-drop-down-ruby-on-rails
    # http://apidock.com/rails/ActionView/Helpers/FormTagHelper/select_tag
    #  select_tag  :person_id, options_for_select([["A",1],["B",2]]), 
    #            :onchange => "$.post('#{admin_person_path(engagement.contact.id)}', 
    #            {'_method':'put', 'engagement[:person]':this.value} );"

    column "Engagement Day", :sortable => :id do |engagement|
       link_to engagement.schedule.day.strftime("%d %b, %Y"), 
           admin_company_project_quote_solution_job_schedule_engagement_path( 
            engagement.schedule.job.solution.quote.project.company, 
            engagement.schedule.job.solution.quote.project, 
            engagement.schedule.job.solution.quote, 
            engagement.schedule.job.solution, 
            engagement.schedule.job, 
            engagement.schedule, 
            engagement 
            )
    end
    selectable_column

    column "Subbie" do |engagement|
      render engagement.person
      if engagement.person.identifiers.count > 0
        @identifiers = engagement.person.identifiers
        render @identifiers 
      end
      if engagement.person.certs.count > 0
        @certs = engagement.person.certs
        render @certs
      end
    end

    column "Equipment" do |engagement|
      engagement.schedule.job.solution.equipment_name
    end
    
    column "Job" do |engagement|
      engagement.schedule.job.name
    end

    column "Docket(s)" do |engagement|
      render engagement.dockets
    end   

    column :onsite_now do |engagement|
      status_tag (engagement.onsite_now ? "YES" : "No"), (engagement.onsite_now ? :ok : :error)      
    end     

    column :no_show do |engagement|
      status_tag (engagement.no_show ? "YES" : "No"), (engagement.no_show ? :ok : :error)      
    end     

    column :breakdown do |engagement|
      status_tag (engagement.breakdown ? "YES" : "No"), (engagement.breakdown ? :ok : :error)      
    end     

    column :OK_tomorrow do |engagement|
      status_tag (engagement.OK_tomorrow ? "YES" : "No"), (engagement.OK_tomorrow ? :ok : :error)      
    end     

  end

  form do |f|
    error_panel f

    f.inputs "Schedule:  #{schedule.display_name}" do      

      #  STILL NEED TO SCOPE THIS COLLECTION TO PEOPLE IN COMPANIES WITH THE REQUIRED EQUIPMENT
      f.input :person, 
              :required         => true, 
              :as               => :select, 
              :collection       => engagement.people_with_equipment_required, 
              :include_blank    => false,
              :hint             => AdminConstants::ADMIN_ENGAGEMENT_PERSON_HINT + "#{engagement.schedule.job.solution.equipment_name.pluralize}."
                        
      #f.input :schedule, 
      #        :hint => "Schedule this person will be on."
              
      f.input :docket_number,
              :required         => true, 
              :hint             => AdminConstants::ADMIN_ENGAGEMENT_DOCKET_NUMBER_HINT,
              :placeholder      => "00000"
    end
    
    f.inputs "Status" do
      f.input :onsite_now
      
      f.input :onsite_at, 
              :label           => 'Onsite soon',
              :hint             => AdminConstants::ADMIN_ENGAGEMENT_ONSITE_AT_HINT
              
      f.input :breakdown
      
      f.input :no_show
      
      f.input :OK_tomorrow
      
      f.input :engagement_declined

    end
    f.buttons
  end

  show :title => "Engagement" do |engagement|
    attributes_table do
      row("Day") { engagement.schedule.day }
      row("Project") { schedule.job.solution.quote.project.name }
      row :person
      row :docket_number
      row(:onsite_now) { status_tag (engagement.onsite_now ? "YES" : "No"), (engagement.onsite_now ? :ok : :error) }
      row(:onsite_at)  { status_tag (engagement.onsite_at ? "YES" : "No"), (engagement.onsite_at ? :ok : :error) }
      row(:breakdown) { status_tag (engagement.breakdown ? "YES" : "No"), (engagement.breakdown ? :ok : :error) }        
      row(:no_show) { status_tag (engagement.no_show ? "YES" : "No"), (engagement.no_show ? :ok : :error) }        
      row(:OK_tomorrow) { status_tag (engagement.OK_tomorrow ? "YES" : "No"), (engagement.OK_tomorrow ? :ok : :error) }        
      row(:engagement_declined) { status_tag (engagement.engagement_declined ? "YES" : "No"), (engagement.engagement_declined ? :ok : :error) }        
      row :updated_at
    end
    active_admin_comments
  end #show

#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Engagement Context", only: [:index] do 
    ul
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Engagements Context", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      hr
      li link_to "Make a new Engagement", 
           new_admin_company_project_quote_solution_job_schedule_engagement_path( 
            engagement.schedule.job.solution.quote.project.company, 
            engagement.schedule.job.solution.quote.project, 
            engagement.schedule.job.solution.quote, 
            engagement.schedule.job.solution, 
            engagement.schedule.job, 
            engagement.schedule
            )
      hr
      status_tag('Other things you can do:')
      hr
      li link_to "Dockets", admin_engagement_dockets_path(engagement)
      li link_to "View Dashboard", admin_dashboard_path
      hr
      li link_to "Manage Conditions", admin_conditions_path
      li link_to "Manage Materials", admin_materials_path
      li link_to "Manage Tip Sites", admin_tips_path
  end

#
# P U S H B U T T O N S
#
  action_item :only => [:index, :show] do
    link_to 'List reservations', admin_reservations_path
  end

  action_item :only => [:edit, :show] do
    link_to "Create Docket",    
       new_admin_company_project_quote_solution_job_schedule_engagement_docket_path( 
            engagement.schedule.job.solution.quote.project.company, 
            engagement.schedule.job.solution.quote.project, 
            engagement.schedule.job.solution.quote, 
            engagement.schedule.job.solution, 
            engagement.schedule.job, 
            engagement.schedule, 
            engagement 
         )  
  end


end
