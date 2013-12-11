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
              :as                   => :select,
              :collection           => equipment.equipment_list,
              :include_blank        => false,
              :hint                 => AdminConstants::ADMIN_EQUIPMENT_NAME_HINT
      end                  
      
    # DRY -- not DRY, people, companies, tips also do this
    f.inputs do

      f.has_many :certs do |f|
        
        f.input :certificate,
                :collection         => Certificate.where({:for_equipment => true}),
                :hint               => AdminConstants::ADMIN_EQUIPMENT_CERTIFICATE_HINT,
                :include_blank      => false

        f.input :active

        f.input :expires_on, 
                :as                 => :date_picker,
                :hint               => AdminConstants::ADMIN_EQUIPMENT_EXPIRES_ON_HINT

        f.input :permanent

        f.input :serial_number, 
                :hint               => AdminConstants::ADMIN_EQUIPMENT_SERIAL_NUMBER_HINT
      end
    end
    f.actions
    end
       
  show do

    attributes_table do
      rows :name, :company
      row ("Certifications") { render equipment.certs}

    end
    
=begin    
    panel 'Certificates' do
      attributes_table_for(equipment) do
        certs = equipment.certs.where({:for_equipment => true})
        certs.each do |cert|
          row("#{cert.certificate.name}") {"#{cert.serial_number}"}
        end
      end
    end
=end
    active_admin_comments
  end          

end
