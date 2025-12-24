require "test_helper"

class SystemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @sector = sectors(:one)
    sign_in @user
  end

  test "should get bulk upload" do
    get bulk_upload_systems_url(sector_id: @sector.id)
    assert_response :success
  end

  test "should process bulk upload" do
    file = fixture_file_upload('misc_files/example_system_file.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    
    assert_difference('SectorModel::System.count', 38) do
      post process_bulk_upload_systems_url, params: { sector_id: @sector.id, file: file }
    end

    assert_redirected_to systems_path(sector_id: @sector.id)
    assert_equal "Created 38 systems.", flash[:notice]
  end

  test "should process bulk upload and ignore duplicates" do
    # Create an existing system at location 0102 (matches first row of Excel file)
    @sector.systems.create!(name: "Existing", location: "0102", uwp: "A000000-0", pbg: "000")
    
    file = fixture_file_upload('misc_files/example_system_file.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    
    # example_system_file.xlsx has 38 rows. One of them is 0102.
    assert_difference('SectorModel::System.count', 37) do
      post process_bulk_upload_systems_url, params: { sector_id: @sector.id, file: file }
    end
    
    assert_redirected_to systems_path(sector_id: @sector.id)
    assert_match /Created 37 systems/, flash[:notice]
    assert_match /Ignored 1 duplicate/, flash[:notice]
    assert_match /0102/, flash[:notice]
  end

  test "should process bulk upload with headers" do
    # Ensure no system at 0101 exists in this sector for this test
    @sector.systems.where(location: "0101").destroy_all
    
    file = fixture_file_upload('test/fixtures/files/systems_with_headers.csv', 'text/csv')
    
    assert_difference('SectorModel::System.count', 1) do
      post process_bulk_upload_systems_url, params: { sector_id: @sector.id, file: file }
    end
    
    assert_redirected_to systems_path(sector_id: @sector.id)
    assert_equal "Created 1 systems.", flash[:notice]
  end

  test "should process bulk upload with custom headers" do
    file = fixture_file_upload('test/fixtures/files/systems_with_custom_header.csv', 'text/csv')
    
    assert_difference('SectorModel::System.count', 1) do
      post process_bulk_upload_systems_url, params: { sector_id: @sector.id, file: file }
    end
    
    assert_redirected_to systems_path(sector_id: @sector.id)
    assert_equal "Created 1 systems.", flash[:notice]
  end

  test "should not process bulk upload if any row is invalid" do
    file = fixture_file_upload('test/fixtures/files/invalid_systems.csv', 'text/csv')
    
    assert_no_difference('SectorModel::System.count') do
      post process_bulk_upload_systems_url, params: { sector_id: @sector.id, file: file }
    end
    
    assert_redirected_to systems_path(sector_id: @sector.id)
    assert_match /Errors encountered/, flash[:alert]
    assert_match /InvalidUWP/, flash[:alert]
    assert_match /InvalidLoc/, flash[:alert]
  end

  test "should not process bulk upload if not author" do
    @sector.update(author: 'other@example.com')
    file = fixture_file_upload('misc_files/example_system_file.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    
    assert_no_difference('SectorModel::System.count') do
      post process_bulk_upload_systems_url, params: { sector_id: @sector.id, file: file }
    end

    assert_redirected_to systems_path(sector_id: @sector.id)
  end
end
