require 'test_helper'

class AppControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get boolean" do
    get :boolean
    assert_response :success
  end

  test "should get vetorial" do
    get :vetorial
    assert_response :success
  end

end
