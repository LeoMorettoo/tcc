class DropAutoIncrement < ActiveRecord::Migration
  def change
  	change_column :nodes, :id, :integer
  end
end
