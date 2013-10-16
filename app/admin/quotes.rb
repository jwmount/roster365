#require 'debugger'
ActiveAdmin.register Quote do
      
  menu label: "Quotes", parent: "Sales"

  filter :name
  filter :rep
  filter :expected_start
  filter :project
  filter :duration

  # NOT OPTIONAL, effect is to scope quotes to project, apparently is NOT same effect as same statement in quote.rb.
  # In shallow version is not used.
  # belongs_to :project

  after_build do |quote|
    quote.generate_name
    quote.fire_ants_verified_by = current_user.email
  end
  
  index do

    column :name, :sortable => 'name' do |quote|
      link_to quote.name, admin_quote_path(quote)
    end

    column "Project" do |quote|
      @project = quote.project
      render @project unless @project.nil?
    end

    column :rep do |quote|
      @rep  = Person.find quote.rep_id
      render @rep
    end

    
    column :expected_start
    
    column :duration

    column "Requirements" do |quote|
      @requirements = quote.requirements
      render @requirements unless @requirements.nil?
    end

  end
 
  form do |f|
    error_panel f

    f.inputs  do
      f.input :name, 
              :as => :hidden,
              :hint => "Name is automatically assigned and not edited.",
              :disabled => true
              
           
      f.input :rep_id,
              label: "Quote Rep",
              hint:  "Quote and Project Reps may be same person.",
              as: :select,
              #collection: roster365.people,  #company.people.where("name = ?", "Roster365"),
              collection: Person.alphabetically.where({:company_id => Company.where({name: 'Roster365'})} && {title: 'Rep'}), 
              include_blank: true

      # This select needs to be scoped to employees of this company
      f.input :quote_to_id, 
              :label => "Quote to", 
              :hint => "Who we deliver the quote to.",
              :required => true,
              :as => :select, 
              :collection => quote.project.company.people, 
              :include_blank => false
    end
    
    f.inputs "Dates" do
      f.input :expected_start, 
              :as => :string, 
              :input_html => {:class => 'datepicker'}, 
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

    f.inputs "Requirements" do 
      f.has_many :requirements do |r|
        r.input :certificate
        r.input :description
      end
    end

    f.buttons :commit
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
        row ("Project Rep") {quote.prep_name}        
        row ("Quote Rep") {quote.qrep_name}        
      end
    end
  
    
    panel :Dates do
      attributes_table_for(quote) do
        row :expected_start
        row ("Duration (days)") {quote.duration}
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

    panel :Requirements do
      attributes_table_for quote do
        row "Requirements" do |quote|
          begin
            @quotes = Requirement.where("requireable_id = ? AND requireable_type = ?", self.id, 'Quote')
            render quote.requirements
          rescue
            render "None"
          end
        end
      end
    end
  
  end # show
  
    

  #
  # Express Quote - Create from Deep copy of this quote
  #
  action_item :only => [:edit, :show] do
    link_to 'Express Quote', express_admin_quote_path( quote ) 
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
 # action_item :only => [:edit, :show] do
  #  link_to 'Solutions', admin_quote_solutions_path( quote ) 
  #end

  action_item :only => [:edit, :show ] do
    link_to "Print", print_admin_quote_path( quote )
  end

  # In partials the local variable 'print' refers to @quote
  member_action :print, :method => :get do
    @quote = Quote.find(params[:id])
    render :partial => "print", :layout => "quotes/print", :object => @quote, :target => '_blank'
  end


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
    
    def quote_params
      params.permit(:quote => [ :name, 
                                :rep_id, 
                                :quote_to_id, 
                                :project_id,    
                                :council, 
                                :duration, 
                                :expected_start, 
                                :fire_ants, 
                                :fire_ants_verified_by, 
                                :inclusions,
                                :updated_at,
                                :addresses_attributes ] )
    end
  end

end
