require 'active_support/core_ext/integer/inflections.rb'

ActiveAdmin.register Identifier do

  menu label: "Rollodex", parent: "Admin"
  
  actions :all, :except => :new

  scope :all, :default => true
  scope :Contacts do |identifiers|
    identifiers.where ({identifiable_type: 'Contact'})
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
        when  'Contact'
          begin
            owner = Contact.find  "#{id.identifiable_id}"
            link_to owner.display_name, admin_contact_path(owner.id)
          rescue
            owner = Contact.find
            owner.name = 'Delete: Contact not found.'
            flash[:error] = 'Bad Contact (does not exist), address should be deleted.'
            owner.display_name
          end
        else
          flash[:error] = 'Could not determine identifiable_type.'
          link_to 'Unknown Type', admin_identifiers_path
        end
    end
      
    column :name
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
  
end
