#require 'debugger'
require 'active_support/all'

ActiveAdmin.register Job do
# remove all default actions, e.g. [:new, :edit, :show etc]
# config.clear_action_items!

# JOBS can only be made from a solution.
# NOTE:  Path problems arise if the ActiveAdmin association chain does NOT MATCH the Actrive Record chain.
# It was happening here (for how long?) with quotes, solutions and jobs.  
  menu label: "Jobs", parent: "Solution"

  belongs_to :solution
#
# C A L L  B A C K S
#

  after_build do |job|
     job.name = "#{job.solution.quote.project.name}-#{job.solution.quote.name}-#{job.solution.name}-J#{job.solution.jobs.count+1}"
     job.purchase_order = job.solution.purchase_order_required ? 'PO required' : 'PO Not Required'
   end

#
# S C O P E S
#
#  scope :active do |projects|
#    projects.where ({active: true})
#  end
 
#
# F I L T E R S
#  
  filter :name
       

  index do
    selectable_column

    # By the time Jobs are created the one or more reps should be assigned.
    # Currently its not fatal if no rep is on Project or Quote.  Warnings are given separately.
    column :job_name, :sortable => 'name' do |job|
      h5 link_to job.name, 
          edit_admin_company_project_quote_solution_job_path( job.solution.quote.project.company, job.solution.quote.project, job.solution.quote, job.solution, job )
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
              :required    => true, 
              :label       => "Job Name", 
              :input_html  => {:disabled => true },
              :hint        => AdminConstants::ADMIN_JOB_NAME_HINT,
              :placeholder => AdminConstants::ADMIN_JOB_NAME_PLACEHOLDER
              
      f.input :purchase_order,
              :placeholder => AdminConstants::ADMIN_JOB_PURCHASE_ORDER_PLACEHOLDER
              
      f.input :active, 
              :as          => :radio
              
      f.input :complete,
              :as          => :radio

      f.input :start_on, 
              :as          => :date_picker, 
              :required    => true
              
      f.input :finished_on, 
              :as          => :date_picker,
              :required    => true,
              :hint        => AdminConstants::ADMIN_JOB_FINISHED_ON_HINT + "#{job.solution.quote.duration} days."
    end
    f.actions
  end
  
  show :title => "Job Details" do |job|
    h3 "Job: #{job.name}"
    attributes_table do
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
# P U S H  B U T T O N S
#
#

#
# I N D E X / L I S T  C O N T E X T
#
  sidebar "Jobs Context", only: [:index] do 
    ul
      li link_to "Solutions", admin_quote_solutions_path( solution.quote )
      hr
      li link_to "Dashboard", admin_dashboard_path
  end

#
# C O N T E X T -- Places you can go
#
  sidebar "Jobs Context", only: [:show, :edit] do 
    ul
      status_tag('Now you can:')
      hr
      #li link_to "Prepare Schedules", admin_job_schedules_path( job )
      li link_to "Prepare Schedules", admin_company_project_quote_solution_job_schedules_path( job.solution.quote.project.company, job.solution.quote.project, job.solution.quote, job.solution, job )
      hr
      status_tag('Other things you can do:')
      hr
      li link_to "Manage Conditions", admin_conditions_path
      li link_to "Manage Materials", admin_materials_path
      li link_to "Manage Tip Sites", admin_tips_path
      hr
      li link_to "Dashboard", admin_dashboard_path
  end


end
