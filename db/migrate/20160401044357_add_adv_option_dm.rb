class AddAdvOptionDm < ActiveRecord::Migration
  def change
    add_column :service_dailies, :adv, :int, :default => 0  # Boolean.
    add_column :service_dailies, :anti, :int, :default => 0  # Boolean.
    
    # Keys will be shared, and will denote topic/heading.
    # Note. Each column below is internally represented and used as a hash.
    add_column :service_dailies, :adv_keywords, :text
    add_column :service_dailies, :adv_senders, :text
    add_column :service_dailies, :adv_categories, :text
  end
end
