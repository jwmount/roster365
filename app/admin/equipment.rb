#require 'debugger'

ActiveAdmin.register Equipment do

  menu :parent => "Admin"
  #menu :parent => "Admin", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) #&& !Company.all.empty?
  #  }

  index do
    
    column :name do |equipment|
      link_to equipment.name, admin_equipment_path(equipment)
    end

    column :company do |equipment|
      begin
        h5 equipment.company.display_name
        @people = equipment.company.people
        render @people
      rescue NameError
        company = Company.new
        company.name = "Equipment.id #{equipment.id} has an unknown company, delete it."
      end

    end

    column :certificates do |equipment|
      certificates = equipment.certificate_list
    end
  end  

  form do |f|
    error_panel f

    f.inputs "Equipment" do
      f.input :name, :as => :select, 
                     :collection => equipment.equipment_list,
                     :include_blank => false,
                     :required => true,
                     :hint => "Select one."
                     
      f.input :company, :label => "Owner", :as => :select, 
                        :collection => Company.alphabetically.all.map {|u| [u.name, u.id]}, 
                        :include_blank => false,
                        :hint => "Select one."
      end                  
      f.inputs do
        f.has_many :certs do |f|
          f.input :certificate
          f.input :expires_on, :input_html => {:class => 'datepicker'},
                               :hint => "Expiration date.  Leave blank if certification is permanent."
          f.input :serial_number, :hint => "Value that makes the certificate unique.  For example, License Number, Rego, etc."
          f.input :permanent
          f.input :active
        end
      end
    f.buttons
    end
       
  show do
    panel "Equipment Details" do
      attributes_table_for equipment do
        row :name
        row :company
      end
    end
    
    panel 'Certificates' do
      attributes_table_for(equipment) do
        certs = equipment.certs.all
        certs.each do |cert|
          row("#{cert.certificate.name}") {"#{cert.serial_number}"}
        end
      end
    end
    
    active_admin_comments
  end          

private

  def equipment_params 
      params.require(:equipment).permit( :company, :description, :name, :company_id, :certs_attributes )
    end

end
