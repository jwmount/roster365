#require 'debugger'
require "csv"
ActiveAdmin.register Docket do

  menu label: "Dockets", parent: "Engagement"

  # Rails 5.2.2 scope statements
  # t.b.d.

=begin
  Rails 5.2.2, remove
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
=end

  belongs_to :engagement
#  actions :all, :except => :new
  
  after_build do |docket|
     docket.number = docket.engagement.docket_number
     docket.person = docket.engagement.person
     docket.date_worked = docket.engagement.schedule.day
   end

  index do
    selectable_column
   
    column "Number" do |docket|
      link_to docket.number, admin_engagement_docket_path( docket.engagement, docket )
    end
    
    column "Gross($)" do |docket|
      docket.gross_amount
    end

    column :date_worked
    
    column :person, 
           :label => "Subcontractor"
    
    column "Project" do |docket|
      docket.engagement.schedule.job.solution.quote.project.name
    end

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
      f.input :number, 
              :input_html      => {:disabled => true },
              :hint            => AdminConstants::ADMIN_DOCKETS_NUMBER_HINT,
              :placeholder     => AdminConstants::ADMIN_DOCKETS_NUMBER_PLACEHOLDER
      
      f.input :person,
              :input_html      => {:disabled => true },
              :hint            => AdminConstants::ADMIN_DOCKETS_PERSON_HINT
      
      f.input :date_worked, 
              :as              => :date_picker,
              :hint            => AdminConstants::ADMIN_DOCKETS_DATE_WORKED_HINT
              
      f.input :engagement,
              :required        =>true, 
              :as              => :select, 
              :collection      => Engagement.all.map {|e| [e.schedule.job.name, e.id]}, 
              :include_blank   => false,
              :hint            => AdminConstants::ADMIN_DOCKETS_ENGAGEMENT_HINT

      f.input :dated, 
              :as              => :date_picker,
              :required        => true,
              :hint            => AdminConstants::ADMIN_DOCKETS_DATED_HINT
              
      f.input :received_on, 
              :as              => :date_picker,
              :required        => true,
              :hint            => AdminConstants::ADMIN_DOCKETS_RECEIVED_ON_HINT
              
      f.input :operator_signed, 
              :required        => true,
              :as              => :radio
      
      f.input :client_signed, 
              :required        => true,
              :as              => :radio              
    end

    
    f.inputs "Payable Amounts" do

      f.input :a_inv_pay, 
              :label           => AdminConstants::ADMIN_DOCKETS_RECEIVED_ON_LABEL,
              :hint            => AdminConstants::ADMIN_DOCKETS_RECEIVED_ON_HINT,
              :placeholder     => AdminConstants::ADMIN_DOCKETS_RECEIVED_ON_PLACEHOLDER
              
      f.input :b_inv_pay, 
              :label           => AdminConstants::ADMIN_DOCKETS_B_INV_PAY_LABEL,
              :hint            => AdminConstants::ADMIN_DOCKETS_B_INV_PAY_HINT,
              :placeholder     => AdminConstants::ADMIN_DOCKETS_B_INV_PAY_PLACEHOLDER
              
      f.input :supplier_inv_pay, 
              :label           => AdminConstants::ADMIN_DOCKETS_SUPPLIER_INV_PAY_LABEL, 
              :hint            => AdminConstants::ADMIN_DOCKETS_SUPPLIER_INV_PAY_HINT, 
              :placeholder     => AdminConstants::ADMIN_DOCKETS_SUPPLIER_INV_PAY_PLACEHOLDER
              
    end
    f.actions
  end

 show :title => "Docket" do |docket|
   h3 "Booking Number: #{docket.number}"
    attributes_table do
      row :number
      row :gross_amount
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
      docket.number
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
 
  
end
