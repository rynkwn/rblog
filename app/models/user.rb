class User < ActiveRecord::Base
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