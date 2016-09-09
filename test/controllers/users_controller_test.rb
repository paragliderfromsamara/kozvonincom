require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: @user.email, en_name: @user.en_name, encrypted_password: @user.encrypted_password, fb_url: @user.fb_url, ru_name: @user.ru_name, salt: @user.salt, user_type_id: @user.user_type_id, vk_url: @user.vk_url } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, en_name: @user.en_name, encrypted_password: @user.encrypted_password, fb_url: @user.fb_url, ru_name: @user.ru_name, salt: @user.salt, user_type_id: @user.user_type_id, vk_url: @user.vk_url } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
