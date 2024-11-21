require "test_helper"

class AudittrailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @audittrail = audittrails(:one)
  end

  test "should get index" do
    get audittrails_url
    assert_response :success
  end

  test "should get new" do
    get new_audittrail_url
    assert_response :success
  end

  test "should create audittrail" do
    assert_difference("Audittrail.count") do
      post audittrails_url, params: { audittrail: { current_data: @audittrail.current_data, data_differences: @audittrail.data_differences, event_type: @audittrail.event_type, ip_address: @audittrail.ip_address, modified_by_email: @audittrail.modified_by_email, modified_by_name: @audittrail.modified_by_name, module: @audittrail.module, old_data: @audittrail.old_data } }
    end

    assert_redirected_to audittrail_url(Audittrail.last)
  end

  test "should show audittrail" do
    get audittrail_url(@audittrail)
    assert_response :success
  end

  test "should get edit" do
    get edit_audittrail_url(@audittrail)
    assert_response :success
  end

  test "should update audittrail" do
    patch audittrail_url(@audittrail), params: { audittrail: { current_data: @audittrail.current_data, data_differences: @audittrail.data_differences, event_type: @audittrail.event_type, ip_address: @audittrail.ip_address, modified_by_email: @audittrail.modified_by_email, modified_by_name: @audittrail.modified_by_name, module: @audittrail.module, old_data: @audittrail.old_data } }
    assert_redirected_to audittrail_url(@audittrail)
  end

  test "should destroy audittrail" do
    assert_difference("Audittrail.count", -1) do
      delete audittrail_url(@audittrail)
    end

    assert_redirected_to audittrails_url
  end
end
