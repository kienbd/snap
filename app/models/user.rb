# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  include AuthenticationsHelper

  attr_accessible :email, :name, :password, :password_confirmation,:gender,:avatar, :remote_avatar_url, :authentications_attributes
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_persistence_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_many :user_follow_relationships, foreign_key: "follower_id",
  dependent: :destroy
  has_many :following_users, through: :user_follow_relationships, source: :following

  has_many :reverse_user_follow_relationships, foreign_key: "following_id",
  class_name:  "UserFollowRelationship",
  dependent:   :destroy

  has_many :followers, through: :reverse_user_follow_relationships, source: :follower
  has_many :comments, dependent: :destroy

  has_many :user_box_follows, foreign_key: "user_id",
  dependent: :destroy

  has_many :following_boxes, through: :user_box_follows, source: :box

  has_many :boxes, class_name: "Box"

  has_many :likes, foreign_key: "user_id",
  dependent: :destroy

  has_many :liked_photos, through: :likes, source: :photo

  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  mount_uploader :avatar, ImageUploader

  def following?(other_user)
    user_follow_relationships.find_by_following_id(other_user.id)
  end

  def follow!(other_user)
    if !following?(other_user)
      user_follow_relationships.create!(following_id: other_user.id)
      Notification.create!(source_id: self.id, target_id: other_user.id,
       relation_type: "user_user_relationships")
      other_user.boxes.each do | box |
        follow_box!(box)
      end
    end
  end

  def unfollow!(other_user)
    if following?(other_user)
      user_follow_relationships.find_by_following_id(other_user.id).destroy
      other_user.boxes.each do | box |
        unfollow_box(box)
      end
    end
  end


  def follow_box!(box)
    if !following_box?(box)
      user_box_follows.create!(box_id: box.id)
    end
  end

  def unfollow_box!(box)
    if following_box?(box)
      user_box_follows.find_by_box_id(box.id).destroy
    end
  end

  def following_box?(box)
    user_box_follows.find_by_box_id(box.id) != nil
  end

  def like(photo)
    if liked_photo?(photo)
      return false
    end

    self.likes.create!(photo_id: photo.id)
  end

  def unlike(photo)
    self.likes.find_by_photo_id(photo.id).destroy
  end

  def liked_photo?(photo)
    return !self.likes.find_by_photo_id(photo.id).nil?
  end

  def tweet(content)
    twitter = twitter(self)
    twitter.update(content + " clgt ")
  end

  def verify!
    self.update_attribute("verified",true)
  end

  def verify?
    self.verified
  end

  def following_photos
    photos = []
    self.following_boxes.each do |b|
      photos.concat b.photos
    end
    photos = photos.sort_by{|t| - t.created_at.to_i}.uniq
    photos
  end


  def all_photos
    photos = []
    self.boxes.each do |b|
      photos.concat b.photos
    end
    photos = photos.sort_by{|t| - t.created_at.to_i}.uniq
    photos
  end

  private

  def create_persistence_token
    self.persistence_token = SecureRandom.urlsafe_base64
  end

  def unfollow_box(box)

    rel = user_box_follows.find_by_box_id(box.id)
    if rel != nil
      rel.destroy
    end
  end
end
