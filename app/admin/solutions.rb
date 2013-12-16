#require 'debugger'
ActiveAdmin.register Solution do
   
  belongs_to :quote
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
  filter :equipment


  index do 
    selectable_column

    column :name, :sortable => 'name' do |solution|
      link_to "Solution #{solution.name}", 
          edit_admin_company_project_quote_solution_path( solution.quote.project.company, solution.quote.project,solution.quote, solution )
    end

    column :solution_type
    
    #HACK -- singleton site enforced in a posssibly risky way!  Are there ever more than one?
    # Sure, why not?  remove the limit(1)
    column "Tip Sites" do |solution|
      if solution.tips.all.empty?
        status_tag( "No tip site assigned.", :error)
      else
        @tips = solution.tips
        render @tips
      end
    end
    
    column "Equipment" do |solution|
      solution.equipment_name
    end

    column "Equip requested/day" do |solution|
      solution.equipment_units_required_per_day
    end

    column :approved do |solution|
      status_tag (solution.approved ? "YES" : "No"), (solution.approved ? :ok : :error)      
    end       
    
    column :client_approved do |solution|
      status_tag (solution.client_approved ? "YES" : "No"), (solution.client_approved ? :ok : :error)      
    end       
    
    column :semis_permitted do |solution|
      status_tag (solution.semis_permitted ? "YES" : "No"), (solution.semis_permitted ? :ok : :error)      
    end       
    
  
  end #index


