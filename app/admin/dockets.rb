require "csv"
ActiveAdmin.register Docket do

  menu label: "Dockets", parent: "Accounting"

  scope :all, :default => true
  scope :operator_signed do |solutions|
    solutions.where ({operator_signed: true})
  end
  scope :operator_not_signed do |solutions|
    solutions.where ({operator_signed: false})
  end
  scope :client_signed do |solutions|
    solutions.where ({client_signed: true})
  end
  scope :client_not_signed do |solutions|
    solutions.where ({client_signed: false})
  end
  scope :approved do |solutions|
    solutions.where ({approved: true})
  end
  scope :not_approved do |solutions|
    solutions.where ({approved: false})
  end
  
  #actions :all, :except => :new
  
  index do
    column :booking_no do |docket|
      link_to docket.booking_no, admin_engagement_docket_path(docket.engagement_id, docket.id)
    end
    column :date_worked
    column :person, :label => "Subcontractor"
    column :operator_signed do |docket|
      status_tag (docket.operator_signed ? "YES" : "No"), (docket.operator_signed ? :ok : :error)      
    end      
    column :client_signed do |docket|
      status_tag (docket.client_signed ? "YES" : "No"), (docket.client_signed ? :ok : :error)      
    end      
    
    column :approved do |docket|
      status_tag (docket.approved ? "YES" : "No"), (docket.approved ? :ok : :error)      
    end      
  end
 
  form do |f|
    error_panel f

    #f.inputs "Docket from #{docket.person.display_name} for #{docket.engagement.schedule.job.name}" do      
    f.inputs do
      f.input :booking_no, 
              #:input_html => {:disabled => true },
              :required => true,
              :hint => "Unique Booking number provided by subbie entered by operations to complete the engagement.",
              :placeholder => "ssssssss"
      
      f.input :person
      
      f.input :date_worked, 
              :as => :string, 
              :required => true,
              :input_html => {:class => 'datepicker'},
              :hint => "Day the work was performed.",
              :placeholder => 'dd-mm-yyyy'
              
      f.input :engagement,
              :required=>true, 
              :as => :select, 
              :collection => Engagement.all.map {|e| [e.schedule.job.name, e.id]}, 
              :include_blank => false,
              :hint => "Engagement associated with this docket."

      f.input :dated, 
              :as => :string, 
              :input_html => {:class => 'datepicker'},
              :hint => "Date docket was marked completed."
              
      f.input :received_on, 
              :as => :string, 
              :input_html => {:class => 'datepicker'},
              :hint => "Date docket was received."
              
      f.input :operator_signed, 
              :as => :radio
      
      f.input :client_signed, 
              :as => :radio
              
    end

    f.inputs "Approvals" do
      f.input :approved, :as => :radio
      f.input :approved_by
      f.input :approved_on, :as => :string, :input_html => {:class => 'datepicker'},
                    :hint => "Date we approved docket."
    end
    
    f.inputs "Payable Amounts" do
      f.input :a_inv_pay, 
              :label => "Load Client(Supplier) Invoice Pay Amount ($)",
              :hint => "Amount we'll pay to first party.",
              :placeholder => "000.00"
              
      f.input :b_inv_pay, 
              :label => "Second Party Invoice Pay Amount ($)", 
              :hint => "Amount we'll pay to second party, if any." ,
              :placeholder => "000.00"
              
      f.input :supplier_inv_pay, 
              :label => "First Party Invoice Pay Amount ($)", 
              :hint => "Amount we'll pay to a third party, if any.",
              :placeholder => "000.00"
              
    end
    f.buttons
  end

 show :title => "Docket" do |docket|
   h3 "Booking Number: #{docket.booking_no}"
    attributes_table do
      row :booking_no
      row ("Engagement For (Job)") { docket.engagement.schedule.job.name }
      row ("Subcontractor") {docket.person}
    #  "2010-07-27".to_date              # => Tue, 27 Jul 2010
      row :date_worked
      row :dated
      row :received_on
    end
  h3 "Approvals"
    attributes_table do
      row("Operator Signed") { status_tag (docket.operator_signed ? "YES" : "No"), (docket.operator_signed ? :ok : :error) }        
      row("Client Signed") { status_tag (docket.client_signed ? "YES" : "No"), (docket.client_signed ? :ok : :error) }        
      row("Approved") { status_tag (docket.approved ? "YES" : "No"), (docket.approved ? :ok : :error) }        
      row :approved_by
      row :approved_on
    end
  h3 "Invoice amounts"
    attributes_table do
      row ("Load Client(Supplier) invoice pay amount ($)"){docket.a_inv_pay}
      row ("Tip Client(Supplier) invoice pay amount ($)"){docket.b_inv_pay}
      row ("Supplier invoice pay amount ($)"){docket.supplier_inv_pay}
    end
    active_admin_comments
  end
  
  
  csv do
    column("Booking No.") { |docket|
      docket.booking_no
    }
    column("Job No.") { |docket|
      docket.job.display_name
    }
    column("Solution No.") { |docket|
      docket.solution.display_name
    }
    column("Date Performed") { |docket|
      docket.dated
    }
    column :received_on

    column :invoiced_on

    column("Quantity") {|docket|
      docket.running_total
    }

    column("Price") {|docket|
      number_to_currency(docket.solution.excel_data[:contract_price])
    }
    column("Unit") {|docket|
      docket.solution.unit_of_material
    }
    # column("Description") { |docket|
    #    docket.solution.display_name
    #  }
    column("Person") { |docket|
      docket.person.display_name
    }
    column("Address") { |docket|
      docket.solution.address.to_s
    }
    column("Approved") { |docket|
      docket.t360_approved
    }
  end

  # Print Docket action -- not built out as unnecessary.  We have no need to print
  # a facsimile of the docket form.  
#   action_item :only => [:edit, :show ] do
#     link_to "Print", print_admin_docket_path(docket.id)
#   end
#   
#   member_action :print, :method => :get do
#     @docket = Docket.find(params[:id])
#     render "print", :layout => "print"
#   end

controller do
  nested_belongs_to :engagement

  def create
    params.permit!
    super
  end

  def docket_params
    params.permit(:docket => [  :booking_no, :date_worked, :dated, :received_on, :operator_signed, :client_signed,
                                       :approved, :approved_by, :approved_on,
                                       :a_inv_pay, :b_inv_pay, :supplier_inv_pay,
                                       :engagement_id, :person_id 
                                 ] )

    end
  end
 
  
end
