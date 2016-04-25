class FixleaveNumber < ActiveRecord::Migration
  def change
  	rename_column :trees, :instances_numbers, :leaf_number
  end
end
