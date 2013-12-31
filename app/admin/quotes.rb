#require 'debugger'
ActiveAdmin.register Quote do
      
  filter :name
  filter :rep
  filter :expected_start
  filter :project
  filter :duration

  # NOT OPTIONAL, effect is to scope quotes to project, apparently is NOT same effect as same statement in quote.rb.
  belongs_to :project

#
# C A L L  B A C K S
#

  # Warn user if project work site has not been entered.  Fires on #new only.
  before_build do |quote|
    flash[:warning] = AdminConstants::ADMIN_QUOTE_NO_WORK_SITE_DEFINED unless quote.worksite_defined?
  end

  after_build do |quote|
    quote.generate_name
    quote.fire_ants_verified_by = current_user.email
    # Precondition for a new Quote -- nobody home?  Cannot complete :quote_to.  
    if quote.project.company.people.empty?
      flash[:warning] = AdminConstants::ADMIN_NOONE_WORKS_FOR_COMPANY
    end
  end

=begin  
     batch_action :flag do |selection|
      Company.find(selection).each do |company|
        company.name = 'XYZ'
        company.save!
      end
    end
=end

  index do
    selectable_column

    column "Name (click for details)", :sortable => 'name' do |quote|
      link_to quote.name, admin_company_project_quote_path( quote.project.company, project, quote )
    end

    column "Project", :sortable => 'name' do |quote|
      render quote.project
    end

    column :rep do |quote|
      @rep  = Person.find quote.rep_id
      render @rep
    end
    
    column :expected_start
    
    column :duration

#    column "Requirements" do |quote|
#      @requirements = quote.requirements
#      render @requirements unless @requirements.nil?
#    end

  end
 
  form do |f|
    error_panel f

    f.inputs  do
      f.input :name, 
              :as                  => :hidden,
              :hint                => AdminConstants::ADMIN_QUOTE_NAME_HINT,
              :disabled            => true
              
      # rep is 'our' or LICENSEE rep who manages projects     
      f.input :rep_id,
              label: "Quote Rep",
              hint:  "Quote and Project Reps may be same person.",
              as: :select,
              collection: list_of_reps,
              include_blank: false

      # This select needs to be scoped to employees of this company
      f.input :quote_to_id, 
              :label => "Quote to", 
              :hint => AdminConstants::ADMIN_QUOTE_QUOTE_TO_ID_HINT + " #{quote.project.company.name}",
              :required => true,
              :as => :select, 
              :collection => quote.project.company.people,
              :include_blank => false
    end
    
    f.inputs "Dates" do
      f.input :expected_start, 
              :as => :date_picker,
              :hint => "When you expect to start.  Estimate."
      f.input :duration, :required => true, 
              :label => "Duration (days)",
              :hint => "How long project will be, in days."
    end
    
    f.inputs "Details" do
      f.input :fire_ants, :as => :radio, :label => "Fire Ants Present"
      f.input :fire_ants_verified_by, label: "Fire Ant Status Verified By:", input_html: {disabled: true}
      f.input :council,
              :hint => "Council with jurisdiction, if known."
    end

    f.actions
  end
  
  show :title => :name do |quote|
    
    panel :Names do
      attributes_table_for(quote) do
        row :name
        row :project
        row ("Company") do
          @company = quote.project.company
          render @company
        end
        row (:quote_to_id) {quote.quote_to_name} 
        row ("#{ENV['LICENSEE']} Project Rep") {quote.prep_name}        
        row ("#{ENV['LICENSEE']} Quote Rep") {quote.qrep_name}        
      end
    end
  
    
    panel :Dates do
      attributes_table_for(quote) do
        row ("Expected Begin Date") {quote.expected_start.strftime("%b %d, %Y")}
        row ("Duration (days)")     {quote.duration}
        row ("Expected End Date")   {(quote.expected_start + quote.duration.days).strftime("%b %d, %Y")}
      end
    end
  
  
    panel 'Load Site' do
      attributes_table_for(quote) do
        row("Fire Ants Present") { status_tag (quote.fire_ants ? "YES" : "No"), (quote.fire_ants ? :present : :no) }
        row :fire_ants_verified_by
        row :council
        row "Address" do |quote|
          @address = Address.where("addressable_id = ? AND addressable_type = ?", quote.project_id, 'Project').limit(1)
          if @address.blank?
            flash[:error] = "Missing project work site address.  Correct this in Project."
          else
            render @address
          end
        end
      end   
  end

    panel :Conditions do
      attributes_table_for(quote) do
        quote.inclusions.each do |inclusion|
          row (inclusion.name) {inclusion.verbiage}
        end
      end
    end

  end # show


#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Quotes Context", only: [:index] do 
    ul
      li link_to "Projects", admin_company_projects_path( project.company )
      hr
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Quote Context", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      hr
      li link_to 'Prepare Solutions',   admin_company_project_quote_solutions_path( quote.project.company, quote.project, quote )   
      hr  
      status_tag('Other things you can do:')
      hr
      li link_to "Visit the Dashboard", admin_dashboard_path
      li link_to "Manage Conditions",   admin_conditions_path
      li link_to "Manage Materials",    admin_materials_path
      li link_to "Manage Tip Sites",    admin_tips_path

  end

#
# P U S H  B U T T O N S
#
#  action_item do |quote|
#   link_to 'Back ( --> Parent Project', admin_company_project_path( quote.project.company, quote.project ) 
#  end

#
# Express Quote - Create from Deep copy of this quote
#
  action_item :only => [:edit, :show] do
    link_to 'Express Quote', express_admin_project_quote_path( quote.project, quote ) 
  end
  # Express Quote
  # Deep copy quote with its solutions, if any.  Solution names no longer 
  # validated to be unique to allow this.  Issue 40.
  member_action :express, :method => :get do
    @quote = Quote.find(params[:id])
    @quote_new = @quote.dup
    @quote_new.name = "Q"+(Quote.count + 1 + 5000).to_s

    if @quote_new.save
      @new_solutions = []
      @quote.solutions.each do |old_solution|
        @new_solutions << Solution.create!(old_solution.attributes.merge({id: nil, quote_id: @quote_new.id}))
      end

      flash[:notice] = "Express Quote #{@quote_new.name} created with #{@new_solutions.count} solutions."
      # take user to edit express quote just created.
      redirect_to edit_admin_project_quote_path(@quote_new.project_id, @quote_new.id)
    else
      flash[:warning] = 'Express Quote could not be created.'
      redirect_to admin_project_quotes_path(@quote_new.project_id)
    end
  end

  # Appears on Quotes page but needs qualification
  # Is navigation, no longer a pbutton
  #action_item :only => [:edit, :show] do
  #  link_to 'Solutions', admin_quote_solutions_path( quote ) 
  #end
  
  action_item :only => [:edit, :show ] do
    link_to "Print", print_admin_project_quote_path( quote.project, quote )
  end

  # In partials the local variable 'print' refers to @quote
  member_action :print, :method => :get do
    @quote = Quote.find(params[:id])
    render :partial => "print", :layout => "quotes/print", :object => @quote, :target => '_blank'
  end

end