# Use conditional validations to determine if input is complete for a given contract type.
# At this time if contract type is not given, nothing is required.
form do |f|
  error_panel f

    f.inputs "Approvals" do

      f.input :approved, 
              :as       => :radio, 
              :hint     => AdminConstants::ADMIN_SOLUTION_APPROVED_HINT

      f.input :client_approved, 
              :as       => :radio, 
              :hint     => AdminConstants::ADMIN_SOLUTION_CLIENT_APPROVED_HINT
              
    end
    
    f.inputs "Solution Details" do 

      f.input :name, 
              :input_html => {:disabled => true },
              :hint       => AdminConstants::ADMIN_SOLUTION_NAME_HINT

      f.input :solution_type,
              :label         => AdminConstants::ADMIN_SOLUTION_SOLUTION_TYPE_LABEL,
              :hint          => AdminConstants::ADMIN_SOLUTION_SOLUTION_TYPE_HINT,
              :as            => :select, 
              :include_blank => true,
              :collection    => solution_type_options,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_SOLUTION_TYPE_PLACEHOLDER
              #:input_html => {
               #               "data-placeholder"  => "Solution Type ...", 
                #              :style => "width:200px", 
                 #             :class => "chzn-select"
                  #          }
                             
      f.input :material_id, 
              :as            => :select, 
              :collection    => Material.all.map {|m| [m.name, m.id]},
              :label         => AdminConstants::ADMIN_SOLUTION_MATERIAL_ID_LABEL, 
              :hint          => AdminConstants::ADMIN_SOLUTION_MATERIAL_ID_HINT, 
              :include_blank => false

                            
      f.input :unit_of_material, 
              :as            => :select, 
              :label         => AdminConstants::ADMIN_SOLUTION_UNIT_OF_MATERIAL_LABEL, 
              :hint          => AdminConstants::ADMIN_SOLUTION_UNIT_OF_MATERIAL_HINT, 
              :collection    => AdminConstants::ADMIN_SOLUTION_UNIT_OF_MATERIAL_COLLECTION

      f.input :total_material, 
              :hint          => AdminConstants::ADMIN_SOLUTION_TOTAL_MATERIAL_HINT

    end
    
    f.inputs "Tip Site for this solution" do
      f.input :tips, 
              :as => :radio, 
              :collection    => Tip.alphabetically.all.map {|u| [u.name, u.id]}
       end

    f.inputs "Time & Distance -- #{solution.quote.project.addresses[0].to_s} to tip site" do

      f.input :kms_one_way,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_KMS_ONE_WAY_PLACEHOLDER
              
      f.input :loads_per_day,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_LOADS_PER_DAY_PLACEHOLDER
      
      f.input :drive_time_into_site,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_DRIVE_TIME_INTO_SITE_PLACEHOLDER
              
      f.input :load_time,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_LOAD_TIME_PLACEHOLDER
      
      f.input :drive_time_out_of_site,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_DRIVE_TIME_OUT_OF_SITE_PLACEHOLDER
              
      f.input :drive_time_from_load_to_tip,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_DRIVE_TIME_FROM_LOAD_TO_TIP_PLACEHOLDER
              
      f.input :drive_time_tip_to_load,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_DRIVE_TIME_TIP_TO_LOAD_PLACEHOLDER
              
      f.input :drive_time_into_tip,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_DRIVE_TIME_INTO_TIP_PLACEHOLDER
              
      f.input :unload_time,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_UNLOAD_TIME_PLACEHOLDER
              
      f.input :drive_time_out_of_tip_site,
              :placeholder   => AdminConstants::ADMIN_SOLUTION_DRIVE_TIME_OUT_OF_TIP_SITE_PLACEHOLDER
              
    end

    f.inputs "Required Equipment Certificates and Characteristics" do

      f.has_many :requirements do |f|

        f.input :certificate, 
                :collection       => Certificate.where({:for_equipment => true}),
                :include_blank    => false,
                :hint             => AdminConstants::ADMIN_SOLUTION_EQUIPMENT_CERTIFICATE_HINT
        f.input :for_equipment
        f.input :for_person
        f.input :description

      end
    end
    
    # Equipment must exist before it can be quoted.  This prevents user from quoting something
    # without a sourcing solution for it.  See also description of this constraint in Engagement.rb.
    f.inputs "Equipment" do 
      
      f.input :semis_permitted, 
              :as               => :radio

      f.input :equipment_name, 
              :as               => :select, 
              :collection       => solution.equipment_names,  #solution.quote.project.company.equipment,
              :include_blank    => false,
              :hint             => AdminConstants::ADMIN_SOLUTION_EQUIPMENT_NAME_HINT

      f.input :purchase_order_required, 
              :as               => :radio, 
              :hint             => AdminConstants::ADMIN_SOLUTION_PURCHASE_ORDER_REQUIRED_HINT

      f.input :equipment_units_required_per_day,
              :hint             => AdminConstants::ADMIN_SOLUTION_EQUIPMENT_UNITS_REQUIRED_PER_DAY_HINT + "#{solution.quote.project.company.name}"

      f.input :equipment_dollars_per_day,
              :precision        => 8, 
              :scale            => 2,
              :placeholder      => "usually 1250 or 750...",
              :hint             => AdminConstants::ADMIN_SOLUTION_EQUIPMENT_DOLLARS_PER_DAY_HINT
    end
    

    f.inputs "Pricing" do

      f.input :invoice_load_client,
              :precision       => 8, 
              :scale           => 2,
              :placeholder     => '00.00'

      f.input :pay_load_client,
              :precision       => 8, 
              :scale           => 2,
              :placeholder     => '00.00'

      f.input :invoice_tip_client,
              :precision       => 8, 
              :scale           => 2,
              :placeholder     => '00.00'

      f.input :pay_tip_client,
              :precision       => 8, 
              :scale           => 2,
              :placeholder     => '00.00'
              
      f.input :pay_equipment_per_unit,  
              :precision       => 8, 
              :scale           => 2

      f.input :pay_tolls,  
              :precision       => 8, 
              :scale           => 2

      f.input :pay_tip,  
              :precision       => 8, 
              :scale           => 2

      f.input :hourly_hire_rate, 
              :precision       => 8, 
              :scale           => 2

    end    
    f.actions
  end
  
  show :title => "Solution Details" do |s|
    h3 "Solution: #{s.name}"
    attributes_table do
      row :solution_type
      row :equipment_name, 
          :label => "Equipment"
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
        row  :equipment_name
        row  :equipment_units_required_per_day
        row( 'equipment_dollars_per_day') {number_to_currency(solution.equipment_dollars_per_day)}
        row( :semis_permitted ) { status_tag (solution.semis_permitted ? "YES" : "No"), (solution.semis_permitted ? :ok : :error) }        
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
        row('Hourly Hire Rate') {number_to_currency(solution.hourly_hire_rate)}
      end
    end
  end

#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Solutions Context", only: [:index] do 
    ul
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Solution Context", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      hr
      if solution.has_final_approval?
        li link_to 'Prepare Jobs', 
           admin_company_project_quote_solution_jobs_path( solution.quote.project.company, solution.quote.project, solution.quote, solution )   
      else
        li link_to 'Prepare Jobs (requires final approval)', 
           admin_company_project_quote_solution_path( solution.quote.project.company, solution.quote.project, solution.quote, solution )   
        flash[:warning] = "Solution MUST be approved before Jobs can be created."
      end
      hr
      status_tag('Other things you can do:')
      hr
      li link_to "Manage Conditions", admin_conditions_path
      li link_to "Manage Materials", admin_materials_path
      li link_to "Manage Tip Sites", admin_tips_path
      hr
      li link_to "Dashboard", admin_dashboard_path
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
    solution = Solution.find(params[:id])
    flash[:notice] = "Costing was popped (simulated, not really computed)."
    flash[:notice] << " Price was $1250.00."
    redirect_to admin_quote_solutions_path(solution.quote, solution ) 
  end

  action_item :only => [:show] do
    link_to 'Copy', duplicate_admin_quote_solution_path( quote, solution )    
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


end
