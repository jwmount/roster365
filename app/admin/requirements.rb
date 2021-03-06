ActiveAdmin.register Requirement do
  
  menu parent: "Compliance"
  #actions :all, :except => :new

=begin
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
    requirements.where({requireable_type: 'Person'})
  end
  scope :equipment do |requirements|
    requirements.where({requireable_type: 'Equipment'})
  end
  scope :companies do |requirements|
    requirements.where({requireable_type: 'Material'})
  end
  scope :solutions do |requirements|
    requirements.where({requireable_type: 'Solution'})
  end
  scope :solutions do |requirements|
    requirements.where({requireable_type: 'Site'})
  end
=end

  index do
    column :certificate
    column :requireable_type
    column "Project" do |req|
      name = req.requireable_type.to_s.camelize.constantize.find(req.requireable_id).name
    end
    column :for_person
    column :for_company
    column :for_equipment
    column :for_location
    column :description
    column do |req|
    end
  end
     

end