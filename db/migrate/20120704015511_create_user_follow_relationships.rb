class CreateUserFollowRelationships < ActiveRecord::Migration
	def change
		create_table :user_follow_relationships do |t|
			t.integer :following_id
			t.integer :follower_id

			t.timestamps
		end

		add_index :user_follow_relationships, :follower_id
		add_index :user_follow_relationships, :following_id
		add_index :user_follow_relationships, [:follower_id, :following_id], unique: true

	end
end
