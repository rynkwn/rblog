class Subject < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :blogs
  
  # Overrides the as_json function to include a type key-value.
  def as_json(options)
    super().merge!(type: "subject")
  end
end
