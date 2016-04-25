class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name , null: false
      t.string :login , null: false , unique: true
      t.string :password , null: false
      t.string :email , null: false , unique: true
      t.datetime :created_at , null: false
      t.datetime :updated_at
      t.datetime :deleted_at
      t.integer :status

      t.timestamps null: false
    end
  end
end
