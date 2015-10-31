require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "index returns all users as json" do
    User.create(first_name: "Brett", last_name: "Grigsby", email: "test@email.com", social_security_number: "123456789")
    User.create(first_name: "John", last_name: "Doe", email: "john@email.com", social_security_number: "123456780")

    get :index
    assert_response :success

    index_output = JSON.parse(@response.body)
    assert_equal 2, index_output.length
    assert_equal({"id" => 1, "first_name"=>"Brett", "last_name"=>"Grigsby", "email"=>"test@email.com"}, index_output.first)
    assert_equal({"id" => 2, "first_name"=>"John", "last_name"=>"Doe", "email"=>"john@email.com"}, index_output.last)
  end

  test "user show only returns json for correct user" do
    User.create(first_name: "Brett", last_name: "Grigsby", email: "test@email.com", social_security_number: "123456789")
    User.create(first_name: "John", last_name: "Doe", email: "john@email.com", social_security_number: "123456780")

    get :show, { 'id' => '1' }
    assert_response :success

    show_output = JSON.parse(@response.body)
    assert_equal({"id" => 1, "first_name"=>"Brett", "last_name"=>"Grigsby", "email"=>"test@email.com"}, show_output)
  end

  test "show returns error for user that doesn't exist" do
    User.create(first_name: "Brett", last_name: "Grigsby", email: "test@email.com", social_security_number: "123456789")
    User.create(first_name: "John", last_name: "Doe", email: "john@email.com", social_security_number: "123456780")

    get :show, { 'id' => '3' }
    assert_response :missing
    assert_equal "Unknown User", @response.body
  end

  test "create user by sending json" do
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

  test "create user with dashes in SSN" do
    post :create, { 'user' => { 'first_name' => 'Create',
                                'last_name' => 'User',
                                'email' => 'created@test.com',
                                'social_security_number' => '123-45-6789' }}, :format => :json

    assert_response :success

    user_output = JSON.parse(@response.body)
    assert_equal "Create", user_output["first_name"]
    assert_equal "User", user_output["last_name"]
    assert_equal "created@test.com", user_output["email"]
    refute user_output["social_security_number"]

    created_user = User.find_by(first_name: "Create")
    assert_equal "created@test.com", created_user.email
    assert_equal "123456789", created_user.social_security_number
  end

  test "user creation fails with invalid params" do
    post :create, { 'user' => { 'first_name' => 'Create',
                                'last_name' => 'User',
                                'email' => 'created@test.com',
                                'social_security_number' => 'pizza' }}, :format => :json

    assert_response 400
    assert_equal "Invalid Params", @response.body
    assert_equal 0, User.where(email: "created@test.com").length

    post :create, { 'user' => { 'first_name' => 'Create',
                                'email' => 'created@test.com',
                                'social_security_number' => '123456789' }}, :format => :json

    assert_response 400
    assert_equal "Invalid Params", @response.body
    assert_equal 0, User.where(email: "created@test.com").length

    post :create, { 'user' => { 'first_name' => 'Create',
                                'last_name' => 'User',
                                'email' => 'pizza',
                                'social_security_number' => '123456789' }}, :format => :json

    assert_response 400
    assert_equal "Invalid Params", @response.body
    assert_equal 0, User.where(email: "created@test.com").length

  end
end
