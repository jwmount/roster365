ActiveAdmin.register Material do

  menu parent: "Admin"

  filter :name
  filter :description
        
  index do
    column :name do |material|
      link_to material.name, admin_material_path(material)
    end
    column :description    
  end  

  form do |f|
    error_panel f

    f.inputs "material" do
      f.input :name,
              :required => true,
              :placeholder => "Name"
              
      f.input :description,
              :placeholder => "Description"
    end
    f.buttons
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


  controller do
    def permitted_params
      params.require(:identifier).permit( :description, :name )
    end
  end

end
