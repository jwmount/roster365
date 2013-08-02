#require 'debugger'
#require 'active_support/core_ext/object/include_blank.rb'
#require 'active_support/core_ext/string/filters'
require 'active_support/all'

ActiveAdmin.register Schedule do

  menu parent: "Operations"
  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Job.all.empty?
  #}
  
  filter :day, :label => "Date Range", :as => :date_range
  filter :job
#  filter :equipment_units_today


  # View with spreadsheet like extensions 
  index do

    column :day do |schedule|
      schedule.day.strftime("%a %d %b, %Y")
    end

    column "Schedule" do |schedule|
      link_to schedule.job.name, edit_admin_schedule_path(schedule.id)
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
      rescue ActiveRecord::RecordNotFound
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
        'unknown'
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
        'unknown'
      end
    end

    column 'Dockets' do |schedule|      
      @dockets = []
      engagements = schedule.engagements
      engagements.each do |e|
        @dockets << Docket.where("engagement_id = ?", e.id)
      end
      @dockets.each { |docket| render docket }
    end

    column 'Subcontractors' do |schedule|
      h5 link_to "Roster", admin_schedule_engagements_path(schedule)
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

  
  show :title => 'Schedule' do |schedule|
    h3 schedule.day.strftime("%b %m, %Y")
    attributes_table_for(schedule) do
      row :day
      row :job
      row :equipment_units_today
      row ('Equipment') {link_to "#{schedule.job.solution.equipment.name}", 
                                    admin_equipment_path(schedule.job.solution.equipment)}
      row :updated_at
    end
    active_admin_comments
  end

  sidebar :context do
    h4 link_to "Dashboard", admin_dashboard_path
  end
  
  sidebar :job, :except => [:index, :new] do |job|
    job = Job.find schedule.job
    #link_to "#{job.name}",
        #admin_project_quote_solution_path(job.solution.quote.project.id, job.solution.quote.id, job.solution.id)
  end
  
#  action_item :only => [:index] do
#    link_to "Manage Rosters",  roster_admin_schedule_path(1)
#  end

#  member_action :roster, :method => :get do
#    @companies = Company.all
#    render @companies, :layout => 'application'
#  end    


  controller do
    def permitted_params
      params.require(:schedule).permit( :day, :equipment_id, :equipment_units_today, :job_id ) 
    end
  end

end
