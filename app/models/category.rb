class Category < ActiveRecord::Base
  # attr_accessible :name

  validates :name, presence: true

  has_many :boxes, class_name: "Box"
  has_many :photos, through: :boxes, source: :photos, order: "created_at desc"
end
