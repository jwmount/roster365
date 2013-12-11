#ActiveAdmin.register Role do

#  menu label: "User Roles"
#  menu parent: "System Administration"
  
#end
ActiveAdmin.register Role do
### ?? from before Rails 4.0.0  controller.authorize_resource

  menu :parent => "System Administration"

#  menu :parent => "System Administration", :if => lambda{|tabs_renderer|
#    controller.current_ability.can?(:manage, Role)
#  }

  index do
    column :name do |role|
      link_to role.name, admin_role_path(role)
    end

    default_actions
  end


  form do |f|
    error_panel f

    f.inputs do

      f.input :name, 
              :label        => 'Role Name', 
              :required     => true, 
              :input_html   => {:class => "large"}
    end

    f.inputs "Users" do

      f.input :users, 
              :as            => :select, 
              :input_html    => {"data-placeholder" => "Select Users...", :style=> "width:900px", :class => "chzn-select"},
              :collection    => AdminUser.alphabetically.all.map {|u| [u.email, u.id]}, 
              :include_blank => false
    end
    f.actions
  end
  
  show do |f|
    attributes_table_for(role) do
      row('Role Name') {f.name}
    end
    active_admin_comments    
  end


end
