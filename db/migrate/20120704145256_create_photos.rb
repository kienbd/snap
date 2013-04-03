class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.string :name
      t.integer :box_id
      t.integer :origin_owner_id
      t.string :image

      t.timestamps
    end
  end
end
