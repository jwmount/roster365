#require 'debugger'
#require 'active_support/core_ext/object/include_blank.rb'
#require 'active_support/core_ext/string/filters'
require 'active_support/all'

ActiveAdmin.register Schedule do

  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Job.all.empty?
  #}
  belongs_to :job
  
  filter :job
  filter :day, :label => "Date Range", :as => :date_range
  filter :equipment
  filter :equipment_units_today


  # View with spreadsheet like extensions 
  index do
    selectable_column

    column "Schedule for" do |schedule|
      link_to schedule.day.strftime("%a,%d%b"), 
        edit_admin_company_project_quote_solution_job_schedule_path(
                                    schedule.job.solution.quote.project.company,
                                    schedule.job.solution.quote.project,
                                    schedule.job.solution.quote,
                                    schedule.job.solution,
                                    schedule.job,
                                    schedule)
    end

    column "Job" do |schedule|
      link_to schedule.job.name, admin_solution_job_path(schedule.job.solution, schedule.job)
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
      schedule.job.solution.equipment_name
    end

    column 'Units' do |schedule|
      schedule.equipment_units_today
    end

    column "Roster" do |schedule|
      render schedule.engagements
    end

  end

  form do |f|
    error_panel f

    f.inputs "Schedule details.  Equipment for #{schedule.job.solution.quote.project.company.name}, #{schedule.job.solution.quote.project.name} project." do
      f.input :job,
              :hint => 'Job being scheduled.'

      f.input :day,
              :as => :string,
              :as => :date_picker,
              :required => true, 
              :label=>"Day", 
              :hint => "Day you are scheduling to have the equipment on site.",
              :placeholder => "Date."  
      end      

      f.inputs "Number of #{schedule.job.solution.equipment_name.pluralize} needed on site." do

        f.input :equipment_units_today,
                :placeholder => "#{schedule.equipment_units_today.to_s}",
                :hint => "Number of #{schedule.job.solution.equipment_name.pluralize} needed on site this date for job."
      end
    f.buttons
  end

  show :title => 'Schedule' do |schedule|
    attributes_table_for(schedule) do
      row :day
      row :job
      row :equipment_units_today                                    
      row ("Equipment") do |schedule|
        schedule.job.solution.equipment_name
      end
    end
    active_admin_comments
  end

#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Schedules Context", only: [:index] do 
    ul
      li link_to "Jobs",        admin_solution_jobs_path(        job.solution )
      hr
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Schedule Context", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      br
      li link_to 'Prepare Engagements', #admin_schedule_engagements_path( schedule )   
         admin_company_project_quote_solution_job_schedule_engagements_path(
                                    schedule.job.solution.quote.project.company,
                                    schedule.job.solution.quote.project,
                                    schedule.job.solution.quote,
                                    schedule.job.solution,
                                    schedule.job,
                                    schedule)
      hr
      status_tag('Other things you can see:')
      br      
      li link_to "Schedules",   admin_job_schedules_path(        schedule.job )
      li link_to "Jobs",        admin_solution_jobs_path(        schedule.job.solution )
      li link_to "Solutions",   admin_quote_solutions_path(      schedule.job.solution.quote )
      li link_to "Quotes",      admin_project_quotes_path(       schedule.job.solution.quote.project )
      li link_to "Projects",    admin_company_projects_path(     schedule.job.solution.quote.project.company )
      li link_to "Companies",   admin_companies_path
      hr
      li link_to "View Dashboard", admin_dashboard_path
  end

#
# P U S H  B U T T O N S
#    
  action_item :only => [:show] do
    link_to 'Reserve', '/', #admin_reservations_path,
      :popup => ['Place a reservation','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes']
  end


end
