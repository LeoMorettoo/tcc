class AddUserIdToTrees < ActiveRecord::Migration
  def change
    add_reference :trees, :user, index: true, foreign_key: true
  end
end
