# localhost:3000/api => User Guide
# localhost:3000/api/projects/bri => projects with 'b-r-i' prefix
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

  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*'# =>  'http://localhost:8081/' 
    headers['Access-Control-Request-Method'] = '*' 
  end



end
