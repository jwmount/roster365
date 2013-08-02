ActiveAdmin.register Condition do

  menu parent: "Compliance"
#  menu :label => "Compliance", :if => lambda{|tabs_renderer|
#    controller.current_ability.can?(:manage, AdminUser)
#  }

  scope :all
  scope :approved do |conditions|
    conditions.where ({approved: true})
  end
  scope :approved do |conditions|
    conditions.where ({approved: false})
  end

  filter :name
  filter :status
  filter :verbiage
  filter :indication

  
  index do
    column :name do |condition|
      link_to condition.name, admin_condition_path(condition)
    end

    column :verbiage

    column :indication
#    column :approved
    column :approved do |condition|
      status_tag (condition.approved ? "YES" : "No"), (condition.approved ? :ok : :error)
    end

  end


  form :title => :name do |f|
    f.inputs do |condition|
      f.input :name, 
              :required => true, 
              :input_html => {:class => "large"},
              :placeholder => "Name"
              
      f.input :verbiage, 
              :required => true,
              :placeholder => "Official description of this condition."
              
      f.input :indication, 
              :required => true,
              :placeholder => "How, When or Why Condition applies."
      f.input :approved
    end

    f.buttons
  end


  show :title => 'Condition' do
    h3 condition.name
    attributes_table_for(condition) do
      rows :name, :verbiage, :indication
      row("Approved") { status_tag (condition.approved ? "YES" : "No"), (condition.approved ? :ok : :error) }        
    end
    active_admin_comments
  end

 controller do
    def permitted_params
      params.require(:condition).permit( :approved, :change_approved_at, :change_approved_by, 
                                       :indication, :name, :status, :verbiage )
    end
  end
  
end
