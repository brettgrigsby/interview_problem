require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "index returns all users as json" do
    User.create(first_name: "Brett", last_name: "Grigsby", email: "test@email.com", social_security_number: "123456789")
    User.create(first_name: "John", last_name: "Doe", email: "john@email.com", social_security_number: "123456780")

    get :index
    assert_response :success
  end

  test "create user by sneding json" do
    post :create, { 'user' => { 'first_name' => 'Create',
                                'last_name' => 'User',
                                'email' => 'created@test.com',
                                'social_security_number' => '123456789' }}, :format => :json

    assert_response :success

    user_output = JSON.parse(@response.body)
    assert_equal "Create", user_output["first_name"]
    assert_equal "User", user_output["last_name"]
    assert_equal "created@test.com", user_output["email"]
    refute user_output["social_security_number"]

    created_user = User.find_by(first_name: "Create")
    assert_equal "created@test.com", created_user.email
    
  end

end
