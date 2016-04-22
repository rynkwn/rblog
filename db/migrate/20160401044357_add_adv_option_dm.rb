class AddAdvOptionDm < ActiveRecord::Migration
  def change
    add_column :service_dailies, :adv, :int, :default => 0  # Boolean.
    add_column :service_dailies, :anti, :int, :default => 0  # Boolean.
    
    # An array of keys. In order with the rest of the columns below.
    add_column :service_dailies, :adv_keys, :text
    
    # Keys will be shared, and will denote topic/heading.
    # Keys are exactly what's stored in adv_keys, and in the same order.
    # Note. Each column below is internally represented and used as a hash.
    add_column :service_dailies, :adv_keywords, :text
    add_column :service_dailies, :adv_antiwords, :text
    add_column :service_dailies, :adv_senders, :text
    add_column :service_dailies, :adv_categories, :text
  end
end
