#require 'debugger'

# SolutionTips is HABTM join, action_on_permitted_parameters allows this to work 
# Not entirely clear on this!  Also this probably applies to all models, take care.
# Reference: http://api.rubyonrails.org/classes/ActionController/Parameters.html 
ActionController::Parameters.action_on_unpermitted_parameters = :raise

ActiveAdmin.register Solution do
   
   menu false 

  
   scope :all, :default => true
   scope :approved do |solutions|
     solutions.where ({approved: true})
   end    
   scope :client_approved do |solutions|
     solutions.where ({client_approved: true})
   end    
   scope :semis_permitted do |solutions|
     solutions.where ({semis_permitted: true})
   end    
  
  # Interesting note
  # "Total is %<total>.02f" % {:total => 43.1}  # => Total is 43.10

  controller do
    # Breadcrumbs for CRUD ops, e.g. Edit does not generate complete paths without nested_belongs_to :project
    nested_belongs_to :project
    nested_belongs_to :quote

    before_action :check_approval, :only => [:edit, :update]
          
    # Remember:  redirect_to include admin_project_*_path or breadcrumbs will be invalid.  
    def check_approval
       solution = Solution.find params[:id]
       if solution
         if solution.approved
           flash[:warning] = "Solution cannot be changed because it has final approval.  You can Copy it and edit that one."
           redirect_to admin_project_quote_solution_path(solution.quote.project.id,solution.quote.id, solution.id)
         end
       end
    end
   
   end #controller

   after_build do |solution|
     solution.generate_name
   end

  index do 

    column :name do |solution|
      link_to "Solution #{solution.name}", admin_project_quote_solution_path(solution.quote.project.id, solution.quote.id, solution.id),
               :class => "member_link"
    end

    column :solution_type
    
    #HACK -- singleton site enforced in a posssibly risky way!  Are there ever more than one?
    column "Tip Site" do |solution|
      if solution.tips.count == 0
        status_tag( "No tip site assigned.", :error)
      else
        @tip = solution.tips.limit(1)
        render @tip
      end
    end
    
    column :equipment_units_required_per_day, :label => 'Units/day'
    
    column :approved do |solution|
      status_tag (solution.approved ? "YES" : "No"), (solution.approved ? :ok : :error)      
    end       
    
    column :client_approved do |solution|
      status_tag (solution.client_approved ? "YES" : "No"), (solution.client_approved ? :ok : :error)      
    end       
    
    column :semis_permitted do |solution|
      status_tag (solution.semis_permitted ? "YES" : "No"), (solution.semis_permitted ? :ok : :error)      
    end       
    
    column 'Jobs' do |solution|
      @jobs = solution.jobs
      @jobs.each do |job|
        render job
        status_tag('Active', :ok) if job.active
        if solution.purchase_order_required
          status_tag("Purchase Order: #{job.purchase_order}", :warning) 
        end
        simple_format("<hr/>")
      end
    end
  
  end #index


#  sidebar :calculate, :only => [:new, :edit]
  sidebar :Solutions do |solution|
    h4 link_to "Solutions", admin_project_quote_solutions_path(solution.quote.project.id,solution.quote.id)
  end
  sidebar :Quote do |solution|
    h4 link_to "#{solution.quote.name}", admin_project_quote_path(solution.quote.project.id,solution.quote)
  end
  sidebar :Project do |solution|
    h4 link_to "Project: #{solution.quote.project.display_name}", admin_project_path(solution.quote.project.id)
  end

