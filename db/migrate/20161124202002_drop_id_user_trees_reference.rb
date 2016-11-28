class DropIdUserTreesReference < ActiveRecord::Migration
  def change
  	remove_index :"trees", name: "index_trees_on_user_id"
  	remove_column :trees, :user_id
  end
end
