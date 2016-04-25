class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.integer :instances_numbers , null: false
      t.integer :variable_numbers , null: false
      t.integer :tree_size , null: false

      t.timestamps null: false
    end
  end
end
