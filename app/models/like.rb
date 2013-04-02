class Like < ActiveRecord::Base
  attr_accessible :photo_id, :quantity, :user_id

  belongs_to :user
  belongs_to :photo
end
