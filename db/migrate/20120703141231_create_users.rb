class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :gender
      t.boolean :active
      t.boolean :admin
      t.boolean :banned
      t.boolean :verified

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
