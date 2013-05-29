ActiveAdmin.register AdminUser do
  
  menu parent: "System Administration"
  
  filter :email
  
  index do
    column do |f|
      link_to f.email, edit_admin_admin_user_path(f.id)
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
  end

  form do |f|
    error_panel f

    f.inputs "Admin Details" do
      f.input :email,
              :placeholder => "Valid email (must end in .com)"
              
      f.input :password,
              :placehoder => "At least 6, maximum of 128 characters"
    end
    f.buttons
  end
  
  show :title => :email do
    attributes_table do
      row :email
      row :reset_password_sent_at
      row :sign_in_count
      row :last_sign_in_at
      row :last_sign_in_ip
    end
  end
  
end
