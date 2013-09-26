#require 'debugger'
ActiveAdmin.register Address do
  
  menu parent: "Admin"
  # Address must be created from parent, e.g. Company, Person, Tip
  actions :all, :except => :new


  index do
    column :id

    column :owner do |id|
      case id.addressable_type
        # Clugy way to establish if address owner exists and who or what it is
        when 'Company' 
          begin
            owner = Company.find("#{id.addressable_id}")
            link_to "#{owner.display_name} (#{id.addressable_type})", admin_company_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Company.new
            owner.name = "Delete: Company not found!"
            flash[:error] = 'Company does not exist, address should be deleted.'
          end
        when  'Person'
          begin
            owner = Person.find("#{id.addressable_id}")
            link_to "#{owner.display_name} (#{id.addressable_type})", admin_person_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Person.new
            owner.name = 'Delete: Person not found.'
            flash[:error] = 'Bad Person (does not exist), address should be deleted.'
          end
        when  'Project'
          begin
            owner = Project.find("#{id.addressable_id}")
            link_to "#{owner.name} (#{id.addressable_type})", admin_project_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Project.new
            owner.name = 'Delete: Project not found.'
            flash[:error] = 'Project does not exist, address should be deleted.'
          end
        when  'Tip'
          begin
            owner = Tip.find("#{id.addressable_id}")
            link_to "#{owner.name} (#{id.addressable_type})", admin_tip_path(owner.id)
          rescue ActiveRecord::RecordNotFound
            owner = Tip.new
            owner.name = 'Delete: Tip not found.'
            flash[:error] = 'Tip does not exist, address should be deleted.'
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
  
  form do |f|
    error_panel f

    f.inputs "People" do
      f.input :addressable, magic_select_options(Person.all)
    end
    f.inputs  "Companies" do
      f.input :addressable, magic_select_options(Company.all)
    end
    f.inputs "Address" do
      f.input :street_address,
              :placeholder => "Street"
      f.input :city,
              :placeholder => "City"
      f.input :state, magic_select_options(%w[QLD NSW VIC NT ICT SA WA], r=true)
      f.input :post_code,
              :placeholder => "Post or zip code"
      f.input :map_reference,
              :placeholder => "map coordinates"
    end
    f.buttons
  end
  
  show :title => :display_name do
    render :partial => "show"
  end

#  show :title => 'Address Details' do |address|
#    h3 address.addressable.name
#      attributes_table  do
#        row("Street") { address.street_address }
#        row("City") { address.city }
#        row("State") {address.state}
#        row("Post Code") { address.post_code }
#        row("Map Reference") { address.map_reference }
#      end
#    active_admin_comments
#  end          

  action_item :only => [:edit] do |address|
    link_to 'Company Address', edit_admin_addresses_path(address.id) 
  end

controller do
    def permitted_params
      params.permit(:address => [ :addressable_id, 
                                  :addressable_type, 
                                  :state, 
                                  :street_address, 
                                  :city,
                                  :post_code, 
                                  :map_reference
                                ]
                    )
    end
  end

end

