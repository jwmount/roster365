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
      row ("Email") { mail_to admin_user.email }
      row :reset_password_sent_at
      row :sign_in_count
      row :last_sign_in_at
      row :last_sign_in_ip
    end
  end

# found unpermitted parameters: utf8, authenticity_token, commit
  controller do
    def permitted_params
      #params.require(:admin_user).permit( :id, :email, :password, :password_confirmation, :remember_me )
     #params.require(:admin_user).permit(
      params.permit!
=begin

      params.permit(:admin_user => [ 
        :email,
        :encrypted_password,
        :reset_password_token,
        :reset_password_sent_at,
        :remember_created_at,
        :sign_in_count,
        :current_sign_in_at,
        :last_sign_in_at,
        :current_sign_in_ip,
        :last_sign_in_ip,
        :password
      ]
    )
=end
    end
  end  

end
