require 'test_helper'

class HeadlinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:headlines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create headline" do
    assert_difference('Headline.count') do
      post :create, :headline => { }
    end

    assert_redirected_to headline_path(assigns(:headline))
  end

  test "should show headline" do
    get :show, :id => headlines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => headlines(:one).to_param
    assert_response :success
  end

  test "should update headline" do
    put :update, :id => headlines(:one).to_param, :headline => { }
    assert_redirected_to headline_path(assigns(:headline))
  end

  test "should destroy headline" do
    assert_difference('Headline.count', -1) do
      delete :destroy, :id => headlines(:one).to_param
    end

    assert_redirected_to headlines_path
  end
end
