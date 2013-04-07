require 'open-uri'
class Photo < ActiveRecord::Base
  attr_accessible :box_id, :description, :name, :image,:origin_id, :repin_count

  validates :name, presence: true
  validates :box_id, presence: true

  #imgsize
  has_one :img_size

  has_one :owner_user,through: :box,source: :owner

  # like
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :pons, class_name: :Photo, foreign_key: :origin_id
  has_many :pon_users, through: :pons, source: :owner_user, uniq: true
  belongs_to :origin_photo, class_name: :Photo, foreign_key: :origin_id
  has_one :origin_owner_user, through: :origin_photo, source: :owner_user

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
    return self.origin_id.nil?
  end

  def increase_repin_count
    return self.update_attributes(repin_count: self.repin_count+1)
  end

  private

  def do_download_remote_image
    io = open(URI.parse(image_url))

    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
  end

end
