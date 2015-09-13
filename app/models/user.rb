class User < ActiveRecord::Base
    has_secure_password
    
    def ryan?
      self.ryan == 1
    end
end