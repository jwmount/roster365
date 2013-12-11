
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
        :hint                => AdminConstants::ADMIN_TIP_NAME_HINT,
        :placeholder         => AdminConstants::ADMIN_TIP_NAME_PLACEHOLDER 
      
      f.input :company,
        :hint                => AdminConstants::ADMIN_TIP_COMPANY_HINT, 
        :placeholder         => AdminConstants::ADMIN_TIP_COMPANY_PLACEHOLDER

      f.input :fee,
        :hint                => AdminConstants::ADMIN_TIP_FEE_HINT,
        :placeholder         => AdminConstants::ADMIN_TIP_FEE_PLACEHOLDER

      f.input :fire_ant_risk_level,
        :as                  => :select,
        :collection          => AdminConstants::ADMIN_TIP_FIRE_ANT_RISK_LEVEL_COLLECTION,
        :include_blank       => false,
        :required            => true,
        :hint                => AdminConstants::ADMIN_TIP_FIRE_ANT_RISK_LEVEL_HINT

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
                :collection           => Certificate.where({:for_location => true}),
                :include_blank        => false

        f.input :active

        f.input :expires_on, 
                :as                   => :date_picker,
                :hint                 => AdminConstants::ADMIN_CERT_EXPIRES_ON_HINT

        f.input :permanent

        f.input :serial_number, 
                :hint                 => AdminConstants::ADMIN_CERT_SERIAL_NUMBER_HINT
      end
    end
    f.actions
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
