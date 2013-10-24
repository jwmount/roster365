#require 'debugger'
#require 'active_support/core_ext/object/include_blank.rb'
#require 'active_support/core_ext/string/filters'
require 'active_support/all'


ActiveAdmin.register Engagement do
  
  menu label: "Engagements", parent: "Schedules"
  # belongs_to :schedule
  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Schedule.all.empty?
  #}
  
  belongs_to :person, :optional=>true
    navigation_menu :schedule
  belongs_to :schedule, :optional=>false
    navigation_menu :schedule

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

    column "Engagement", :sortable => :id do |engagement|
      link_to engagement.id, admin_schedule_engagement_path( engagement.schedule, engagement )
    end

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
=begin
    column "Job" do |engagement|
      engagement.schedule.job.name
    end

    column "Day" do |engagement|
      engagement.schedule.day.strftime("%d %b, %Y")
    end
=end
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

    f.inputs "Schedule" do      
      f.input :person, 
              :required=>true, 
              :as => :select, 
              :collection => Person.alphabetically.all.map {|u| [u.display_name, u.id]}, 
              :include_blank => false,
              :hint => "Person you are engaging to work.  Must work for vendor with required equipment."
                        
      f.input :schedule, 
              :hint => "Schedule this person will be on."
              
      #f.input :docket,
      #        :hint => "Booking number from docket. GET THIS WHEN THE DRIVER TELLS YOU THEY ARE ON SITE.",
      #        :placeholder => "00000"
    end
    
    f.inputs "Status" do
      f.input :onsite_now
      
      f.input :onsite_at, 
              :label => 'Onsite soon',
              :hint => "Operator estimates will be at work site within 15 minutes."
              
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
      li link_to "Dockets", admin_dockets_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Engagements Context", only: [:show, :edit] do 
    ul
      li link_to "Engagements", admin_schedule_engagements_path( engagement.schedule )
      li link_to "Schedules",   admin_job_schedules_path(        engagement.schedule.job )
      li link_to "Jobs",        admin_solution_jobs_path(        engagement.schedule.job.solution )
      li link_to "Solutions",   admin_quote_solutions_path(      engagement.schedule.job.solution.quote )
      li link_to "Quotes",      admin_project_quotes_path(       engagement.schedule.job.solution.quote.project )
      li link_to "Projects",    admin_company_projects_path(     engagement.schedule.job.solution.quote.project.company )
      li link_to "Companies",   admin_companies_path
      hr
      li link_to "View Dashboard", admin_dashboard_path
      li link_to "Dockets", admin_dockets_path
  end

#
# P U S H B U T T O N S
#
  action_item :only => [:index, :edit, :show] do
    link_to "Create Docket", admin_dockets_path
  end

   # Action to create the docket.  The Scheduler or User needs to edit the booking_no default given here.
   # Consequently nav goes to edit_admin_engagement_docket_path to support this.
   member_action :docketify, :method => :get do
     engagement = Engagement.find params[:id]
     docket = Docket.new
     docket.booking_no = 'To be Supplied'
     docket.engagement_id = params[:id]
     docket.date_worked = Date.current
     docket.person_id = docket.engagement.person_id
     begin
       docket.save
       flash[:notice] = "Docket has been created."
       redirect_to edit_admin_engagement_docket_path(docket.engagement.id, docket.id) 
     rescue ActiveRecord::RecordNotUnique
       flash[:error] = "Booking number has been taken.  Booking numbers must be unique."
       redirect_to admin_engagement_path(engagement)
     rescue ActiveRecord::StatementInvalid
       flash[:error] = "Docket could not be updated.  You may be missing booking number. Wait until you have it to create a docket."
       redirect_to admin_engagement_path(engagement)
     end
   end  
   
=begin
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

  def engagement_params
      params.permit(:engagement => [ :schedule_id,
                                     :person_id,
                                     :onsite_now,
                                     :onsite_at,
                                     :breakdown,
                                     :no_show,
                                     :OK_tomorrow,
                                     :engagement_declined,
                                     :next_available_day,
                                     :do_not_contact_until,
                                     :contacted_at,
                                     :date_next_available,
                                     :docket_id
                                   ]
                   )
    end
  end
=end 
end
