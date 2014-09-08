# localhost:3000/api => all providers
# localhost:3000/api/locations/bri => locations with 'b-r-i' prefix
# http://localhost:3000/api?utf8=%E2%9C%93&locality=burleigh%20wa&post_code=&state=&commit=Find+Address
# curl -i -H "Accept: application/json" http://localhost:3000/api/locations/Bro
# curl -i -H "Accept: application/json" http://daycare-decisions.herokuapp.com/api/locations/Bri  
# jsonify gem:  https://github.com/bsiggelkow/jsonify

class ApiController < ApplicationController
  include ActionController::MimeResponds
  after_filter :set_access_control_headers

  #
  # ? - Help, if this gets longer go to a template
  #
  def help
    render template: "shared/_api_guide"
  end

=begin  
  #
  # Get providers by name or name part, e.g. 'Small'
  # Note that get all names is not supported.
  #
  def names
    if params[:name].nil?
      render :json => []
    else
      providers = Provider.where("name LIKE ?", "%#{params[:name]}%").select("id,name").order("name")      
      #pg version: providers = Provider.where("name ~* ?", params[:name]).select("id,name").order("name")      
      render :json => providers
    end
  end

  #
  # Rollodex api -- get rollodex for a given provider
  #
  def rolodex
    if params[:id].nil?
      render json: []
    else
      rolo = Rolodex.find params[:id]
      render json: rolo
    end
  end

  #
  # Get all locations in a state, e.g. 'QLD' or 'NT' generated from 'Bri'
  #
  def states
    if params[:state].nil?
      render :json => []
    else
      city_states = []
      # State only, get those 
      if params.include?(:state) && !params[:state].empty?
        addresses = Address.where( "state = ?", params[:state]).select("locality, state")
      end
      addresses.each do |aid| 
        city_states << "#{aid.locality.split.map(&:capitalize).*(' ')}, #{aid.state}"
      end
      render json: city_states
    end
  end

  #
  # Get all locations in soundex queries, e.g. 'B' followed by 'Bri'
  #
  def locations
    city_states = []
    if params.include?(:locality) && !params[:locality].empty?
      addresses = Address.where( "locality LIKE ?", "%#{params[:locality]}%").select("locality, state").distinct
      #pg version: addresses = Address.where( "locality ~* ?", params[:locality]).select("locality, state").distinct
    end
    addresses.each do |aid| 
      city_states << "#{aid.locality.split.map(&:capitalize).*(' ')}, #{aid.state}"
    end
    render json: city_states
  end #locations

  # Return all providers, or if filters are present, filtered ones.
  # <host>/api/providers
  # <host>/api/providers/?locality=Brisbane%2c%20&real_grass=1

  def providers
    filter = params.except :utf8, :commit, :action, :controller
    if filter.empty?
      render :json => Provider.all.order(:name)
    else
      geo_ids, services = get_queries filter
      providers = Provider.where(:id => geo_ids).where(services).order("name")      
      render :json => providers
    end
  end


  # Construct where clauses
  def get_queries filter
    elements = filter[:locality].split(',')
    city = elements[0]
    state = elements[1].lstrip
    geo_ids = Address.where("locality LIKE ? and state = ?", "%#{city}%", state ).select("addressable_id")
    #pg version: geo_ids = Address.where("locality ~* ? and state = ?", city, state ).select("addressable_id")

    # get the services filter set, first remove the location elements
    services = filter.except :locality, :post_code, :state
    return geo_ids, services
  end


  def provider
    render :json => Provider.where( "id = ?", params[:id])
  end

=end
  # from http://madhukaudantha.blogspot.com/2011/05/access-control-allow-origin-in-rails.html
  # called by before filter
  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*'# =>  'http://localhost:8081/' 
    headers['Access-Control-Request-Method'] = '*' 
  end



end
