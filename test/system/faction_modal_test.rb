require "application_system_test_case"

class FactionModalTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @user.update(email: 'test@example.com') # Ensure email matches sector author
    @sector = sectors(:one)
    @sector.update(author: @user.email)
    @system = systems(:one)
    @system.update(sector: @sector)
    
    login_as(@user)
  end

  test "creating a new faction from system edit page closes the modal" do
    visit edit_system_path(@system)

    assert_selector "button", text: "New Faction"
    click_button "New Faction"

    within "#newFactionModal" do
      fill_in "Name", with: "New Test Faction"
      fill_in "Description", with: "A test description"
      # Color picker might be tricky to fill, but we just need to submit
      click_button "Save Faction"
    end

    # Wait for the modal to close
    assert_no_selector ".modal-backdrop"
    assert_no_selector "#newFactionModal", visible: true

    # Verify faction was added to dropdown and selected
    assert_equal "New Test Faction", find("#faction_select").value
  end
end
