class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email
      t.text :password_digest
      t.integer :ryan

      t.timestamps null: false
    end
  end
end
