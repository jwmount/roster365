ActiveAdmin.register Material do

  menu parent: "Admin"

  filter :name
  filter :description
        
  index do
    selectable_column

    column :name, :sortable => 'name' do |material|
      link_to material.name, admin_material_path(material)
    end
    column :description    
  end  

  form do |f|
    error_panel f

    f.inputs "material" do
      f.input :name,
              :required        => true,
              :placeholder     => AdminConstants::ADMIN_MATERIAL_NAME_PLACEHOLDER
              
      f.input :description,
              :placeholder     => AdminConstants::ADMIN_MATERIAL_DESCRIPTION_PLACEHOLDER
    end
    #f.buttons
    f.action :submit
  end
       

  show title: 'Material' do
    panel "Material Details" do
      attributes_table_for material do
        row("Name") { material.name }
        row("Description") {material.description}
#        row("For Company") { status_tag (material.for_company ? "YES" : "No"), (material.for_company ? :ok : :error) }
      end
    end
    active_admin_comments
  end          

end
