class Blog < ActiveRecord::Base
  validates :name, presence: true
  validates :subject_id, presence: true
  
  serialize :tags, Array  # Sets up Tags to be an array.
  
  # Summarizes the blog's content in 100 characters or less.
  def summarize
    if self.content.length >= 100
      self.content[0..100] + "..."
    else
      self.content
    end
  end
  
  # to_data converts the meaningful data of this object into a string, to be used
  # for data_nukes.
  def to_data
    "Name: " + self.name + "\n" +
    "Date Created: " + self.date_created.to_s + "\n" +
    "Subject: " + Subject.find_by(id: self.subject_id).name + "\n" +
    "Content: " + self.content + "\n" +
    "Tags: " + self.tags.to_s
  end
  
end