# Use conditional validations to determine if input is complete for a given contract type.
# At this time if contract type is not given, nothing is required.
form do |f|
  error_panel f

    f.inputs "Approvals" do
      f.input :approved, :as => :radio, :hint => 'Once approved solutions cannot be changed.'
      f.input :client_approved, :as => :radio, :hint => 'Once approved solutions cannot be changed.'
      f.input :updated_at, :disabled => true, :hint => "Last updated timestamp; blank if New Solution."
    end
    
    f.inputs "Solution Details" do 
      f.input :name, 
              :input_html => {:disabled => true },
              :hint => "Name is pre-assigned.  Fully qualified name will be used for scheduling."

      f.input :solution_type,
                            :label => 'Contract type',
                             :hint => "Type of solution this is.", 
                             :as=>:select, 
                             :include_blank => true,
                             :collection => solution_type_options,
                             :input_html => {"data-placeholder" => "Solution Type ...", 
                             :style=> "width:200px", 
                             :class => "chzn-select"}
                             
      f.input :material_id, :as => :select, 
                            :label => 'Material', 
                            :hint => "What kind material will be moved.", 
                            :collection => Material.all
                            
      f.input :unit_of_material, as:         :select, 
                                 label:      "Unit of Material", 
                                 hint:       "Unit that is basis for our price.", 
                                 collection: %w[m3 tonne 'hourly hire' loads]

      f.input :total_material, hint:     "How much material will be moved in this solution."

    end
    
    f.inputs "Tip Site (Choose one)" do
      f.input :tips, :as => :check_boxes, :collection => Tip.alphabetically.all.map {|u| [u.name, u.id]}

       end

    f.inputs "Time & Distance" do
      f.input :kms_one_way,
              :placeholder => "distance"    
              
      f.input :loads_per_day,
              :placeholder => "number of loads"    
      
      f.input :drive_time_into_site,
              :placeholder => "minutes"
              
      f.input :load_time,
              :placeholder => "minutes"
      
      f.input :drive_time_out_of_site,
              :placeholder => "minutes"
              
      f.input :drive_time_from_load_to_tip,
              :placeholder => "minutes"
              
      f.input :drive_time_tip_to_load,
              :placeholder => "minutes"
              
      f.input :drive_time_into_tip,
              :placeholder => "minutes"
              
      f.input :unload_time,
              :placeholder => "minutes"
              
      f.input :drive_time_out_of_tip_site,
              :placeholder => "minutes"
              
    end

    f.inputs "Required Equipment Certificates and Characteristics" do
      f.has_many :requirements do |f|
        f.input :certificate, :hint => "If the requirement is not listed, use the Certificate menu to create it."
      end
    end
    
    f.inputs "Equipment" do 
      # At Quote time equipment vendor not generally known... pick this up later in Scheduling
      # Once this is firmly established, do a migration to remove vendor_id from model.
      #f.input :vendor_id, :as => :select, :label => 'Equipment Vendor', required: true, 
      #                     :hint => "Subcontractor or Supplier of the equipment.  To search for equipment use the Equipment menu.", 
      #                     :collection => Company.all, :input_html => {"data-placeholder" => "Select Partner Company ...", :style=> "width:200px", 
      #                     :class => "chzn-select"}
      f.input :semis_permitted, 
              :as => :radio

      f.input :equipment_id, 
              :as => :select, 
              :collection => Equipment.alphabetically.all.map {|u| [u.name, u.id]}, 
              :include_blank => false,
              :hint => "Equipment for this solution.  To search for equipment use the Equipment menu."
                           
      f.input :purchase_order_required, 
              :as => :radio, 
              :hint => "ALERT:  #{solution.quote.project.company.name} may require a purchase order before a job is activated."                                 

      f.input :equipment_units_required_per_day,
              :hint => "How many we expect to have on site each day."

      f.input :equipment_dollars_per_day,
              :precision => 8, 
              :scale => 2,
              :placeholder => "usually 1250 or 750...",
              :hint => 'Total daily payment target amount.'
    end
    

    f.inputs "Pricing" do
      f.input :invoice_load_client,
              :precision => 8, :scale => 2,
              :placeholder => '00.00'

      f.input :pay_load_client,
              :precision => 8, :scale => 2,
              :placeholder => '00.00'

      f.input :invoice_tip_client,
              :precision => 8, :scale => 2,
              :placeholder => '00.00'

      f.input :pay_tip_client,
              :precision => 8, :scale => 2,
              :placeholder => '00.00'
              
      f.input :pay_equipment_per_unit,  
              :precision => 8, 
              :scale => 2

      f.input :pay_tolls,  
              :precision => 8, 
              :scale => 2

      f.input :pay_tip,  
              :precision => 8, 
              :scale => 2

      f.input :hourly_hire_rate, 
              :precision => 8, 
              :scale => 2

    end    
    f.buttons
  end
  
  show :title => :name do |s|
    attributes_table do
      row :name
      row :solution_type
      row :tip_site
      row :updated_at
      row("Roster365 Approved") { status_tag (solution.approved ? "YES" : "No"), (solution.approved ? :ok : :error) }        
      row("Client Approved") { status_tag (solution.client_approved ? "YES" : "No"), (solution.client_approved ? :ok : :error) }        
      row :material
      row(:total_material) { "#{solution.total_material} #{solution.unit_of_material}"}
      row (:purchase_order_required) { status_tag (solution.purchase_order_required ? "YES" : "No"), (solution.purchase_order_required ? :ok : :error) }
    end

    panel "Requirements" do
      attributes_table_for solution do
        solution.requirements.each do |s|
          row ("#{s.certificate.name}") { s.certificate.description }
        end
      end
    end

    panel "Vendor & Equipment" do
      attributes_table_for solution do
        rows :equipment, :equipment_units_required_per_day
        row( 'equipment_dollars_per_day') {number_to_currency(solution.equipment_dollars_per_day)}
        row(:semis_permitted) { status_tag (solution.semis_permitted ? "YES" : "No"), (solution.semis_permitted ? :ok : :error) }        
      end
    end

    panel 'Time and Distance' do
      attributes_table_for solution do
        rows :kms_one_way, :loads_per_day, :drive_time_into_site, :load_time, :drive_time_out_of_site,
           :drive_time_from_load_to_tip, :drive_time_tip_to_load, :drive_time_into_tip, :unload_time,
           :drive_time_out_of_tip_site
      end
    end
    
    panel 'Pricing' do
      attributes_table_for solution do
        row('Invoice Load Client') {number_to_currency(solution.invoice_load_client)}
        row('Pay Load Client') {number_to_currency(solution.pay_load_client)}
        row('Invoice Tip Client') {number_to_currency(solution.invoice_tip_client)}
        row('Pay Tip Client') {number_to_currency(solution.pay_tip_client)}
        row('pay_equipment_per_unit') {number_to_currency(solution.pay_equipment_per_unit)}
        row('pay_tolls') {number_to_currency(solution.pay_tolls)}
        row('pay_tip') {number_to_currency(solution.pay_tip)}
        row('PAY EQUIPMENT PER UNIT') {number_to_currency(solution.pay_equipment_per_unit)}
        row('Hourly Hire Rate') {number_to_currency(solution.hourly_hire_rate)}
      end
    end
  end
  
  action_item :only => [:edit, :show] do
    link_to 'Costing', costing_admin_solution_path( solution.id ),
      :confirm => 'question?',
      :popup => ['Costing','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes']
  end

  member_action :costing, :method => :get do
    @solution = Solution.find(params[:id])
    flash[:notice] = "Costing was popped."
    flash[:notice] << " Price was $1250.00."
    redirect_to admin_project_quote_solutions_path(@solution.quote.project.id,@solution.quote.id)
  end

  action_item :only => [:show] do
    link_to 'Copy', duplicate_admin_solution_path( solution.id )
  end

  # Copy solution to new one
  # Get the original solution selected and dup the new one from it
  # Assign @solution.id = Solution.count + 1
  member_action :duplicate, :method => :get do
    #@original = Solution.includes(:quote).find(params[:id])
    @original = Solution.find(params[:id])
    @solution_new = @original.dup
    @solution_last = Solution.last

    # name = "S" + number of solutions in this quote -- this seems clumsy, why?
    quote = Quote.find @original.quote_id
    n = quote.solutions.count + 1
    @solution_new.name = "S" + n.to_s
    @solution_new.approved = false
    
    # SOLUTION_TIPS ASSOCIATION 
    # If validated for prescence of will cause this to fail as the association is NOT managed by .dup.
    # Currently it is commeted out in solution.rb.  This may impact the copy quote operation in quotes.rb.
    begin
      @solution_new.save
      flash[:notice] = "A copy of solution was created."
    rescue
      flash[:error] = "A copy of solution could NOT be created."
    end

    redirect_to admin_quote_solutions_path(@solution_new.quote.id)
  end    
  
  # needed because you have to create a Job in the context of its solution.
  # do not allow New operation in jobs.rb.
  action_item :only => [:edit, :show] do
   # link_to 'Jobs', admin_project_quote_solution_jobs_path( solution.quote.project.id, solution.quote.id, solution.id ) 
    link_to 'New Job', jobify_admin_solution_path(solution.id)
  end

  member_action :jobify, :method => :get do
    @solution = Solution.find(params[:id])
    name = "#{@solution.quote.project.name} - #{@solution.quote.name} - #{@solution.name} - J#{@solution.jobs.count+1}"
    if @solution.has_final_approval?
      if @solution.purchase_order_required == true
        @job = Job.create!(
          :name => name, 
          :solution_id => @solution.id, 
          :purchase_order => 'PO required',
          :start_on => Date.today,
          :time => '06:30'
          )
      else
        @job = Job.create!(
          :name => name, 
          :solution_id => @solution.id,
          :purchase_order => 'Not required',
          :start_on => Date.today,
          :time => '06:30'
          )
      end
      flash[:notice] = "Job was successfully created"
      #redirect_to admin_project_quote_solution_job_path(@solution.quote.project.id, @solution.quote.id, @solution, @job)
      redirect_to admin_project_quote_solutions_path(@solution.quote.project.id, @solution.quote.id)
    else
      flash[:alert] = "Solution needs to be approved before a job can be created"
      redirect_to admin_project_quote_solution_path(@solution.quote.project, @solution.quote, @solution)
    end
  end

