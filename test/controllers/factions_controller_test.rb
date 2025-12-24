require "test_helper"

class FactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @user.member! # Ensure user is a member to pass check_member
    @sector = sectors(:one)
    @sector.update(author: @user.email)
    @faction = sector_model_factions(:one)
    @faction.update(sector: @sector)
    sign_in @user
  end

  test "should get index" do
    get factions_path(sector_id: @sector.id)
    assert_response :success
  end

  test "should get new" do
    get new_faction_path(sector_model_faction: { sector_id: @sector.id })
    assert_response :success
  end

  test "should create faction" do
    assert_difference('SectorModel::Faction.count') do
      post factions_path, params: {
        sector_model_faction: {
          sector_id: @sector.id,
          name: "New Faction",
          description: "Description",
          color_code: "#FF0000"
        }
      }
    end

    assert_redirected_to factions_path(sector_id: @sector.id)
  end

  test "should show faction" do
    get faction_path(@faction)
    assert_response :success
  end

  test "should get edit" do
    get edit_faction_path(@faction, sector_model_faction: { sector_id: @sector.id })
    assert_response :success
  end

  test "should update faction" do
    patch faction_path(@faction), params: {
      sector_model_faction: {
        sector_id: @sector.id,
        name: "Updated Name"
      }
    }
    assert_redirected_to factions_path(sector_id: @sector.id)
    @faction.reload
    assert_equal "Updated Name", @faction.name
  end

  test "should destroy faction" do
    assert_difference('SectorModel::Faction.count', -1) do
      delete faction_path(@faction), params: { sector_model_faction: { sector_id: @sector.id } }
    end

    assert_redirected_to factions_path(sector_id: @sector.id)
  end
end
