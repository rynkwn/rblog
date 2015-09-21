class Subject < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :blogs
  
  # to_data converts the meaningful data of this object into a string, to be used
  # for data_nukes.
  def to_data
    "Name: " + self.name
  end
end
