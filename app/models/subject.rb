class Subject < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :blogs
  
  # Returns all blogs associated with this subject.
  def blogs
    self.blogs
  end
end
