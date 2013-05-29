ActiveAdmin.register Contact do
  
  actions :all, :except => [:destroy]
  
  #menu :parent => "Admin", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Company.all.empty?
  #}

  menu :parent => "Admin"
  

  scope :all, :default => true 
  scope :available do |contacts|
    contacts.where ({available: true})
  end
  scope :not_available do |contacts|
    contacts.where ({available: false})
  end
  scope :OK_to_contact do |contacts|
    contacts.where ({OK_to_contact: true})
  end
  scope :Do_NOT_contact do |contacts|
    contacts.where ({OK_to_contact: false})
  end

  
  index do
    column :name do |contact|
      if contact.identifiers.count > 0
        h5 link_to "#{contact.display_name + ', ' + contact.title}", admin_contact_path(contact.id)
        @identifiers = contact.identifiers.order(:rank)
        render @identifiers
      else
        h5 link_to "#{contact.display_name}", admin_contact_path(contact.id)
      end
    end

    column :company
    column :available do |contact|
      status_tag (contact.available ? "YES" : "No"), (contact.available ? :ok : :error)      
    end
    column :OK_to_contact  do |contact|
      status_tag (contact.OK_to_contact ? "YES" : "No"), (contact.OK_to_contact ? :ok : :error)            
    end   
    column :active  do |contact|
      status_tag (contact.active ? "YES" : "No"), (contact.active ? :ok : :error)            
    end   
  end
  
  form do |f|
    error_panel f

    f.inputs "Contact Details" do
      f.input :company
      f.input :first_name,
              :placeholder => "First name"
      f.input :last_name,
              :placeholder => "Last name"
      f.input :title, 
              :placeholder => "Title"
      f.input :active, :as => :radio
    end
       
    f.inputs "Availability" do
      f.input :available, :as => :radio
      f.input :next_available_on, :as => :datepicker
    end   
    
    f.inputs do
      f.has_many :addresses do |f|
        f.input :street_address
        f.input :city
        f.input :state
        f.input :post_code
        f.input :map_reference
      end
    end
  
    f.inputs do  
      f.has_many :identifiers do |f|
        f.input :name, :collection => %w[Mobile Email Office Truck Pager FAX Skype SMS Twitter Home],
                :label => 'Type or kind*',
                :hint => 'Kind of device or way to communicate with this Contact.  Cannot be blank.'
        f.input :value,
                :label => 'Number, address, etc.',
                :placeholder => 'phone number, email address, etc.'
        f.input :rank, :collection => %w[1 2 3 4 5 6 7 8 9],
                :label => 'Priority*',
                :hint => 'Order prefered.',
                :placeholder => '1 .. 9'
      end
    end
    
    f.inputs do
      f.has_many :certs do |f|
        f.input :certificate
        f.input :expires_on, :input_html => {:class => 'datepicker'},
                             :hint => "Expiration date."
        f.input :serial_number, :hint => "Value that makes the certificate unique.  For example, License Number, Rego, etc."
        f.input :permanent
        f.input :active
      end
    end
    f.buttons
  end


  show :title => 'Contact' do
    panel "Name" do
      attributes_table_for(contact) do
        rows :last_name, :first_name, :title, :company
        row("active") { status_tag (contact.active ? "YES" : "No"), (contact.active ? :ok : :error) }
      end
    end
    
    panel 'Availability' do
      attributes_table_for(contact) do
        row("Available") { status_tag (contact.available ? "YES" : "No"), (contact.available ? :ok : :error) }
        unless contact.available
          row( "When #{contact.display_name} will be available") {contact.next_available_on}
        end
        row("OK_to_contact") { status_tag (contact.OK_to_contact ? "YES" : "No"), (contact.OK_to_contact ? :ok : :error) }
      end
    end

    # Cert model is polymorphic
    # certifiable_id == who owns it, e.g. Contact, Company, Vehicle...
    # certificate_id == what is it, e.g. Driving License, Birth Certificate...
    panel 'Certificates' do
      attributes_table_for(contact) do
        unless contact.certs.any?
          h4 'Empty'
        else
          certs = contact.certs.all.each do |cert|
            row("#{cert.certificate.name}") {cert.certificate.description}
          end
        end
      end
    end
    
    panel "Address" do
      attributes_table_for contact do
        row :address
     end
   end
        
    panel 'Rollodex' do
      attributes_table_for(contact) do
        contact.identifiers.order(:rank).each do |i|
          if i.name.include?("email")
            row("#{i.name}") {mail_to "#{i.value}"}
          else
            row("#{i.name}") {i.value}      
          end
        end
      end
    end
    active_admin_comments
  end

  
end
