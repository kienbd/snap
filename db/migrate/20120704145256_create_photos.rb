class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.string :name
      t.integer :box_id
      t.integer :origin_owner_id
      t.integer :repin_count , default: 0
      t.string :image

      t.timestamps
    end
  end
end
