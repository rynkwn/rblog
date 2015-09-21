class Blog < ActiveRecord::Base
  validates :name, presence: true
  validates :subject_id, presence: true
  
  serialize :tags, Array  # Sets up Tags to be an array.
  
  def summarize
    if self.content.length >= 100
      self.content[0..100] + "..."
    else
      self.content
    end
  end
end