require 'open-uri'
class Photo < ActiveRecord::Base
  attr_accessible :box_id, :description, :name, :source, :image

  validates :name, presence: true
  validates :box_id, presence: true

  #imgsize
  has_one :img_size

  # like
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  # comments
  has_many :comments, dependent: :destroy

  belongs_to :box

  mount_uploader :image, ImageUploader

  private

  def do_download_remote_image
    io = open(URI.parse(image_url))

    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
  end

end
