class Box < ActiveRecord::Base
  attr_accessible :title, :user_id, :category_id,:position

  validates :title, presence: true, length: {maximum: 50}, uniqueness: { scope: :user_id }

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  belongs_to :category

  has_many :user_box_follows, foreign_key: "box_id",
  dependent: :destroy

  has_many :users, through: :user_box_follows, source: :user
  has_many :photos, dependent:   :destroy
end
