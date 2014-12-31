ActiveAdmin.register Reservation do

  index do
    h2 'Experimental Resource Scheduler'

    selectable_column
    column :schedule
    column :equipment
  end

  form do |f|
    error_panel f
    f.inputs "Schedule Details" do
      h2 'Experimental Resource Scheduler'

      f.input :schedule, 
              :as => :select, 
              :label => 'Schedule', 
              :hint => "Schedule involved.", 
              :collection => Schedule.all.map {|s| [s.day, s.id]},
              :include_blank => false
     
      f.input :equipment_id,
              :required=>true, 
              :as => :select, 
              :collection => Equipment.all.map {|e| [e.display_name, e.id]}, 
              :include_blank => false,
              :hint => "Equipment.  Must work for vendor with required equipment."

      f.input :number_requested
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
