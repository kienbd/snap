class Comment < ActiveRecord::Base
  attr_accessible :content, :photo_id, :user_id

  validates :photo_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 20 }

  belongs_to :photo
  belongs_to :user
end
