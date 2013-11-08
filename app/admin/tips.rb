
ActiveAdmin.register Tip do

  menu parent: "Admin"

  index do
    selectable_column

    column :name do |tip|
      link_to tip.name, admin_tip_path(tip)
    end
    column :company
    column :fee do |tip|
      number_to_currency(tip.fee)
    end

    column :fire_ant_risk_level

    column :address do |tip|
      @address = tip.addresses.limit(1)
      render @address
    end
  end

  form do |f|
    error_panel f

    f.inputs "Site Details" do
      f.input :name,
        :placeholder => "name",
        :hint => "Commonly known name, ususally not same as Company name.",
        :placeholder => "name"
      
      f.input :company,
        :hint => "Company owner or DBA name.",
        :placeholder => "name"

      f.input :fee,
        :hint => "Customary tip fee.  May be negotiated by reps.",
        :placeholder => "0.00"

      f.input :fire_ant_risk_level,
        :as => :select,
        :collection => %w[ High Medium Low None],
        :include_blank => false,
        :required => true,
        :hint => "High, medium or none.  Do not move material from high to medium or none, or from medium to none."

      f.has_many :addresses do |f|
        f.input :street_address
        f.input :city
        f.input :state
        f.input :post_code
        f.input :map_reference
      end
    end

    # DRY -- not DRY, people, companies, tips also do this
    f.inputs do
      f.has_many :certs do |f|
        f.input :certificate,
                :collection => Certificate.where({:for_location => true}),
                :include_blank => false
        f.input :active
        f.input :expires_on, 
                :as => :date_picker,
                :hint => "Expiration date."
        f.input :permanent
        f.input :serial_number, 
                :hint => "Value that makes the certificate unique.  For example, License Number, Rego, etc."
      end
    end

    
    f.buttons
  end

  show :title => :name do |t|

    panel "Tip Site Details" do
      attributes_table_for(tip) do
        row :name
        row :company
        row :fee
        row :fire_ant_risk_level
        row :address do |tip|
          @address = tip.addresses
          render @address
        end
        row ("Certifications") { render tip.certs}
      end
    end
  end

end
