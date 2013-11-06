module ApplicationHelper

  # Do not call flash here!  will get Stack Level Too Deep on flash (which is indeed missing)!
  def method_missing(name, *args, &block)
    whats_missing = "METHOD MISSING:  Called #{name} from #{self.class} with #{args.inspect} and #{block}"
    puts whats_missing
  end
  
  def metamorphic_path(elements)
    polymorphic_path(elements)
  end

  def set_resource(resource)
    @resource = resource
  end

  def polymorphic_form_elements
    if parent?
      [:admin, parent, resource]
    else
      [:admin, resource]
    end
  end

  def row(field, opts = {})
    label = opts[:label] || field.to_s.humanize.capitalize
    value = opts[:value] || resource.send(field.intern)
    actions = opts[:actions]
    render(:partial => "admin/shared/row", :locals => { :label => label, :value => value, :css => "",  :actions => actions}.merge(opts))
  end


  # This gives back all People 
  def person_select_options(opts = {})
    {:as => "select", :required => true, :collection => Person.order("last_name").all, :include_blank => true, :input_html => {"data-placeholder" => "Select a Person...", :style=> "width:500px", :class => "chzn-select"}}.merge(opts)
  end

  def magic_select_options(collection, r=true)
   {:as => "select", :required => r, :collection => collection, :include_blank => true, :input_html => {"data-placeholder" => "Select an option", :style=> "width:500px", :class => "chzn-select"}}
  end

  def solution_type_options
    [
      'Export', 'Import', 'Hourly Hire', 'Load, Cart and Dispose', 'Cart Only', 'Budget Price', 
      'Machine Hire - Wet', 'Machine Hire - Dry, Uninsured', 'Machine Hire - Dry, Insured',
      'Think 360 Free Tip - Private Customers', 'COD, Credit Card Accounts'
    ]
  end

  # Get a list of people whose title is 'Rep' at LICENSEE company.
  # Person.alphabetically.where({:company_id => Company.where({:name => "#{ENV['LICENSEE']}"})} && {:title => 'Rep'})
  def list_of_reps
    company = Company.where({ :name=>"#{LICENSEE}" })
    reps = company[0].people.where({:title=>"Rep"})
  end
    
  def index_actions(resource, exclude = {})
    path_elements = [:admin, resource]
    links = []

    unless exclude[:view] === false
      links << link_to(I18n.t('active_admin.view'), polymorphic_path(path_elements), :class => "member_link view_link")
    end

    unless exclude[:edit] === false
      links << link_to(I18n.t('active_admin.edit'), polymorphic_path(path_elements, :action => :edit), :class => "member_link edit_link")
    end

    unless exclude[:delete] === false
      links << link_to(I18n.t('active_admin.delete'), polymorphic_path(path_elements), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link")
    end

    links.to_html
  end

end


