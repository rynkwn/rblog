class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.text :page  # A description of the page that was loaded.
      t.date :date_created  # The date this object was created.

      t.timestamps null: false
    end
  end
end
