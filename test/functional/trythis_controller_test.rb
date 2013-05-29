require 'test_helper'

class TrythisControllerTest < ActionController::TestCase
  test "should get name:string" do
    get :name:string
    assert_response :success
  end

  test "should get active:booleanl" do
    get :active:booleanl
    assert_response :success
  end

end
