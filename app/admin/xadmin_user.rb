ActiveAdmin.register AdminUser do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def permitted_params
#      params.require(:admin_user).permit( :id, :email, :password, :password_confirmation, :remember_me )
      params.require(:admin_user).permit( :id, :email, :current_sign_in_at, :last_sign_in_at, :sign_in_count )
    end
  end  

end