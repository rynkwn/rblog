class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.text :name # My understanding is that there's no substantial difference
                    # between string and text currently. Though text can store
                    # far more characters than String.
                    # I also believe some search gems like sunspot/elastisearch do
                    # prefer text data. It's possible my memory is faulty on this
                    # however.
      t.date :date_created  # I want to store this in case of future data purges.              
      t.integer :subject_id  # Will be used to categorize blogs.
      t.text :content
      t.text :tags # Unsure how much I'll use this. But it'll essentially be
                    # an array of words that describe the main content of the
                    # post.

      t.timestamps null: false
    end
  end
end
