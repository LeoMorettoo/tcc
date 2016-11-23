class AddResultNumbersToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :result_numbers, :string
  end
end
