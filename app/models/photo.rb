require 'open-uri'
class Photo < ActiveRecord::Base
  attr_accessible :box_id, :description, :name, :image,:origin_owner_id

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

  after_create :create_imgsize

  def create_imgsize
    if self.image.url
      ImgSize.create(photo_id: self.id,width: self.image.geometry[:width],height: self.image.geometry[:height])
    else
      ImgSize.create(photo_id: self.id, width: 300, height: 100);
    end
  end

  def is_origin?
    return self.origin_owner_id.nil?
  end

  private

  def do_download_remote_image
    io = open(URI.parse(image_url))

    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
  end

end
