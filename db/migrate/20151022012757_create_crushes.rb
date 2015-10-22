class CreateCrushes < ActiveRecord::Migration
  def change
    create_table :crushes do |t|

      t.timestamps null: false
    end
  end
end
