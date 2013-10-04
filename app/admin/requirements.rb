ActiveAdmin.register Requirement do
  
  menu parent: "Compliance"
  actions :all, :except => :new

  scope :all, :default => true 
#  scope :active do |requirements|
#    requirements.where ({active: 'true'})
#  end
#  scope :inactive do |requirements|
#    requirements.where ({active: 'false'})
#  end
  scope :companies do |requirements|
    requirements.where({requireable_type: 'Company'})
  end
  scope :people do |requirements|
    requirements.where({requireable_type: 'Persion'})
  end
  scope :equipment do |requirements|
    requirements.where({requireable_type: 'Equipment'})
  end
  scope :companies do |requirements|
    requirements.where({requireable_type: 'Material'})
  end
  scope :project do |requirements|
    requirements.where({requireable_type: 'Project'})
  end
  scope :solutions do |requirements|
    requirements.where({requireable_type: 'Solution'})
  end
   
  index do
    column :certificate
    column :requireable_type
    column :material do |req|
      name = req.requireable_type.to_s.camelize.constantize.find(req.requireable_id).name
    end
    column :description
    column do |req|
    end
  end
     

  controller do

    def create
      params.permit!
      super
    end

    def update
      params.permit!
      super
    end

    def requirement_params
      params.require(:requirement).permit( :requireable_id, :requireable_type, 
                                         :certificate_id, :description ) 
    end
  end

end