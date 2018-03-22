require 'test_helper'

class FoursquareControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get foursquare_callback_url
    assert_response :success
  end

end
