class UserFollowRelationship < ActiveRecord::Base
	attr_accessible :following_id,:follower_id

	belongs_to :user,  class_name: "User"

end
