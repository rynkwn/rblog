class User < ActiveRecord::Base
  before_save {self.email = email.downcase }
  
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}
  
  has_secure_password
  
  after_initialize :init
    
  def init
    self.ryan = self.email == 'rynkwn@gmail.com' ? 1 : 0
    self.save!
  end
  
  def ryan?
    self.ryan == 1
  end
end