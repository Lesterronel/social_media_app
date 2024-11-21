require "application_system_test_case"

class AudittrailsTest < ApplicationSystemTestCase
  setup do
    @audittrail = audittrails(:one)
  end

  test "visiting the index" do
    visit audittrails_url
    assert_selector "h1", text: "Audittrails"
  end

  test "should create audittrail" do
    visit audittrails_url
    click_on "New audittrail"

    fill_in "Current data", with: @audittrail.current_data
    fill_in "Data differences", with: @audittrail.data_differences
    fill_in "Event type", with: @audittrail.event_type
    fill_in "Ip address", with: @audittrail.ip_address
    fill_in "Modified by email", with: @audittrail.modified_by_email
    fill_in "Modified by name", with: @audittrail.modified_by_name
    fill_in "Module", with: @audittrail.module
    fill_in "Old data", with: @audittrail.old_data
    click_on "Create Audittrail"

    assert_text "Audittrail was successfully created"
    click_on "Back"
  end

  test "should update Audittrail" do
    visit audittrail_url(@audittrail)
    click_on "Edit this audittrail", match: :first

    fill_in "Current data", with: @audittrail.current_data
    fill_in "Data differences", with: @audittrail.data_differences
    fill_in "Event type", with: @audittrail.event_type
    fill_in "Ip address", with: @audittrail.ip_address
    fill_in "Modified by email", with: @audittrail.modified_by_email
    fill_in "Modified by name", with: @audittrail.modified_by_name
    fill_in "Module", with: @audittrail.module
    fill_in "Old data", with: @audittrail.old_data
    click_on "Update Audittrail"

    assert_text "Audittrail was successfully updated"
    click_on "Back"
  end

  test "should destroy Audittrail" do
    visit audittrail_url(@audittrail)
    click_on "Destroy this audittrail", match: :first

    assert_text "Audittrail was successfully destroyed"
  end
end