# http://api.rubyonrails.org/classes/ActionController/Parameters.html
# http://guides.rubyonrails.org/action_controller_overview.html#more-examples
# http://stackoverflow.com/questions/13091011/how-to-get-activeadmin-to-work-with-strong-parameters
# You can't use require() when calling new since root key does not exist yet.  Duh.  However
# this approach is DANGEROUS as it defeats the whitelisting altogether.
  controller do

    def create
      params.permit!
      super
    end

    def solution_params
      begin
        params.permit(:solution => [
                                        :approved,
                                        :client_approved,
                                        :drive_time_from_load_to_tip,
                                        :drive_time_into_site, 
                                        :drive_time_into_tip, 
                                        :drive_time_out_of_site,
                                        :drive_time_out_of_tip_site,
                                        :drive_time_tip_to_load,
                                        :equipment_dollars_per_day, 
                                        :equipment_id, 
                                        :equipment_units_required_per_day,
                                        :hourly_hire_rate, 
                                        :invoice_load_client, 
                                        :invoice_tip_client, 
                                        :kms_one_way, 
                                        :load_time, 
                                        :loads_per_day, 
                                        :material_id, 
                                        :name, 
                                        :pay_equipment_per_unit, 
                                        :pay_load_client,
                                        :pay_tip_client,
                                        :pay_tip, 
                                        :pay_tolls,   
                                        :project_id,                                     
                                        :purchase_order_required, 
                                        :quote_id, 
                                        :solution_type,  
                                        :semis_permitted, 
                                        :total_material, 
                                        :tip_ids,
                                        :unit_of_material, 
                                        :unload_time,
                                        :updated_at
          ])
    end
    rescue
      params.permit!
    end
  end


end
