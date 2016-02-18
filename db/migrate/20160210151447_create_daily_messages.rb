# These store Daily Messages for use by the Daily Messenger Service.

class CreateDailyMessages < ActiveRecord::Migration
  def change
    create_table :daily_messages do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
