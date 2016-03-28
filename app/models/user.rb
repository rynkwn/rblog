class User < ActiveRecord::Base
  before_save {self.email = email.downcase }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, 
            uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}
  
  has_secure_password
  
  after_create :ryanize
  
  ####################################################
  #
  # Relationships with other models
  #
  ####################################################
  
  has_one :service_daily, :dependent => :destroy
    
  ####################################################
  #
  # Model methods
  #
  ####################################################
  
  def ryanize
    self.ryan = self.email == 'rynkwn@gmail.com' ? 1 : 0
    self.save
  end
  
  def ryan?
    self.ryan == 1
  end
end