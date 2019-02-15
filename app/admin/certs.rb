ActiveAdmin.register Cert do

  menu parent: "Compliance"
  #menu :parent => "Compliance", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Certificate.all.empty?
  #}
  
  actions :all, :except => :new
  
  # Rails 5.2.2 scopes
  scope :all, -> { where(default: true) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :permanent, -> { where(permanent: true) }
  
=begin
  Rails 3.x removed
  scope :all, :default => true 
  scope :active do |certificates|
    certificates.where ({active: 'true'})
  end
  scope :inactive do |certificates|
    certificates.where ({active: 'false'})
  end
  scope :permanent do |certificates|
    certificates.where ({permanent: 'true'})
  end
=end

  index do
    selectable_column

    column :certificate do |cert|
      link_to cert.certificate.name, admin_cert_path(cert.id)
    end
    # The find here returns an Arel relation object so this works so long as the 
    # located model has a display_name method.
    column :holder do |cert|
      @holder = Person.where("id = ?",cert.certifiable_id)
      @holder.empty? ? 'Empty' : @holder[0].display_name
    end

    column :type do |cert|
      cert.certifiable_type
    end

    column :expires_on

    column :permanent do |cert|
      status_tag (cert.permanent ? "YES" : "No"), (cert.permanent ? :ok : :error)            
    end

    column :active do |cert|
      status_tag (cert.active ? "YES" : "No"), (cert.active ? :ok : :error)            
    end
  end 

  form do |f|
    error_panel f

    f.inputs "Details" do
      if Certificate.alphabetically.all.empty?
        'No certificates have been added yet.'
      else
        f.input :certificate, :as => :select, 
                              :collection => Certificate.alphabetically.all.map {|u| [u.name, u.id]}, 
                              :include_blank => false
      end
      
      f.input :serial_number, 
              :hint => "ID number, license number or value that makes this document unique."

      f.input :expires_on, 
              :as => :date_picker,              
              :hint => "When the certificate or license expires.  Leave blank if document or status is permanent."  

      f.input :permanent do |cert|
        status_tag (cert.permanent ? "YES" : "No"), (cert.permanent ? :ok : :error)  
      end          

      f.input :active do |cert|
        status_tag (cert.active ? "YES" : "No"), (cert.active ? :ok : :error)            
      end        
    end
    #f.buttons
    f.actions
  end
  
  show do
    attributes_table do
      rows :certificate, :expires_on, :serial_number
      row ("permanent") {status_tag (cert.permanent ? "YES" : "No"), (cert.permanent ? :ok : :error)}
      row ("active") {status_tag (cert.active ? "YES" : "No"), (cert.active ? :ok : :error)}
    end
    active_admin_comments
  end #show

end
