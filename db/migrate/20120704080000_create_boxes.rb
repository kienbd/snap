class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.integer :category_id
      t.integer :position , default: 0
      t.timestamps
    end
  end
end
