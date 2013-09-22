#require 'debugger'
#require 'active_support/core_ext/object/include_blank.rb'
#require 'active_support/core_ext/string/filters'
require 'active_support/all'


ActiveAdmin.register Engagement do
  
  menu :parent => "Operations"
  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Schedule.all.empty?
  #}
  
  belongs_to :person, :optional=>true
  belongs_to :schedule, :optional=>true

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

  
  filter :person
  filter :schedule
  filter :do_not_contact_until
    
  index do 
    column :id

    # http://stackoverflow.com/questions/1192843/grouped-select-in-rails
    # http://stackoverflow.com/questions/9579402/active-admin-refresh-second-drop-down-based-on-first-drop-down-ruby-on-rails
    # http://apidock.com/rails/ActionView/Helpers/FormTagHelper/select_tag
    #  select_tag  :person_id, options_for_select([["A",1],["B",2]]), 
    #            :onchange => "$.post('#{admin_person_path(engagement.contact.id)}', 
    #            {'_method':'put', 'engagement[:person]':this.value} );"

    column "Subbie" do |engagement|
      render engagement
    end

    column "Job" do |engagement|
      link_to engagement.schedule.job.name, admin_engagement_path(engagement.id)
    end

    column "Day" do |engagement|
      engagement.schedule.day.strftime("%d %b, %Y")
    end

    column "Docket" do |engagement|
      link_to "New Docket", new_admin_engagement_docket_path(engagement.id)
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

      f.input :do_not_contact_until, 
              :as => :string, 
              :input_html => {:class => 'datepicker'},
              :hint => "Not available for work/do not contac until this date."
                    
    end
    f.buttons
  end

  show :title => "Engagement" do |engagement|
    attributes_table do
      row :id
      row :schedule
      row :person
      row(:onsite_now) { status_tag (engagement.onsite_now ? "YES" : "No"), (engagement.onsite_now ? :ok : :error) }
      row(:onsite_at)  { status_tag (engagement.onsite_at ? "YES" : "No"), (engagement.onsite_at ? :ok : :error) }
      row(:breakdown) { status_tag (engagement.breakdown ? "YES" : "No"), (engagement.breakdown ? :ok : :error) }        
      row(:no_show) { status_tag (engagement.no_show ? "YES" : "No"), (engagement.no_show ? :ok : :error) }        
      row(:OK_tomorrow) { status_tag (engagement.OK_tomorrow ? "YES" : "No"), (engagement.OK_tomorrow ? :ok : :error) }        
      row(:engagement_declined) { status_tag (engagement.engagement_declined ? "YES" : "No"), (engagement.engagement_declined ? :ok : :error) }        
      row :do_not_contact_until do |engagement|
        engagement.do_not_contact_until
      end
      row :updated_at do |engagement|
        engagement.updated_at
      end
    end
    active_admin_comments
  end #show

   sidebar :context do
     h4 link_to "Dashboard", admin_dashboard_path
     h4 link_to "Dockets", admin_dockets_path
     h4 link_to "Schedules", admin_schedules_path
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
   

controller do
  def permitted_params
      #params.require(:engagement).permit( :OK_tomorrow, :breakdown, :person_id, :contacted_at, :date_next_available,
      #  :engagement_declined, :next_available_day, :no_show, :onsite_at, :onsite_now, :schedule_id,
      #  :do_not_contact_until )
      params.permit(:schedule => [  :OK_tomorrow, :breakdown, :person_id, :contacted_at, :date_next_available,
                                    :engagement_declined, :next_available_day, :no_show,
                                    :onsite_at, :onsite_now, :schedule_id,
                                    :do_not_contact_until 
                                 ] )
    end
  end
 
end
