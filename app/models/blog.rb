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
  # for data_nukes. ʭ is the delimiter between attributes, ʬ delimits objects.
  def to_data
    "Type: " + "Blog" + "ʭ" +
    "Name: " + self.name + "ʭ" +
    "Date Created: " + self.date_created.to_s + "ʭ" +
    "Subject: " + Subject.find_by(id: self.subject_id).name + "ʭ" +
    "Content: " + self.content + "ʭ" +
    "Tags: " + self.tags.to_s +
    "ʬ"
  end
  
end