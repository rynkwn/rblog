class AddAdvOptionDm < ActiveRecord::Migration
  def change
    add_column :service_dailies, :anti, :int, :default => 0
  end
end
