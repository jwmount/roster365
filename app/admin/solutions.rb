#require 'debugger'

# SolutionTips is HABTM join, action_on_permitted_parameters allows this to work 
# Not entirely clear on this!  Also this probably applies to all models, take care.
# Reference: http://api.rubyonrails.org/classes/ActionController/Parameters.html 
#ActionController::Parameters.action_on_unpermitted_parameters = :raise

ActiveAdmin.register Solution do
   
  menu label: "Solutions", parent: "Quote"
  belongs_to :quote
    navigation_menu :quote
#
# C A L L  B A C K S
#
  after_build do |solution|
     solution.generate_name
   end
  after_build do |solution|
    solution.isApproved?
  end

  #before_action :ensure_permission, only: [ :edit, :update ]    
#
# S C O P E S
#
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


  index do 

    column :name, :sortable => 'name' do |solution|
      link_to "Solution #{solution.name}", edit_admin_quote_solution_path( solution.quote, solution )
      #link_to "Solution #{solution.name}",
       #   edit_admin_company_project_quote_solution_path(company, solution.quote.project, solution.quote, solution )
    end

    column :solution_type
    
    #HACK -- singleton site enforced in a posssibly risky way!  Are there ever more than one?
    # Sure, why not?  remove the limit(1)
    column "Tip Sites" do |solution|
      if solution.tips.all.empty?
        status_tag( "No tip site assigned.", :error)
      else
        @tips = solution.tips #.limit(1)
        render @tips
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
        simple_format("<br/>")
      end
    end
  
  end #index


# Use conditional validations to determine if input is complete for a given contract type.
# At this time if contract type is not given, nothing is required.
form do |f|
  error_panel f

    f.inputs "Approvals" do
      f.input :approved, 
              :as => :radio, 
              :hint => 'Once approved solutions cannot be changed.'

      f.input :client_approved, 
              :as => :radio, 
              :hint => 'Once approved solutions cannot be changed.'
              
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
                             :input_html => {
                                             "data-placeholder"  => "Solution Type ...", 
                                                          :style => "width:200px", 
                                                          :class => "chzn-select"}
                             
      f.input :material_id, :as => :select, 
                            :label => 'Material', 
                            :hint => "What kind material will be moved.", 
                            :collection => Material.all.map {|m| [m.name, m.id]},
                            :include_blank => false

                            
      f.input :unit_of_material, as:         :select, 
                                 label:      "Unit of Material", 
                                 hint:       "Unit that is basis for our price.", 
                                 collection: %w[m3 tonne 'hourly hire' loads]

      f.input :total_material, hint:  "How much material will be moved in this solution."

    end
    
    f.inputs "Tip Site (Choose one)" do
      f.input :tips, 
              :as => :check_boxes, 
              :collection => Tip.alphabetically.all.map {|u| [u.name, u.id]}

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
        f.input :certificate, 
                :hint => "If the requirement is not listed, use the Certificate menu to create it."
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

#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Solution Context", only: [:index] do 
    ul
      li link_to "Dockets", admin_dockets_path
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Solutions Context", only: [:show, :edit] do 
    ul
      li link_to 'Prepare Jobs', admin_solution_jobs_path( solution )   
      hr
      li link_to 'Solutions',   admin_quote_solutions_path(      solution.quote )   
      li link_to "Quotes",      admin_project_quotes_path(       solution.quote.project )
      li link_to "Projects",    admin_company_projects_path(     solution.quote.project.company )
      li link_to "Companies",   admin_companies_path
  end

# 
# P U S H  B U T T O N S
#
  # APPROVE
  # Approve sets BOTH types of approval for now.  Elaborate later.
  # Aside from the obvious need to do one or the other and perhaps toggle them
  # this operation should be silently logged for audit purposes.
  action_item :only => [:edit, :show] do
    link_to 'Approve', approve_admin_quote_solution_path( quote, solution )
  end

  member_action :approve, :method => :get do
    @solution = Solution.find(params[:id])
    @solution.client_approved = true
    @solution.approved = true
    @solution.save
    flash[:notice] = "Solution was approved."
    redirect_to admin_quote_solution_path(@solution.quote, @solution)
  end
  
  action_item :only => [:edit, :show] do
    link_to 'Costing', costing_admin_quote_solution_path( quote, solution ),
      :confirm => 'question?',
      :popup => ['Costing','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes']
  end

  member_action :costing, :method => :get do
    @solution = Solution.find(params[:id])
    flash[:notice] = "Costing was popped (simulated, not really computed)."
    flash[:notice] << " Price was $1250.00."
    redirect_to admin_quote_solutions_path(quote, @solution ) 
  end

  action_item :only => [:show] do
    link_to 'Copy', duplicate_admin_quote_solution_path( quote, @solution )
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

    redirect_to admin_company_project_quote_solutions_path(
                  solution.quote.project.company, solution.quote.project, solution.quote, @solution_new.quote
                  )
  end    

          
  # needed because you have to create a Job in the context of its solution.
  # do not allow New operation in jobs.rb.
  # fully qualified path is: admin_company_project_quote_solution_jobs_path( solution.quote.project.company, solution.quote.project, solution.quote )
  # action_item :only => [:edit, :show] do
  #   link_to 'Jobs', admin_solution_jobs_path( solution )
  # end

=begin

  action_item :only => [:edit, :show] do
    job = Job.create!([:name => 'soljob'])
    link_to "New Job", new_admin_solution_job_path( solution )
  end
  member_action :jobify, :method => :get do
    solution = Solution.find(params[:id])
    name = "#{@solution.quote.project.name} - #{@solution.quote.name} - #{@solution.name} - J#{@solution.jobs.count+1}"
    if solution.has_final_approval?
      if solution.purchase_order_required == true
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
    if @job.exists?
      flash[:notice] = "Job was successfully created"
      redirect_to admin_solution_jobs_path(solution)
    else
      flash[:alert] = "Solution needs to be approved before a job can be created"
      redirect_to admin_quote_solution_path(solution.quote, solution)
    end
  end
=end


end
