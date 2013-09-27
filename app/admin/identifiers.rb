require 'active_support/core_ext/integer/inflections.rb'

ActiveAdmin.register Identifier do

  menu label: "Rollodex", parent: "Admin"
  
  actions :all, :except => :new

  scope :all, :default => true
  scope :People do |identifiers|
    identifiers.where ({identifiable_type: 'Person'})
  end
  scope :Companies do |identifiers|
    identifiers.where ({identifiable_type: 'Company'})
  end

  filter :name
  filter :value  
  
  index do
    column :owner do |id|
      case id.identifiable_type
        when 'Company' 
          begin
            owner = Company.find  "#{id.identifiable_id}"
            link_to owner.display_name, admin_company_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Company.new
            owner.name = "Delete: Company not found!"
            flash[:error] = 'Bad company (does not exist), address should be deleted.'
            owner.display_name
          end
        when  'Person'
          begin
            owner = Person.find  "#{id.identifiable_id}"
            link_to owner.display_name, admin_person_path(owner.id)
          rescue
            owner = Person.find
            owner.name = 'Delete: Person not found.'
            flash[:error] = 'Bad Person (does not exist), address should be deleted.'
            owner.display_name
          end
        else
          flash[:error] = 'Could not determine identifiable_type.'
          link_to 'Unknown Type', admin_identifiers_path
        end
    end
      
    #column :name
    column :name do |id|
      link_to id.name, admin_identifier_path(id)
    end

    column :value do |id|
      if ['email','Email'].any? { |word| id.name.include?(word) }
        mail_to id.value 
      else
        id.value
      end
    end
    column :rank do |id|
      id.rank.ordinalize
    end
  end


controller do
  def permitted_params
    params.permit(:identifier => [ :identifiable_id, 
                                   :identifiable_type, 
                                   :name, 
                                   :rank,
                                   :updated_at, 
                                   :value
                                ]
                 )
    end
  end
  
end
