ActiveAdmin.register Certificate do


  menu parent: "Compliance"

# Rails 5.2.2
=begin 
  scope :all, -> { where(default: true) }
  scope :active, -> { where(active: true ) }
  scope :inactive, -> { where(active: false) }
  scope :people, -> { where(for_person: true) }
  scope :companies, -> { where(for_company: true) }
  scope :equipment, -> { where(for_equipment: true) }
  scope :location, -> { where(forelocation: true) }

  Rails 3.x remove 
  scope :all, :default => true 
  scope :active do |certificates|
    certificates.where ({active: true})
  end
  scope :inactive do |certificates|
    certificates.where ({active: false})
  end
  scope :people do |certificates|
    certificates.where ({for_person: true})
  end
  scope :companies do |certificates|
    certificates.where ({for_company: true})
  end
  scope :equipment do |certificates|
    certificates.where ({for_equipment: true})
  end   
  scope :location do |certificates|
    certificates.where ({for_location: true})
  end
=end
  index do
    column :name , :sortable => 'name' do |certificate|
      link_to certificate.name, admin_certificate_path(certificate)
    end
    column :description
    column :for_person do |certificate|
      status_tag (certificate.for_person ? "YES" : "No"), (certificate.for_person ? :ok : :error)
    end    
    column :for_company do |certificate|
      status_tag (certificate.for_company ? 'YES' : 'No'), (certificate.for_company ? :ok : :error)
    end    
    column :for_equipment do |certificate|
      certificate.for_equipment ? 'YES' : 'No'
      status_tag (certificate.for_equipment ? "YES" : "No"), (certificate.for_equipment ? :ok : :error)      
    end    
    column :for_location do |certificate|
      status_tag (certificate.for_location ? 'YES' : 'No'), (certificate.for_location ? :ok : :error)
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
      f.input :for_company
      f.input :for_equipment
      f.input :for_person
      f.input :for_location

    end
    #f.buttons
    f.actions
  end
       
  show :title => 'Certificate Details' do
    h3 certificate.name
    panel "Certificate Details" do
      attributes_table_for certificate do
        row("Name") { certificate.name }
        row("Active") { status_tag (certificate.active ? "YES" : "No"), (certificate.active ? :ok : :error) }
        row("Description") {certificate.description}
        row("For Company") { status_tag (certificate.for_company ? "YES" : "No"), (certificate.for_company ? :ok : :error) }
        row("For Equipment") { status_tag (certificate.for_equipment ? "YES" : "No"), (certificate.for_equipment ? :ok : :error) }
        row("For Location") { status_tag (certificate.for_location ? "YES" : "No"), (certificate.for_location ? :ok : :error) }
        row("For Person") { status_tag (certificate.for_person ? "YES" : "No"), (certificate.for_person ? :ok : :error) }
      end
    end
    active_admin_comments
  end          

#
# W H I T E  L I S T  M A N A G E M E N T
#
controller do

    def create
      params.permit!
      super
    end

    def update
      params.permit!
      super
    end

    def certificate_params
      params.require(:certificate).permit( :id,
                                           :name,
                                           :description,
                                           :for_person,
                                           :for_company,
                                           :for_equipment,
                                           :for_location,
                                           :active,
                                           :updated_on
                                         )
    end
  end

end
