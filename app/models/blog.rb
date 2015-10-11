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
  
  # Overrides the as_json function to a few extra key-values.
  def as_json(options)
    super().merge!(type: "blog", subject: Subject.find_by(subject_id).name)
  end
end