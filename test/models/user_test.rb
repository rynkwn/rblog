require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email:"foo@bar.com", password:"1234567", 
                    password_confirmation:"1234567")
  end

  test "should be valid" do 
    assert @user.valid?
  end
  
  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end
  
  test "Ryan-ness correctly established" do
    u = User.new(email: "rynkwn@gmail.com", password: "123456",
                 password_confirmation:"123456")
    u.save
    assert u.ryan?, "Ryan-ness not properly set."
    assert_not @user.ryan?, "Non-correct emails getting Ryan property."
  end
  
  test "email should have the right form" do
    invalid_addresses = %w[test test.@te test@tes..com test@test.]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid "
    end
  end
  
  test "password should not be blank" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end
  
  test "password should be at least 6 chars long" do
    @user.password = @password_confirmation = "a"*5
    assert_not @user.valid?
  end
end
