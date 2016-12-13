require 'test_helper'

class Api::RapsControllerTest < ActionDispatch::IntegrationTest
  test "should get battle" do
    get api_raps_battle_url
    assert_response :success
  end

end
