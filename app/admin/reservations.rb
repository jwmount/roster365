ActiveAdmin.register Reservation do

  index do
    selectable_column
    
    column :schedule
    column :person
    column :equipment
  end

  form do |f|
    error_panel f

    f.inputs "Schedule Details" do
      f.input :schedule, 
              :as => :select, 
              :label => 'Schedule', 
              :hint => "Schedule involved.", 
              :collection => Schedule.all.map {|s| [s.day, s.id]},
              :include_blank => false
     
      f.input :person_id, 
              :required=>true, 
              :as => :select, 
              :collection => Person.alphabetically.all.map {|u| [u.display_name, u.id]}, 
              :include_blank => false,
              :hint => "Person you are engaging to work.  Must work for vendor with required equipment."

      f.input :equipment_id,
              :required=>true, 
              :as => :select, 
              :collection => Equipment.alphabetically.all.map {|e| [e.display_name, e.id]}, 
              :include_blank => false,
              :hint => "Equipment.  Must work for vendor with required equipment."

    end
  end

  show :title => :display_name do
    attributes_table do
      row :schedule
      row :persion
      row :equipment
    end

    active_admin_comments

  end

end
