require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get commit" do
    get :commit
    assert_response :success
  end

  test "should get error" do
    get :error
    assert_response :success
  end

  test "should get management" do
    get :management
    assert_response :success
  end

  test "should get admin_page" do
    get :admin_page
    assert_response :success
  end

end
