class CreateImgSizes < ActiveRecord::Migration
  def change
    create_table :img_sizes do |t|
      t.integer :photo_id
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
