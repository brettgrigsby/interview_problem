require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Brett", last_name: "Grigsby", email: "test@email.com", social_security_number: "123456789")
  end

  test "user is valid" do
    assert @user.valid?
  end

  test "user invalid without first name" do
    @user.first_name = nil
    refute @user.valid?
  end

  test "user invalid without last name" do
    @user.last_name = nil
    refute @user.valid?
  end

  test "user invalid without email" do
    @user.email = nil
    refute @user.valid?
  end

  test "user invalid with improper email" do
    @user.email = "thisaintnoemail"
    refute @user.valid?
  end

  test "user invalid without social" do
    @user.social_security_number = nil
    refute @user.valid?
  end

  test "user invalid with improper social" do
    @user.social_security_number = "12345"
    refute @user.valid?

    @user.social_security_number = "whizzbang"
    refute @user.valid?
  end
end
