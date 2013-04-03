class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :gender
      t.string :avatar
      t.boolean :active
      t.boolean :admin
      t.boolean :banned
      t.boolean :verified
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token, :default => "", :null => false

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :persistence_token
    add_index :users, :single_access_token
    add_index :users, :perishable_token
  end
end
