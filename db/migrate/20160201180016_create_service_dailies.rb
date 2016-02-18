## Stores User preferences with regards to the Daily Messenger service.

class CreateServiceDailies < ActiveRecord::Migration
  def change
    create_table :service_dailies do |t|
      t.text :key_words  # Key words to find in body of daily message.
      t.text :sender  # Check sender.
      
      t.references :user
      t.timestamps null: false
    end
  end
end
