require 'test_helper'

class AmazonsControllerTest < ActionController::TestCase
  test "should get get_request" do
    get :get_request
    assert_response :success
  end


end
