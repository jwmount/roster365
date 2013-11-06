#require 'debugger'

ActiveAdmin.register Equipment do

  menu parent: "Company"
  belongs_to :company
  
  filter :name
  
  sidebar "Equipment Context", only: [:show, :edit] do 
    ul do
      li link_to "Dashboard", admin_dashboard_path
    end
  end  


  index do
    selectable_column
    
    column :name, sortable: :name do |equipment|
      link_to equipment.name, admin_company_equipment_path(equipment.company.id, equipment.id), :class => "member_link"
    end

    column :certs do |equipment|
      render equipment.certs
    end

  end  


  form do |f|
    error_panel f

    f.inputs "Equipment for #{self.company.name}" do
      f.input :name,
              :as => :select,
              :collection => equipment.equipment_list, #Equipment.alphabetically.all.map {|u| [u.name, u.id]},               
              :include_blank => false,
              :hint => "Select one."
      end                  
      
      f.inputs do
        f.has_many :certs do |f|
          f.input :certificate,
                  :include_blank => false
          f.input :expires_on, 
                  :as => :date_picker,
                  :hint => "Expiration date.  Leave blank if certification is permanent."
          f.input :serial_number, :hint => "Value that makes the certificate unique.  For example, License Number, Rego, etc."
          f.input :permanent
          f.input :active
        end
      end
    f.buttons
    end
       
  show do

    attributes_table do
      rows :name, :company
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

end
