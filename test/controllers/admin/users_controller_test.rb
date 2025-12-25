require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin)
    @user = users(:user)
    sign_in @admin
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get show" do
    get admin_user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_url(@user)
    assert_response :success
  end

  test "should update user role" do
    patch admin_user_url(@user), params: { user: { role: 'member' } }
    assert_redirected_to admin_user_url(@user)
    @user.reload
    assert_equal 'member', @user.role
  end

  test "should reset user password" do
    patch reset_password_admin_user_url(@user)
    assert_redirected_to admin_user_url(@user)
    assert_not_nil flash[:notice]
    assert flash[:notice].include?("Password reset successfully")
  end

  test "should redirect non-admin from index" do
    sign_out @admin
    sign_in @user
    get admin_users_url
    assert_redirected_to root_url
  end
end
