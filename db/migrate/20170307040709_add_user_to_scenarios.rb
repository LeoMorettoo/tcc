class AddUserToScenarios < ActiveRecord::Migration
  def change
    add_reference :scenarios, :user, index: true, foreign_key: true
  end
end
