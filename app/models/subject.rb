class Subject < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :blogs
  
  # to_data converts the meaningful data of this object into a string, to be used
  # for data_nukes. ʭ is the delimiter between attributes, ʬ delimits objects.
  def to_data
    "Type: " + "Subject" + "ʭ" +
    "Name: " + self.name +
    "ʬ"
  end
end
