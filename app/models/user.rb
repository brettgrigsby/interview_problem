class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: /@/ }
  validates :social_security_number, presence: true, length: { is: 9 }
end
