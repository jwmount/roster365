#require 'debugger'

ActiveAdmin.register Job do
  # remove all default actions, e.g. [:new, :edit, :show etc]
  config.clear_action_items!

# JOBS can only be made from a solution.  Once a Job is created the User can edit it directly.
  menu parent: "Operations"
  #menu :parent => "Operations", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Solution.all.empty?
  #}

  scope :all
  scope :is_active?
  scope :is_not_active?
  
       
  # Use Jobify method to force context of given solution.
  actions :all, :except => [:new]

  index do
    
    # By the time Jobs are created the one or more reps should be assigned.
    # Currently its not fatal if no rep is on Project or Quote.  Warnings are given separately.
    column :job_name do |job|
      h5 link_to job.name, edit_admin_project_quote_solution_job_path(job.solution.quote.project.id, job.solution.quote.id, job.solution.id, job.id),
                 :class => "member_link"
      begin
        @prep = Person.find(job.solution.quote.project.rep_id)
        render @prep if @prep
      rescue ActiveRecord::RecordNotFound
        h5 "No Project Rep assigned."
      end

      unless job.solution.quote.rep_id.nil?
        @qrep = Person.find(job.solution.quote.rep_id)
        render @qrep if @qrep
      end
    end

    column :start_on
    column :finished_on
    column :purchase_order
    column :active do |job|
      status_tag (job.active ? "YES" : "No"), (job.active ? :ok : :error)
    end     
    column :complete do |job|
      status_tag (job.complete ? "YES" : "No"), (job.complete ? :ok : :error)
    end     
  end
  
  form do |f|
    error_panel f

    f.inputs "Define Job" do
      f.input :name, 
              :required => true, 
              :label=>"Job Name", 
              :input_html => {:disabled => true },
              :hint => "Job Name is generated for you.",
              :placeholder => "Job Name"
              
      f.input :purchase_order,
              :placeholder => "Purchase Order"
              
      f.input :active, 
              :as => :radio
              
      f.input :complete,
              :as => :radio

      f.input :start_on, 
              :as => :string, 
              :input_html => {:class => 'datepicker'}, 
              :required => true
              
      f.input :finished_on, 
              :as => :string, 
              :input_html => {:class => 'datepicker'}, 
              :required => true
    end
    f.buttons
  end
  
  show :title => :name do |job|
    attributes_table do
      row :name
      #row ("Project Rep") { link_to job.prep.full_name, admin_person_path(@prep.id) }
      #row ("Quote Rep") { link_to job.qrep.full_name, admin_person_path(@qrep.id) }
      row :start_on.to_s #strftime("%b %m, %Y")
      row :finished_on.to_s #strftime("%b %m, %Y")
      row :purchase_order
      row("Active") { status_tag (job.active ? "YES" : "No"), (job.active ? :ok : :error) }        
      row("Complete") { status_tag (job.complete ? "YES" : "No"), (job.complete ? :ok : :error) }        
    end
    active_admin_comments
  end

#
# W H I T E L I S T  M A N A G E M E N T
#
controller do

  def update
    params.permit!
    super
  end

  def create
    params.permit!
    super
  end

  def job_params
    params.permit(:job => [ :active, :complete, :name, :solution_id, :start_on, :time, :finished_on, 
                                     :purchase_order, :solution_ids 
                                     ])
    end
  end

end
