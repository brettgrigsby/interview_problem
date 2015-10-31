require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "index returns all users as json" do
    User.create(first_name: "Brett", last_name: "Grigsby", email: "test@email.com", social_security_number: "123456789")
    User.create(first_name: "John", last_name: "Doe", email: "john@email.com", social_security_number: "123456780")

    get :index
    assert_response :success
  end

end
