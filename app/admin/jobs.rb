#require 'debugger'
require 'active_support/all'

ActiveAdmin.register Job do
  # remove all default actions, e.g. [:new, :edit, :show etc]
  # config.clear_action_items!

# JOBS can only be made from a solution.
# NOTE:  Path problems arise if the ActiveAdmin association chain does NOT MATCH the Actrive Record chain.
# It was happening here (for how long?) with quotes, solutions and jobs.  
  menu label: "Jobs", parent: "Solutions"
  belongs_to :solution
#
# C A L L  B A C K S
#
  after_build do |job|
     job.name = "#{job.solution.quote.project.name}-#{job.solution.quote.name}-#{job.solution.name}-J#{job.solution.jobs.count+1}"
     job.purchase_order = job.solution.purchase_order_required ? 'PO required' : 'PO Not Required'
   end

  #before_action :ensure_permission, only: [ :edit, :update ]    
#
# S C O P E S
#
  
  scope :all
  scope :is_active?
  scope :is_not_active?
  
  filter :name
       
  # Use Jobify method to force context of given solution.
  #actions :all, :except => [:new]

  index do
    
    # By the time Jobs are created the one or more reps should be assigned.
    # Currently its not fatal if no rep is on Project or Quote.  Warnings are given separately.
    column :job_name, :sortable => 'name' do |job|
      h5 link_to job.name, 
          edit_admin_solution_job_path( job.solution, job )
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

    f.inputs "Job Details" do
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

# C O N T E X T  -  GIVE USER WAY BACK
#
  sidebar :context do
    link_to "Dashboard", admin_dashboard_path
  end

#
# P U S H  B U T T O N S
#
##
#
# Schedules -- Schedules for this job
#
#
  action_item :only => [:edit, :show] do
    link_to "Schedules", admin_job_schedules_path( job )
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
