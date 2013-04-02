class UserFollowRelationship < ActiveRecord::Base
	attr_accessible :following_id,:follower_id

  belongs_to :follower, class_name: "User"
	belongs_to :following, class_name: "User"


end
