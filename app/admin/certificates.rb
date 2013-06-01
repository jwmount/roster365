ActiveAdmin.register Certificate do

  menu parent: "Compliance"

  scope :all, :default => true 
  scope :active do |certificates|
    certificates.where ({active: true})
  end
  scope :inactive do |certificates|
    certificates.where ({active: false})
  end
  scope :people do |certificates|
    certificates.where ({for_contact: true})
  end
  scope :companies do |certificates|
    certificates.where ({for_company: true})
  end
  scope :equipment do |certificates|
    certificates.where ({for_equipment: true})
  end
 
  index do
    column :name do |certificate|
      link_to certificate.name, admin_certificate_path(certificate)
    end
    column :description
    column :for_contact do |certificate|
      status_tag (certificate.for_contact ? "YES" : "No"), (certificate.for_contact ? :ok : :error)
    end    
    column :for_company do |certificate|
      status_tag (certificate.for_company ? 'YES' : 'No'), (certificate.for_company ? :ok : :error)
    end    
    column :for_equipment do |certificate|
      certificate.for_equipment ? 'YES' : 'No'
      status_tag (certificate.for_equipment ? "YES" : "No"), (certificate.for_equipment ? :ok : :error)      
    end    
    column :active do |certificate|
      status_tag (certificate.active ? "YES" : "No"), (certificate.active ? :ok : :error)      
    end    
  end
  
  form do |f|
    error_panel f

    f.inputs "Certificate" do
      f.input :name,          
              :required => true,
              :placeholder => "Name"
      f.input :description, 
              :placeholder => "Description"
      f.input :active, 
              :as => :radio
      f.input :for_contact,  
              :as => :radio, :collection => ["Person", "Equipment", "Company", "Project", "Site"]
      f.input :for_contact
      f.input :for_equipment
      f.input :for_company
    end
    f.buttons
  end
       
  show :title => 'Certificate Details' do
    h3 certificate.name
    panel "Certificate Details" do
      attributes_table_for certificate do
        row("Name") { certificate.name }
        row("Active") { status_tag (certificate.active ? "YES" : "No"), (certificate.active ? :ok : :error) }
        row("Description") {certificate.description}
        row("For Person") { status_tag (certificate.for_contact ? "YES" : "No"), (certificate.for_contact ? :ok : :error) }
        row("For Equipment") { status_tag (certificate.for_equipment ? "YES" : "No"), (certificate.for_equipment ? :ok : :error) }
        row("For Company") { status_tag (certificate.for_company ? "YES" : "No"), (certificate.for_company ? :ok : :error) }
      end
    end
    active_admin_comments
  end          
  
end
