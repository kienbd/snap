class ImgSize < ActiveRecord::Base
  attr_accessible :photo_id, :height, :width

  belongs_to :photo
end
