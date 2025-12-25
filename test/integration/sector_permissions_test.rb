require "test_helper"

class SectorPermissionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @author = users(:one)
    @other_user = users(:two)
    @other_user.update(role: :member)
    @sector = sectors(:one) # author is one@example.com
    @sector.update(author: @author.email)
  end

  test "author can view sector" do
    sign_in @author
    get sector_path(@sector)
    assert_response :success
  end

  test "other user cannot view private sector without permission" do
    @sector.update(public_view: '0')
    sign_in @other_user
    get sector_path(@sector)
    assert_redirected_to sectors_path
    assert_equal "You do not have permission to view this sector.", flash[:alert]
  end

  test "other user can view sector with permission" do
    @sector.update(public_view: '0')
    SectorPermission.create!(sector: @sector, user: @other_user, can_view_sector: true)
    sign_in @other_user
    get sector_path(@sector)
    assert_response :success
  end

  test "other user cannot edit sector without permission" do
    sign_in @other_user
    get edit_sector_path(@sector)
    assert_redirected_to sectors_path
    assert_equal "You do not have permission to edit this sector.", flash[:alert]
  end

  test "other user can edit sector with permission" do
    SectorPermission.create!(sector: @sector, user: @other_user, can_edit_sector: true)
    sign_in @other_user
    get edit_sector_path(@sector)
    assert_response :success
  end

  test "other user cannot view factions without permission" do
    @sector.update(public_view: '0')
    sign_in @other_user
    get factions_path(sector_id: @sector.id)
    assert_redirected_to sector_path(@sector)
  end

  test "other user can view factions with permission" do
    @sector.update(public_view: '0')
    SectorPermission.create!(sector: @sector, user: @other_user, can_view_factions: true)
    sign_in @other_user
    get factions_path(sector_id: @sector.id)
    assert_response :success
  end

  test "user with permission can see sector in index" do
    @sector.update(public_view: '0')
    SectorPermission.create!(sector: @sector, user: @other_user, can_view_sector: true)
    sign_in @other_user
    get sectors_path
    assert_select "strong a", text: @sector.name
  end

  test "user without permission cannot see private sector in index" do
    # Clear all permissions to be sure
    SectorPermission.delete_all
    
    @sector.update(public_view: '0', author: 'other@example.com', name: 'Private Sector One')
    sectors(:two).update(public_view: '0', author: 'someone_else@example.com', name: 'Private Sector Two')
    
    # No permission created
    sign_in @other_user # two@example.com
    get sectors_path
    
    # Assert that no sector with name containing 'Private' is shown
    assert_select "strong a", text: /Private/, count: 0
  end

  test "user with permission can access hexmap" do
    @sector.update(public_view: '0')
    SectorPermission.create!(sector: @sector, user: @other_user, can_view_sector: true)
    sign_in @other_user
    get "/hex_system/hexmap?sector_id=#{@sector.id}"
    assert_response :success
  end

  test "user without permission cannot access hexmap" do
    @sector.update(public_view: '0')
    sign_in @other_user
    get "/hex_system/hexmap?sector_id=#{@sector.id}"
    assert_redirected_to sectors_path
    assert_equal "You do not have permission to view this sector's hexmap.", flash[:alert]
  end

  test "unauthorized user is redirected back if referer present" do
    @sector.update(public_view: '0')
    sign_in @other_user
    
    # Simulate being on the profile page and then trying to access a private sector
    get sector_path(@sector), headers: { "HTTP_REFERER" => profile_url }
    
    assert_redirected_to profile_url
    assert_equal "You do not have permission to view this sector.", flash[:alert]
  end

  test "unauthorized user is redirected to default if no referer" do
    @sector.update(public_view: '0')
    sign_in @other_user
    
    get sector_path(@sector)
    
    assert_redirected_to sectors_path
    assert_equal "You do not have permission to view this sector.", flash[:alert]
  end

  test "check_member redirects back for non-members" do
    # users(:two) is a 'user', not 'member' or 'admin' by default in some contexts, 
    # but in setup I updated it to :member. Let's create a fresh non-member.
    non_member = User.create!(email: "nonmember@example.com", password: "password", role: :user)
    sign_in non_member
    
    # trying to access 'new sector' which requires member role
    get new_sector_path, headers: { "HTTP_REFERER" => root_url }
    
    assert_redirected_to root_url
    assert_equal "You must be a member or admin to perform this action.", flash[:alert]
  end

  test "user without edit permission cannot see edit buttons for factions" do
    @sector.update(public_view: '1') # allow view
    sign_in @other_user
    get factions_path(sector_id: @sector.id)
    assert_response :success
    assert_select "a", text: "New Faction", count: 0
    assert_select "a", text: "Edit", count: 0
    assert_select "a", text: "Delete", count: 0
  end

  test "user with edit permission can see edit buttons for factions" do
    @sector.update(public_view: '1')
    SectorPermission.create!(sector: @sector, user: @other_user, can_view_factions: true, can_edit_factions: true)
    sign_in @other_user
    get factions_path(sector_id: @sector.id)
    assert_response :success
    assert_select "a", text: /New Faction/
    assert_select "a i.bi-pencil", count: 1
    assert_select "a i.bi-trash", count: 1
  end

  test "user without edit permission cannot see edit buttons for systems" do
    @sector.update(public_view: '1')
    sign_in @other_user
    get systems_path(sector_id: @sector.id)
    assert_response :success
    assert_select "a", text: "New System", count: 0
    assert_select "a", text: "Bulk Upload", count: 0
    assert_select "a", text: "Edit", count: 0
    assert_select "a", text: "Delete", count: 0
  end

  test "user without edit permission cannot see edit buttons for system notes" do
    system = SectorModel::System.first
    @sector = system.sector
    @sector.update(public_view: '1')
    sign_in @other_user
    get system_path(system)
    assert_response :success
    assert_select "button", text: "New Note", count: 0
    assert_select "button", text: "Edit", count: 0
    assert_select "a", text: "Delete", count: 0
  end
end
