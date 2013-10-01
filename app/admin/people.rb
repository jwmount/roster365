require 'debugger'

ActiveAdmin.register Person do

  actions :all, :except => [:destroy]

  #menu :parent => "Admin", :if => lambda{|tabs_renderer|
  #  controller.current_ability.can?(:manage, Role) &&
  #  !Company.all.empty?
  #}

  menu :parent => "Admin"


  scope :all, :default => true
  scope :available do |people|
    people.where ({available: true})
  end
  scope :not_available do |people|
    people.where ({available: false})
  end
  scope :OK_to_contact do |people|
    people.where ({OK_to_contact: true})
  end
  scope :Do_NOT_contact do |people|
    people.where ({OK_to_contact: false})
  end


  index do
    column :name do |person|
      if person.identifiers.count > 0
        h5 link_to "#{person.display_name + ', ' + person.title}", admin_person_path(person.id)
        @identifiers = person.identifiers.order(:rank)
        render @identifiers
      else
        h5 link_to "#{person.display_name}", admin_person_path(person.id)
      end
    end

    column :company
    column :available do |person|
      status_tag (person.available ? "YES" : "No"), (person.available ? :ok : :error)
    end
    column :OK_to_contact  do |person|
      status_tag (person.OK_to_contact ? "YES" : "No"), (person.OK_to_contact ? :ok : :error)
    end
    column :active  do |person|
      status_tag (person.active ? "YES" : "No"), (person.active ? :ok : :error)
    end
  end

  form do |f|
    error_panel f

    f.inputs "Person Details" do
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
      f.input :available_on, :as => :datepicker
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
        :hint => 'Kind of device or way to communicate with this Person.  Cannot be blank.'
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


  show :title => 'Person' do
    panel "Name" do
      attributes_table_for(person) do
        rows :last_name, :first_name, :title, :company
        row("active") { status_tag (person.active ? "YES" : "No"), (person.active ? :ok : :error) }
      end
    end

    panel 'Availability' do
      attributes_table_for(person) do
        row("Available") { status_tag (person.available ? "YES" : "No"), (person.available ? :ok : :error) }
        unless person.available
          row( "When #{person.display_name} will be available") {person.available_on}
        end
        row("OK_to_contact") { status_tag (person.OK_to_contact ? "YES" : "No"), (person.OK_to_contact ? :ok : :error) }
      end
    end

    # Cert model is polymorphic
    # certifiable_id == who owns it, e.g. Person, Company, Vehicle...
    # certificate_id == what is it, e.g. Driving License, Birth Certificate...
    panel 'Certificates' do
      attributes_table_for(person) do
        unless person.certs.any?
          h4 'Empty'
        else
          certs = person.certs.all.each do |cert|
            row("#{cert.certificate.name}") {cert.certificate.description}
          end
        end
      end
    end

    panel "Address" do
      attributes_table_for person do
        row :address
      end
    end

    # HACK?  Here we use a trinary assignment to catch item.name being nil.
    # Should prevent this via defaults and verifications,  ??.
    # In identifier.rb with defaults enforced validations seem to work fine.  Line marked
    # as trial below can be removed if no further problems.  Sept. 27, 2013.
    panel 'Rollodex' do
      attributes_table_for(person) do
        person.identifiers.order(:rank).each do |item|
          if item.name.include?("email")
            row("#{item.name}") {mail_to "#{item.value}"}
          else
 #trial           item.name = item.name.nil? ? 'unknown' : item.name
            row("#{item.name}") {item.value} 
          end
        end
      end
    end
    active_admin_comments
  end


  controller do
    def permitted_params
      params.permit(:person => [ :available, 
                                 :available_on, 
                                 :company_id, 
                                 :OK_to_contact, 
                                 :first_name, 
                                 :last_name, 
                                 :title, 
                                 :active,
                                 :updated_at,
                                 addresses_attributes:[:addressable_id, 
                                                      :addressable_type, 
                                                      :state, 
                                                      :street_address, 
                                                      :city,
                                                      :post_code, 
                                                      :map_reference
                                                     ], 
                                 certs_attributes: [:active,
                                                    :certifiable_id,
                                                    :certifiable_type,
                                                    :certificate_id,
                                                    :permanent,
                                                    :serial_number
                                                   ],
                                 identifiers_attributes:[:identifiable_id, 
                                                        :identifiable_type, 
                                                        :name, 
                                                        :rank, 
                                                        :value
                                                       ]
                                ]
                   )
    end
  end

end
