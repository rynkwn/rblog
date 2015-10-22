class CreateCrushes < ActiveRecord::Migration
  def change
    create_table :crushes do |t|
      t.text :name
      t.integer :fans
      
      t.timestamps null: false
    end
  end
end
