ActiveAdmin.register Role do

  menu :parent => "System Administration"

  index do
    selectable_column

    column :name do |role|
      link_to role.name, admin_role_path(role)
    end

    actions
  end


  form do |f|
    error_panel f

    f.inputs do

      f.input :name, 
              :label        => 'Role Name', 
              :required     => true, 
              :input_html   => {:class => "large"}
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
