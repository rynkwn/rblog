class AddIndexToBlog < ActiveRecord::Migration
  def change
    add_index :blogs, :subject_id
  end
end
