#require 'debugger'
ActiveAdmin.register Address do
  
  actions :all, :except => :new

  # Address must be created from parent, e.g. Company, Person, Tip
  # actions :all, :except => :new
  belongs_to :Company

  index do
    selectable_column

    column :owner do |id|
      case id.addressable_type

        # Clugy way to establish if address owner exists and who or what it is
        # There IS a better way, just need time to find it.

        when 'Company' 
          begin
            owner = Company.find("#{id.addressable_id}")
            link_to "#{owner.display_name} (#{id.addressable_type})", admin_company_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Company.new
            owner.name = "Delete: Company not found!"
            flash[:error] = ADMIN_ADDRESS_OWNER_NOT_FOUND
          end
        
        when  'Person'
          begin
            owner = Person.find("#{id.addressable_id}")
            link_to "#{owner.display_name} (#{id.addressable_type})", admin_person_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Person.new
            owner.name = 'Delete: Person not found.'
            flash[:error] = ADMIN_ADDRESS_PERSON_NOT_FOUND
          end
        
        when  'Project'
          begin
            owner = Project.find("#{id.addressable_id}")
            link_to "#{owner.name} (#{id.addressable_type})", admin_project_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Project.new
            owner.name = 'Delete: Project not found.'
            flash[:error] =  ADMIN_ADDRESS_PROJECT_NOT_FOUND
          end
        
        when  'Tip'
          begin
            owner = Tip.find("#{id.addressable_id}")
            link_to "#{owner.name} (#{id.addressable_type})", admin_tip_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Tip.new
            owner.name = 'Delete: Tip not found.'
            flash[:error] = ADMIN_ADDRESS_TIP_NOT_FOUND
          end
        
        else
          flash[:error] = 'Could not determine whether owner of one or more of these addresses is Company, Customer or Tip.'
          link_to 'Unknown Type', admin_addresses_path          
        end
        
    end

    column :street_address
    column :city
    column :state
    column :post_code
    column :map_reference
  end
  
  
  action_item :only => [:edit] do |address|
    link_to 'Company Address', edit_admin_addresses_path(address.id) 
  end


end

