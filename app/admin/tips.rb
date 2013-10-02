
ActiveAdmin.register Tip do

  menu parent: "Admin"

  index do
    column :name do |tip|
      link_to tip.name, admin_tip_path(tip)
    end
    column :company
    column :fee do |tip|
      number_to_currency(tip.fee)
    end

    column :fire_ant_risk_level do |tip|
      tip.fire_ant_risk_level
    end

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

      f.input :fire_ant_risk_level_name,
        :as => :select,
        :collection => fire_ant_risk_levels,
        :placeholder => "None",
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
    f.buttons
  end

  show :title => :name do |t|

    panel "Tip Site Details" do
      attributes_table_for(tip) do
        row :name
        row :company
        row :fee
        row (:fire_ant_risk_level) {fire_ant_risk_levels[t.fire_ant_risk_level]}
        row :address do |tip|
          @address = tip.addresses.limit(1)
          render @address
        end
      end
    end
  end

controller do

  def create
    params.permit!
    super
  end

  def tip_params
      params.permit(:tip => [ :name, 
                              :company_id, 
                              :fee, 
                              :fire_ant_risk_level 
                            ]
                   )
    end
  end

end
