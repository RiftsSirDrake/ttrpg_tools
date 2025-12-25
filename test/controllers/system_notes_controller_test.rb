require "test_helper"

class SystemNotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @system = systems(:one)
    @sector = sectors(:one)
    sign_in @user
  end

  test "should get new" do
    get new_system_system_note_url(system_id: @system.id), xhr: true
    assert_response :success
  end

  test "should create system_note" do
    assert_difference('SectorModel::SystemNote.count') do
      post system_system_notes_url(system_id: @system.id), params: { sector_model_system_note: { content: 'Test note', public_view: true } }, xhr: true
    end

    assert_response :no_content
  end

  test "should get edit" do
    note = SectorModel::SystemNote.create!(system_id: @system.id, author: @user.email, content: 'Initial content')
    get edit_system_system_note_url(system_id: @system.id, id: note.id), xhr: true
    assert_response :success
  end

  test "should update system_note" do
    note = SectorModel::SystemNote.create!(system_id: @system.id, author: @user.email, content: 'Initial content')
    patch system_system_note_url(system_id: @system.id, id: note.id), params: { sector_model_system_note: { content: 'Updated content' } }, xhr: true
    assert_response :no_content
    assert_equal 'Updated content', note.reload.content
  end

  test "should destroy system_note" do
    note = SectorModel::SystemNote.create!(system_id: @system.id, author: @user.email, content: 'Initial content')
    assert_difference('SectorModel::SystemNote.count', -1) do
      delete system_system_note_url(system_id: @system.id, id: note.id)
    end

    assert_redirected_to system_path(@system.id)
  end
end
