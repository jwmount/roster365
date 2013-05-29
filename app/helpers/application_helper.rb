module ApplicationHelper


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


  # This gives back all Contacts 
  def contact_select_options(opts = {})
    {:as => "select", :required => true, :collection => Contact.order("last_name").all, :include_blank => true, :input_html => {"data-placeholder" => "Select a Contact...", :style=> "width:500px", :class => "chzn-select"}}.merge(opts)
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

  def fire_ant_risk_levels
    [
      ['None', 0],
      ['Medium', 1],
      ['High', 2]
    ]
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


