require "test_helper"

class FactionCreationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.update(email: 'test@example.com')
    @sector = sectors(:one)
    @sector.update(author: @user.email)
    login_as(@user)
  end

  test "should create faction via JSON" do
    assert_difference('SectorModel::Faction.count') do
      post factions_path, params: { 
        sector_model_faction: { 
          sector_id: @sector.id, 
          name: "AJAX Faction", 
          description: "Testing AJAX", 
          color_code: "rgb(255, 0, 0)" 
        } 
      }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal "AJAX Faction", json_response["name"]
  end
end
