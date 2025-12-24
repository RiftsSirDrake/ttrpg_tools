require "test_helper"

class HexSystemControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @sector = sectors(:one)
    sign_in @user
  end

  test "should get hexmap" do
    get hexmap_hex_system_index_url(sector_id: @sector.id)
    assert_response :success
  end
end
