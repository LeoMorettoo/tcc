class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :tree, index: true, foreign_key: true
      t.string :variable
      t.string :condition
      t.string :result
      t.integer :level

      t.timestamps null: false
    end
  end
end
