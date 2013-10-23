#require 'debugger'
#require 'active_support/core_ext/object/include_blank.rb'
#require 'active_support/core_ext/string/filters'
require 'active_support/all'

ActiveAdmin.register Schedule do

  menu label: "Schedules", parent: "Jobs"
  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Job.all.empty?
  #}
  belongs_to :job
    navigation_menu :job
  
  filter :job
  filter :day, :label => "Date Range", :as => :date_range
  filter :equipment
  filter :equipment_units_today


  # View with spreadsheet like extensions 
  index do

    column :day do |schedule|
      schedule.day.strftime("%a %d %b, %Y")
    end

    column "Schedule" do |schedule|
      begin
        link_to schedule.job.name, edit_admin_schedule_path(schedule.id)
      rescue Exception
        flash[:error] = "ERROR:  Job does not exist!"
      end
    end

    column "Rep(s)" do |schedule|
      @rep = schedule.prep
      unless @rep.nil?
        render :partial => "rep", :locals => {:role=>'P', :rep => @rep }
        @identifiers = @rep.identifiers.order(:rank)
        render :partial => 'identifier', :collection => @identifiers
      else
        flash[:warning] = "Project rep not assigned."
      end

      @rep = schedule.qrep
      unless @rep.nil?
        render :partial => "rep", :locals => {:role=>'Q', :rep => @rep}
        @identifiers = @rep.identifiers.order(:rank)
        render :partial => 'identifier', :collection => @identifiers
      end
    end 

    # NOTE:  :partial _address located in views/addresses
    column 'Load Site' do |schedule|
      begin
        @quote = Quote.find schedule.job.solution.quote_id
        @address = @quote.project.addresses.limit(1)
        render @address
      rescue NoMethodError
        @quote = nil
        status_tag("No load site.", :warning)
      end
      
      if @address == []
        flash[:error] = simple_format("At least one schedule has no load site address.")
      end
    end

    column 'Material' do |schedule|
      begin
        @material = schedule.job.solution.material
        render @material

        schedule.job.solution.quote.fire_ants == true ? status_tag('fire ants present', :warning) : 
                                                        status_tag('No fire ants present', :ok)
        render :partial => "material_solution_aspects", 
               :locals => {
                 :material_fee => number_to_currency(schedule.job.solution.pay_equipment_per_unit)
                 }
      rescue NoMethodError
        @material = nil
      end
    end

    column "Tip" do |schedule|
      begin
        @solution = Solution.find schedule.job.solution_id
        tips = @solution.tips
        @tip = tips[0]
        if @tip.blank?
          #highlight(schedule.no_tip_assigned, "No tip assigned.")
          status_tag("No tip assigned.", :warning)
        else
          render @tip
        end
      rescue Exception
        @solution = nil
      end
    end

    column 'Contract' do |schedule|
      begin
        schedule.job.solution.solution_type
      rescue NoMethodError
        'unknown'
      end
    end

    column 'Start Time' do |schedule|
      schedule.day.strftime("%H:%M")
    end

    column 'Equipment' do |schedule|
      begin
        link_to "#{schedule.job.solution.equipment.name}", admin_equipment_path(schedule.job.solution.equipment)
      rescue
        'Not specified'
      end
    end

    column 'Units' do |schedule|
      schedule.equipment_units_today
    end

    column 'Inv/pay' do |schedule|
      begin
        pay_load_client = number_to_currency(schedule.job.solution.pay_load_client)
        invoice_load_client = number_to_currency(schedule.job.solution.invoice_load_client)
        pay_tip_client = number_to_currency(schedule.job.solution.pay_tip_client)
        invoice_tip_client = number_to_currency(schedule.job.solution.invoice_tip_client)
        render :partial => 'invpay', :locals => {
          :pay_load_client => pay_load_client,
          :invoice_load_client => invoice_load_client,
          :pay_tip_client => pay_tip_client,
          :invoice_tip_client => invoice_tip_client
        }
      rescue NoMethodError
        'Not specified'
      end
    end

    column 'Subcontractors' do |schedule|
      #h5 link_to "Roster", admin_schedule_engagements_path(schedule)
      @engagements = schedule.engagements
      @engagements.each do |engagement|

        render engagement
        status_tag('On Site', :ok) if engagement.onsite_now
        status_tag('NO SHOW', :error) if engagement.no_show
        status_tag('Breakdown', :warning) if engagement.breakdown
        status_tag('OK tomorrow', :ok) if engagement.OK_tomorrow
        br
      #br link_to 'New Docket', new_admin_docket_path
      
      end
    end

  end

  form do |f|
    error_panel f

    f.inputs "Daily Roster (Schedule)" do
      f.input :day,
              :as => :string,
              :input_html => {:class => 'datepicker'},
              :required => true, 
              :label=>"Day", 
              :hint => "Day you are scheduling.",
              :placeholder => "Date."  
      f.input :job,
              :hint => 'Job being scheduled.'
      f.input :equipment_units_today,
              :hint => "Number of #{schedule.job.solution.equipment.name}(s) needed on site this date for job."
      f.input :equipment_id, 
              :as => :select, 
              :collection => Equipment.alphabetically.all.map {|u| [u.name, u.id]}, 
              :include_blank => false,
              :hint => "Equipment needed for day you are scheduling."

    end
    f.buttons
  end

  show :title => 'Schedule' do |schedule|
    h3 schedule.day.strftime("%b %m, %Y")
    attributes_table_for(schedule) do
      row :day
      row :job
      row :equipment_units_today                                    
      row ("Equipment") do |schedule|
        puts "***** EQUIPMENT: #{schedule.equipment.name}"
        schedule.equipment.name
      end
      row :updated_at
    end
    active_admin_comments
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Schedule Context", only: [:show, :edit] do 
    ul
      li link_to "Return to #{schedule.job.display_name} Schedule", admin_job_schedule_path( schedule.job, job ) 
      li link_to 'Prepare Engagements', admin_schedule_engagements_path( schedule )   
      hr
      li link_to "View Dashboard", admin_dashboard_path
  end

#
# P U S H  B U T T O N S
#    
  action_item :only => [:edit, :show] do 
    link_to "Engagements",  admin_schedule_engagements_path(schedule)
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

    def schedule_params
      params.require(:schedule).permit( :day, 
                                        :equipment_id, 
                                        :equipment_units_today, 
                                        :job_id  )
    end
  end
=end
end
